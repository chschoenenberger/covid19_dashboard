body_about <- dashboardBody(
  fluidRow(
    fluidRow(
      column(
        box(
          title = div("About this project", style = "padding-left: 20px", class = "h2"),
          column(
            "This dashbord is based on", tags$a(href = "https://github.com/chschoenenberger/covid19_dashboard", "covid19_dashboard"), 
            "by Christoph Schoenenberger, an open source project that shows the development of the COVID-19 pandemic.",
            tags$br(),
            tags$b("Disclaimer"), "This project is made for visualizing and learning purposes. The author is not an epidemiologist nor a 
            health expert. The dashboard is being adapted and many constants still refer to the original version (the use of the word 
            'Countries' instead of 'Provinces', for example)",
            tags$br(),
            h3("Motivation"),
            "My idea was to show the development of the COVID-19 pandemic in Argentina. I also think that",
            tags$b("geography and time"), "are key elements in the pandemic evolution dataviz.",
            tags$br(),
            "I found a cute open source project and adapted it to be fed by the data source I created.",
            tags$br(),
            tags$br(),
            h3("Data"),
            tags$ul(
              tags$li(tags$b("Repo argcovidapi:"), tags$a(href = "https://github.com/mariano22/argcovidapi/",
                "argcovidapi")),
              tags$li(tags$b("Population data:"), "Wikipedia (censo 2010)")
            ),
            h3("Bugs, Issues & Enhancement Requests"),
            "If you find any bugs, issues, or have any ideas on how to improve the dashboard, please create an issue on",
            tags$a(href = "https://github.com/mariano22/covid19_dashboard/issues","Github"),
            ".I will do my best to look into it as soon as possible.",
            h3("Contribute"),
            "If you want to add a visualization or any further information, feel free to create a pull request on",
            tags$a(href = "https://github.com/mariano22/covid19_dashboard/pulls", "Github"), 
            ".For major reworks, either fork the repository or create an issue so we can discuss it.",
            h3("Developers"),
            "Mariano Crosetti | Computer Sciences student @",
            tags$a(href = "https://www.facebook.com/mariano.crosetti.3", "Facebook"), "|",
            tags$a(href = "https://www.linkedin.com/in/mariano-crosetti-0b71a4146/", "LinkedIn"), "|",
            tags$a(href = "https://twitter.com/MarianoCrosetti", "Twitter"), "|",
            tags$a(href = "https://github.com/mariano22/", "Github"),
            tags$br(),
            tags$br(),
            "Christoph Schoenenberger (original repo) | Data Scientist @",
            tags$a(href = "https://www.zuehlke.com/ch/en/", "Zuehlke Engineering"), "|",
            tags$a(href = "https://www.linkedin.com/in/cschonenberger/", "LinkedIn"), "|",
            tags$a(href = "https://twitter.com/ChSchonenberger", "Twitter"), "|",
            tags$a(href = "https://github.com/chschoenenberger/", "Github"),
            width = 12,
            style = "padding-left: 20px; padding-right: 20px; padding-bottom: 40px; margin-top: -15px;"
          ),
          width = 6,
        ),
        width = 12,
        style = "padding: 15px"
      )
    )
  )
)

page_about <- dashboardPage(
  title   = "About",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_about
)