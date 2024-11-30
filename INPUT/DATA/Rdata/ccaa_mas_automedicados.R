library(pxR)
library(readr)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(tidyr)

# Leer el archivo .px
archivo_px <- read.px("INPUT/DATA/datos_ccaa/tipo_ccaa_recetado_o_no.px")
df_px <- as.data.frame(archivo_px)

# Ver las primeras filas


# quedarme solo con los antibióticos
antibiotic <- df_px[df_px[["Tipo.de.medicamento"]] == "Antibióticos" & df_px$`Sexo` == "Ambos sexos", ]



# qué comunidad autónoma se automedica más
consumo_comunidades <- antibiotic%>%
  dplyr::filter(`Recetado` == "No recetado") %>%
  dplyr::filter(value != 0)%>%
  group_by(`Comunidad.autónoma`) %>%
  arrange(desc(value)) %>%
  select(Comunidad.autónoma, value)%>%
  dplyr::rename(comunidades_autonomas = Comunidad.autónoma)%>%
  dplyr::rename("Automedicación (%)" = value)%>%
  dplyr::mutate(comunidades_autonomas = case_when(
    comunidades_autonomas == "Total" ~ "Total País",
    TRUE ~ comunidades_autonomas
  ))


# CARGAR ccaa_consumo_antibioticos
c_c_final
consumo_comunidades

unir_consumo_autoconsumo <- inner_join(c_c_final, consumo_comunidades, by = "comunidades_autonomas")%>%
  mutate("Automedicación (%)" = total_consumo_ccaa * `Automedicación (%)`/100)%>%
  dplyr::rename("Consumo total" = total_consumo_ccaa)%>%
  pivot_longer(.,names_to = "Variable", values_to = "Valores", cols = c("Consumo total":"Automedicación (%)")) %>% 
  mutate(Variable = factor(Variable, levels = c("Consumo total","Automedicación (%)")))


ggplot(unir_consumo_autoconsumo, aes(fill = Variable, y = Valores, x = reorder(comunidades_autonomas, -Valores))) +
  geom_bar(position = "stack", stat = "identity") +
  scale_fill_manual(values = c("Consumo total" = "lightgreen", 
                               "Automedicación (%)" = "tomato")) +
  labs(x = "Comunidades Autónomas", y = "Porcentaje de Consumo", title = "Automedicación según el consumo de antibióticos por CCAA ")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  


