body_overview <- dashboardBody(
  tags$head(
    tags$style(type = "text/css", "#overview_map {height: 48vh !important;}"),
    tags$style(type = 'text/css', ".slider-animate-button { font-size: 20pt !important; }"),
    tags$style(type = 'text/css', ".slider-animate-container { text-align: left !important; }")

  ),
  fluidRow(
    fluidRow(
      uiOutput("box_keyFigures")
    ),
    fluidRow(
      column(
        box(
          width = 12,
          leafletOutput("overview_map")
        ),
        width = 8,
        style = 'padding:0px;'
      ),
      column(
        uiOutput("summaryTables"),
        width = 4,
        style = 'padding:0px;'
      )),
    fluidRow(
      column(
        sliderInput(
          "timeSlider",
          label      = "Select date",
          min        = min(data_evolution$date),
          max        = max(data_evolution$date),
          value      = max(data_evolution$date),
          width      = "100%",
          timeFormat = "%d.%m.%Y",
          animate    = animationOptions(loop = TRUE)
        ),
        width = 12,
        style = 'padding-left:15px; padding-right:15px;'
      )
    )
  )
)

page_overview <- dashboardPage(
  title   = "Overview",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_overview
)