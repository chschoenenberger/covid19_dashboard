ui <- dashboardPage(
  dashboardHeader(
    title      = "COVID-19 Global Cases - Open Source Version",
    titleWidth = "400px"
  ),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    tags$head(
      tags$style(type = "text/css", "#overview_map {height: calc(100vh - 170px) !important;}")
    ),
    fluidRow(
      column(
        uiOutput("box_confirmed"),
        width = 2,
        style = "padding-left: 0px; padding-right: 0px"
      ),
      column(
        box(
          title = "Overview Map",
          width = 12,
          leafletOutput("overview_map")
        ),
        width = 6,
        style = "padding-left: 0px; padding-right: 0px"
      ),
      column(
        uiOutput("box_deaths"),
        width = 2,
        style = "padding-left: 0px; padding-right: 0px"
      ),
      column(
        uiOutput("box_recovered"),
        width = 2,
        style = "padding-left: 0px; padding-right: 0px"
      )
    )
  )
)
