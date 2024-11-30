
library(dplyr)
library(rlang)

cambio_nombre_codigo <- function(Tabla, columna) {
  # Convertir el nombre de la columna en un símbolo
  columna_sym <- ensym(columna)
  
  Tabla %>%
    mutate(
      !!columna_sym := case_when(
        !!columna_sym == "Slovakia" ~ "SK",
        !!columna_sym == "Belgium" ~ "BE",
        !!columna_sym == "Cyprus" ~ "CY",
        !!columna_sym == "Greece" ~ "EL",
        !!columna_sym == "Romania" ~ "RO",
        !!columna_sym == "Bulgaria" ~ "BG",
        !!columna_sym == "France" ~ "FR",
        !!columna_sym == "Malta" ~ "MT",
        !!columna_sym == "Poland" ~ "PL",
        !!columna_sym == "Spain" ~ "ES",
        !!columna_sym == "Ireland" ~ "IE",
        !!columna_sym == "Italy" ~ "IT",
        !!columna_sym == "Luxembourg" ~ "LU",
        !!columna_sym == "Portugal" ~ "PT",
        !!columna_sym == "Czech Republic" ~ "CZ",
        !!columna_sym == "Czechia" ~ "CZ",
        !!columna_sym == "Finland" ~ "FI",
        !!columna_sym == "Austria" ~ "AT",
        !!columna_sym == "Germany" ~ "DE",
        !!columna_sym == "Denmark" ~ "DK",
        !!columna_sym == "Estonia" ~ "EE",
        !!columna_sym == "Hungary" ~ "HU",
        !!columna_sym == "Croatia" ~ "HR",
        !!columna_sym == "Lithuania" ~ "LT",
        !!columna_sym == "Latvia" ~ "LV",
        !!columna_sym == "Netherlands" ~ "NL",
        !!columna_sym == "Sweden" ~ "SE",
        !!columna_sym == "Slovenia" ~ "SI",
        TRUE ~ as.character(!!columna_sym) # Mantener valores originales si no coinciden
      )
    )
}



cambio_codigo_nombre <- function(Tabla, columna) {
  # Convertir el nombre de la columna en un símbolo
  columna_sym <- ensym(columna)
  
  Tabla %>%
    mutate(
      !!columna_sym := case_when(
        !!columna_sym == "SK" ~ "Slovakia",
        !!columna_sym == "BE" ~ "Belgium",
        !!columna_sym == "CY" ~ "Cyprus",
        !!columna_sym == "EL" ~ "Greece",
        !!columna_sym == "RO" ~ "Romania",
        !!columna_sym == "BG" ~ "Bulgaria",
        !!columna_sym == "FR" ~ "France",
        !!columna_sym == "MT" ~ "Malta",
        !!columna_sym == "PL" ~ "Poland",
        !!columna_sym == "ES" ~ "Spain",
        !!columna_sym == "IE" ~ "Ireland",
        !!columna_sym == "IT" ~ "Italy",
        !!columna_sym == "LU" ~ "Luxembourg",
        !!columna_sym == "PT" ~ "Portugal",
        !!columna_sym == "CZ" ~ "Czech Republic",
        !!columna_sym == "FI" ~ "Finland",
        !!columna_sym == "AT" ~ "Austria",
        !!columna_sym == "DE" ~ "Germany",
        !!columna_sym == "DK" ~ "Denmark",
        !!columna_sym == "EE" ~ "Estonia",
        !!columna_sym == "HU" ~ "Hungary",
        !!columna_sym == "HR" ~ "Croatia",
        !!columna_sym == "LT" ~ "Lithuania",
        !!columna_sym == "LV" ~ "Latvia",
        !!columna_sym == "NL" ~ "Netherlands",
        !!columna_sym == "SE" ~ "Sweden",
        !!columna_sym == "SI" ~ "Slovenia",
        TRUE ~ as.character(!!columna_sym) # Mantener valores originales si no coinciden
      )
    )
}


