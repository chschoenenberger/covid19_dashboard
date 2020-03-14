body_plots <- dashboardBody(
  tags$head(
    tags$style(type = "text/css", ".container-fluid {padding-left: 0px; padding-right: 0px !important;}"),
    tags$style(type = "text/css", ".navbar {margin-bottom: 0px;}"),
    tags$style(type = "text/css", ".content {padding: 0px;}"),
    tags$style(type = "text/css", ".row {margin-left: 0px; margin-right: 0px;}"),
    tags$style(HTML(".col-sm-12 { padding: 5px; margin-bottom: -15px; }")),
    tags$style(HTML(".col-sm-6 { padding: 5px; margin-bottom: -15px; }")),
    tags$style(HTML("::-webkit-scrollbar { display: none; }"))
  ),
  fluidRow(
    fluidRow(
      uiOutput("box_caseEvolution")
    )
  )
)

page_plots <- dashboardPage(
  title   = "Plots",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_plots
)