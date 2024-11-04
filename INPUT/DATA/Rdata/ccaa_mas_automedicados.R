library(pxR)
library(readr)
library(dplyr)
library(ggplot2)
library(RColorBrewer)

# Leer el archivo .px
archivo_px <- read.px("C:/Users/usuario/seminario_fuentes/INPUT/DATA/datos_ccaa/tipo_ccaa_recetado_o_no.px")

df_px <- as.data.frame(archivo_px)

# Ver las primeras filas
head(df_px)
View(df_px)


# quedarme solo con los antibióticos
antibioticos <- df_px[df_px[["Tipo.de.medicamento"]] == "Antibióticos" & df_px$`Sexo` == "Ambos sexos", ]
antibioticos
View(antibioticos)


# qué comunidad autónoma se automedica más
antibioticos_sin_receta <- antibioticos[antibioticos$`Recetado` == "No recetado",]
antibioticos_sin_receta
View(antibioticos_sin_receta)

antibioticos_sin_receta <- antibioticos_sin_receta %>%
  filter(value != 0)


consumo_comunidades <- antibioticos_sin_receta %>%
  group_by(`Comunidad.autónoma`) %>%
  summarise(Total_Consumo = sum(as.numeric(value), na.rm = TRUE)) %>%
  arrange(desc(Total_Consumo))

consumo_comunidades



ggplot(consumo_comunidades, aes(x = "", y = Total_Consumo, fill = `Comunidad.autónoma`)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Consumo de Antibióticos por Comunidad Autónoma",
       fill = "Comunidad Autónoma") +
  theme_void()  # Elimina el fondo y los ejes



