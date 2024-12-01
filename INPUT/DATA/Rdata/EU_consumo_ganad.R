library(readr)
library(readxl)
library(dplyr)
library(tidyr)


ant_europa_g <- read_excel("INPUT/DATA/consumo_ganaderia_2022.xlsx", skip = 3)


# Procesamiento inicial de los datos
a_e_g <- ant_europa_g %>%
  select("Country", "...5") %>%  # Seleccionar las columnas relevantes
  dplyr::rename(Antibiotic_use_in_livestock_1000_PCU = `...5`) %>%  # Renombrar columnas
  mutate(Year = "2022") %>%  # Añadir la columna de año
  cambio_nombre_codigo("Country") %>%  # Usar la función para cambiar nombres de países a códigos
  drop_na() %>%  # Eliminar filas con valores NA
  relocate(3, .before = 2)  # Reubicar la columna 'Year' antes de 'Country'

# Crear un nuevo data frame con datos modificados
new <- a_e_g %>%
  select(-Year) %>%  # Eliminar la columna 'Year'
  mutate(Antibiotic_use_in_livestock_100_PCU = as.numeric(Antibiotic_use_in_livestock_1000_PCU) / 10) %>%  # Calcular el nuevo indicador
  select(-Antibiotic_use_in_livestock_1000_PCU)  # Eliminar la columna original