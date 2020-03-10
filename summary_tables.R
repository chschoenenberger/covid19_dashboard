summary_confirmed <- data_latest %>%
  group_by(`Country/Region`) %>%
  summarise(Confirmed = sum(confirmed)) %>%
  arrange(desc(Confirmed))

output$table_confirmed <- renderDataTable(
  datatable(
    as.data.frame(summary_confirmed),
    rownames = FALSE,
    options  = list(
      scrollY        = T,
      scrollCollapse = T,
      dom            = 't',
      paging         = FALSE
    )
  )
)

summary_death <- data_latest %>%
  group_by(`Country/Region`) %>%
  summarise(Deaths = sum(death)) %>%
  arrange(desc(Deaths))

output$table_deaths <- renderDataTable(
  datatable(
    as.data.frame(summary_death),
    rownames = FALSE,
    options  = list(
      scrollY        = T,
      scrollCollapse = T,
      dom            = 't',
      paging         = FALSE
    )
  )
)

summary_recovered <- data_latest %>%
  group_by(`Country/Region`) %>%
  summarise(Recovered = sum(recovered)) %>%
  arrange(desc(Recovered))

output$table_recovered <- renderDataTable(
  datatable(
    as.data.frame(summary_recovered),
    rownames = FALSE,
    options  = list(
      scrollY        = T,
      scrollCollapse = T,
      dom            = 't',
      paging         = FALSE
    )
  )
)