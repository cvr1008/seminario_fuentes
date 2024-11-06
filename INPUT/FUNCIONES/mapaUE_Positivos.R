library(sf)
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
world_map <- st_read("INPUT/DATA/mapaMundi")  # Cargar el mapa de países en formato `sf`

#Filtramos para que solo contenga 
world_map_europe <- world_map %>% 
  filter(NAME %in% paises_UE)

positivity_by_country <- paises_UE_df %>%
  group_by(NombrePais) %>%
  summarize(total_tested = sum(TotalMuestras, na.rm = TRUE),
            total_positive = sum(MuestraPositiva, na.rm = TRUE)) %>%
  mutate(positivity_rate = (total_positive / total_tested) * 100)

# Unir datos de positividad al mapa
world_map_europe$NAME <- as.character(world_map_europe$NAME)
positivity_by_country$NombrePais <- as.character(positivity_by_country$NombrePais)

# Realizar el join usando las columnas correctas
world_map_europe <- world_map_europe %>% 
  left_join(positivity_by_country, by = c("NAME" = "NombrePais"))




# Cargar librerías necesarias
library(ggplot2)
library(plotly)

# Crear el gráfico de mapa de Europa con ggplot2
p <- ggplot(world_map_europe) +
  geom_sf(aes(fill = positivity_rate)) +
  scale_fill_viridis_c(option = "plasma", na.value = "gray") +
  labs(title = "Tasa de Positividad por País en Europa",
       fill = "Tasa de Positividad (%)") +
  coord_sf(xlim = c(-30, 50), ylim = c(35, 72), expand = FALSE) +  # Ajustar límites para hacer zoom en Europa
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# Convertir el gráfico a interactivo con plotly
interactive_map <- ggplotly(p)

# Mostrar el gráfico interactivo
interactive_map




