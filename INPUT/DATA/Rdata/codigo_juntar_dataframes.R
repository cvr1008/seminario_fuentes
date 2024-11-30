# Cargar dplyr
library(dplyr)
library(ggplot2)

# 1. Listar los nombres de todos los dataframes que terminan en ".xlsx" (ajusta si es necesario)
nombres_dataframes <- ls(pattern = "_AMR_PUB\\.xlsx$")

# 2. Convertir los nombres a una lista de dataframes usando mget()
lista_dataframes <- mget(nombres_dataframes)

# 3. Unir todos los dataframes en uno solo usando bind_rows
df_combinado <- bind_rows(lista_dataframes, .id = "origen")

# Mostrar el dataframe combinado
print(df_combinado)


#seleccionamos las columnas que vamos a necesitar
paises_UE_df <- df_combinado %>%
  select(rep_Country_name, rep_Country_code, zoonosis_name, matrix_name, 
         totUnitsTested, totUnitsPositive, sampUnitType_name, sampType_name,MIC_name, CUTOFFVALUE) %>%
  mutate(zoonosis_name = sub(" .*", "", zoonosis_name)) %>%  # Extraer solo la primera palabra
  filter(zoonosis_name != "Escherichia coli, non-pathogenic, unspecified")



# Renombrar las columnas utilizando rename de dplyr
paises_UE_df <- paises_UE_df %>%
  rename(
    NombrePais = rep_Country_name,
    Codigo = rep_Country_code,
    OrigenMuestra = matrix_name,
    TotalMuestras = totUnitsTested,
    MuestraPositiva = totUnitsPositive,
    Tipo_Unidad_Muestra = sampUnitType_name,
    TipoMuestra = sampType_name,
    ValorCorte = CUTOFFVALUE
  )


