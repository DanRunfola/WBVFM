library(sp)
library(maptools)
library(rgdal)
library(gstat)
library(RColorBrewer)
library(classInt)
library(raster)

x.range <- as.numeric(c(-179.5, 180.0))  
y.range <- as.numeric(c(-60.0, 85)) 

b = CRS("+init=epsg:4326")

grd <- expand.grid(x = seq(from = x.range[1], to = x.range[2], by = 1.0), y = seq(from = y.range[1], to = y.range[2], by = 1.0))  
coordinates(grd) <- ~x + y
gridded(grd) <- TRUE
proj4string(grd) <- b

countries <- readShapePoly("/home/dan/Desktop/GitRepo/WBVFM/ne_110m_admin_0_countries.shp")
proj4string(countries) <- b

plot(grd, cex = 1.5, col = "grey")
lines(countries)

land_grd = grd[!is.na(over(grd,as(countries,"SpatialPolygons"))),]

plot(land_grd, cex=1.5, col="grey")
lines(countries)


grd_write <- as(as(land_grd, "SpatialPixels"), "SpatialPolygons")
proj4string(grd_write) <- b

IDs <- sapply(slot(grd_write, "polygons"), function(x) slot(x, "ID"))
df <- data.frame(rep(0, length(IDs)), row.names=IDs)
SPDFxx <- SpatialPolygonsDataFrame(grd_write, df)
writePolyShape(SPDFxx, "/home/dan/Desktop/GitRepo/WBVFM/WB_Extra_grd.shp")
