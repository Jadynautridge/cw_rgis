#raster 2
if(!require(pacman))install.packages("pacman")

pacman::p_load(tidyverse,terra,tidyterra,mapview,stars)


rm(list=ls())



# precipitation example ---------------------------------------------------

spr_prec<-rast("data/spr_prec_us.tif")



ext(spr_prec)

ggplot() +
  geom_spatraster(data = spr_prec) 

spr_prec_crop<-crop(x=spr_prec,y=c(-80,-75,34,37))

#Map of cropped data
ggplot()+
  geom_spatraster(data=spr_prec_crop)

#county polygon data
sf_nc_county<-readRDS("data/sf_nc_county.rds")

ggplot()+
  geom_spatraster(data=spr_prec_crop)+
  geom_sf(data=sf_nc_county,alpha=0.25)


#use polygon layer to crop raster
spr_prec_nc<-crop(x=spr_prec,y=sf_nc_county)

#map
ggplot() +
  geom_spatraster(data = spr_prec_nc) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)


# merge -------------------------------------------------------------------

spr_nw <- rast("data/spr_prec_ncnw.tif") 
spr_ne <- rast("data/spr_prec_ncne.tif") 
spr_sw <- rast("data/spr_prec_ncsw.tif") 
spr_se <- rast("data/spr_prec_ncse.tif") 


#northwest portion of NC
ggplot() +
  geom_spatraster(data = spr_nw) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)


#southwest portion

ggplot() +
  geom_spatraster(data = spr_sw) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)

#Merge() function to combine two panels

spr_n <- merge(spr_nw, spr_ne)

ggplot()+
  geom_spatraster(data=spr_n)+
  geom_sf(data=sf_nc_county,alpha=0.25)

#merge more than two panels

list_spr<-list(spr_ne,spr_nw,spr_se,spr_sw)


spr_col<-sprc(list_spr)

#merge
spr_merge<-merge(spr_col)


#map spr_merge and af_nc_county
ggplot()+
  geom_spatraster(data=spr_merge)+
  geom_sf(data=sf_nc_county,alpha=0.25,fill="Chocolate")

writeRaster(spr_merge,"data/spr_prec_nc.tif",overwrite=TRUE)


# stack -------------------------------------------------------------------

spr_prec_nc <- rast("data/spr_prec_nc.tif")
spr_tmp_nc <- rast("data/spr_tmp_nc.tif")

ggplot()+
  geom_spatraster(data=spr_tmp_nc)+
  geom_sf(data=sf_nc_county,alpha=0.25)

#create a Multi Layer Raster (Stack)
spr_pt_nc<-c(spr_prec_nc,spr_tmp_nc)


##-precipiation
spr_pt_nc$precipitation

##-temperature
spr_pt_nc$temperature

##try to stack "spr_ne" and "spr_tmp_nc"
#c(spr_me,spr_tmp_nc)
#this would not work because of spatial extent mismatch


# reprojection ------------------------------------------------------------

(spr_prec_nc_proj <- project(x = spr_prec_nc,
                             y = "EPSG:32617"))



# Excercise ---------------------------------------------------------------


sf_nc_county<-readRDS("data/sf_nc_county.rds")


spr_nw <- rast("data/spr_tmp_ncnw.tif") 
spr_ne <- rast("data/spr_tmp_ncne.tif")
spr_sw <- rast("data/spr_tmp_ncsw.tif") 
spr_se <- rast("data/spr_tmp_ncse.tif") 


spr_list<-list(spr_nw,spr_ne,spr_sw,spr_se)


spr_collection<-terra::sprc(spr_list)


spr_merge<-terra::merge(spr_collection)

ggplot()+geom_spatraster(data=spr_merge)+
  geom_sf(data=sf_nc_county, fill="green",alpha=0.25)



# Crop --------------------------------------------------------------------


(sf_nc_county)

sf_camden<-sf_nc_county %>% 
  filter(county=="camden")

ext(sf_camden)

spr_tmp_camden<-crop(x=spr_merge,y=sf_camden)

ggplot()+
  geom_spatraster(data=spr_tmp_camden)+
  geom_sf(data=sf_nc_county,alpha=0.25)


# reproject ---------------------------------------------------------------

spr_tmp_camden_proj<-terra::project(x = spr_tmp_camden,
                                    y = "EPSG:32618",
                                    method="bilinear")


