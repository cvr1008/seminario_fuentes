library(readr)
Tipo_dos_semanas <- read_delim("C:/CLASE/practicas_fuentes/Tipo_medicamento_españa_dos_semanas.csv", 
                      delim = ";", escape_double = FALSE, trim_ws = TRUE)

Tipo_dos_semanas
summary(Tipo_dos_semanas)
#View(Tipo_dos_semanas) 
