createSummaryTable <- function(data, column, title, icon, selectable = FALSE) {
  valueBox_summary <- valueBox(
    width    = 12,
    format(sum(data[[column]]), big.mark = " "),
    subtitle = title,
    icon     = icon,
    color    = "light-blue"
  )

  datatable_summary <- datatable(
    as.data.frame(data),
    rownames  = FALSE,
    options   = list(
      scrollY        = "calc(100vh - 300px)",
      scrollCollapse = T,
      dom            = 't',
      paging         = FALSE
    ),
    selection = ifelse(selectable, "single", "none")
  )

  return(
    renderUI({
      box(
        valueBox_summary,
        renderDataTable(datatable_summary),
        width  = 12,
        height = "calc(100vh - 106px)"
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
  "Confirmed",
  "Total Confirmed",
  icon("file-medical")
)

summary_death <- data_latest %>%
  group_by(`Country/Region`) %>%
  summarise(Deaths = sum(death)) %>%
  arrange(desc(Deaths))

output$box_deaths <- createSummaryTable(
  summary_death,
  "Deaths",
  "Total Deaths",
  icon("heartbeat")
)

summary_recovered <- data_latest %>%
  group_by(`Country/Region`) %>%
  summarise(Recovered = sum(recovered)) %>%
  arrange(desc(Recovered))

output$box_recovered <- createSummaryTable(
  summary_recovered,
  "Recovered",
  "Total Recovered",
  icon("heartbeat")
)