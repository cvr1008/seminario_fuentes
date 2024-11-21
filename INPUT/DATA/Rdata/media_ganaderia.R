
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






table(factor(media_nueva$grupo))
table(factor(media_ganaderia_nueva$zoonosis_name))


#Filtro solo las bacterias comunes y les cambio el nombre de las bacterias comunes
media_nueva<-otra %>%
  filter(grupo %in% c("Ent", "Esc")) %>%
  mutate(grupo = recode(grupo, "Ent" = "Enterococcus", "Esc" = "Escherichia"))
#Filtro las bacterias comunes
media_ganaderia_nueva<-media_ganaderia %>%
  filter(zoonosis_name %in% c("Enterococcus,", "Escherichia")) %>%
  mutate(zoonosis_name = recode(zoonosis_name, "Enterococcus," = "Enterococcus"))


summary(media_ganaderia_nueva)
summary(media_nueva)

#Hago un join usando de union el codigo y las bacterias comunes
tabla_unida <- full_join(
  media_ganaderia_nueva, 
  media_nueva, 
  by = c("Codigo" = "RegionCode", "zoonosis_name" = "grupo")
)






