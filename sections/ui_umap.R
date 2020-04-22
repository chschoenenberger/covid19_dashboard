body_plots <- dashboardBody(
  fluidRow(
    fluidRow(
      uiOutput("box_umap")
    )
  )
)

page_plots <- dashboardPage(
  title   = "Umap",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_plots
)