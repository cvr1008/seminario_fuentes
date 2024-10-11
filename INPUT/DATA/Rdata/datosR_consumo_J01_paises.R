library(tidyverse)
library(rjson)
library(tidyjson)

consumo_J01 <- fromJSON(file = "C:/Users/deyan/fuentes/seminario_fuentes/INPUT/DATA/consumo_ATC_J01_sectorHospitalario_vs_sectorComunitario_2022.JSON")

consumo_J01
head(consumo_J01)

spread_all(consumo_J01) %>% View()

consumo_J01 %>% 
  gather_object %>% 
  json_types %>% 
  count(name, type)