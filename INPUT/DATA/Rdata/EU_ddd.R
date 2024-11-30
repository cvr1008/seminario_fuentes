library(tidyverse)
library(rjson)
library(dplyr)
library(tidyr)
library(ggplot2)


DDD_Europa_Json <- fromJSON(file = "INPUT/DATA/DDD_1000_habitantes_paises.JSON")

DDD_Europa_Json

# --------------------
DDD_Europa_df <- do.call(rbind, lapply(DDD_Europa_Json, function(x) {
  data.frame(Country = x$Country, 
             DDD_per_1000_inhabitants_per_day = as.numeric(x$`DDD per 1000 inhabitants per day`))
}))

# lapply: Aplica una función a cada elemento de una lista y devuelve una lista con los resultados
# function(x): Define una función anónima que será aplicada a cada elemento x de la lista DDD_Europa_Json.
# x$Country: Extrae el campo Country del elemento x.
# x$'DDD per 1000 inhabitants per day': Extrae el campo DDD per 1000 inhabitants per day de x y lo convierte en numérico con as.numeric.
# data.frame(...): Crea un dataframe con dos columnas


# Usar la función 'cambio_nombre_codigo' para convertir nombres de países en códigos
DDD_Europa_df <- cambio_nombre_codigo(DDD_Europa_df, "Country")

# Añadir columna para calcular DDD por cada 100 habitantes y eliminar la columna original
DDD_Europa_df <- DDD_Europa_df %>%
  mutate(DDD_per_100_inhabitants_per_day = DDD_per_1000_inhabitants_per_day / 10) %>%
  select(-DDD_per_1000_inhabitants_per_day)


# al tratarse del número de dosis estándar consumidas diariamente por cada 1000 personas, se divide entre 10 para
# que sea número de dosis diarias por cada 100 habitantes.

# resumen: el x% de la población de cada país consume antibiótico de forma diaria en el sector 
# hospitalario y comunitario.



grafico_DDD <- ggplot(DDD_Europa_df, aes(x = reorder(Country, -DDD_per_100_inhabitants_per_day), 
                          y = DDD_per_100_inhabitants_per_day)) +
  geom_bar(stat = "identity", fill = "turquoise") +
  labs(title = "DDD por 100 habitantes por día en Europa", 
       x = "País", 
       y = "DDD por 100 habitantes por día") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
grafico_DDD

