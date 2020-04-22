body_about <- dashboardBody(
  fluidRow(
    fluidRow(
      column(
        box(
          title = div("Proyecto", style = "padding-left: 20px", class = "h2"),
          column(
            "Este tablero esta basado en ", tags$a(href = "https://github.com/chschoenenberger/covid19_dashboard", "covid19_dashboard"), 
            "de Christoph Schoenenberger, un proyecto open source con MIT License, enfocado en producir un tablero de visualización a nivel global del avance de la pandemia originada por el COVID-19.",
            tags$br(),
            # tags$b("Disclaimer"), "This project is made for visualizing and learning purposes. The author is not an epidemiologist nor a 
            # health expert. The dashboard is being adapted and many constants still refer to the original version (the use of the word 
            # 'Countries' instead of 'Provinces', for example)",
            tags$br(),
            h3("Motivación"),
            "La idea principal es aunar esfuerzos para desarrollar una visualización de datos enfocados en el seguimiento histórico del avance de COVID-19 en Argentina.",
            tags$br(),
            tags$br(),
            h3("Data"),
            tags$ul(
              tags$li(tags$b("Repo argcovidapi:"), tags$a(href = "https://github.com/mariano22/argcovidapi/",
                "argcovidapi")),
              tags$li(tags$b("Population data:"), "Wikipedia (censo 2010)")
            ),
            h3("Bugs, Issues y solicitudes de mejora"),
            "Si encuentra algún error, problema o tiene alguna idea sobre cómo mejorar el panel, cree una solicitud en",
            tags$a(href = "https://github.com/disenodc/covid19_dashboard/issues","Github"),
            "Haré todo lo posible para investigarlo lo antes posible.",
            h3("Contribuciones"),
            "Si desea agregar una visualización o cualquier otra información, no dude en crear una solicitud de extracción en",
            tags$a(href = "https://github.com/disenodc/covid19_dashboard/pulls", "Github"), 
            "Para mayores modificaciones, cree un fork en el repositorio o cree una solicitud (Issue) para que podamos analizarlo.",
            h3("Desarrollo"),
            "Dario Ceballos (UI) | Data analyst - Arts & Tech UNQ Bachelor degree -  @",
            tags$a(href = "https://www.facebook.com/disenodc", "Facebook"), "|",
            tags$a(href = "https://www.linkedin.com/in/dario-ceballos/", "LinkedIn"), "|",
            tags$a(href = "https://github.com/disenodc/", "Github"),
            tags$br(),
            tags$br(),
            # "Dario Ceballos | Data analyst - Arts & Tech UNQ Bachelor degree -  @",
            # tags$a(href = "https://www.facebook.com/disenodc", "Facebook"), "|",
            # tags$a(href = "https://www.linkedin.com/in/dario-ceballos/", "LinkedIn"), "|",
            # tags$a(href = "https://github.com/disenodc/", "Github"),
            # tags$br(),
            # tags$br(),
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