valueBox_confirmed <- renderUI({
  data <- data_atDate(input$timeSlider)
  column(
    valueBox(
      format(sum(data$confirmed), big.mark = " "),
      subtitle = "Confirmed",
      icon     = icon("file-medical"),
      color    = "light-blue",
      width    = NULL
    ),
    width = 3,
    style = "padding-left: 0px"
  )
})


valueBox_recovered <- renderUI({
  data <- data_atDate(input$timeSlider)
  valueBox(
    format(sum(data$recovered), big.mark = " "),
    subtitle = "Recovered",
    icon     = icon("heart"),
    color    = "light-blue",
    width    = 3
  )
})

valueBox_death <- renderUI({
  data <- data_atDate(input$timeSlider)
  valueBox(
    format(sum(data$death), big.mark = " "),
    subtitle = "Death",
    icon     = icon("heartbeat"),
    color    = "light-blue",
    width    = 3
  )
})

valueBox_countries <- renderUI({
  data <- data_atDate(input$timeSlider)
  valueBox(
    length(unique(data$`Country/Region`)),
    subtitle = "Affected Countries",
    icon     = icon("flag"),
    color    = "light-blue",
    width    = 3
  )
})

output$box_keyFigures <- renderUI(box(
  title = paste0("Key Figures (", strftime(input$timeSlider, format = "%d.%m.%Y"), ")"),
  fluidRow(
    valueBox_confirmed,
    valueBox_recovered,
    valueBox_death,
    valueBox_countries
  ),
  div("Last updated: ", strftime(changed_date, format = "%d.%m.%Y - %R %Z")),
  width = 12
))