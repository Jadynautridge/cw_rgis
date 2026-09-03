library(tidyverse)

## Shift+Ctrl+M for pipe
##aes(.......,Color=Columnname)

iris %>% 
  ggplot(
aes(x=Sepal.Length,
y=Sepal.Width))+geom_point()



# point:figure ------------------------------------------------------------

iris %>% ggplot(aes(x=Sepal.Length, y=Sepal.Width, color=Species))+geom_point()

iris %>% ggplot(aes(x=Sepal.Length, y=Sepal.Width))+ geom_point(color="darkblue")




# line figure -------------------------------------------------------------

df_x <- tibble(x= 1:50, y= 2*x)


df_x %>% ggplot(aes(x=x, y=y))+geom_line()


# Histogram ---------------------------------------------------------------

iris %>% ggplot(aes(x=Sepal.Length))+geom_histogram()


