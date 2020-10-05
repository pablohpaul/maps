library(shiny)
library(leaflet)
library(readxl)
library(RColorBrewer)
library(dplyr)

agencia <- read_xlsx("C:/Users/Porotos/Documents/Mapa/Mapa_2/reclamos_def_consumidor.xlsx")

ui <- bootstrapPage(
    tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
    leafletOutput("map", width = "100%", height = "100%"),
    absolutePanel(top = 10, right = 10,
                  sliderInput("range", "Magnitudes", min(agencia$Edad, na.rm=TRUE), max(agencia$Edad, na.rm=TRUE),
                              value = range(agencia$Edad, na.rm=TRUE), step = 10
                  ),
                  selectInput("tipoUnidad", "Tipo de Unidad",
                              choices=distinct(agencia, region_reclamante)
                  ),
                  checkboxInput("legend", "Show legend", TRUE)
    )
)

server <- function(input, output, session) {
    
    # Reactive expression for the data subsetted to what the user selected
    #filteredData <- reactive({
    #    quakes[quakes$mag >= input$range[1] & quakes$mag <= input$range[2],]
    #})
    
    # This reactive expression represents the palette function,
    # which changes as the user makes selections in UI.
    # mapa <- reactive({
    #     mapa <- agencia[agencia$Branch_Type_Desc == input$tipoUnidad,]
    # })
    
    output$map <- renderLeaflet({
        # Use leaflet() here, and only include aspects of the map that
        # won't need to change dynamically (at least, not unless the
        # entire map is being torn down and recreated).
        mapa <- agencia[agencia$region_reclamante == input$tipoUnidad, ]
        leaflet() %>% addTiles() %>%
            addProviderTiles(providers$CartoDB.Positron) %>% setView(-58, -34, zoom = 4)  %>%
            addMarkers(mapa$Longitude_Val, mapa$Latitude_Val)
    })
    
    # Incremental changes to the map (in this case, replacing the
    # circles when a new color is chosen) should be performed in
    # an observer. Each independent set of things that can change
    # should be managed in its own observer.
    #observe({
    #    pal <- colorpal()
    #    
    #    leafletProxy("map", data = agencia) %>%
    #        clearShapes() %>%
    #        addCircles(radius = ~10^valores/10, weight = 1, color = "#777777",
    #                   fillColor = ~pal(valores), fillOpacity = 0.7, popup = ~paste(valores)
    #        )
    #})
    
    # Use a separate observer to recreate the legend as needed.
    #observe({
    #    proxy <- leafletProxy("map", data = quakes)
        
        # Remove any existing legend, and only if the legend is
        # enabled, create a new one.
    #    proxy %>% clearControls()
    #    if (input$legend) {
    #        pal <- colorpal()
    #        proxy %>% addLegend(position = "bottomright",
    #                            pal = pal, values = ~mag
    #        )
    #    }
    #})
}

shinyApp(ui, server)