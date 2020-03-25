server <- function(input, output) {
  sourceDirectory("sections", recursive = TRUE)

  showNotification("Attention: There is an issue with the source data from Johns Hopkins University. I am aware of
  the issue and working on it. In the meantime the numbers shown in the dashboard are flawed.", duration = NULL,
    type                                                                                                 = "error")

  # Trigger once an hour
  dataLoadingTrigger <- reactiveTimer(3600000)

  observeEvent(dataLoadingTrigger, {
    updateData()
  })

  observe({
    data <- data_atDate(input$timeSlider)
  })
}