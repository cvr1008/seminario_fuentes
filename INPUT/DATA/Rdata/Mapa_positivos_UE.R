library(ggiraph)
library(ggplot2)
library(dplyr)
library(patchwork)
library(plotly)
library(leaflet)  # Para crear mapas interactivos
library(sf)       # Para trabajar con datos espaciales (sf)
library(viridis)
library(tidyr)
library(readr)

paises_UE_mapa <- c(
  "Cyprus", "France", "Lithuania", "Czechia", "Germany", 
  "Estonia", "Latvia", "Sweden", "Finland", "Luxembourg", 
  "Belgium", "Spain", "Denmark", "Romania", "Hungary", 
  "Slovakia", "Poland", "Ireland", "Greece", "Austria", 
  "Italy", "Netherlands", "Croatia", "Slovenia", "Bulgaria", 
  "Portugal", "Malta"
)





mapa_mundo <- st_read("INPUT/DATA/mapaMundi")  # Cargar el mapa de países en formato `sf`
mapa_mundo$NAME



#Filtramos y cambiamos a codigo para poder unir 
mapa_mundo <- mapa_mundo %>% 
  filter(NAME %in% paises_UE_mapa) 

mapa_mundo <- cambio_nombre_codigo(mapa_mundo, "NAME")


# Realizar el join usando las columnas correctas
mapa_mundo_europa <-left_join(x=mapa_mundo,y=media_region, by = c("NAME" = "RegionCode")) %>% 
  dplyr::rename(Porcentaje_positivos=mean_value_region) %>%  
  dplyr::mutate(Porcentaje_positivos = round(Porcentaje_positivos, 2))



graf_barras <- ggplot(mapa_mundo_europa, aes(
  y=Porcentaje_positivos,
  x = reorder(NAME_LONG,-Porcentaje_positivos), #ordenamos según el porcentaje de positivos
  tooltip =  paste("País: ", NAME_LONG, "<br>Tasa de Positividad: ", Porcentaje_positivos),#mensaje que sale al pasar el cursor
  data_id = NAME_LONG,#el identificador de cada barra
  fill = NAME_LONG #colorea según el pais
)) +
  geom_col_interactive(data = mapa_mundo_europa) +
  coord_flip() + #gira el gráfico 
  theme_minimal() +
  theme(legend.position = "none")+ #elimina la leyenda 
  labs(x='paises',y='porcentaje de positivos en AMR')


mapaMundo <- ggplot() +
  geom_sf(data = mapa_mundo_europa, fill = "lightgrey", color = "lightgrey") + #dibuja el mapa y asigna color de relleno y borde
  geom_sf_interactive(
    data = mapa_mundo_europa,
    aes(fill = NAME_LONG, tooltip =  paste("País: ", NAME_LONG, "<br>Tasa de Positividad: ", Porcentaje_positivos), data_id = NAME_LONG)) +
  coord_sf(xlim = c(-30, 50), ylim = c(35, 72), expand = FALSE) + #limita la vista a la región especifica 
  theme_void() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    legend.position = "none"
  )



combined_plot <- (graf_barras + mapaMundo) + 
  plot_layout(widths = c(1, 2)) + #ajustamos el ancho
  plot_annotation(
    title = 'Porcentaje de positivos en AMR por país',
    theme = theme(plot.title = element_text(hjust = 0.5))#centrar titulo
  )


#Creamos el mapa interactivo
mapaCombinado <- girafe(ggobj = combined_plot)#convertimos en grafico interactivo
mapaCombinado <- girafe_options(
  mapaCombinado,
  opts_hover(css = "fill:red;stroke:black;")#cambia el color cuando el cursor pasa sobre el objeto
)
mapaCombinado
