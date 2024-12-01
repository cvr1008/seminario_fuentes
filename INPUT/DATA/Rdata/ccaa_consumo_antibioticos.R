library(readr)
library(dplyr)
library(ggplot2)


tipo_ccaa_consumo_o_no <- read_delim("INPUT/DATA/datos_ccaa/tipo_ccaa_consumo_o_no.csv", 
                                     delim = ";", escape_double = FALSE, trim_ws = TRUE)


antibioticos <- tipo_ccaa_consumo_o_no %>% 
  dplyr::filter(`Tipo de medicamento` == "Antibióticos",`Sexo` == "Ambos sexos")%>%
  dplyr::filter(`Sí o no` == "Sí")


# Esta tabla enseña que el 3,54% de la población española en la última encuesta reconoce 
# haber consumido antibióticos en las últimas 2 semanas (En el año 2021)


antibioticos$Total <- gsub(",", ".", antibioticos$Total)

# Limpia espacios y caracteres no numéricos (si es necesario)
antibioticos$Total <- gsub(" ", "", antibioticos$Total)

# Convierte a numérico
antibioticos$Total <- as.numeric(antibioticos$Total)

# Revisa si hay NA después de la conversión
sum(is.na(antibioticos$Total))  # Muestra el número de NAs



consumo <- antibioticos %>%
  group_by(`Comunidades y Ciudades Autónomas`) %>%
  arrange(desc(Total))

consumo

c_c_final <- consumo %>%
  mutate(`Comunidades y Ciudades Autónomas` = ifelse(is.na(`Comunidades y Ciudades Autónomas`), "Total País", `Comunidades y Ciudades Autónomas`))%>%
  dplyr::rename(comunidades_autonomas = `Comunidades y Ciudades Autónomas`)%>%
  select(comunidades_autonomas, Total)%>%
  dplyr::rename(total_consumo_ccaa = Total)

c_c_final



# Crear el gráfico de barras
ggplot(c_c_final, aes(x = reorder(comunidades_autonomas, -total_consumo_ccaa), y = total_consumo_ccaa)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(x = "Comunidades Autónomas", y = "Total Consumo", title = "Consumo de antibióticos por Comunidad Autónoma") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 


