output$selectize_doublingTime_Country <- renderUI({
  selectizeInput(
    "selectize_doublingTime_Country",
    label    = "Select Countries",
    choices  = unique(data_evolution$`Country/Region`),
    selected = top5_countries,
    multiple = TRUE
  )
})

output$selectize_doublingTime_Variable <- renderUI({
  selectizeInput(
    "selectize_doublingTime_Variable",
    label    = "Select Variable",
    choices  = list("Confirmed" = "doublingTimeConfirmed", "Deceased" = "doublingTimeDeceased"),
    multiple = FALSE
  )
})

output$plot_doublingTime <- renderPlotly({
  req(input$selectize_doublingTime_Country, input$selectize_doublingTime_Variable)
  daysGrowthRate <- 7
  data           <- data_evolution %>%
    pivot_wider(id_cols = c(`Province/State`, `Country/Region`, date, Lat, Long), names_from = var, values_from = value) %>%
    filter(if (input$selectize_doublingTime_Variable == "doublingTimeConfirmed") (confirmed >= 100) else (deceased >= 10)) %>%
    filter(if (is.null(input$selectize_doublingTime_Country)) TRUE else `Country/Region` %in% input$selectize_doublingTime_Country) %>%
    group_by(`Country/Region`, date) %>%
    select(-recovered, -active) %>%
    summarise(
      confirmed = sum(confirmed, na.rm = T),
      deceased  = sum(deceased, na.rm = T)
    ) %>%
    arrange(date) %>%
    mutate(
      doublingTimeConfirmed = round(log(2) / log(1 + (((confirmed - lag(confirmed, daysGrowthRate)) / lag(confirmed, daysGrowthRate)) / daysGrowthRate)), 1),
      doublingTimeDeceased  = round(log(2) / log(1 + (((deceased - lag(deceased, daysGrowthRate)) / lag(deceased, daysGrowthRate)) / daysGrowthRate)), 1),
    ) %>%
    mutate("daysSince" = row_number()) %>%
    filter(!is.na(doublingTimeConfirmed) | !is.na(doublingTimeDeceased))

  p <- plot_ly(data = data, x = ~daysSince, y = data[[input$selectize_doublingTime_Variable]], color = ~`Country/Region`, type = 'scatter', mode = 'lines')

  if (input$selectize_doublingTime_Variable == "doublingTimeConfirmed") {
    p <- layout(p,
      yaxis = list(title = "Doubling time of confirmed cases in days"),
      xaxis = list(title = "# Days since 100th confirmed case")
    )
  } else {
    p <- layout(p,
      yaxis = list(title = "Doubling time of deceased cases in days"),
      xaxis = list(title = "# Days since 10th deceased case")
    )
  }

  return(p)
})
