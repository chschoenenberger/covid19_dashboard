# ---- Loading libraries ----
library("shiny")
library("shinydashboard")
library("tidyverse")
library("leaflet")
library("plotly")
library("DT")

# Download data from Johns Hopkins (https://github.com/CSSEGISandData/COVID-19) if the data is older than 1h
if (as.double(Sys.time() - file_info("data/covid19_data.zip")$change_time, units = "hours") > 1) {
  file_delete("data/covid19_data.zip")

  download.file(
    url      = "https://github.com/CSSEGISandData/COVID-19/archive/master.zip",
    destfile = "data/covid19_data.zip"
  )

  data_path <- "COVID-19-master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-"
  unzip(
    zipfile   = "data/covid19_data.zip",
    files     = paste0(data_path, c("Confirmed.csv", "Deaths.csv", "Recovered.csv")),
    exdir     = "data",
    junkpaths = T
  )
}

# TODO: Still throws a warning but works for now
data_confirmed <- read_csv("data/time_series_19-covid-Confirmed.csv")
data_death     <- read_csv("data/time_series_19-covid-Deaths.csv")
data_recovered <- read_csv("data/time_series_19-covid-Recovered.csv")

# Get latest data
data_confirmed_latest        <- data_confirmed[, c(1:4, ncol(data_confirmed))]
names(data_confirmed_latest) <- c(names(data_confirmed_latest)[1:4], "confirmed")
data_death_latest            <- data_death[, c(1:4, ncol(data_death))]
names(data_death_latest)     <- c(names(data_death_latest)[1:4], "death")
data_recovered_latest        <- data_recovered[, c(1:4, ncol(data_recovered))]
names(data_recovered_latest) <- c(names(data_recovered_latest)[1:4], "recovered")
rm(data_confirmed, data_death, data_recovered)

# Join datasets
data_latest <- full_join(data_confirmed_latest, data_death_latest)
data_latest <- full_join(data_latest, data_recovered_latest)
rm(data_confirmed_latest, data_death_latest, data_recovered_latest)
