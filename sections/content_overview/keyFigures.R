key_figures <- reactive({
  summary <- global_time_series_melt %>%
             filter(date == input$timeSlider) %>%
             backend_filter_location_by_level(0)
 
  keyFigures <- list(
    "confirmed" = HTML(paste(format(summary$CONFIRMADOS, big.mark = " "), sprintf("<h4>(%+.1f %%)</h4>", summary$CONFIRMADOS_DIFF_RATIO*100))),
    "recovered" = HTML(paste(format(summary$RECUPERADOS, big.mark = " "), sprintf("<h4>(%+.1f %%)</h4>", summary$RECUPERADOS_DIFF_RATIO*100))),
    "deceased"  = HTML(paste(format(summary$MUERTOS, big.mark = " "), sprintf("<h4>(%+.1f %%)</h4>", summary$MUERTOS_DIFF_RATIO*100))),
    "countries" = HTML(paste(format(summary$AFFECTED_SUBREGIONS, big.mark = " "), "/ 23", sprintf("<h4>(%+d)</h4>", summary$AFFECTED_SUBREGIONS_DIFF)))
  )
  return(keyFigures)
})

output$valueBox_confirmed <- renderValueBox({
  valueBox(
    key_figures()$confirmed,
    subtitle = "Confirmados",
    icon     = icon("virus"),
    color    = "navy",
    width    = NULL
  )
})


output$valueBox_recovered <- renderValueBox({
  valueBox(
    key_figures()$recovered,
    subtitle = "Recuperados",
    icon     = icon("heart"),
    color    = "green"
  )
})

output$valueBox_deceased <- renderValueBox({
  valueBox(
    key_figures()$deceased,
    subtitle = "Fallecidos",
    icon     = icon("heartbeat"),
    color    = "red"
  )
})

output$valueBox_countries <- renderValueBox({
  valueBox(
    key_figures()$countries,
    subtitle = "Provincias afectadas",
    icon     = icon("flag"),
    color    = "light-blue"
  )
})

output$box_keyFigures <- renderUI(box(
  title = "Indicadores Clave",
  fluidRow(
    column(
      valueBoxOutput("valueBox_confirmed", width = 3),
      valueBoxOutput("valueBox_recovered", width = 3),
      valueBoxOutput("valueBox_deceased", width = 3),
      valueBoxOutput("valueBox_countries", width = 3),
      width = 12,
      style = "margin-left: -20px"
    )
  ),
  div("Última actualización: ", strftime(global_changed_date, format = "%d.%m.%Y")),
  width = 12
))
