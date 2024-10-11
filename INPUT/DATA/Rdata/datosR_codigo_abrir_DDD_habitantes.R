library(tidyverse)
library(rjson)

DDD_Europa_Json <- fromJSON(file = "C:/CLASE/practicas_fuentes/seminario_fuentes/INPUT/DATA/DDD_1000_habitantes_paises..JSON")

DDD_Europa_Json
head(DDD_Europa_Json)

spread_all(DDD_Europa_Json)


DDD_Europa_Json
lobstr::obj_size(DDD_Europa_Json)
spread_all(DDD_Europa_Json) %>% View()

DDD_Europa_Json %>% 
  gather_object %>% 
  json_types %>% 
  count(name, type)

head(DDD_Europa_Json)
spread_all(DDD_Europa_Json)

DDD_Europa_Json %>%
  spread_all() %>% 
  View()




##chat

DDD_Europa_Json %>%
  gather_object %>% # descomposición del json en pares clave valor
  spread_all() %>% # convertir claves en columnas (convertirlo en tabla)
  glimpse() # dar visión general de la estructura


# --------------------------------- funciona pero sale la columna JSON
DDD_Europa_Json %>%
  spread_all() %>% 
  select(country = Country, DDD_per_1000_inhabitants_day = 'DDD per 1000 inhabitants per day') %>%
  group_by(country, DDD_per_1000_inhabitants_day)  # Agrupa solo por el país


# ---------------------- aquí te cargas la columna JSON pero sale todo null
DDD_Europa_Json %>%
  gather_object() %>%  # Descompone el JSON en pares clave-valor
  filter(name %in% c("Country", "DDD per 1000 inhabitants per day")) %>%  # Filtra solo las filas relevantes
  spread(name, ..JSON) %>%  # Convierte los datos en columnas
  select(country = Country, DDD_per_1000_inhabitants_day = `DDD per 1000 inhabitants per day`)  # Selecciona y renombra las columnas


# --------- lo que dice chat para quitar la tabla JSON pero sigue saliendo
library(dplyr)
library(tidyr)

final_table <- DDD_Europa_Json %>%
  spread_all() %>%  # Convierte todas las claves en columnas
  select(country = Country, DDD_per_1000_inhabitants_day = `DDD per 1000 inhabitants per day`) %>%  # Selecciona y renombra las columnas
  mutate(DDD_per_1000_inhabitants_day = as.numeric(DDD_per_1000_inhabitants_day)) %>%  # Convierte a numérico
  na.omit()  # Elimina filas con valores NA

# Verifica el resultado
print(final_table)
