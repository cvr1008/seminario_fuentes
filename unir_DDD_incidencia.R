# aquí vamos a unir las tablas para sacar: similitudes de bacterias entre ganadería 
# y la incidencia total (se usa el df otra)

# aquí podemos ver si se puede unir los factores: ddd y ganadería con media_region (la incidencia total)

# necesita que se cargue el archivo EU_ddd y EU_Incidencia_enfermedades



# porcentaje de personas que consumen antibiótico de forma anual por cada país en sector hospitalario y comunidad.
DDD_Europa_df
new

paises_consumo_ab_sectores<-left_join(x = DDD_Europa_df, y = new, by = "Country")
#positivos_resist_sectores<- 


# porcentaje de la población que da positivo en resistencia de los encuestados
media_region

# aquí separado por bacterias para unirlo con las bacterias de la ganadería para ver si hay coincidencias
# las bacterias son las que provocan que se dé positivo en resistencia
otra



