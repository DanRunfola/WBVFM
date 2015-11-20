library(sp)
library(maptools)
library(rgdal)
library(gstat)
library(RColorBrewer)
library(classInt)
library(raster)

bio_results = "/home/dan/Desktop/GitRepo/WBVFM/bio_par_test_1_merge.geojson"

bio = readOGR(bio_results, "OGRGeoJSON")

b <- bio

#Calculate total impact on state score for each row
b$bio_impact = b$coef_TrtBin + b$coef_TrtBin.sector_group

b <- b[b$bio_impact <= 3.0,]
b <- b[b$bio_impact >= -3.0,]

#Need to loop over this per sector:
x.range <- as.numeric(c(-178.0, 180.0))  
y.range <- as.numeric(c(-88.0, 88)) 

grd <- expand.grid(x = seq(from = x.range[1], to = x.range[2], by = 1.0), y = seq(from = y.range[1], to = y.range[2], by = 1.0))  
coordinates(grd) <- ~x + y
gridded(grd) <- TRUE
proj4string(grd) <- proj4string(b)

plot(grd, cex = 1.5, col = "grey")
points(b, pch = 1, col = "red", cex = 1)

idw.spatial <- idw(formula = bio_impact ~ 1, locations = b, newdata = grd, idp=1)

rast <- raster(idw)
writeRaster(rast, filename="/home/dan/Desktop/GitRepo/WBVFM/test.tif", format="GTiff", overwrite=TRUE)

