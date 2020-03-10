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
        width = 2,
        valueBox(
          width    = 12,
          format(sum(data_latest$confirmed), big.mark = " "),
          subtitle = "Total Confirmed",
          icon     = icon("file-medical"),
          color    = "light-blue"
        ),
        fluidRow(
          column(
            width = 12,
            dataTableOutput("table_confirmed"),
            style = "overflow-y: scroll; height: calc(100vh - 200px)"
          )
        )
      ),
      column(
        width = 6,
        box(
          title = "Overview Map",
          width = 12,
          leafletOutput("overview_map")
        )
      ),
      column(
        width = 2,
        valueBox(
          width    = 12,
          format(sum(data_latest$death), big.mark = " "),
          subtitle = "Total Deaths",
          icon     = icon("heartbeat"),
          color    = "light-blue"
        ),
        fluidRow(
          column(
            width = 12,
            dataTableOutput("table_deaths"),
            style = "overflow-y: scroll; height: calc(100vh - 200px)"
          )
        )
      ),
      column(
        width = 2,
        valueBox(
          width    = 12,
          format(sum(data_latest$recovered), big.mark = " "),
          subtitle = "Total Recovered",
          icon     = icon("heart"),
          color    = "light-blue"
        ),
        fluidRow(
          column(
            width = 12,
            dataTableOutput("table_recovered"),
            style = "overflow-y: scroll; height: calc(100vh - 200px)"
          )
        )
      )
    )
  )
)
