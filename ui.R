source("sections/ui_overview.R", local = TRUE)
source("sections/ui_plots.R", local = TRUE)

navbarPage(
  title       = "COVID-19 Global Cases - Open Source Version",
  collapsible = TRUE,
  fluid       = TRUE,
  tabPanel("Overview", page_overview, value = "page-overview"),
  tabPanel("Plots", page_plots, value = "page-plots")
)