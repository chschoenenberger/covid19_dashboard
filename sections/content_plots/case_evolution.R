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
    arrange(date)
  if (nrow(data_confirmed) > 0) {
    data_confirmed <- data_confirmed %>%
      mutate(Confirmed = if_else(normalizeByPopulation, round(Confirmed / population * 100000, 2), Confirmed))
  }
  data_confirmed <- data_confirmed %>% as.data.frame()

  data_recovered <- data_evolution %>%
    select(`Country/Region`, date, var, value, population) %>%
    filter(`Country/Region` %in% countries &
      var == "recovered" &
      value > 0) %>%
    group_by(`Country/Region`, date, population) %>%
    summarise("Recovered" = sum(value)) %>%
    arrange(date)
  if (nrow(data_recovered) > 0) {
    data_recovered <- data_recovered %>%
      mutate(Recovered = if_else(normalizeByPopulation, round(Recovered / population * 100000, 2), Recovered))
  }
  data_recovered <- data_recovered %>% as.data.frame()

  data_deceased <- data_evolution %>%
    select(`Country/Region`, date, var, value, population) %>%
    filter(`Country/Region` %in% countries &
      var == "deceased" &
      value > 0) %>%
    group_by(`Country/Region`, date, population) %>%
    summarise("Deceased" = sum(value)) %>%
    arrange(date)
  if (nrow(data_deceased) > 0) {
    data_deceased <- data_deceased %>%
      mutate(Deceased = if_else(normalizeByPopulation, round(Deceased / population * 100000, 2), Deceased))
  }
  data_deceased <- data_deceased %>% as.data.frame()

  return(list(
    "confirmed" = data_confirmed,
    "recovered" = data_recovered,
    "deceased"  = data_deceased
  ))
}

output$case_evolution_byCountry <- renderPlotly({
  data <- getDataByCountry(input$caseEvolution_country, input$checkbox_per100kEvolutionCountry)

  req(nrow(data$confirmed) > 0)
  p <- plot_ly(data = data$confirmed, x = ~date, y = ~Confirmed, color = ~`Country/Region`, type = 'scatter', mode = 'lines',
    legendgroup     = ~`Country/Region`) %>%
    add_trace(data = data$recovered, x = ~date, y = ~Recovered, color = ~`Country/Region`, line = list(dash = 'dash'),
      legendgroup  = ~`Country/Region`, showlegend = FALSE) %>%
    add_trace(data = data$deceased, x = ~date, y = ~Deceased, color = ~`Country/Region`, line = list(dash = 'dot'),
      legendgroup  = ~`Country/Region`, showlegend = FALSE) %>%
    add_trace(data = data$confirmed[which(data$confirmed$`Country/Region` == input$caseEvolution_country[1]),],
      x            = ~date, y = -100, line = list(color = 'rgb(0, 0, 0)'), legendgroup = 'helper', name = "Confirmed") %>%
    add_trace(data = data$confirmed[which(data$confirmed$`Country/Region` == input$caseEvolution_country[1]),],
      x            = ~date, y = -100, line = list(color = 'rgb(0, 0, 0)', dash = 'dash'), legendgroup = 'helper', name = "Recovered") %>%
    add_trace(data = data$confirmed[which(data$confirmed$`Country/Region` == input$caseEvolution_country[1]),],
      x            = ~date, y = -100, line = list(color = 'rgb(0, 0, 0)', dash = 'dot'), legendgroup = 'helper', name = "Deceased") %>%
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
    summarise(new_cases = sum(value_new))

  if (input$selectize_casesByCountries_new == "All") {
    data <- data %>%
      group_by(date, var) %>%
      summarise(new_cases = sum(new_cases))
  }

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
    filter(value >= 100 & var == "confirmed") %>%
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
  if (input$checkbox_per100kEvolutionCountry100th) {
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
        column(
          uiOutput("selectize_casesByCountries_new"),
          width = 3,
        ),
        column(
          HTML("Note: Active cases are calculated as <i>Confirmed - (Recovered + Deceased)</i>. Therefore, <i>new</i> active cases can
          be negative for some days, if on this day there were more new recovered + deceased cases than there were new
          confirmed cases."),
          width = 7
        ),
        width = 6
      )
    ),
    fluidRow(
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
            width = 3,
            style = "float: right; padding: 10px; margin-right: 50px"
          )
        ),
        width = 6
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
        ),
        width = 6
      )
    )
  )
})