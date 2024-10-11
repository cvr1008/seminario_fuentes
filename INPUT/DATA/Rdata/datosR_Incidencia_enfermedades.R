
library(readr)
Incidencia_enfermedades <- read_delim("C:/CLASE/practicas_fuentes/seminario_fuentes/INPUT/DATA/ECDC_encuesta_AMR_incidencia_enfermedades.csv", 
                      delim = ",", escape_double = FALSE, trim_ws = TRUE)

Incidencia_enfermedades
summary(Incidencia_enfermedades)
#View(Incidencia_enfermedades) 
