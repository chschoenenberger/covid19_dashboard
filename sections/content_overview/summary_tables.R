summariseData <- function(df, variable, groupBy) {
  name_var <- capFirst(variable)

  df %>%
    group_by(!!sym(groupBy)) %>%
    summarise(!!name_var := sum(!!sym(variable))) %>%
    arrange(!!-sym(name_var))
}

getSummaryDT <- function(data, variable, groupBy, selectable = FALSE) {
  summaryDT <- datatable(
    na.omit(as.data.frame(summariseData(data, variable, groupBy))),
    rownames  = FALSE,
    options   = list(
      scrollY        = "calc(100vh - 360px)",
      scrollCollapse = T,
      dom            = 't',
      paging         = FALSE
    ),
    selection = ifelse(selectable, "single", "none")
  )
}

createSummaryTable <- function(data, variable, title, icon, selectable = FALSE) {
  valueBox_summary <- valueBox(
    width    = 12,
    format(sum(data[[2]]), big.mark = " "),
    subtitle = title,
    icon     = icon,
    color    = "light-blue"
  )

  summaryTables <- tabBox(
    tabPanel("Country/Region", renderDataTable(getSummaryDT(data_latest, variable, "Country/Region"))),
    tabPanel("Province/State", renderDataTable(getSummaryDT(data_latest, variable, "Province/State"))),
    width = 12
  )

  return(
    renderUI({
      box(
        valueBox_summary,
        summaryTables,
        width = 12
      )
    })
  )
}

summary_confirmed <- data_latest %>%
  group_by(`Country/Region`) %>%
  summarise(Confirmed = sum(confirmed)) %>%
  arrange(desc(Confirmed))

output$box_confirmed <- createSummaryTable(
  summary_confirmed,
  "confirmed",
  "Total Confirmed",
  icon("file-medical")
)

summary_death <- data_latest %>%
  group_by(`Country/Region`) %>%
  summarise(Deaths = sum(death)) %>%
  arrange(desc(Deaths))

output$box_deaths <- createSummaryTable(
  summary_death,
  "death",
  "Total Deaths",
  icon("heartbeat")
)

summary_recovered <- data_latest %>%
  group_by(`Country/Region`) %>%
  summarise(Recovered = sum(recovered)) %>%
  arrange(desc(Recovered))

output$box_recovered <- createSummaryTable(
  summary_recovered,
  "recovered",
  "Total Recovered",
  icon("heartbeat")
)