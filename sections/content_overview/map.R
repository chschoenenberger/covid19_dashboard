library("htmltools")

addLabel <- function(data) {
  data$label <- paste0(
    '<b>', data$LOCATION, '</b><br>
    <table style="width:120px;">
    <tr><td>Confirmed:</td><td align="right">', data$CONFIRMADOS, '</td></tr>
    <tr><td>Deceased:</td><td align="right">', data$MUERTOS, '</td></tr>
    <tr><td>Recoveries:</td><td align="right">', data$RECUPERADOS, '</td></tr>
    <tr><td>Active:</td><td align="right">', data$ACTIVOS, '</td></tr>
    </table>'
  )
  data$label <- lapply(data$label, HTML)

  return(data)
}

map_data_at_date <- function(date_argument) {
    global_time_series_melt %>%
    filter(date == date_argument & CONFIRMADOS>0) %>%
    backend_filter_location_by_level(1) %>%
    addLabel()
}

map <- leaflet() %>%
  setMaxBounds(-180, -90, 180, 90) %>%
  setView( -65.061253, -37.474996, zoom = 3) %>%
  addTiles() %>%
  addProviderTiles(providers$CartoDB.Positron, group = "Light") %>%
  addProviderTiles(providers$HERE.satelliteDay, group = "Satellite") %>%
  addLayersControl(
    baseGroups    = c("Light", "Satellite"),
    overlayGroups = c("Confirmed", "Confirmed (per capita)", "Recoveries", "Deceased", "Active", "Active (per capita)")
  ) %>%
  hideGroup("Confirmed (per capita)") %>%
  hideGroup("Recoveries") %>%
  hideGroup("Deceased") %>%
  hideGroup("Active") %>%
  hideGroup("Active (per capita)") %>%
  addEasyButton(easyButton(
    icon    = "glyphicon glyphicon-globe", title = "Reset zoom",
    onClick = JS("function(btn, map){ map.setView([20, 0], 2); }"))) %>%
  addEasyButton(easyButton(
    icon    = "glyphicon glyphicon-map-marker", title = "Locate Me",
    onClick = JS("function(btn, map){ map.locate({setView: true, maxZoom: 6}); }")))

observe({
  req(input$timeSlider, input$overview_map_zoom)
  zoomLevel               <- input$overview_map_zoom
  data                    <- map_data_at_date(input$timeSlider)
  k <- 50
  leafletProxy("overview_map") %>%
    clearMarkers() %>%
    addCircleMarkers(
      lng          = data$LONG,
      lat          = data$LAT,
      radius       = log(data$CONFIRMADOS^(zoomLevel / 2)+k),
      stroke       = FALSE,
      fillOpacity  = 0.5,
      label        = data$label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Confirmed"
    ) %>%
    addCircleMarkers(
      lng          = data$LONG,
      lat          = data$LAT,
      radius       = log(data$CONFIRMADOS_PER100K^(zoomLevel)+k),
      stroke       = FALSE,
      color        = "#00b3ff",
      fillOpacity  = 0.5,
      label        = data$label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Confirmed (per capita)"
    ) %>%
    addCircleMarkers(
      lng          = data$LONG,
      lat          = data$LAT,
      radius       = log(data$RECUPERADOS^(zoomLevel)+k),
      stroke       = FALSE,
      color        = "#005900",
      fillOpacity  = 0.5,
      label        = data$label,
      labelOptions = labelOptions(textsize = 15),
      group = "Recoveries"
    ) %>%
    addCircleMarkers(
      lng          = data$LONG,
      lat          = data$LAT,
      radius       = log(data$MUERTOS^(zoomLevel)+k),
      stroke       = FALSE,
      color        = "#E7590B",
      fillOpacity  = 0.5,
      label        = data$label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Deceased"
    ) %>%
    addCircleMarkers(
      lng          = data$LONG,
      lat          = data$LAT,
      radius       = log(data$ACTIVOS^(zoomLevel / 2)+k),
      stroke       = FALSE,
      color        = "#f49e19",
      fillOpacity  = 0.5,
      label        = data$label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Active"
    ) %>%
    addCircleMarkers(
      lng          = data$LONG,
      lat          = data$LAT,
      radius       = log(data$ACTIVOS_PER100K^(zoomLevel)+k),
      stroke       = FALSE,
      color        = "#f4d519",
      fillOpacity  = 0.5,
      label        = data$label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Active (per capita)"
    )
})

output$overview_map <- renderLeaflet(map)
