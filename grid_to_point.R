#Add IDs to grid and create a point-based shapefile for extracts
#Point shapefile will retain those IDs
library(sp)
library(maptools)
library(rgdal)
library(gstat)
library(RColorBrewer)
library(classInt)
library(raster)

land_grd <- readShapePoly("/home/dan/Desktop/GitRepo/WBVFM/WB_Extra_grd.shp") 
b = CRS("+init=epsg:4326")

uID <- rownames(land_grd@data)
land_grd@data <- cbind(uID=uID, land_grd@data)


centroids <- coordinates(land_grd)
centroids <- SpatialPointsDataFrame(coords=centroids, data=land_grd@data, proj4string=b)
points(centroids, col = "Blue")

writePointsShape(centroids, "/home/dan/Desktop/GitRepo/WBVFM/Pt_grid_forExtraction.shp")
