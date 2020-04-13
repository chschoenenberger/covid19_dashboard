output$selectize_casesByCountriesAfter100th <- renderUI({
  selectizeInput(
    "caseEvolution_countryAfter100th",
    label    = "Select Countries",
    choices  = unique(data_evolution$`Country/Region`),
    selected = top5_countries,
    multiple = TRUE
  )
})

output$selectize_casesSince100th <- renderUI({
  selectizeInput(
    "caseEvolution_var100th",
    label    = "Select Variable",
    choices  = list("Confirmed" = "confirmed", "Deceased" = "deceased"),
    multiple = FALSE
  )
})

output$case_evolution_after100 <- renderPlotly({
  req(!is.null(input$checkbox_per100kEvolutionCountry100th), input$caseEvolution_var100th)
  data <- data_evolution %>%
    arrange(date) %>%
    filter(if (input$caseEvolution_var100th == "confirmed") (value >= 100 & var == "confirmed") else (value >= 10 & var == "deceased")) %>%
    group_by(`Country/Region`, population, date) %>%
    filter(if (is.null(input$caseEvolution_countryAfter100th)) TRUE else `Country/Region` %in% input$caseEvolution_countryAfter100th) %>%
    summarise(value = sum(value, na.rm = T)) %>%
    mutate("daysSince" = row_number()) %>%
    ungroup()

  if (input$checkbox_per100kEvolutionCountry100th) {
    data$value <- data$value / data$population * 100000
  }

  p <- plot_ly(data = data, x = ~daysSince, y = ~value, color = ~`Country/Region`, type = 'scatter', mode = 'lines')

  if (input$caseEvolution_var100th == "confirmed") {
    p <- layout(p,
      yaxis = list(title = "# Confirmed cases"),
      xaxis = list(title = "# Days since 100th confirmed case")
    )
  } else {
    p <- layout(p,
      yaxis = list(title = "# Deceased cases"),
      xaxis = list(title = "# Days since 10th deceased case")
    )
  }
  if (input$checkbox_logCaseEvolution100th) {
    p <- layout(p, yaxis = list(type = "log"))
  }
  if (input$checkbox_per100kEvolutionCountry100th) {
    p <- layout(p, yaxis = list(title = "# Cases per 100k Inhabitants"))
  }

  return(p)
})
