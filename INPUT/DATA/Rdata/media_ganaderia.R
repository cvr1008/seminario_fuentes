
library(dplyr)

# Calcular la media basada en la proporción de positivos
media_ganaderia <- paises_UE_df %>%
  group_by(Codigo, zoonosis_name) %>%
  dplyr::summarise(
    media = mean((MuestraPositiva / TotalMuestras)*100, na.rm = TRUE)) %>%
  ungroup() %>% 
  drop_na()





lista_codigos_paises <- list("AT", "BE", "BG", "CY", "CZ", "DE", "DK", "EE", "EL", "ES", "FI", "FR", "HR", "HU", 
                             "IE", "IT", "LT", "LU", "LV", "MT", "NL", "PL", "PT", "RO", "SE", "SI", "SK")

#Cargamos el df de las bacterias que afectan a las personas
otra <- otra %>% 
  dplyr::filter(RegionCode %in% lista_codigos_paises)

#Las unicas bacterias comunes son Enterococcus y Escherichia
table(factor(otra$grupo))
table(factor(media_ganaderia$zoonosis_name))



#Filtro solo las bacterias comunes y les cambio el nombre de las bacterias comunes
bacterias_personas<-otra %>%
  dplyr::filter(grupo %in% c("Enterococcus", "Escherichia")) 
  

#Filtro las bacterias comunes
media_ganaderia_nueva<-media_ganaderia %>%
  filter(zoonosis_name %in% c("Enterococcus,", "Escherichia")) %>%
  mutate(zoonosis_name = recode(zoonosis_name, "Enterococcus," = "Enterococcus"))


summary(media_ganaderia_nueva)
summary(bacterias_personas)

#Hago un join usando de union el codigo y las bacterias comunes
library(tidyr)
library(ggplot2)

tabla_unida <- full_join(x=media_ganaderia_nueva, y= bacterias_personas, 
  by = c("Codigo" = "RegionCode", "zoonosis_name" = "grupo")) %>% 
  dplyr::rename(mediaGanaderia=media, mediaEnPoblacion=mean_value) %>% 
  pivot_longer(.,names_to = "Variable", values_to = "Valores", cols = c(mediaGanaderia:mediaEnPoblacion)) %>% 
  mutate(zoonosis_name = factor(zoonosis_name, levels = c("Escherichia","Enterococcus"))) %>% 
  mutate(Variable = factor(Variable, levels = c("mediaGanaderia","mediaEnPoblacion"))) %>% 
  drop_na()



ggplot(data = tabla_unida, aes(x = Valores, y = Codigo)) +
  geom_bar(aes(fill = zoonosis_name), position = "dodge", stat = "identity") +
  facet_wrap(facets = vars(Variable), nrow = 1)


# ahora sacamos tabla sencillita para unirla con los positivos en personas

positivos_animales <- bacterias_personas%>%
  group_by(RegionCode)%>%
  dplyr::summarise(media = mean(mean_value, na.rm = TRUE))


#BOXPLOT DE BACTERIAS QUE AFECTAN A ANIMALES

boxplot_bac_ganaderia<-ggplot(media_ganaderia,aes(x=zoonosis_name, y=media, fill=zoonosis_name)) + 
  geom_boxplot() +
  labs(title = "Incidencia de bacterias en ganadería ",
       x = "bacterias", y = "Incidencia media")  +
  theme(legend.position="none")

boxplot_baterias_personas <- ggplot(otra, aes(x = grupo, y = mean_value, fill=grupo)) +
  geom_boxplot() +
  labs(title = "Incidencia de bacterias en personas ",
       x = "bacterias", y = "Incidencia media") +
  theme(legend.position="none",
  axis.text.x = element_text(angle = 45, hjust = 1))


library(patchwork)
boxplot_bac_ganaderia + boxplot_baterias_personas




