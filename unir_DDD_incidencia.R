# aquí vamos a unir las tablas para sacar: similitudes de bacterias entre ganadería 
# y la incidencia total (se usa el df otra)


# necesita que se cargue el archivo EU_ddd y EU_Incidencia_enfermedades



library(tidyr)


# Respuestas para la pregunta tres, Consumo y resistencia en sectores específicos en la UE.

DDD_Europa_df # consumo personas antibiótico
new # consumo ganadería antibiótico

paises_consumo_ab_sectores<-left_join(x = DDD_Europa_df, y = new, by = "Country")

positivos_resist_sectores<-left_join(x = media_region, y = positivos_animales, by = "RegionCode")%>%
  dplyr::rename(porcentaje_posit_animales = media)%>%
  dplyr::rename(porcentaje_posit_personas = mean_value_region) %>% 
  group_by(RegionCode) %>% 
  pivot_longer(.,names_to = "Variable", values_to = "Valores", cols = c(porcentaje_posit_personas:porcentaje_posit_animales)) %>% 
  mutate(Variable = factor(Variable, levels = c("porcentaje_posit_personas","porcentaje_posit_animales"))) %>% 
  filter(Valores!=0.00)


positivos_animales # positivo animales resistencia antibiotico
media_region # positivo personas resistencia antibiotico

# aquí separado por bacterias para unirlo con las bacterias de la ganadería para ver si hay coincidencias
# las bacterias son las que provocan que se dé positivo en resistencia
otra

library(ggplot2)

#GRAFICA DE BARRAS DE ENTRE MEDIA DE POSITIVOS EN ANIMALES Y PERSONAS
ggplot(data = positivos_resist_sectores, aes(y = Valores, x = RegionCode)) +
  geom_bar(aes(fill = Variable), position = "dodge", stat = "identity")+
  labs(title='Media por paises de positivos en animales y en personas',
       x='Paises',
       fill='Medias')+
  scale_fill_manual(values = c("porcentaje_posit_personas" = 'violet', 
                               "porcentaje_posit_animales" = "blue")) 



pib_2022_desc

positivos_sinPivotar<-left_join(x = media_region, y = positivos_animales, by = "RegionCode")%>%
  dplyr::rename(porcentaje_posit_animales = media)%>%
  dplyr::rename(porcentaje_posit_personas = mean_value_region)

positivos_PIB<-full_join(y= pib_2022_desc ,x=positivos_sinPivotar,by=c('RegionCode'='pais')) %>% 
  dplyr::rename(PIB='2022') %>% 
  group_by(RegionCode) %>% 
  pivot_longer(.,names_to = "Variable", values_to = "Valores", cols = c(porcentaje_posit_personas:porcentaje_posit_animales)) %>% 
  mutate(Variable = factor(Variable, levels = c("porcentaje_posit_personas","porcentaje_posit_animales"))) %>% 
  filter(Valores!=0.00)

ggplot(positivos_PIB,aes(x=PIB, y=Valores))+
  geom_point(aes(color=factor(Variable)))+
  geom_smooth(method = 'lm',aes(colour=factor(Variable)))+
  labs(title = 'Relación entre PIB y resistencia antimicrobiana',
       y='positivos en AMR',
       colour='poblaciones de positivos')

