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
      yaxis = list(title = "# cases"),
      xaxis = list(title = "Date")
    )


  if (input$checkbox_logCaseEvolution) {
    p <- layout(p, yaxis = list(type = "log"))
  }

  return(p)
})

top5_countries             <- data_evolution %>%
  group_by(`Country/Region`) %>%
  summarise(value = sum(value)) %>%
  arrange(desc(value)) %>%
  top_n(5) %>%
  select(`Country/Region`) %>%
  pull()
output$selectize_countries <- renderUI({
  selectizeInput(
    "caseEvolution_country",
    label    = "Select countries",
    choices  = unique(data_evolution$`Country/Region`),
    selected = top5_countries,
    multiple = TRUE
  )
})

getDataByCountry <- function(countries) {
  data_confirmed <- data_evolution %>%
    select(`Country/Region`, date, var, value) %>%
    filter(`Country/Region` %in% countries &
      var == "confirmed" &
      value > 0) %>%
    group_by(`Country/Region`, date) %>%
    summarise("Confirmed" = sum(value)) %>%
    arrange(date) %>%
    as.data.frame()

  data_recovered <- data_evolution %>%
    select(`Country/Region`, date, var, value) %>%
    filter(`Country/Region` %in% countries &
      var == "recovered" &
      value > 0) %>%
    group_by(`Country/Region`, date) %>%
    summarise("Recovered" = sum(value)) %>%
    arrange(date) %>%
    as.data.frame()

  data_death <- data_evolution %>%
    select(`Country/Region`, date, var, value) %>%
    filter(`Country/Region` %in% countries &
      var == "death" &
      value > 0) %>%
    group_by(`Country/Region`, date) %>%
    summarise("Death" = sum(value)) %>%
    arrange(date) %>%
    as.data.frame()

  return(list(
    "confirmed" = data_confirmed,
    "recovered" = data_recovered,
    "death" = data_death
  ))
}

output$case_evolution_byCountry <- renderPlotly({
  data <- getDataByCountry(input$caseEvolution_country)

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
      yaxis = list(title = "# cases", range = c(0, max(data$confirmed$Confirmed))),
      xaxis = list(title = "Date")
    )

  if (input$checkbox_logCaseEvolutionCountry) {
    p <- layout(p, yaxis = list(type = "log", range = log(c(2, max(data$confirmed$Confirmed)))))
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
      yaxis = list(title = "# new cases"),
      xaxis = list(title = "Date")
    )
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
        title = "Cases per Country",
        plotlyOutput("case_evolution_byCountry"),
        fluidRow(
          column(
            uiOutput("selectize_countries"),
            width = 3,
          ),
          column(
            ,
            width = 2
          ),
          column(
            checkboxInput("checkbox_logCaseEvolutionCountry", label = "Logaritmic Y-Axis", value = FALSE),
            width = 3,
            style = "float: right; padding: 10px; margin-right: 50px"
          )
        )
      )
    ),
    fluidRow(
      column(
        box(
          title = "New cases",
          plotlyOutput("case_evolution_new"),
          width = 12
        ), width = 6
      )
    )
  )
})