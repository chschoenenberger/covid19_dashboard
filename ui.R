ui <- dashboardPage(
  dashboardHeader(
    title      = "COVID-19 Global Cases - Open Source Version",
    titleWidth = "400px"
  ),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    tags$style(type = "text/css", "#overview_map {height: calc(100vh - 170px) !important;}"),
    fluidRow(
      width = 12,
      box(
        title = "Overview Map",
        width = 12,
        leafletOutput("overview_map")
      )
    )
  )
)
