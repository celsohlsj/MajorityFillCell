### Identifying majority pixel value per polygon in R
#-------------------

# required libraries
library(rgdal)
library(raster)

# Opening raster
raster_lulc = raster("raster_name.tif")

# Opening shapefile
grid_orig = readOGR("cells_name.shp")
grid_cells <- grid_orig


# Function to identify the majority class (mode) 
maj.class = function(x){
  uniqv <- unique(x)
  uniqv[which.max(tabulate(match(x, uniqv)))]
  
}

# Appling function defined above in a loop for each cell
for (i in 1:length(grid_orig)){

  # Cutting raster for each cell
  a = crop(raster_lulc, grid_orig[i,])
  
  # Creating data frame with the information
  b = as.data.frame(a, na.rm=TRUE) #na.rm=TRUE : delete NA
  
  # Appling the function
  c = maj.class(b)
  
  # Saving the majority class in each cell
  grid_cells@data[i,paste0('maj_class')] = c

  # Processing Progress
  print(paste0("Cell-",i,"/",length(grid_cells)))
  
}

# Saving the large filled with the majority class
writeOGR(grid_cells,paste0("path_to_file/file_name.shp"), layer="file_name", driver = 'ESRI Shapefile')

