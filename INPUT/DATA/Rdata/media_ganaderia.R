library(patchwork)
library(dplyr)
library(tidyr)
library(ggplot2)

# Calcular la media basada en la proporción de positivos
media_ganaderia <- paises_UE_df %>%
  group_by(Codigo, zoonosis_name) %>%
  dplyr::summarise(
    media = mean((MuestraPositiva / TotalMuestras)*100, na.rm = TRUE)) %>%
  ungroup() %>% 
  tidyr::drop_na()


table(factor(otra$grupo))
table(factor(media_ganaderia$zoonosis_name))
#Observamos que las unicas bacterias comunes son Enterococcus y Escherichia



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


tabla_unida <- full_join(x=media_ganaderia_nueva, y= bacterias_personas, 
  by = c("Codigo" = "RegionCode", "zoonosis_name" = "grupo")) %>% 
  dplyr::rename(Ganaderia=media, Poblacion=mean_value) %>% 
  pivot_longer(.,names_to = "Variable", values_to = "Valores", cols = c(Ganaderia:Poblacion)) %>% 
  mutate(Bacteria = factor(zoonosis_name, levels = c("Escherichia","Enterococcus"))) %>% 
  mutate(Variable = factor(Variable, levels = c("Ganaderia","Poblacion"))) %>% 
  tidyr::drop_na()



ggplot(data = tabla_unida, aes(x = Valores, y = Codigo)) +
  geom_bar(aes(fill = Bacteria), position = "dodge", stat = "identity") +
  facet_wrap(facets = vars(Variable), nrow = 1)+
  labs(x = "Porcentaje de incidencia")


# ahora sacamos tabla sencillita para unirla con los positivos en personas

positivos_animales <- bacterias_personas%>%
  group_by(RegionCode)%>%
  dplyr::summarise(media = mean(mean_value, na.rm = TRUE))


#BOXPLOT DE BACTERIAS QUE AFECTAN A ANIMALES Y BACTERIAS

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


boxplot_bac_ganaderia + boxplot_baterias_personas




