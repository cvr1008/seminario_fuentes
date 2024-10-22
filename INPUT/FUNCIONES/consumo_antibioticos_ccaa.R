library(readr)
library(dplyr)
library(ggplot2)


tipo_ccaa_consumo_o_no <- read_delim("C:/CLASE/practicas_fuentes/datos_ccaa/tipo_ccaa_consumo_o_no.csv", 
                                     delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(tipo_ccaa_consumo_o_no)

typeof(tipo_ccaa_consumo_o_no)
class(tipo_ccaa_consumo_o_no)

antibioticos <- tipo_ccaa_consumo_o_no %>% 
  filter(`Tipo de medicamento` == "Antibióticos")

antibioticos <- tipo_ccaa_consumo_o_no[tipo_ccaa_consumo_o_no$`Tipo de medicamento` == "Antibióticos" & tipo_ccaa_consumo_o_no$`Sexo` == "Ambos sexos",]
antibioticos
View(antibioticos)

# Esta tabla enseña que el 3,54% de la población española en la última encuesta reconoce 
# haber consumido antibióticos en las últimas 2 semanas (En el año 2021)


# Comunidad que más consume

antibioticos_si <- antibioticos[antibioticos$`Sí o no` == "Sí",]
antibioticos_si
View(antibioticos_si)


antibioticos_si$Total <- gsub(",", ".", antibioticos_si$Total)

# Limpia espacios y caracteres no numéricos (si es necesario)
antibioticos_si$Total <- gsub(" ", "", antibioticos_si$Total)

# Convierte a numérico
antibioticos_si$Total <- as.numeric(antibioticos_si$Total)

# Revisa si hay NA después de la conversión
sum(is.na(antibioticos_si$Total))  # Muestra el número de NAs



consumo_comunidades <- antibioticos_si %>%
  group_by(`Comunidades y Ciudades Autónomas`) %>%
  summarise(Total_Consumo = sum(as.numeric(Total), na.rm = TRUE)) %>%
  arrange(desc(Total_Consumo))

consumo_comunidades

c_c_final <- consumo_comunidades %>%
  mutate(`Comunidades y Ciudades Autónomas` = ifelse(is.na(`Comunidades y Ciudades Autónomas`), "Total País", `Comunidades y Ciudades Autónomas`))
c_c_final



# Crear el gráfico de barras
ggplot(c_c_final, aes(x = reorder(`Comunidades y Ciudades Autónomas`, -Total_Consumo), y = Total_Consumo)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(x = "Comunidades Autónomas", y = "Total Consumo", title = "Consumo de antibióticos por Comunidad Autónoma") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 
