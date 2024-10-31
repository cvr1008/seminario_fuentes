library(tidyverse)
library(rjson)
library(tidyjson)
library(dplyr)


# teniendo el archivo DDD este no es necesario, no sirve
consumo_J01 <- fromJSON(file = "INPUT/DATA/consumo_ATC_J01_sectorHospitalario_vs_sectorComunitario_2022.JSON")

consumo_J01

View(consumo_J01)

head(consumo_J01)

spread_all(consumo_J01) %>% View()

consumo_J01 %>% 
  gather_object %>% 
  json_types %>% 
  count(name, type)


# Saca en modo tabla las tres columnas
consumo_J01_df <- do.call(rbind, lapply(consumo_J01, function(x) {
  data.frame(Country = x$Country, 
             Community_2022 = as.numeric(x$`Community, 2022`),
             Hospital_sector_2022 = as.numeric(x$`Hospital sector, 2022`))
}))
View(consumo_J01_df)


