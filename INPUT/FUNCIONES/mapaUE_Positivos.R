library(sf)
library(ggplot2)
library(plotly)
library(dplyr)
library(leaflet)  # Para crear mapas interactivos
library(sf)       # Para trabajar con datos espaciales (sf)
library(viridis)

paises_UE <- c(
  "Cyprus", "France", "Lithuania", "Czechia", "Germany", 
  "Estonia", "Latvia", "Sweden", "Finland", "Luxembourg", 
  "Belgium", "Spain", "Denmark", "Romania", "Hungary", 
  "Slovakia", "Poland", "Ireland", "Greece", "Austria", 
  "Italy", "Netherlands", "Croatia", "Slovenia", "Bulgaria", 
  "Portugal", "Malta"
)




# Suponiendo que tienes un objeto `world_map` con las geometrías de países
# y `positivity_by_country` es un data frame con las tasas de positividad por país
mapa_mudo <- st_read("INPUT/DATA/mapaMundi")  # Cargar el mapa de países en formato `sf`

#Filtramos para que solo contenga 
mapa_mundo_europa <- mapa_mudo %>% 
  filter(NAME %in% paises_UE)

mapa_mundo_europa <- mapa_mudo %>% filter(NAME %in% paises_UE)


positivos_por_ciudad <- paises_UE_df %>%
  group_by(NombrePais) %>%
  summarize(total_pruebas = sum(TotalMuestras, na.rm = TRUE),
            total_positivos= sum(MuestraPositiva, na.rm = TRUE)) %>%
  mutate(ratio_positivo = (total_positivos / total_pruebas) * 100)

# Unir datos de positividad al mapa
mapa_mundo_europa$NAME <- as.character(mapa_mundo_europa$NAME)
positivos_por_ciudad$NombrePais <- as.character(positivos_por_ciudad$NombrePais)

# Realizar el join usando las columnas correctas
mapa_mundo_europa <- mapa_mundo_europa %>% 
  left_join(positivos_por_ciudad, by = c("NAME" = "NombrePais"))
mapa_mundo_europa


# Crear el gráfico de mapa de Europa con ggplot2
mapa <- ggplot(mapa_mundo_europa) +
  geom_sf(aes(fill = ratio_positivo)) +
  scale_fill_viridis_c(option = "plasma", na.value = "gray") +
  labs(title = "Tasa de Positividad por País en Europa",
       fill = "Tasa de Positividad (%)") +
  coord_sf(xlim = c(-30, 50), ylim = c(35, 72), expand = FALSE) +  # Ajustar límites para hacer zoom en Europa
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))


# Convertir el gráfico a interactivo con plotly
mapa_interactivo <- ggplotly(mapa)

# Mostrar el gráfico interactivo
mapa_interactivo


