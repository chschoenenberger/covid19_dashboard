server <- function(input, output) {
  source("map.R", local = TRUE)
  source("summary_tables.R", local = TRUE)

  # Trigger once an hour
  dataLoadingTrigger <- reactiveTimer(3600000)

  observeEvent(dataLoadingTrigger, {
    updateData()
  })
}