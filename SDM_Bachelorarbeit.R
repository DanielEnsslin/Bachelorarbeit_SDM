#### daten einlesen ####


#install.packages("raster")
#install.packages("rgdal")

library(raster)
library(rgdal)

## Working directory festlegen
setwd("C:/Users/Enz/Documents/Studium/Bachelorarbeit")

## Waldinventur daten laden

NFI <- (read.table("Data/PA_data_NFI3.txt"))
# CRS :+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0 +ellps=bessel +towgs84=612.4,77.0,440.2,-0.054,0.057,-2.797,2.55 +units=m +no_defs


head(NFI)
summary(NFI)


# Worldclim Daten einlesen

bioclim_ger <- raster("Data/bio_16_tif/bio1_16.tif") 
bioclim_fr <- raster("Data/bio_15_tif/bio1_15.tif") 


bioclim_fr
bioclim_ger

ger_fr <- stack(c("Data/bio_16_tif/bio1_16.tif","Data/bio_16_tif/bio4_16.tif")) 


## Bodendaten laden

# Basen
bs <- raster("Data/bs_sub_directory_dom_stu/bs_sub/w001001.adf")
bsx <- raster("Data/bs_sub_directory_dom_stu/bs_sub/w001001x.adf")
dbl <- raster("Data/bs_sub_directory_dom_stu/bs_sub/dblbnd.adf")
sta <- raster("Data/bs_sub_directory_dom_stu/bs_sub/sta.adf")
vat <- raster("Data/bs_sub_directory_dom_stu/bs_sub/vat.adf")
hdr <- raster("Data/bs_sub_directory_dom_stu/bs_sub/hdr.adf")


boden <- stack(bs, bsx, dbl, sta, vat, hdr)

plot(boden)

# Bodendaten CRS zuweisen

crs(bs) <- "+init=epsg:25832"                     ## welche ist das richtig crs
crs(bs) <- "+proj=longlat +datum=WGS84 +no_defs" ## crs?
hdr


### CRS Transformation Rasterdaten(Boden, Klima)

crs(bs) <- "+init=epsg:25832"  

wsg84 <- "+init=epsg:4326"
bs1 <- projectRaster(bs, crs = wsg84 )
bioclim_ger1 <- projectRaster(bioclim_ger, crs  = wsg84)



# CRS Transformation Punktdaten/NFI

wgs <- "+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0 +ellps=bessel +towgs84=612.4,77.0,440.2,-0.054,0.057,-2.797,2.55 +units=m +no_defs"


coordinates(NFI) <- ~GKrechts+GKhoch
proj4string(NFI) = CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0 +ellps=bessel +towgs84=612.4,77.0,440.2,-0.054,0.057,-2.797,2.55 +units=m +no_defs")

NFI1 <- spTransform(NFI, CRS = wgs)
plot(NFI1)


