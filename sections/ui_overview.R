body_overview <- dashboardBody(
  tags$head(
    tags$style(type = "text/css", "#overview_map {height: 65vh !important;}"),
    tags$style(type = "text/css", ".container-fluid {padding-left: 0px; padding-right: 0px !important;}"),
    tags$style(type = "text/css", ".navbar {margin-bottom: 0px;}"),
    tags$style(type = "text/css", ".content {padding: 0px;}"),
    tags$style(type = "text/css", ".row {margin-left: 0px; margin-right: 0px;}"),
    tags$style(HTML(".col-sm-12 { padding: 5px; margin-bottom: -15px; }")),
    tags$style(HTML("::-webkit-scrollbar { display: none; }"))
  ),
  fluidRow(
    fluidRow(
      uiOutput("box_keyFigures")
    ),
    column(
      box(
        width = 12,
        leafletOutput("overview_map")
      ),
      width = 8,
      style = 'padding:0px;'
    ),
    column(
      uiOutput("summaryTable"),
      width = 4,
      style = 'padding:0px;'
    )
  )
)

page_overview <- dashboardPage(
  title   = "Overview",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_overview
)