# Asegúrate de cargar dplyr si no lo has hecho
library(dplyr)

# Calcular la media de TotalMuestras y MuestraPositiva por país y bacteria
media_bacterias <- paises_UE_df %>%
  group_by(NombrePais, zoonosis_name) %>%
  summarise(
    MediaTotalMuestras = mean(TotalMuestras, na.rm = TRUE),
    MediaMuestraPositiva = mean(MuestraPositiva, na.rm = TRUE)
  )




tipos_bacterias <- paises_UE_df %>%
  distinct(zoonosis_name)
tipos_bacterias



# Asegúrate de cargar dplyr si no lo has hecho
library(dplyr)

# Crear un nuevo dataframe con la media de muestras positivas por país y bacteria
media_bacterias <- paises_UE_df %>%
  group_by(zoonosis_name, NombrePais) %>%
  summarise(MediaMuestraPositiva = mean(TotalMuestras/MuestraPositiva, na.rm = TRUE)) %>%
  ungroup()

# Ver el resultado
print(media_bacterias)

ggplot(media_por_bacteria, aes(x = grupo, y = media_mean_value)) +
  geom_boxplot() +
  labs(title = "Distribution of Mean Incidence by Bacteria Group",
       x = "Bacteria Group", y = "Mean Incidence") +
  theme_minimal()



# gráfico que te dice qué países tienen esa media para cada bacteria

# Crear el conjunto de datos interactivo con highlight_key
incidencia_keyed <- highlight_key(media_bacterias, ~media_bacterias$NombrePais)

# Crear el gráfico ggplot con el texto configurado para el tooltip
scatter_plot <- ggplot(incidencia_keyed, aes(x =media_bacterias$zoonosis_name, y = MediaMuestraPositiva, color = media_bacterias$NombrePais, text = paste("País:", NombrePais))) +
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

