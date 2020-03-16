output$summaryTable <- renderUI({
  tabBox(
    tabPanel("Country/Region", dataTableOutput("summaryDT_country")),
    tabPanel("Province/State", dataTableOutput("summaryDT_state")),
    width = 12
  )
})

output$summaryDT_country <- renderDataTable(getSummaryDT(data_atDate(current_date), "Country/Region"))
proxy_summaryDT_country  <- dataTableProxy("summaryDT_country")
output$summaryDT_state   <- renderDataTable(getSummaryDT(data_atDate(current_date), "Province/State"))
proxy_summaryDT_state    <- dataTableProxy("summaryDT_state")

observeEvent(input$timeSlider, {
  data <- data_atDate(input$timeSlider)
  replaceData(proxy_summaryDT_country, summariseData(data, "Country/Region"), rownames = FALSE)
  replaceData(proxy_summaryDT_state, summariseData(data, "Province/State"), rownames = FALSE)
}, ignoreInit = TRUE, ignoreNULL = TRUE)

summariseData <- function(df, groupBy) {
  df %>%
    group_by(!!sym(groupBy)) %>%
    summarise(
      "Confirmed" = sum(confirmed),
      "Recovered" = sum(recovered),
      "Deaths"    = sum(death),
      "Active"    = sum(active)
    ) %>%
    as.data.frame()
}

getSummaryDT <- function(data, groupBy, selectable = FALSE) {
  datatable(
    na.omit(summariseData(data, groupBy)),
    rownames  = FALSE,
    options   = list(
      order          = list(1, "desc"),
      scrollY        = "45.5vh",
      scrollCollapse = T,
      dom            = 't',
      paging         = FALSE
    ),
    selection = ifelse(selectable, "single", "none")
  )
}