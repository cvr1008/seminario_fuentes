# aquí vamos a unir las tablas para sacar: similitudes de bacterias entre ganadería 
# y la incidencia total (se usa el df otra)


# necesita que se cargue el archivo EU_ddd y EU_Incidencia_enfermedades





# Respuestas para la pregunta tres, Consumo y resistencia en sectores específicos en la UE.

DDD_Europa_df # consumo personas antibiótico
new # consumo ganadería antibiótico

paises_consumo_ab_sectores<-left_join(x = DDD_Europa_df, y = new, by = "Country")

positivos_resist_sectores<-left_join(x = media_region, y = positivos_animales, by = "RegionCode")%>%
  rename(porcentaje_posit_animales = media)%>%
  rename(porcentaje_posit_personas = mean_value_region)


positivos_animales # positivo animales resistencia antibiotico
media_region # positivo personas resistencia antibiotico

# aquí separado por bacterias para unirlo con las bacterias de la ganadería para ver si hay coincidencias
# las bacterias son las que provocan que se dé positivo en resistencia
otra


