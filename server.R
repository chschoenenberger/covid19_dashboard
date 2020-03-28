server <- function(input, output) {
  sourceDirectory("sections", recursive = TRUE)

  showNotification("Attention: Johns Hopkins University does not provide recovered cases anymore. Therefore,
  recovered cases are an estimation only. Please check the about section for more information.",
    duration = 30, type = "error")

  # Trigger once an hour
  dataLoadingTrigger <- reactiveTimer(3600000)

  observeEvent(dataLoadingTrigger, {
    updateData()
  })

  observe({
    data <- data_atDate(input$timeSlider)
  })
}