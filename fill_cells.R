### Fill cells tool for the majority class of land use and land cover maps: a R language script (v1.0.3) ###
rm(list=ls())
setwd("Folder Path with Files")
library(rgdal)
library(raster)


 
raster_lulc = raster("raster_name.tif")
grid_orig = readOGR("cells_name.shp")
grid_cells = grid_orig

# Function to Identify Major Class
maj.class = function(x){
  uniqv <- unique(x)
  uniqv[which.max(tabulate(match(x, uniqv)))]
}

for (i in 1:length(grid_orig)){
  
  # Cutting raster for each cell
  a = crop(raster_lulc, grid_orig[i,])
  b = as.data.frame(a)
  c = maj.class(b$nome_raster)
  
  # Saving the majority class in each cell
  grid_cells@data[i,paste0('maj_class')] = c

  # Processing Progress
  print(paste0("Cell-",i,"/",length(grid_cells)))
  
}

# Saving the large filled with the majority class
writeOGR(grid_cells,paste0("./file_name.shp"), layer="file_name", driver = 'ESRI Shapefile')
