library(leaflet)
library(rgdal)
library(xl)

#si quiero cambiar el código del marker
leafIcons <- icons(
  iconUrl =  "logo.jpg",
  iconWidth = 22, iconHeight = 22,
  iconAnchorX = 22, iconAnchorY = 22
)

agencia <- read_xlsx("Coordenadas.xlsx")
valores <- sample(100:80000, 656, replace=TRUE) 
agencia <- cbind(agencia, valores)

#punto individual
m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=-58.3712, lat=-34.6083, popup="The birthplace of R")
m  # Print the map

#mapa con marcadores
m %>% addProviderTiles(providers$CartoDB.Positron) %>% setView(-58, -34, zoom = 7)  %>%
  addMarkers(agencia$Longitude_Val, agencia$Latitude_Val, popup = agencia$Branch_Id, 
  label = agencia$Branch_Name, icon = leafIcons, clusterOptions = markerClusterOptions()) 

#mapa con puntos variables según valor
m %>% addProviderTiles(providers$CartoDB.Positron) %>% setView(-58, -34, zoom = 7)  %>%
  addCircleMarkers(agencia$Longitude_Val, agencia$Latitude_Val,
    radius = agencia$valores/10000,
    color = "red",
    stroke = FALSE, fillOpacity = 0.5
  )

#mapas SHP (shape)
states <- readOGR("provincia.shp")
leaflet(states) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE))

#subida de mapas json
counties <- readLines("departamento.json") %>% paste(collapse = "\n")
leaflet() %>% setView(lng = -54.583, lat = -38, zoom = 3) %>%
  addTiles() %>%
  addTopoJSON(counties)
