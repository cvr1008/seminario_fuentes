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


# Nuevo vector con los nombres de las columnas
nuevos_nombres <- c("NombrePais", "Codigo", "zoonosis_name","OrigenMuestra", "TotalMuestras","MuestraPositiva","Tipo_Unidad_Muestra","TipoMuestra","MIC_name","ValorCorte")  # Modifica según el número de columnas

# Asignar los nuevos nombres de las columnas al data frame
colnames(paises_UE_df) <- nuevos_nombres


