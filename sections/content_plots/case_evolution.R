output$case_evolution <- renderPlotly({
  data <- data_evolution %>%
    group_by(date, var) %>%
    summarise(
      "value" = sum(value)
    ) %>%
    as.data.frame()

  p <- plot_ly(
    data,
    x     = ~date,
    y     = ~value,
    name  = sapply(data$var, capFirst),
    color = ~var,
    type  = 'scatter',
    mode  = 'lines') %>%
    layout(
      yaxis = list(title = "# Cases"),
      xaxis = list(title = "Date")
    )


  if (input$checkbox_logCaseEvolution) {
    p <- layout(p, yaxis = list(type = "log"))
  }

  return(p)
})

output$selectize_casesByCountries <- renderUI({
  selectizeInput(
    "caseEvolution_country",
    label    = "Select Countries",
    choices  = unique(data_evolution$`Country/Region`),
    selected = top5_countries,
    multiple = TRUE
  )
})

getDataByCountry <- function(countries, normalizeByPopulation) {
  req(countries)
  data_confirmed <- data_evolution %>%
    select(`Country/Region`, date, var, value, population) %>%
    filter(`Country/Region` %in% countries &
      var == "confirmed" &
      value > 0) %>%
    group_by(`Country/Region`, date, population) %>%
    summarise("Confirmed" = sum(value)) %>%
    arrange(date) %>%
    mutate(Confirmed = if_else(normalizeByPopulation, round(Confirmed / population * 100000, 2), Confirmed)) %>%
    as.data.frame()

  data_recovered <- data_evolution %>%
    select(`Country/Region`, date, var, value, population) %>%
    filter(`Country/Region` %in% countries &
      var == "recovered" &
      value > 0) %>%
    group_by(`Country/Region`, date, population) %>%
    summarise("Recovered" = sum(value)) %>%
    arrange(date) %>%
    mutate(Recovered = if_else(normalizeByPopulation, round(Recovered / population * 100000, 2), Recovered)) %>%
    as.data.frame()

  data_death <- data_evolution %>%
    select(`Country/Region`, date, var, value, population) %>%
    filter(`Country/Region` %in% countries &
      var == "death" &
      value > 0) %>%
    group_by(`Country/Region`, date, population) %>%
    summarise("Death" = sum(value)) %>%
    arrange(date) %>%
    mutate(Death = if_else(normalizeByPopulation, round(Death / population * 100000, 2), Death)) %>%
    as.data.frame()

  return(list(
    "confirmed" = data_confirmed,
    "recovered" = data_recovered,
    "death" = data_death
  ))
}

output$case_evolution_byCountry <- renderPlotly({
  data <- getDataByCountry(input$caseEvolution_country, input$checkbox_per100kEvolutionCountry)

  req(nrow(data$confirmed) > 0)
  p <- plot_ly(data = data$confirmed, x = ~date, y = ~Confirmed, color = ~`Country/Region`, type = 'scatter', mode = 'lines',
    legendgroup     = ~`Country/Region`) %>%
    add_trace(data = data$recovered, x = ~date, y = ~Recovered, color = ~`Country/Region`, line = list(dash = 'dash'),
      legendgroup  = ~`Country/Region`, showlegend = FALSE) %>%
    add_trace(data = data$death, x = ~date, y = ~Death, color = ~`Country/Region`, line = list(dash = 'dot'),
      legendgroup  = ~`Country/Region`, showlegend = FALSE) %>%
    add_trace(data = data$confirmed[which(data$confirmed$`Country/Region` == input$caseEvolution_country[1]),],
      x            = ~date, y = -100, line = list(color = 'rgb(0, 0, 0)'), legendgroup = 'helper', name = "Confirmed") %>%
    add_trace(data = data$confirmed[which(data$confirmed$`Country/Region` == input$caseEvolution_country[1]),],
      x            = ~date, y = -100, line = list(color = 'rgb(0, 0, 0)', dash = 'dash'), legendgroup = 'helper', name = "Recovered") %>%
    add_trace(data = data$confirmed[which(data$confirmed$`Country/Region` == input$caseEvolution_country[1]),],
      x            = ~date, y = -100, line = list(color = 'rgb(0, 0, 0)', dash = 'dot'), legendgroup = 'helper', name = "Death") %>%
    layout(
      yaxis = list(title = "# Cases", rangemode = "nonnegative"),
      xaxis = list(title = "Date")
    )

  if (input$checkbox_logCaseEvolutionCountry) {
    p <- layout(p, yaxis = list(type = "log"))
  }
  if (input$checkbox_per100kEvolutionCountry) {
    p <- layout(p, yaxis = list(title = "# Cases per 100k Inhabitants"))
  }

  return(p)
})

