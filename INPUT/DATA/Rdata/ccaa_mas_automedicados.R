library(pxR)
library(readr)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(tidyr)

# Leer el archivo .px
archivo_px <- read.px("INPUT/DATA/datos_ccaa/tipo_ccaa_recetado_o_no.px")
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
  dplyr::rename(porcentaje_automedicacion = value)%>%
  dplyr::mutate(comunidades_autonomas = case_when(
    comunidades_autonomas == "Total" ~ "Total País",
    TRUE ~ comunidades_autonomas
  ))
  



consumo_comunidades
View(consumo_comunidades)



ggplot(consumo_comunidades, aes(x = "", y = porcentaje_automedicacion, fill = comunidades_autonomas)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Consumo de Antibióticos por Comunidad Autónoma",
       fill = "Comunidad Autónoma") +
  theme_void()  # Elimina el fondo y los ejes



# CARGAR ccaa_consumo_antibioticos
c_c_final
consumo_comunidades

unir_consumo_autoconsumo <- inner_join(c_c_final, consumo_comunidades, by = "comunidades_autonomas")%>%
  mutate(porcentaje_automedicacion = total_consumo_ccaa * porcentaje_automedicacion/100)%>%
  pivot_longer(.,names_to = "Variable", values_to = "Valores", cols = c(total_consumo_ccaa:porcentaje_automedicacion)) %>% 
  mutate(Variable = factor(Variable, levels = c("total_consumo_ccaa","porcentaje_automedicacion")))


ggplot(unir_consumo_autoconsumo, aes(fill = Variable, y = Valores, x = reorder(comunidades_autonomas, -Valores))) +
  geom_bar(position = "stack", stat = "identity") +
  scale_fill_manual(values = c("total_consumo_ccaa" = "lightgreen", 
                               "porcentaje_automedicacion" = "tomato")) +
  labs(x = "Comunidades Autónomas", y = "Valores")


