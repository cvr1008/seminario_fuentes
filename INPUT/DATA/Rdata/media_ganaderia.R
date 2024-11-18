
library(dplyr)

# Calcular la media basada en la proporción de positivos
media_ganaderia <- paises_UE_df %>%
  group_by(Codigo, zoonosis_name) %>%
  summarise(
    media = mean((MuestraPositiva / TotalMuestras)*100, na.rm = TRUE)
  ) %>%
  ungroup()

media_ganaderia$media[is.nan(media_ganaderia$media)] <- 0



lista_codigos_paises <- list("AT", "BE", "BG", "CY", "CZ", "DE", "DK", "EE", "EL", "ES", "FI", "FR", "HR", "HU", 
                             "IE", "IT", "LT", "LU", "LV", "MT", "NL", "PL", "PT", "RO", "SE", "SI", "SK")


otra <- otra %>% 
  dplyr::filter(RegionCode %in% lista_codigos_paises)

resultado <- full_join(media_bacterias, otra, by = c("Codigo" = "RegionCode"))

