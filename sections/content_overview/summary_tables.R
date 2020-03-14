output$summaryTable <- renderUI({
  data <- data_atDate(input$timeSlider)
  tabBox(
    tabPanel("Country/Region", renderDataTable(getSummaryDT(data, "Country/Region"))),
    tabPanel("Province/State", renderDataTable(getSummaryDT(data, "Province/State"))),
    width = 12
  )
})

summariseData <- function(df, groupBy) {
  df %>%
    group_by(!!sym(groupBy)) %>%
    summarise(
      "Confirmed" = sum(confirmed),
      "Recovered" = sum(recovered),
      "Deaths"    = sum(death)
    )
}

getSummaryDT <- function(data, groupBy, selectable = FALSE) {
  summaryDT <- datatable(
    na.omit(as.data.frame(summariseData(data, groupBy))),
    rownames  = FALSE,
    options   = list(
      order          = list(1, "desc"),
      scrollY        = "46vh",
      scrollCollapse = T,
      dom            = 't',
      paging         = FALSE
    ),
    selection = ifelse(selectable, "single", "none")
  )
}