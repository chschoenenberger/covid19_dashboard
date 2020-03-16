# ---- Loading libraries ----
library("shiny")
library("shinydashboard")
library("tidyverse")
library("leaflet")
library("plotly")
library("DT")
library("fs")

source("utils.R", local = T)

updateData <- function() {
  # Download data from Johns Hopkins (https://github.com/CSSEGISandData/COVID-19) if the data is older than 0.5h
  if (as.double(Sys.time() - file_info("data/covid19_data.zip")$change_time, units = "hours") > 0.5) {
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
}
# Update with start of app
updateData()

# TODO: Still throws a warning but works for now
data_confirmed <- read_csv("data/time_series_19-covid-Confirmed.csv")
data_death     <- read_csv("data/time_series_19-covid-Deaths.csv")
data_recovered <- read_csv("data/time_series_19-covid-Recovered.csv")

# Get latest data
current_date                 <- as.Date(names(data_confirmed)[ncol(data_confirmed)], format = "%m/%d/%y")
changed_date                 <- file_info("data/covid19_data.zip")$change_time

# Get evolution data by country
data_confirmed_sub <- data_confirmed %>%
  pivot_longer(names_to = "date", cols = 5:ncol(data_confirmed)) %>%
  group_by(`Province/State`, `Country/Region`, date, Lat, Long) %>%
  summarise("confirmed" = sum(value))

data_recovered_sub <- data_recovered %>%
  pivot_longer(names_to = "date", cols = 5:ncol(data_recovered)) %>%
  group_by(`Province/State`, `Country/Region`, date, Lat, Long) %>%
  summarise("recovered" = sum(value))

data_death_sub <- data_death %>%
  pivot_longer(names_to = "date", cols = 5:ncol(data_death)) %>%
  group_by(`Province/State`, `Country/Region`, date, Lat, Long) %>%
  summarise("death" = sum(value))

data_evolution      <- data_confirmed_sub %>%
  full_join(data_recovered_sub) %>%
  full_join(data_death_sub) %>%
  pivot_longer(names_to = "var", cols = c(confirmed, recovered, death)) %>%
  ungroup()
data_evolution$date <- as.Date(data_evolution$date, "%m/%d/%y")
# Calculating new cases
data_evolution <- data_evolution %>%
  arrange(date) %>%
  group_by(`Province/State`, `Country/Region`) %>%
  mutate(value_new = value - lag(value, 3, default = 0)) %>%
  ungroup()

data_atDate <- function(inputDate) {
  data_evolution[which(data_evolution$date == inputDate),] %>%
    pivot_wider(id_cols = 1:5, names_from = var, values_from = value) %>%
    filter(confirmed > 0 | recovered > 0 | death > 0)
}

data_latest <- data_atDate(max(data_evolution$date))

rm(data_confirmed, data_confirmed_sub, data_recovered, data_recovered_sub, data_death, data_death_sub)
