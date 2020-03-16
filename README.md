# COVID-19 Dashboard 
This [dashboard](https://chschoenenberger.shinyapps.io/covid19_dashboard/) shows recent developments of the COVID-19 pandemic. The latest
open data on the COVID-19 spread are regularly downloaded and displayed in
a map, summary tables, key figures and plots.

## Motivation
Various companies thought that a global crisis is an excellent opportunity to 
show case their technologies. Therefore, my idea was to show that open-source 
technologies, such as R Shiny, can be used to create a decent dashboard in few hours.
Furthermore, the most popular COVID-19 dashboard 
([Johns Hopkins COVID-19](https://coronavirus.jhu.edu/map.html)) is styled rather
alarmist. Therefore, a more neutral dashboard might help to dampen the already 
existing hysteria a little.

### Why Open Source?
My hope is that this dashboard can help researchers around the world to get a 
better overview of the current situation concerning the COVID-19 idea. I hereby
invite all of you to contribute to this project with additional visualizations,
information etc.

## Installation
First install R and your favourite IDE on your machine (I suggest RStudio
or IntelliJ Community Edition with R plugin). To run the dashboard on your 
own machine, clone the repository and install 
[renv](https://rstudio.github.io/renv/articles/renv.html). Renv is a dependency
management tool for R. After installing call ``renv::restore()``. This will
get all libraries in renv.lock and install them on your machine. Afterwards
you should be able to run the dashboard by calling ``shiny::runApp()``.

### Publishing
I used [RStudio Connect](https://rstudio.com/products/connect/) with 
[Shinyapps.io](https://www.shinyapps.io/) to publish this dashboard. As
the rsconnect library currently does not run smoothly with renv, 
deactivate renv by calling ``renv::deactivate()``. Afterwards you should
be able to deploy the dashboard to Shinyapps using ``rsconnect::deployApp()``.

## Contribute
If you want to add any visualization or further information feel free to create
a pull request. For major rework either fork the repository or create
an issue so we can discuss it.

**PLEASE**: Do not add any models or the likes if you are no expert in 
epidemiology or similar. This dashboard should only display validated
research or information. Your pull request will not be accepted if you
are not able to verify your expertise.

## Bugs, Issues & Enhancement Requests
If you find any bug / issue or have an idea how to improve the dashboard,
please create an [issue](https://github.com/chschoenenberger/covid19_dashboard/issues). 
I will try to look into it as soon as possible.

## License
MIT © Christop Schönenberger
