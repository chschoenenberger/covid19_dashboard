valueBox_confirmed <- column(
  valueBox(
    format(sum(data_latest$confirmed), big.mark = " "),
    subtitle = "Confirmed",
    icon     = icon("file-medical"),
    color    = "light-blue",
    width    = NULL
  ),
  width = 3,
  style = "padding-left: 0px"
)

valueBox_recovered <- valueBox(
  format(sum(data_latest$recovered), big.mark = " "),
  subtitle = "Recovered",
  icon     = icon("heart"),
  color    = "light-blue",
  width    = 3
)

valueBox_death <- valueBox(
  format(sum(data_latest$death), big.mark = " "),
  subtitle = "Death",
  icon     = icon("heartbeat"),
  color    = "light-blue",
  width    = 3
)

valueBox_countries <- valueBox(
  nrow(distinct(data_latest, `Country/Region`)),
  subtitle = "Affected Countries",
  icon     = icon("flag"),
  color    = "light-blue",
  width    = 3
)

output$box_keyFigures <- renderUI(box(
  title = paste0("Key Figures (", strftime(current_date, format = "%d.%m.%Y"), ")"),
  fluidRow(
    valueBox_confirmed,
    valueBox_recovered,
    valueBox_death,
    valueBox_countries
  ),
  div("Last updated: ", strftime(changed_date, format = "%d.%m.%Y - %R %Z")),
  width = 12
))