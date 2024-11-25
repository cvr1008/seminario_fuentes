library(tidyverse)
library(rjson)
library(dplyr)
library(tidyr)
library(ggplot2)


DDD_Europa_Json <- fromJSON(file = "INPUT/DATA/DDD_1000_habitantes_paises.JSON")

DDD_Europa_Json

# --------------------
DDD_Europa_df <- do.call(rbind, lapply(DDD_Europa_Json, function(x) {
  data.frame(Country = x$Country, 
             DDD_per_1000_inhabitants_per_day = as.numeric(x$`DDD per 1000 inhabitants per day`))
}))




DDD_Europa_df <- DDD_Europa_df %>%
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
    Country == "Czechia" ~ "CZ",
    Country == "Finland" ~ "FI",
    Country == "Austria" ~ "AT",
    Country == "Norway" ~ "DE",
    Country == "Denmark" ~ "DK",
    Country == "Estonia" ~ "EE",
    Country == "Hungary" ~ "HU",
    Country == "Croatia" ~ "HR",
    Country == "Lithuania" ~ "LT",
    Country == "Latvia" ~ "LV",
    Country == "Netherlands" ~ "NL",
    Country == "Iceland" ~ "SE",
    Country == "Slovenia" ~ "SI",
  ))%>%
  mutate(DDD_per_100_inhabitants_per_day = DDD_per_1000_inhabitants_per_day/10)%>%
  select(-DDD_per_1000_inhabitants_per_day)




# al tratarse del número de dosis estándar consumidas diariamente por cada 1000 personas, se divide entre 10 para
# que sea número de dosis diarias por cada 100 habitantes.

# resumen: el x% de la población de cada país consume antibiótico de forma diaria en el sector 
# hospitalario y comunitario.



grafico_DDD <- ggplot(DDD_Europa_df, aes(x = reorder(Country, -DDD_per_1000_inhabitants_per_day), 
                          y = DDD_per_1000_inhabitants_per_day)) +
  geom_bar(stat = "identity", fill = "turquoise") +
  labs(title = "DDD por 1000 habitantes por día en Europa", 
       x = "País", 
       y = "DDD por 1000 habitantes por día") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
grafico_DDD

