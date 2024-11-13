# Cargar las bibliotecas necesarias
library(dplyr)
library(readr)
library(ggplot2)
library(plotly)

# Cargar el archivo CSV de incidencia de enfermedades
Incidencia_enfermedades <-  read_csv("INPUT/DATA/ECDC_encuesta_AMR_incidencia_enfermedades.csv")

# Filtrar los datos para el año 2022 y las categorías Male y Female
incidencia_2022MF <- Incidencia_enfermedades %>%
  filter(Time == 2022) %>%
  filter(Category == 'Male' | Category == 'Female')

# Convertir 'Value' a numérico
incidencia_2022MF$Value <- as.numeric(incidencia_2022MF$Value)

# Crear el dataframe media_poblacion con una nueva columna 'grupo'
media_poblacion <- incidencia_2022MF %>%
  select(-Unit, -HealthTopic, -Time, -Distribution) %>%
  mutate(grupo = substr(Population, 1, 3))

# Calcular la media de 'Value' por 'RegionCode' y 'grupo'
otra <- media_poblacion %>%
  select(-Category, -CategoryIndex, -Population) %>%
  arrange(RegionCode, grupo) %>%    # Ordena los datos
  group_by(RegionCode, grupo) %>%   # Agrupa por RegionCode y grupo
  summarise(mean_value = mean(Value, na.rm = TRUE))  # Calcula la media en cada grupo y desagrupa

otra$mean_value[is.nan(otra$mean_value)] <- 0

media_region <- otra %>%
  group_by(RegionCode) %>%
  summarise(mean_value_region = mean(mean_value, na.rm = TRUE))  # Calcular la media por RegionCode

# --------------------------------------------------------------------

# gráficos

boxplot_in <- ggplot(otra, aes(x = grupo, y = mean_value)) +
  geom_boxplot() +
  labs(title = "Distribution of Mean Incidence by Bacteria Group",
       x = "Bacteria Group", y = "Mean Incidence") +
  theme_minimal()



# gráfico que te dice qué países tienen esa media para cada bacteria

# Crear el conjunto de datos interactivo con highlight_key
incidencia_keyed <- highlight_key(otra, ~RegionCode)

# Crear el gráfico ggplot con el texto configurado para el tooltip
scatter_plot <- ggplot(incidencia_keyed, aes(x = grupo, y = mean_value, color = RegionCode, text = paste("País:", RegionCode))) +
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



