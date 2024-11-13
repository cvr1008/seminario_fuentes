library(tidyverse)
library(rjson)
library(dplyr)
library(tidyr)
library(ggplot2)


DDD_Europa_Json <- fromJSON(file = "INPUT/DATA/DDD_1000_habitantes_paises.JSON")

DDD_Europa_Json
View(DDD_Europa_Json)

str(DDD_Europa_Json)

# --------------------
DDD_Europa_df <- do.call(rbind, lapply(DDD_Europa_Json, function(x) {
  data.frame(Country = x$Country, 
             DDD_per_1000_inhabitants_per_day = as.numeric(x$`DDD per 1000 inhabitants per day`))
}))

# Verificar la estructura del nuevo dataframe
str(DDD_Europa_df)

# Mostrar las primeras filas del dataframe
head(DDD_Europa_df)
View(DDD_Europa_df)


grafico_DDD <- ggplot(DDD_Europa_df, aes(x = reorder(Country, -DDD_per_1000_inhabitants_per_day), 
                          y = DDD_per_1000_inhabitants_per_day)) +
  geom_bar(stat = "identity", fill = "turquoise") +
  labs(title = "DDD por 1000 habitantes por día en Europa", 
       x = "País", 
       y = "DDD por 1000 habitantes por día") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
grafico_DDD

