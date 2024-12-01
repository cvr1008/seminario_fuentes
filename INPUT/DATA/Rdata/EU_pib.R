library(readr)
library(dplyr)
library(ggplot2)
#--------------------------------
# "INPUT/DATA/datos_pib.tsv"
pibPP <- read_table("INPUT/DATA/datos_pib.tsv")



# Cambio de nombre columna
colnames(pibPP)[1] <- "pais"

# Nos quedamos con las últimas letras
pibPP$pais <- substr(pibPP$pais, nchar(pibPP$pais) - 1, nchar(pibPP$pais))


lista_pais <- list("BE", "BG", "CZ", "DK", "DE", "EE", "IE", "EL", "ES", "FR", "HR", "IT", "CY", "LV", "LT", "LU", "HU", "MT", "NL",
               "AT", "PL", "PT", "RO", "SI", "SK", "FI", "SE")

# nos quedamos solo con los países de la UE


  # Filtrar los datos, quitar columnas nulas y seleccionar las columnas necesarias en una tubería
pib_2022_desc <- pibPP %>%
  dplyr::filter(pais %in% unlist(lista_pais)) %>%  # Filtrar por los países en 'lista_pais'
  dplyr::select(where(~ all(!is.na(.)))) %>% # Eliminar columnas con todos los valores nulos
  dplyr::select(pais, `2022`) %>%                 # Seleccionar las columnas 'pais' y '2022'
  arrange(desc(`2022`))                    # Ordenar por el PIB del 2022 en orden descendente


# Crear el gráfico de barras
grafico_pib <- ggplot(pib_2022_desc, aes(x = reorder(pais, -`2022`), y = `2022`)) +
  geom_bar(stat = "identity", fill = "gold") +
  labs(x = "País", y = "Valor en 2022", title = "PIB por País en 2022") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Rotar etiquetas para mejor legibilidad

grafico_pib


