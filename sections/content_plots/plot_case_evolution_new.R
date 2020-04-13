output$selectize_casesByCountries_new <- renderUI({
  selectizeInput(
    "selectize_casesByCountries_new",
    label    = "Select Country",
    choices  = c("All", unique(data_evolution$`Country/Region`)),
    selected = "All"
  )
})

output$case_evolution_new <- renderPlotly({
  req(input$selectize_casesByCountries_new)
  data <- data_evolution %>%
    mutate(var = sapply(var, capFirst)) %>%
    filter(if (input$selectize_casesByCountries_new == "All") TRUE else `Country/Region` %in% input$selectize_casesByCountries_new) %>%
    group_by(date, var, `Country/Region`) %>%
    summarise(new_cases = sum(value_new, na.rm = T))

  if (input$selectize_casesByCountries_new == "All") {
    data <- data %>%
      group_by(date, var) %>%
      summarise(new_cases = sum(new_cases, na.rm = T))
  }

  p <- plot_ly(data = data, x = ~date, y = ~new_cases, color = ~var, type = 'bar') %>%
    layout(
      yaxis = list(title = "# New Cases"),
      xaxis = list(title = "Date")
    )
})