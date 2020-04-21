body_plots <- dashboardBody(
  fluidRow(
    fluidRow(
      fluidRow(
        box(
          title = "Evolution of Cases since Outbreak",
          plotlyOutput("case_evolution"),
          column(
            checkboxInput("checkbox_logCaseEvolution", label = "Logarithmic Y-Axis", value = FALSE),
            width = 3,
            style = "float: right; padding: 10px; margin-right: 50px"
          ),
          width = 6
        ),
        box(
          title = "New cases",
          plotlyOutput("case_evolution_new"),
          column(
            uiOutput("selectize_casesByCountries_new"),
            width = 3,
          ),
          column(
            HTML("Note: Active cases are calculated as <i>Confirmed - (Estimated Recoveries + Deceased)</i>. Therefore, <i>new</i> active cases can
          be negative for some days, if on this day there were more new estimated recoveries + deceased cases than there were new
          confirmed cases."),
            width = 7
          ),
          width = 6
        )
      ),
      fluidRow(
        box(
          title = "Cases per Country",
          plotlyOutput("case_evolution_byCountry"),
          fluidRow(
            column(
              uiOutput("selectize_casesByCountries"),
              width = 3,
            ),
            column(
              checkboxInput("checkbox_logCaseEvolutionCountry", label = "Logarithmic Y-Axis", value = FALSE),
              checkboxInput("checkbox_per100kEvolutionCountry", label = "Per Population", value = FALSE),
              width = 3,
              style = "float: right; padding: 10px; margin-right: 50px"
            )
          ),
          width = 6
        ),
        box(
          title = "Evolution of Cases since 10th/100th case",
          plotlyOutput("case_evolution_after100"),
          fluidRow(
            column(
              uiOutput("selectize_casesByCountriesAfter100th"),
              width = 3,
            ),
            column(
              uiOutput("selectize_casesSince100th"),
              width = 3
            ),
            column(
              checkboxInput("checkbox_logCaseEvolution100th", label = "Logarithmic Y-Axis", value = FALSE),
              checkboxInput("checkbox_per100kEvolutionCountry100th", label = "Per Population", value = FALSE),
              width = 3,
              style = "float: right; padding: 10px; margin-right: 50px"
            )
          ),
          width = 6
        )
      ),
      fluidRow(
        box(
          title = "Evolution of Doubling Times per Country",
          plotlyOutput("plot_doublingTime"),
          fluidRow(
            column(
              uiOutput("selectize_doublingTime_Country"),
              width = 3,
            ),
            column(
              uiOutput("selectize_doublingTime_Variable"),
              width = 3,
            ),
            column(width = 3),
            column(
              div("Note: The doubling time is calculated based on the growth rate over the last seven days.",
                style = "padding-top: 15px;"),
              width = 3
            )
          )
        )
      )
    )
  )
)

page_plots <- dashboardPage(
  title   = "Plots",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_plots
)