# Raster 1: Basic terra operation

if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars) 

rm(list = ls())

#rest() is a function to read data from your directory

# raster data format ------------------------------------------------------


(spr_ex <- rast("data/spr_example.tif"))


# writeRaster() is a function to export raster data
writeRaster(x=spr_ex,filename="data/spr.elev.tiff",overwrite=TRUE)

#visualize raster data: geom_spatraster()
ggplot()+
  geom_spatraster(data=spr_ex)


#If you want mapview() function to work

star_ex <- st_as_stars(spr_ex)
mapview(star_ex)



# #data type in raster ----------------------------------------------------


#continuous

v_elev <- values(spr_ex)

extract(spr_ex, y=cbind(6.0000,50.0000))

#try to get the highest
extract(spr_ex, y=cbind(5.9, 49.85))

#lowest
extract(spr_ex,y=cbind(6.1,49.7))

#random
extract(spr_ex, y=cbind(6.4,49.3))

#extract data at mulitple points

df_point<-tibble(lon=c(6,5.9), lat=c(50,49.96))

extract(spr_ex, y=df_point)

#discrete data 
#0.1

## load forest raster
(spr_for <- rast("data/spr_forest_nc.tif"))

ggplot() +
  geom_spatraster(data = spr_for)

unique(spr_for)

v_binary<-values(spr_for)
mean(v_binary)*100

#Multiple classes-code values with multiple categories

(spr_land <- rast("data/spr_land_reclass.tif"))

#1001=forest
#1010=crop
#1100=urban
unique(spr_land)

#coordinate, lon -79.0063 lat, 36.0701
extract(spr_land, cbind(-79.8063, 36.0701))

#reclass
cm<-cbind(c(0,1001,1010,1100),c(0,1,0,0))

spr_bin<-classify(spr_land, rcl=cm)
unique(spr_bin)
v_bin<-values(spr_bin)
mean(v_bin)*100

#calculate %cropland

cm_crop<-cbind(c(0,1001,1010,1100),c(0,0,1,0))

spr_crop<-classify(x=spr_land,rcl=cm_crop)

v_crop<-values(spr_crop)

mean(v_crop)*100

#calculate %urban

cm_urban<-cbind(c(0,1001,1010,1100),c(0,0,0,1))

spr_urban<-classify(spr_land, rcl=cm_urban)

unique(spr_urban)

v_urban<-values(spr_urban)
mean(v_urban)*100


# Excercise ---------------------------------------------------------------

sf_nc_county<- readRDS("data/sf_nc_county.rds")
spr_prec_ncne<-rast("data/spr_prec_ncne.tif")

#inspect raster properties

ggplot()+
  geom_spatraster(data=spr_prec_ncne)

sf_site<-readRDS("data/sf_finsync_nc.rds")

df_xy<- st_coordinates(sf_site)

extract(spr_land, df_xy)

df_land<-extract(spr_land, df_xy)


#forest
df_land %>% 
  filter(code==1001) %>% 
  nrow()

#cropland
df_land %>% 
  filter(code==1010) %>% nrow()

#urban 
df_land %>% 
  filter(code==1100) %>% nrow()

#quicker approach
table(df_land)