output$case_evolution_new <- renderPlotly({
  data <- data_evolution %>%
    mutate(var = sapply(var, capFirst)) %>%
    group_by(date, var) %>%
    summarise(new_cases = sum(value_new))

  p <- plot_ly(data = data, x = ~date, y = ~new_cases, color = ~var, type = 'bar') %>%
    layout(
      yaxis = list(title = "# New Cases"),
      xaxis = list(title = "Date")
    )
})

output$selectize_casesByCountriesAfter100th <- renderUI({
  selectizeInput(
    "caseEvolution_countryAfter100th",
    label    = "Select Countries",
    choices  = unique(data_evolution$`Country/Region`),
    selected = top5_countries,
    multiple = TRUE
  )
})

output$case_evolution_after100 <- renderPlotly({
  req(!is.null(input$checkbox_per100kEvolutionCountry100th))

  data <- data_evolution %>%
    arrange(date) %>%
    filter(value >= 100) %>%
    group_by(`Country/Region`, population, date) %>%
    filter(if (is.null(input$caseEvolution_countryAfter100th)) TRUE else `Country/Region` %in% input$caseEvolution_countryAfter100th) %>%
    summarise(value = sum(value)) %>%
    mutate("daysSince" = row_number()) %>%
    ungroup()

  if (input$checkbox_per100kEvolutionCountry100th) {
    data$value <- data$value / data$population * 100000
  }

  p <- plot_ly(data = data, x = ~daysSince, y = ~value, color = ~`Country/Region`, type = 'scatter', mode = 'lines') %>%
    layout(
      yaxis = list(title = "# Cases"),
      xaxis = list(title = "# Days since 100th case")
    )

  if (input$checkbox_logCaseEvolution100th) {
    p <- layout(p, yaxis = list(type = "log"))
  }
  if (input$checkbox_per100kEvolutionCountry) {
    p <- layout(p, yaxis = list(title = "# Cases per 100k Inhabitants"))
  }

  return(p)
})

output$box_caseEvolution <- renderUI({
  tagList(
    fluidRow(
      box(
        title = "Evolution of Cases since Outbreak",
        plotlyOutput("case_evolution"),
        column(
          checkboxInput("checkbox_logCaseEvolution", label = "Logaritmic Y-Axis", value = FALSE),
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        width = 6
      ),
      box(
        title = "New cases",
        plotlyOutput("case_evolution_new"),
        width = 6
      )
    ),
    fluidRow(
      column(
        box(
          title = "Cases per Country",
          plotlyOutput("case_evolution_byCountry"),
          fluidRow(
            column(
              uiOutput("selectize_casesByCountries"),
              width = 3,
            ),
            column(
              checkboxInput("checkbox_logCaseEvolutionCountry", label = "Logaritmic Y-Axis", value = FALSE),
              checkboxInput("checkbox_per100kEvolutionCountry", label = "Per Population", value = FALSE),
              width = 4,
              style = "float: right; padding: 10px; margin-right: 50px"
            )
          )
        ),
        box(
          title = "Evolution of Cases since 100th case",
          plotlyOutput("case_evolution_after100"),
          fluidRow(
            column(
              uiOutput("selectize_casesByCountriesAfter100th"),
              width = 3,
            ),
            column(
              checkboxInput("checkbox_logCaseEvolution100th", label = "Logaritmic Y-Axis", value = FALSE),
              checkboxInput("checkbox_per100kEvolutionCountry100th", label = "Per Population", value = FALSE),
              width = 3,
              style = "float: right; padding: 10px; margin-right: 50px"
            )
          )
        ),
        width = 12
      )
    )
  )
})