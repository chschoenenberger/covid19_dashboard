output$summaryTables <- renderUI({
  tabBox(
    tabPanel("Provincias",
      div(
        dataTableOutput("provinces_DT"),
        style = "margin-top: 10px")
    ),
    #tabPanel("NONE",
             #div(
        #dataTableOutput("summaryDT_state"),
        #style = "margin-top: -10px"
        #  )
    #),
    width = 12
  )
})

provinces_data_at_date <- function(date_argument) {
    global_time_series_melt %>%
    filter(date == date_argument & CONFIRMADOS>0) %>%
    backend_filter_location_by_level(1) %>%
    rename("Provincias" = "LOCATION",
           "Confirmados" = "CONFIRMADOS",
           "Confirmados x 100K hab." = "CONFIRMADOS_PER100K",
           "Recuperados" = "RECUPERADOS",
           "Fallecidos" = "MUERTOS",
           "Fallecidos x 100K hab." = "MUERTOS_PER100K",
           "Activos" = "ACTIVOS") %>%
    .[,c("Provincias","Confirmados", "Confirmados x 100K hab.", "Recuperados", "Fallecidos", "Fallecidos x 100K hab.", "Activos")]
}

to_DataTable <- function(df) {
    datatable(
      df,
      rownames  = FALSE,
      options   = list(
        order          = list(1, "desc"),
        scrollX        = TRUE,
        scrollY        = "37vh",
        scrollCollapse = T,
        dom            = 'ft',
        paging         = FALSE
      ),
      selection = "single"
    )
}

output$provinces_DT <- renderDataTable(to_DataTable(provinces_data_at_date(current_date)))

proxy_provinces_DT  <- dataTableProxy("provinces_DT")

provinces_DT_data <- reactive({provinces_data_at_date(input$timeSlider)})

observeEvent(input$timeSlider, {
  replaceData(proxy_provinces_DT, provinces_DT_data(), rownames = FALSE)
}, ignoreInit = TRUE, ignoreNULL = TRUE)

observeEvent(input$provinces_DT_rows_selected, {
  selected_province <- provinces_DT_data()[input$provinces_DT_rows_selected,"Provincias"]
  location <- global_geoinfo %>%
              backend_filter_location_by_level(1) %>%
              filter(LOCATION == selected_province) %>%
              .[,c("LAT","LONG")]
  leafletProxy("overview_map") %>%
    setView(lng = location$LONG, lat = location$LAT, zoom = 4)
})
