library(dplyr)
library(readr)
Incidencia_enfermedades <- read_delim("INPUT/DATA/ECDC_encuesta_AMR_incidencia_enfermedades.csv", 
                      delim = ",", escape_double = FALSE, trim_ws = TRUE)

Incidencia_enfermedades
summary(Incidencia_enfermedades)

View(Incidencia_enfermedades) 

incidencia_2022 <- Incidencia_enfermedades %>%
  filter(Time == 2022) 
  
incidencia_2022MF <- incidencia_2022 %>%  
  filter(Category == 'Male' | Category == 'Female')

View(incidencia_2022MF)


incidencia_2022MF$Value <- as.numeric(incidencia_2022MF$Value)


media_poblacion_genero <- incidencia_2022MF %>%
  arrange(RegionName, Population) %>%  # Ordenar los datos
  group_by(RegionName, Population) %>%
  mutate(mean_value = (Value + lead(Value)) / 2) %>%
  ungroup()

incidencia <- media_poblacion_genero %>%
  select(-Unit, -Category, -CategoryIndex, -Value, -Distribution)%>%
  filter(!is.na(mean_value))

# Ver el dataframe
print(incidencia)
View(incidencia)


media_por_bacteria <- incidencia %>%
  mutate(grupo = substr(Population, 1, 3)) %>%                # Crear una columna con las primeras letras
  arrange(grupo, RegionName) %>%                              # Ordenar por grupo y RegionName
  group_by(grupo, RegionName) %>%                             # Agrupar por grupo y RegionName
  summarise(media_mean_value = mean(mean_value, na.rm = TRUE)) %>%  # Calcular la media para cada combinación de grupo y RegionName
  ungroup()

View(media_por_bacteria)
