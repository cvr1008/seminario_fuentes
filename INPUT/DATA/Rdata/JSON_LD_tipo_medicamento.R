library(tidyverse)
library(rjson)

Tipo_Medicamento_consumido_españa <- fromJSON(file = "C:/CLASE/practicas_fuentes/seminario_fuentes/INPUT/DATA/Tipo_medicamento_consumido_españa.jsonld")

Tipo_Medicamento_consumido_españa
head(Tipo_Medicamento_consumido_españa)

spread_all(Tipo_Medicamento_consumido_españa)


Tipo_Medicamento_consumido_españa
lobstr::obj_size(Tipo_Medicamento_consumido_españa)
spread_all(Tipo_Medicamento_consumido_españa) %>% View()

Tipo_Medicamento_consumido_españa %>% 
  gather_object %>% 
  json_types %>% 
  count(name, type)

head(Tipo_Medicamento_consumido_españa)
spread_all(Tipo_Medicamento_consumido_españa)

Tipo_Medicamento_consumido_españa %>%
  spread_all() %>% 
  View()

# ----------------------------------------

library(tidyverse)
library(jsonlite)  # Recomendado para manejar JSON

# Cargar archivo JSON-LD
file_path <- "C:/CLASE/practicas_fuentes/seminario_fuentes/INPUT/DATA/Tipo_medicamento_consumido_españa.jsonld"
Tipo_Medicamento_consumido_españa <- fromJSON(file_path)

# Explorar la estructura del archivo
str(Tipo_Medicamento_consumido_españa)

# Extraer la parte relevante del JSON: el grafo
graph_data <- Tipo_Medicamento_consumido_españa$`@graph`

# Explorar la estructura inicial del grafo
str(graph_data)


ids <- graph_data$`@id`
formatos <- graph_data$`dct:format`

distribuciones <- graph_data$`dcat:accessURL`

# Extraer IDs, Títulos en español y URL de acceso
relevant_data <- data.frame(
  ID = ids,
  URL = distribuciones
)

# Mostrar las primeras filas del DataFrame resultante
head(relevant_data)

# Ver el tamaño del objeto en memoria
lobstr::obj_size(Tipo_Medicamento_consumido_españa)

# Expandir todas las columnas anidadas y ver en formato tabla
spread_all(Tipo_Medicamento_consumido_españa) %>% View()

# Ver el tamaño del objeto en memoria
lobstr::obj_size(relevant_data)

# Visualizar el DataFrame en una tabla
View(relevant_data)

# ---------------------------
