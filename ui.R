source("sections/ui_overview.R", local = TRUE)
source("sections/ui_plots.R", local = TRUE)
#source("sections/ui_umap.R", local = TRUE)
#source("sections/ui_about.R", local = TRUE)
source("sections/ui_fullTable.R", local = TRUE)

ui <- fluidPage(
  title = "COVID_19 Argentina",
  tags$head(
    tags$link(rel = "shortcut icon", type = "image/png", href = "logo.png")
  ),
  tags$style(type = "text/css", ".container-fluid {padding-left: 0px; padding-right: 0px !important;}"),
  tags$style(type = "text/css", ".navbar {margin-bottom: 0px;}"),
  tags$style(type = "text/css", ".content {padding: 0px;}"),
  tags$style(type = "text/css", ".row {margin-left: 0px; margin-right: 0px;}"),
  tags$style(HTML(".col-sm-12 { padding: 5px; margin-bottom: -15px; }")),
  tags$style(HTML(".col-sm-6 { padding: 5px; margin-bottom: -15px; }")),
  navbarPage(
    title       = div("COVID_19 Argentina", style = "padding-left: 10px"),
    collapsible = TRUE,
    fluid       = TRUE,
    tabPanel("Tablero", icon = icon("table"), page_overview, value = "page-overview"),
    tabPanel("Data", icon = icon("list-alt"), page_fullTable, value = "page-fullTable"),
    tabPanel("Grafos", icon = icon("bar-chart-o"), page_plots, value = "page-plots"),
    #tabPanel("Umap", icon = icon("map"), page_umap, value = "page-umap"),
    #tabPanel("Proyecto", icon = icon("address-card"), page_about, value = "page-about"),
    tags$script(HTML("var header = $('.navbar > .container-fluid');
    #header.append('<div style=\"float:right\"><a target=\"_blank\" href=\"https://github.com/disenodc/covid19_dashboard\"><img src=\"logo.png\" alt=\"alt\" style=\"float:right;width:33px;padding-top:10px;margin-top:-50px;margin-right:10px\"> </a></div>');
    console.log(header)")
    )
  )
)