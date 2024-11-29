data(mtcars)
mtcars

mtcars$car <- rownames(mtcars)

# data_id in the aes mapping
p1 <- ggplot(mtcars, aes(wt, mpg, tooltip = car, data_id = car)) +
  geom_point_interactive(size = 4)




graf_izq<-ggplot(positivos_PIB, aes(PIB, Valores, tooltip = Valores, data_id = Variable)) +
  geom_point_interactive(size = 2)+
  geom_smooth(method = 'lm',aes(colour=factor(Variable)))



graf_drch<-ggplot(positivos_PIB, aes(x=RegionCode, y=Valores, tooltip=RegionCode, data_id=RegionCode))+
  geom_bar(aes(fill = Variable), position = "dodge", stat = "identity")+
  geom_col_interactive()+
  coord_flip()

  

plot_combinado <- graf_izq + graf_drch + plot_layout(ncol = 2)

graficas_unidas <- girafe(ggobj = plot_combinado)
graficas_unidas


# Gráfico de dispersión interactivo (izquierda)
graf_izq <- ggplot(positivos_PIB, aes(x = PIB, y = Valores, tooltip = RegionCode, data_id = RegionCode)) +
  geom_point_interactive(aes(color = Variable), size = 3) +  # Puntos interactivos
  geom_smooth(method = "lm", aes(color = Variable), se = TRUE) +  # Líneas de tendencia
  labs(title = "Relación entre PIB y Resistencia", x = "PIB", y = "Porcentaje de Resistencia") +
  theme_minimal()+
  theme(legend.position = "none") 

# Gráfico de barras interactivo (derecha)
graf_drch <- ggplot(positivos_PIB, aes(x = RegionCode, y = Valores, tooltip = paste("País:", RegionCode, "<br>Valor:", Valores), data_id = RegionCode)) +
  geom_col_interactive(aes(fill = Variable), position = "dodge") +  # Barras interactivas agrupadas
  coord_flip() +  # Invertir los ejes para barras horizontales
  labs(title = "Porcentaje de Resistencia por País", x = "País", y = "Porcentaje de Resistencia") +
  theme_minimal()+
  theme(legend.position = "right") 
  
#--------------------------------------------------------------------------------------------------------------
# Gráfico de dispersión interactivo (izquierda)
graf_izq <- ggplot(positivos_PIB_2, aes(x = PIB, y = Valores, tooltip = RegionCode, data_id = RegionCode)) +
  geom_point_interactive(aes(color = Variable), size = 2) +  # Puntos interactivos con color por variable
  geom_smooth(method = "lm",aes(color=Variable) , se = TRUE) +  # Líneas de tendencia
  labs(title = "Relación entre PIB y Resistencia", x = "PIB", y = "Porcentaje de Resistencia") +
  #theme_minimal() +
  theme(legend.position = "none",  # Eliminar la leyenda en el gráfico de dispersión
        plot.margin = margin(10, 10, 10, 10))  # Ajuste de márgenes

# Gráfico de barras interactivo (derecha)
graf_drch <- ggplot(positivos_PIB_2, aes(x = RegionCode, y = Valores, tooltip = paste("País:", RegionCode, "<br>Valor:", Valores), data_id = RegionCode)) +
  geom_col_interactive(aes(fill = Variable), position = "dodge") +  # Barras interactivas agrupadas por variable
  coord_flip() +  # Invertir los ejes para barras horizontales
  labs(x = "País", y = "Porcentaje de Resistencia") +
  #theme_minimal() +
  theme(legend.position = "right",  # Mostrar la leyenda solo en el gráfico de barras
        plot.margin = margin(10, 10, 10, 10))  # Ajuste de márgenes

# Combinar los dos gráficos en una disposición horizontal
plot_combinado <- graf_izq + graf_drch + plot_layout(ncol = 2)

# Crear el objeto interactivo con girafe
graficas_unidas <- girafe(ggobj = plot_combinado)

# Mostrar el gráfico interactivo
graficas_unidas

positivos_PIB



