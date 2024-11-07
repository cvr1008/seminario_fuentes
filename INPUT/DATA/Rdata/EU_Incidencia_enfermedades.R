library(dplyr)
library(readr)
library(ggplot2)
library(plotly)
Incidencia_enfermedades <- read_delim("INPUT/DATA/ECDC_encuesta_AMR_incidencia_enfermedades.csv", 
                      delim = ",", escape_double = FALSE, trim_ws = TRUE)

Incidencia_enfermedades
summary(Incidencia_enfermedades)

View(Incidencia_enfermedades) 

incidencia_2022 <- Incidencia_enfermedades %>%
  filter(Time == 2022) 
  
incidencia_2022MF <- incidencia_2022 %>%  
  filter(Category == 'Male' | Category == 'Female')

View(incidencia_2022MF)


incidencia_2022MF$Value <- as.numeric(incidencia_2022MF$Value)


media_poblacion_genero <- incidencia_2022MF %>%
  arrange(RegionName, Population) %>%  # Ordenar los datos
  group_by(RegionName, Population) %>%
  mutate(mean_value = (Value + lead(Value)) / 2) %>%
  ungroup()

incidencia <- media_poblacion_genero %>%
  mutate(grupo = substr(Population, 1, 3)) %>%
  select(-Unit, -Category, -CategoryIndex, -Value, -Distribution)%>%
  filter(!is.na(mean_value))

# Ver el dataframe
print(incidencia)
View(incidencia)


media_por_bacteria <- incidencia %>%
  mutate(grupo = substr(Population, 1, 3)) %>%                # Crear una columna con las primeras letras
  arrange(grupo, RegionName) %>%                              # Ordenar por grupo y RegionName
  group_by(grupo, RegionName) %>%                             # Agrupar por grupo y RegionName
  summarise(media_mean_value = mean(mean_value, na.rm = TRUE)) %>%  # Calcular la media para cada combinación de grupo y RegionName
  ungroup()

View(media_por_bacteria)


ggplot(media_por_bacteria, aes(x = grupo, y = media_mean_value)) +
  geom_boxplot() +
  labs(title = "Distribution of Mean Incidence by Bacteria Group",
       x = "Bacteria Group", y = "Mean Incidence") +
  theme_minimal()



# gráfico que te dice qué países tienen esa media para cada bacteria

# Crear el conjunto de datos interactivo con highlight_key
incidencia_keyed <- highlight_key(media_por_bacteria, ~RegionName)

# Crear el gráfico ggplot con el texto configurado para el tooltip
scatter_plot <- ggplot(incidencia_keyed, aes(x = grupo, y = media_mean_value, color = RegionName, text = paste("País:", RegionName))) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Population vs Mean Incidence Value by Region",
       x = "Population", y = "Mean Incidence Value") +
  theme_classic()

# Convertir el gráfico ggplot en un gráfico interactivo de plotly con highlight
interactive_scatter_plot <- ggplotly(scatter_plot, tooltip = "text") %>%
  highlight(on = "plotly_click", off = "plotly_doubleclick", color = "red", opacityDim = 0.2)

# cuando haces click en un país te dice solo los puntitos de ese país, cuando haces dobleckick en otra parte del gráfico, se desaparece.

# Mostrar el gráfico interactivo
interactive_scatter_plot
