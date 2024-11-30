library(ggiraph)
library(ggplot2)
library(dplyr)
library(patchwork)


graf_barras <- ggplot(mapa_mundo_europa, aes(
  y=Porcentaje_positivos,
  x = reorder(NAME_LONG,-Porcentaje_positivos),
  tooltip =  paste("País: ", NAME_LONG, "<br>Tasa de Positividad: ", Porcentaje_positivos),
  data_id = NAME_LONG,
  fill = NAME_LONG
)) +
  geom_col_interactive(data = mapa_mundo_europa) +
  coord_flip() +
  theme_minimal() +
  theme(legend.position = "none")+
  labs(x='paises',y='porcentaje de positivos en AMR')


mapaMundo <- ggplot() +
  geom_sf(data = mapa_mundo_europa, fill = "lightgrey", color = "lightgrey") +
  geom_sf_interactive(
    data = mapa_mundo_europa,
    aes(fill = NAME_LONG, tooltip =  paste("País: ", NAME_LONG, "<br>Tasa de Positividad: ", Porcentaje_positivos), data_id = NAME_LONG)) +
  coord_sf(xlim = c(-30, 50), ylim = c(35, 72), expand = FALSE) +
  theme_void() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    legend.position = "none"
  )



combined_plot <- (graf_barras + mapaMundo) + 
  plot_layout(widths = c(1, 2)) + 
  plot_annotation(
    title = 'Porcentaje de positivos en AMR por país',
    theme = theme(plot.title = element_text(hjust = 0.5))
  )


#Creamos el mapa interactivo
mapaCombinado <- girafe(ggobj = combined_plot)
mapaCombinado <- girafe_options(
  mapaCombinado,
  opts_hover(css = "fill:red;stroke:black;")
)
mapaCombinado
