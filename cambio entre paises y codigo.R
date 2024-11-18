# este script necesita que se cargue el enviroment .RData

# necesita que se cargue el archivo EU_ddd

View(media_region)
View(DDD_Europa_df)

lista_codigos_paises <- list("AT", "BE", "BG", "CY", "CZ", "DE", "DK", "EE", "EL", "ES", "FI", "FR", "HR", "HU", 
                             "IE", "IT", "LT", "LU", "LV", "MT", "NL", "PL", "PT", "RO", "SE", "SI", "SK") 

DDD_Europa_df <- DDD_Europa_df %>%
  mutate(Country = case_when(
    Country == "Eslovaquia" ~ "SK",
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
    Country == "Croatia" ~ "",
    Country == "Luxembourg" ~ "LU",
    Country == "Portugal" ~ "PT",
    Country == "Iceland" ~ "",
    Country == "Czechia" ~ "CZ",
    Country == "Norway" ~ "",
    
    
    
  ))