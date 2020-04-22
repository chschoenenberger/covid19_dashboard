sumData <- function(date) {
  if (date >= min(data_evolution$date)) {
    data <- data_atDate(date) %>% summarise(
      confirmed = sum(confirmed, na.rm = T),
      recovered = sum(recovered, na.rm = T),
      deceased  = sum(deceased, na.rm = T),
      countries = n_distinct(`Country/Region`)
    )
    return(data)
  }
  return(NULL)
}

augment_percentage <- function(x0,x1) {
  if (!is.null(x0) && x0>0)
    return((x1-x0)/x0*100)
  if (!is.null(x1) && x1>0)
    return(Inf)
  return(0)
}

key_figures <- reactive({
  data           <- sumData(input$timeSlider)
  data_yesterday <- sumData(input$timeSlider - 1)

  data_new <- list(
    new_confirmed = augment_percentage(data_yesterday$confirmed, data$confirmed),
    new_recovered = augment_percentage(data_yesterday$recovered, data$recovered),
    new_deceased  = augment_percentage(data_yesterday$deceased, data$deceased),
    new_countries = data$countries - data_yesterday$countries
  )

  keyFigures <- list(
    "confirmed" = HTML(paste(format(data$confirmed, big.mark = " "), sprintf("<h4>(%+.1f %%)</h4>", data_new$new_confirmed))),
    "recovered" = HTML(paste(format(data$recovered, big.mark = " "), sprintf("<h4>(%+.1f %%)</h4>", data_new$new_recovered))),
    "deceased"  = HTML(paste(format(data$deceased, big.mark = " "), sprintf("<h4>(%+.1f %%)</h4>", data_new$new_deceased))),
    "countries" = HTML(paste(format(data$countries, big.mark = " "), "/ 23", sprintf("<h4>(%+d)</h4>", data_new$new_countries)))
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
  title = paste0("Indicadores Clave"),
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
  div("Última actualización: ", strftime(changed_date, format = "%d.%m.%Y")),
  width = 12
))