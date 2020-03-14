library("htmltools")

addLabel <- function(data) {
  data$label <- paste0(
    '<b>', ifelse(is.na(data$`Province/State`), data$`Country/Region`, data$`Province/State`), '</b><br>
  Confirmed: ', data$confirmed, '<br>
  Deaths: ', data$death, '<br>
  Recovered: ', data$recovered
  )
  data$label <- lapply(data$label, HTML)

  return(data)
}

map <- leaflet(addLabel(data_latest)) %>%
  setMaxBounds(-180, -90, 180, 90) %>%
  setView(0, 0, zoom = 2) %>%
  addTiles()

observe({
  req(input$timeSlider)
  zoomLevel <- input$overview_map_zoom
  data      <- data_atDate(input$timeSlider) %>% addLabel()
  leafletProxy("overview_map", data = data) %>%
    clearMarkers() %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(confirmed^(zoomLevel / 2)),
      stroke       = FALSE,
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15)
    )
})

output$overview_map <- renderLeaflet(map)


