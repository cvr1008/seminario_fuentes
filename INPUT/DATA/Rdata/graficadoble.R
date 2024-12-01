library(ggplot2)
library(ggiraph)
library(patchwork)


# Gráfico de dispersión interactivo (izquierda)


graf_izq <- ggplot(positivos_PIB, aes(x = PIB, y = Valores)) +
  geom_point_interactive(aes(color = Variable, tooltip = RegionCode, data_id = RegionCode), size = 1.5) +
  geom_smooth(aes(color = Variable), method = "lm", se = TRUE) +
  labs(title = "Relación entre PIB y Resistencia", x = "PIB", y = "Porcentaje de Resistencia") +
  theme(legend.position = "none", plot.margin = margin(10, 10, 10, 10))


# Gráfico de barras interactivo (derecha)
graf_drch <- ggplot(positivos_PIB, aes(x = RegionCode, y = Valores, tooltip = paste("País:", RegionCode, "<br>Valor:", Valores), data_id = RegionCode)) +
  geom_col_interactive(aes(fill = Variable), position = "dodge") +  # Barras interactivas agrupadas por variable
  coord_flip() +  # Invertir los ejes para barras horizontales
  labs(x = "País", y = "Porcentaje de Resistencia") +
  #theme_minimal() +
  theme(legend.position = "right",  # Mostrar la leyenda solo en el gráfico de barras
        plot.margin = margin(10, 10, 10, 10))  # Ajuste de márgenes


# Combinar los dos gráficos en una disposición horizontal

graficas_unidas <- girafe(ggobj = graf_izq + graf_drch + plot_layout(ncol = 2))


# Mostrar el gráfico interactivo
graficas_unidas
