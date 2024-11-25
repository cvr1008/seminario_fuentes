
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









#Filtro solo las bacterias comunes y les cambio el nombre de las bacterias comunes
media_nueva<-otra %>%
  filter(grupo %in% c("Ent", "Esc")) %>%
  mutate(grupo = recode(grupo, "Ent" = "Enterococcus", "Esc" = "Escherichia"))
#Filtro las bacterias comunes
media_ganaderia_nueva<-media_ganaderia %>%
  filter(zoonosis_name %in% c("Enterococcus,", "Escherichia")) %>%
  mutate(zoonosis_name = recode(zoonosis_name, "Enterococcus," = "Enterococcus"))

table(factor(media_nueva$grupo))
table(factor(media_ganaderia_nueva$zoonosis_name))

summary(media_ganaderia_nueva)
summary(media_nueva)

#Hago un join usando de union el codigo y las bacterias comunes
library(tidyr)
library(ggplot2)

tabla_unida <- full_join(x=media_ganaderia_nueva, y= media_nueva, 
  by = c("Codigo" = "RegionCode", "zoonosis_name" = "grupo")) %>% 
  rename(mediaGanaderia=media, mediaEnPoblacion=mean_value) %>% 
  pivot_longer(.,names_to = "Variable", values_to = "Valores", cols = c(mediaGanaderia:mediaEnPoblacion)) %>% 
  mutate(zoonosis_name = factor(zoonosis_name, levels = c("Escherichia","Enterococcus"))) %>% 
  mutate(Variable = factor(Variable, levels = c("mediaGanaderia","mediaEnPoblacion"))) %>% 
  drop_na()



ggplot(data = tabla_unida, aes(x = Valores, y = Codigo)) +
  geom_bar(aes(fill = zoonosis_name), position = "dodge", stat = "identity") +
  facet_wrap(facets = vars(Variable), nrow = 1)






