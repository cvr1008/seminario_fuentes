library(pxR)
library(readr)
library(dplyr)
library(ggplot2)
library(RColorBrewer)

# Leer el archivo .px
archivo_px <- read.px("C:/Users/usuario/seminario_fuentes/INPUT/DATA/datos_ccaa/tipo_ccaa_recetado_o_no.px")
View(archivo_px)
df_px <- as.data.frame(archivo_px)

# Ver las primeras filas
head(df_px)


# quedarme solo con los antibióticos
antibiotic <- df_px[df_px[["Tipo.de.medicamento"]] == "Antibióticos" & df_px$`Sexo` == "Ambos sexos", ]
antibiotic


# qué comunidad autónoma se automedica más
antibioticos_sin_receta <- antibiotic[antibiotic$`Recetado` == "No recetado",]
antibioticos_sin_receta
View(antibioticos_sin_receta)

consumo_comunidades <- antibioticos_sin_receta %>%
  filter(value != 0)%>%
  group_by(`Comunidad.autónoma`) %>%
  arrange(desc(value)) %>%
  select(Comunidad.autónoma, value)%>%
  dplyr::rename(comunidades_autonomas = Comunidad.autónoma)%>%
  dplyr::rename(porcentaje_automedicacion = value)
  



consumo_comunidades
View(consumo_comunidades)



ggplot(consumo_comunidades, aes(x = "", y = value, fill = `Comunidad.autónoma`)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Consumo de Antibióticos por Comunidad Autónoma",
       fill = "Comunidad Autónoma") +
  theme_void()  # Elimina el fondo y los ejes



# CARGAR ccaa_consumo_antibioticos
c_c_final

# unir_consumo_autoconsumo <- 



