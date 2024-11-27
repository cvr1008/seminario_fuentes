library(readr)
library(readxl)
library(dplyr)
antibioticos_europa_ganaderia <- read_csv("INPUT/DATA/antibioticos_europa_ganaderia.csv")

View(antibioticos_europa_ganaderia)

antib <- antibioticos_europa_ganaderia%>%
  mutate(Entity = case_when(
    Entity == "Slovakia" ~ "SK",
    Entity == "Belgium" ~ "BE",
    Entity == "Cyprus" ~ "CY",
    Entity == "Greece" ~ "EL",
    Entity == "Romania" ~ "RO",
    Entity == "Bulgaria" ~ "BG",
    Entity == "France" ~ "FR",
    Entity == "Malta" ~ "MT",
    Entity == "Poland" ~ "PL",
    Entity == "Spain" ~ "ES",
    Entity == "Ireland" ~ "IE",
    Entity == "Italy" ~ "IT",
    Entity == "Luxembourg" ~ "LU",
    Entity == "Portugal" ~ "PT",
    Entity == "Czechia" ~ "CZ",
    Entity == "Finland" ~ "FI",
    Entity == "Austria" ~ "AT",
    Entity == "Germany" ~ "DE",
    Entity == "Denmark" ~ "DK",
    Entity == "Estonia" ~ "EE",
    Entity == "Hungary" ~ "HU",
    Entity == "Croatia" ~ "HR",
    Entity == "Lithuania" ~ "LT",
    Entity == "Latvia" ~ "LV",
    Entity == "Netherlands" ~ "NL",
    Entity == "Sweden" ~ "SE",
    Entity == "Slovenia" ~ "SI",
  ))%>%
  drop_na()%>%
  select(-Code)%>%
  filter(Year == "2015")%>%
  dplyr::rename(Country = Entity)
  


ant_europa_g <- read_excel("INPUT/DATA/consumo_ganaderia_2022.xlsx", skip = 3)

View(ant_europa_g)

a_e_g <- ant_europa_g %>%
  select("Country", "...5")%>%
  dplyr::rename(Antibiotic_use_in_livestock_1000_PCU = `...5`)%>%
  mutate(Year = "2022")%>%
  mutate(Country = case_when(
    Country == "Slovakia" ~ "SK",
    Country == "Belgium" ~ "BE",
    Country == "Cyprus" ~ "CY",
    Country == "Greece" ~ "EL",
    Country == "Romania" ~ "RO",
    Country == "Bulgaria" ~ "BG",
    Country == "France" ~ "FR",
    Country == "Malta" ~ "MT",
    Country == "Poland" ~ "PL",
    Country == "Spain" ~ "ES",
    Country == "Ireland" ~ "IE",
    Country == "Italy" ~ "IT",
    Country == "Luxembourg" ~ "LU",
    Country == "Portugal" ~ "PT",
    Country == "Czech Republic" ~ "CZ",
    Country == "Finland" ~ "FI",
    Country == "Austria" ~ "AT",
    Country == "Germany" ~ "DE",
    Country == "Denmark" ~ "DK",
    Country == "Estonia" ~ "EE",
    Country == "Hungary" ~ "HU",
    Country == "Croatia" ~ "HR",
    Country == "Lithuania" ~ "LT",
    Country == "Latvia" ~ "LV",
    Country == "Netherlands" ~ "NL",
    Country == "Sweden" ~ "SE",
    Country == "Slovenia" ~ "SI",
  ))%>%
  drop_na()%>%
  relocate(3, .before = 2)
  
new <- a_e_g %>%
  select(-Year)%>%
  mutate(Antibiotic_use_in_livestock_100_PCU = as.numeric(Antibiotic_use_in_livestock_1000_PCU)/10)%>%
  mutate(Antibiotic_day_livestock_100_PCU = Antibiotic_use_in_livestock_100_PCU/365)%>%
  select(-Antibiotic_use_in_livestock_1000_PCU, -Antibiotic_use_in_livestock_100_PCU)
  