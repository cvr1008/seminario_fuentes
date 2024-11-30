library(sf)
library(ggplot2)
library(plotly)
library(dplyr)
library(leaflet)  # Para crear mapas interactivos
library(sf)       # Para trabajar con datos espaciales (sf)
library(viridis)
library(tidyr)

paises_UE_mapa <- c(
  "Cyprus", "France", "Lithuania", "Czechia", "Germany", 
  "Estonia", "Latvia", "Sweden", "Finland", "Luxembourg", 
  "Belgium", "Spain", "Denmark", "Romania", "Hungary", 
  "Slovakia", "Poland", "Ireland", "Greece", "Austria", 
  "Italy", "Netherlands", "Croatia", "Slovenia", "Bulgaria", 
  "Portugal", "Malta"
)
 




mapa_mundo <- st_read("INPUT/DATA/mapaMundi")  # Cargar el mapa de países en formato `sf`

#Filtramos y cambiamos a codigo para poder unir 
mapa_mundo <- mapa_mundo %>% 
  filter(NAME %in% paises_UE_mapa) %>% 
  mutate(NAME = case_when(
    NAME == "Slovakia" ~ "SK",
    NAME == "Belgium" ~ "BE",
  NAME == "Cyprus" ~ "CY",
  NAME == "Greece" ~ "EL",
  NAME == "Romania" ~ "RO",
  NAME == "Bulgaria" ~ "BG",
  NAME == "France" ~ "FR",
  NAME == "Malta" ~ "MT",
  NAME == "Poland" ~ "PL",
  NAME == "Spain" ~ "ES",
  NAME == "Ireland" ~ "IE",
  NAME == "Italy" ~ "IT",
  NAME == "Luxembourg" ~ "LU",
  NAME == "Portugal" ~ "PT",
  NAME == "Czechia" ~ "CZ",
  NAME == "Finland" ~ "FI",
  NAME == "Austria" ~ "AT",
  NAME == "Norway" ~ "DE",
  NAME == "Denmark" ~ "DK",
  NAME == "Estonia" ~ "EE",
  NAME == "Hungary" ~ "HU",
  NAME == "Croatia" ~ "HR",
  NAME == "Lithuania" ~ "LT",
  NAME == "Latvia" ~ "LV",
  NAME == "Netherlands" ~ "NL",
  NAME == "Iceland" ~ "SE",
  NAME == "Slovenia" ~ "SI",
))


# Realizar el join usando las columnas correctas
mapa_mundo_europa <-left_join(x=mapa_mundo,y=media_region, by = c("NAME" = "RegionCode")) %>% 
  dplyr::rename(Porcentaje_positivos=mean_value_region) %>%  
  dplyr::mutate(Porcentaje_positivos = round(Porcentaje_positivos, 2))




# Crear el gráfico de mapa de Europa con ggplot2
mapa <- ggplot(mapa_mundo_europa) +
  geom_sf(aes(fill = Porcentaje_positivos,
              text = paste("País: ", NAME_LONG, "<br>Tasa de Positividad: ", Porcentaje_positivos))) + #se rellena el mapa con los porcentajes positivos
  scale_fill_viridis_c(option = "plasma", na.value = "gray") +#aplicamos paleta de colores
  labs(title = "Tasa de Positividad en AMR por País en Europa",
       fill = "Tasa de Positividad (%)") +
  coord_sf(xlim = c(-30, 50), ylim = c(35, 72), expand = FALSE) +  # Ajustar límites para hacer zoom en Europa
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))#para modificar y centrar el titulo


# Convertir el gráfico a interactivo con plotly
mapa_interactivo <- ggplotly(mapa,tooltip = "text")

# Mostrar el gráfico interactivo
mapa_interactivo


