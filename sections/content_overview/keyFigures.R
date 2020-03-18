value_confirmed <- reactive({
  data <- data_atDate(input$timeSlider)

  keyFigures <- list(
    "confirmed" = format(sum(data$confirmed), big.mark = " "),
    "recovered" = format(sum(data$recovered), big.mark = " "),
    "death"     = format(sum(data$death), big.mark = " "),
    "countries" = length(unique(data$`Country/Region`))
  )
  return(keyFigures)
})

output$valueBox_confirmed <- renderValueBox({
  valueBox(
    value_confirmed()$confirmed,
    subtitle = "Confirmed",
    icon     = icon("file-medical"),
    color    = "light-blue",
    width    = NULL
  )
})


output$valueBox_recovered <- renderValueBox({
  valueBox(
    value_confirmed()$recovered,
    subtitle = "Recovered",
    icon     = icon("heart"),
    color    = "light-blue"
  )
})

output$valueBox_death <- renderValueBox({
  valueBox(
    value_confirmed()$death,
    subtitle = "Death",
    icon     = icon("heartbeat"),
    color    = "light-blue"
  )
})

output$valueBox_countries <- renderValueBox({
  valueBox(
    paste(value_confirmed()$countries, "/ 195"),
    subtitle = "Affected Countries",
    icon     = icon("flag"),
    color    = "light-blue"
  )
})

output$box_keyFigures <- renderUI(box(
  title = paste0("Key Figures (", strftime(input$timeSlider, format = "%d.%m.%Y"), ")"),
  fluidRow(
    column(
      valueBoxOutput("valueBox_confirmed", width = 3),
      valueBoxOutput("valueBox_recovered", width = 3),
      valueBoxOutput("valueBox_death", width = 3),
      valueBoxOutput("valueBox_countries", width = 3),
      width = 12,
      style = "margin-left: -20px"
    )
  ),
  div("Last updated: ", strftime(changed_date, format = "%d.%m.%Y - %R %Z")),
  width = 12
))