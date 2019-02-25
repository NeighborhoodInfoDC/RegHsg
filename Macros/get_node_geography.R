#' Import, clean, and buffer geographic data for activity centers and transit hubs
#' 
#' @description This function is designed to provide the geographic data needed to 
#' complete the upzoning analysis and analyze the land use around COG-designated 
#' activity centers and transit hubs. Transit hubs include MARC, VRE, Amtrak, Metro,
#' the Loudoun Metro extension, and the planned Purple Line stations.
#' 
#' The function can be used to return the point data, with cleaned variables that
#' make it easy to combine and filter transit hubs and activity centers. You can 
#' specify if you want transit hubs, activity centers, or both.
#' 
#' The buffer option will create the specified buffers around the points. The function
#' allows for different buffer to be used for the different node types. If only one node type
#' is specified, i.e. only "activity" or only "transit", no argument is needed for 
#' the other bufffer. This should be used when doing calculations for each node.
#' 
#' The buffer-union option returns one shape- a union of the specified buffers. This should 
#' be used when calculating one number for the region- i.e. upzoning will produce X units 
#' in Arlington County. This will ensure that we are not double counting.
#' 
#' The geographic data returned is in WGS 1984 (crs = 4326). 
#' 
#' This function requires `library(dplyr)`, `library(sf)`, and `library(units)`
#' 
#'
#' @param node_type Options are "transit", "activity" and "joint". "joint" returns both 
#' activity centers and transit hubs.
#' @param style Options are "point", "buffer", and "buffer-union". If style = "point", 
#' you do not need to designate buffer sizes.
#' @param transit_buffer The size of the buffer, in square miles, around transit hubs.
#' @param activity_buffer The size of the buffer, in square miles, around activity centers.
#'
#' @return The function returns an `sf` object with the specified parameters. If "buffer-union" 
#' is selected for style, this will be in the form of a list with a single element. 
#' 
#' @examples get_node_geography(node_type = "transit",
#'                              style = "buffer",
#'                              transit_buffer = 0.5)
#'                              
get_node_geography <- function(node_type,
                               style,
                               transit_buffer = NA,
                               activity_buffer = NA) {
  
  
  ##### Check argument validity #####
  
  # Make sure node_type is correct
  if (!node_type %in% c("activity",
                            "transit",
                            "joint")) {
    stop('Options for node_type are "activity", "transit", or "joint"')
  }
  
  # Make sure style is correct
  if (!style %in% c("point",
                    "buffer",
                    "buffer-union")) {
    stop('Options for style are "point", "buffer", or "buffer-union"')
  }
  
  # Make sure the buffers are numeric
  if (!is.numeric(transit_buffer) & !is.na(transit_buffer) |
      !is.numeric(activity_buffer) & !is.na(activity_buffer)) {
    
    stop("Specify numeric value (in square miles) for buffers")
    
  }
  
  
  
  # Make sure the buffers that are needed are specified
  
  if (style %in% c("buffer", "buffer-union") 
      & node_type %in% c("joint", "activity")
      & (is.na(activity_buffer))) {
    
    stop("Specify numeric value for activity buffer in square miles")
    
  }
  
  if (style %in% c("buffer", "buffer-union") 
      & node_type %in% c("joint", "transit")
      & (is.na(transit_buffer))) {
    
    stop("Specify numeric value for transit buffer in square miles")
    
  }
  
  
  
  # If one of the buffers is not needed, set to 0
  
  if (node_type %in% c("transit")) {
    activity_buffer <- 0
  }
  
  if (node_type %in% c("activity")) {
    transit_buffer <- 0
  }
  
  ##### Read in transit shapefiles from L drive ####
  
  rhfdir <- "L:/Libraries/RegHsg/Maps"
  
  sink(type = "message")
  
  log <- capture.output({
    
  metro <- sf::st_read(dsn = rhfdir,
                   layer = "Metro__Rail_Stations") %>% 
    sf::st_transform(crs = 4326) %>% 
    mutate(type = "Metro") %>% 
    select(type, 
           name = NAME,
           line = LINE)
  
  vre <- sf::st_read(dsn = rhfdir,
                 layer = "Virginia_Railway_Express_Stations") %>% 
    sf::st_transform(crs = 4326) %>% 
    mutate(type = "VRE") %>% 
    select(type, 
           name = NAME,
           line = LINE)
  
  pl <- sf::st_read(dsn = rhfdir,
                layer = "purple_line_stops") %>% 
    sf::st_transform(crs = 4326) %>% 
    mutate(type = "Purple line",
           line = "Purple") %>% 
    select(type, 
           name = NAME,
           line)
  
  marc <- sf::st_read(dsn = rhfdir,
                  layer = "Maryland_Transit__MARC_Train_Stops") %>% 
    sf::st_transform(crs = 4326) %>% 
    mutate(type = "MARC") %>% 
    select(type, 
           name = Name,
           line = Line_Name)
  
  amtrak <- sf::st_read(dsn = rhfdir,
                    layer = "Maryland_Transit__Amtrak_Rail_Stops") %>% 
    sf::st_transform(crs = 4326) %>% 
    mutate(type = "Amtrak",
           line = "Amtrak") %>% 
    select(type, 
           name = STNNAME,
           line)
  
  loud <- sf::st_read(dsn = rhfdir,
                  layer = "Loudoun_Metrorail_Stations_Planned") %>% 
    sf::st_transform(crs = 4326) %>% 
    mutate(type = "Loudoun Metro extension",
           line = "Loudoun Metro extension") %>% 
    select(type, 
           name = MN_NAME,
           line)
  })
  
  
  ##### Combine transit shapefiles ##### ####
  
  transit <- rbind(amtrak,
                   loud,
                   marc,
                   metro,
                   pl,
                   vre) %>% 
    mutate(type = factor(type,
                         levels = c("Metro",
                                    "VRE",
                                    "MARC",
                                    "Amtrak",
                                    "Purple line",
                                    "Loudoun Metro extension")))

  
  ##### Read in activity centers #####
  
  regdir <- "L:/Libraries/Region/Maps"
  
  log2 <- capture.output({
  act <- suppressWarnings(sf::st_centroid(sf::st_read(dsn = regdir,
                             layer = "Activity_Centers"))) %>% 
    sf::st_transform(crs = 4326) %>% 
    mutate(type = "Activity",
           line = NA) %>% 
    select(name = Activity_C, type, line)
  })
  
  ##### Return point data ##### 
  
  if (style == "point") {
    
    if (node_type == "joint") {
    
      rbind(act, transit)
    
    } else if (node_type == "activity") {
    
      act
    
    } else if (node_type == "transit") {
    
      transit
    
    } 
    
  } else if (style %in% c("buffer", "buffer-union")) {
      
      ##### Create buffers #####
    
      # set radius
      radius_a <- units::set_units(activity_buffer, mi) %>% units::set_units(ft)
      radius_t <- units::set_units(transit_buffer, mi) %>% units::set_units(ft)
    
      # project to MD state plane in feet
      proj_a <- sf::st_transform(act, crs = 2248)
      proj_t <- sf::st_transform(transit, crs = 2248)
      
      # calculate buffer, set CRS back to standard 4326
      buff_a <- sf::st_buffer(proj_a, radius_a) %>% 
        sf::st_transform(crs = 4326) 
      buff_t <- sf::st_buffer(proj_t, radius_t) %>% 
        sf::st_transform(crs = 4326) 
      buff_ta <- rbind(buff_a, buff_t) 
      
      if (style == "buffer") {
        
        if (node_type == "transit") {
          
          buff_t
          
        } else if (node_type == "activity") {
          
          buff_a 
          
        } else if (node_type == "joint") {
          
          buff_ta
        
        }
          
          
      } else if (style == "buffer-union") {
        
        ##### Create unions #####
        
        if (node_type == "transit") {
          
          buff_t %>% sf::st_union()
          
        } else if (node_type == "activity") {
          
          buff_a %>% sf::st_union() 
          
        } else if (node_type == "joint") {
          
          buff_ta %>% sf::st_union()
          
        }
      }
  }    
}
