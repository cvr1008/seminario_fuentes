library(readr)
library(dplyr)
library(ggplot2)
#--------------------------------
# "INPUT/DATA/datos_pib.tsv"
pibPP <- read_table("INPUT/DATA/datos_pib.tsv")
View(pibPP)

str(pibPP)

# Cambio de nombre columna
colnames(pibPP)[1] <- "pais"

# Nos quedamos con las últimas letras
pibPP$pais <- substr(pibPP$pais, nchar(pibPP$pais) - 1, nchar(pibPP$pais))
View(pibPP)

lista_pais <- list("BE", "BG", "CZ", "DK", "DE", "EE", "IE", "EL", "ES", "FR", "HR", "IT", "CY", "LV", "LT", "LU", "HU", "MT", "NL",
               "AT", "PL", "PT", "RO", "SI", "SK", "FI", "SE")

# nos quedamos solo con los países de la UE


pib <- pibPP %>% filter(pais %in% unlist(lista_pais))
View(pib)


# quitar la columna nula

pib <- pib[, colSums(is.na(pib)) < nrow(pib)]
pib


pib_2023 <- pib %>% select(pais, `2023`)
View(pib_2023)


# ggplot del pib en el 20223 (primero lo ponemos en descendente)

pib_2023_desc <- pib_2023 %>% arrange(desc(`2023`))


# sustituir las etiquetas de los países


pib_2023_desc <- pib_2023_desc %>%
  mutate(pais = case_when(
    pais == "SK" ~ "Eslovaquia",
    pais == "SI" ~ "Slovenia",
    pais == "EE" ~ "Estonia",
    pais == "MT" ~ "Malta",
    pais == "LV" ~ "Latvia",
    pais == "HR" ~ "Croatia",
    pais == "EL" ~ "Greece",
    pais == "BG" ~ "Bulgaria",
    TRUE ~ pais # Mantiene los nombres que no están en la lista
  ))


# Cargar ggplot2


# Crear el gráfico de barras
grafico_pib <- ggplot(pib_2023_desc, aes(x = reorder(pais, -`2023`), y = `2023`)) +
  geom_bar(stat = "identity", fill = "gold") +
  labs(x = "País", y = "Valor en 2023", title = "PIB por País en 2023") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Rotar etiquetas para mejor legibilidad

grafico_pib


