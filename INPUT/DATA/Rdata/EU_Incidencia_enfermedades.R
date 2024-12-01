# Cargar las bibliotecas necesarias
library(dplyr)
library(readr)
library(ggplot2)
library(plotly)
library(tidyr)

# Cargar el archivo CSV de incidencia de enfermedades
Incidencia_enfermedades <-  read_csv("INPUT/DATA/ECDC_encuesta_AMR_incidencia_enfermedades.csv")

# Filtrar los datos para el año 2022 y las categorías Male y Female
incidencia_2022MF <- Incidencia_enfermedades %>%
  dplyr::filter(Time == 2022) %>%
  dplyr::filter(Category == 'Male' | Category == 'Female')

# Convertir 'Value' a numérico
incidencia_2022MF$Value <- as.numeric(incidencia_2022MF$Value)

# Crear el dataframe media_poblacion con una nueva columna 'grupo'
media_poblacion <- incidencia_2022MF %>%
  dplyr::select(-Unit, -HealthTopic, -Time, -Distribution) %>%
  mutate(grupo = substr(Population, 1, 3))


lista_codigos_paises <- list("AT", "BE", "BG", "CY", "CZ", "DE", "DK", "EE", "EL", "ES", "FI", "FR", "HR", "HU", 
                             "IE", "IT", "LT", "LU", "LV", "MT", "NL", "PL", "PT", "RO", "SE", "SI", "SK") 


# Calcular la media de 'Value' por 'RegionCode' y 'grupo'
otra <- media_poblacion %>%
  select(-Category, -CategoryIndex, -Population) %>%
  arrange(RegionCode, grupo) %>%    # Ordena los datos
  group_by(RegionCode, grupo) %>%   # Agrupa por RegionCode y grupo
  dplyr::summarise(mean_value = mean(Value, na.rm = TRUE))%>%
  dplyr::filter(RegionCode %in% lista_codigos_paises) %>%   # Calcula la media en cada grupo y desagrupa
  tidyr::drop_na() %>% 
  mutate(grupo = recode(grupo, "Ent" = "Enterococcus", "Esc" = "Escherichia","Aci"="Acinetobacter",
                        "Kle"="Klebsiella","Pse" = "Pseudomonas","Sta"="Staphylococcus", "Str"="Streptococcus"))


media_region <- otra %>%
  group_by(RegionCode) %>%
  summarise(mean_value_region = mean(mean_value, na.rm = TRUE))%>%
  arrange(desc(mean_value_region))





# --------------------------------------------------------------------

# graficos positivos generales

# Crear el gráfico usando los datos ordenados
grafico <- ggplot(media_region, aes(x = reorder(RegionCode, -mean_value_region), y = mean_value_region)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "blue") +
  labs(
    title = "Media de Incidencia por Región (Orden Descendente)",
    x = "País",
    y = "Media de Incidencia"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

grafico

# gráficos bacterias en personas

boxplot_baterias_personas <- ggplot(otra, aes(x = grupo, y = mean_value, fill=grupo)) +
  geom_boxplot() +
  labs(title = "Incidencia de bacterias en personas ",
       x = "Bacterias", y = "Porcentaje de incidencia") +
  theme_light()+
  theme(legend.position="none")

boxplot_baterias_personas




#-------------------------------------------------------------------------------------------
# GRAFICO INTERACTIVO que te dice qué países tienen esa media para cada bacteria

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



