# ---- Loading libraries ----
library("shiny")
library("shinydashboard")
library("tidyverse")
library("leaflet")
library("plotly")
library("DT")
library("fs")
library("wbstats")

source("utils.R", local = T)
# TODO: 
downloadGithubData <- function() {
  download.file(
    url      = "https://github.com/CSSEGISandData/COVID-19/archive/master.zip",
    destfile = "data/covid19_data.zip"
  )
  
  data_path <- "COVID-19-master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_"
  unzip(
    zipfile   = "data/covid19_data.zip",
    files     = paste0(data_path, c("confirmed_global.csv", "deaths_global.csv", "recovered_global.csv", "confirmed_US.csv", "deaths_US.csv")),
    exdir     = "data",
    junkpaths = T
  )
}


updateData <- function() {
  # TODO: updateData is dummy for now
  if (FALSE) {
    # Download data from Johns Hopkins (https://github.com/CSSEGISandData/COVID-19) if the data is older than 0.5h
    if (!dir_exists("data")) {
      dir.create('data')
      downloadGithubData()
    } else if ((!file.exists("data/covid19_data.zip")) || (as.double(Sys.time() - file_info("data/covid19_data.zip")$change_time, units = "hours") > 0.5)) {
      downloadGithubData()
    }
  }
}

# TODO: Update with start of app
updateData()
# TODO: Get last update data day and time
changed_date <- file_info("data/covid19_data_mariano22.zip")$change_time



# Get info data (lat, long, population)
data_info <- read_csv("data/info_arg.csv")
# Get data from my csv
raw_data_covid <- read_csv("data/Argentina_Provinces.csv")
# Get latest day
current_date <- as.Date(paste(names(raw_data_covid)[ncol(raw_data_covid)],'/2020',sep=''), format = "%d/%m/%y")

# Format data: 
data_covid <- raw_data_covid %>%
  pivot_longer(names_to='date', 3:ncol(.)) %>%
  mutate(date = paste(date,'/2020',sep='')) %>%
  mutate(date = as.Date(date, "%d/%m/%y")) %>%
  # pivot_wider(names_from = TYPE, values_from = value) %>%
  mutate(TYPE = recode(TYPE, 'ACTIVOS' = 'active', 'CONFIRMADOS' = 'confirmed', 'RECUPERADOS' = 'recovered', 'MUERTOS' = 'deceased')) %>%
  arrange(date)  %>%
  mutate("Country/Region" = PROVINCIA) %>%
  rename("Province/State" = PROVINCIA, var = TYPE, ) %>%
  left_join(data_info, by = c("Province/State" = "place"))  %>%
  group_by(`Province/State`, `Country/Region`) %>%
  mutate(value_new = value - lag(value, 4, default = 0)) %>%
  ungroup() %>%
  .[, c("Province/State", "Country/Region", "date", "Lat", "Long", "var", "value", "value_new", "population")]

data_evolution <- data_covid

data_atDate <- function(inputDate) {
  x <- data_evolution[which(data_evolution$date == inputDate),] %>%
       distinct() %>%
       pivot_wider(id_cols = c("Province/State", "Country/Region", "date", "Lat", "Long", "population"), names_from = var, values_from = value) %>%
       filter(confirmed > 0 |
              recovered > 0 |
              deceased > 0 |
              active > 0);
  x
   
}

data_latest <- data_atDate(max(data_evolution$date))

top5_countries <- data_evolution %>%
  filter(var == "active", date == current_date) %>%
  group_by(`Country/Region`) %>%
  summarise(value = sum(value, na.rm = T)) %>%
  arrange(desc(value)) %>%
  top_n(5) %>%
  select(`Country/Region`) %>%
  pull()
