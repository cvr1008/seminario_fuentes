"C:/CLASE/practicas_fuentes/seminario_fuentes/INPUT/DATA/AMR - 2023 Interactive dashboard.csv"

library(readr)
Acc_Car <- read_delim("C:/CLASE/practicas_fuentes/seminario_fuentes/INPUT/DATA/AMR - 2023 Interactive dashboard_1.txt", 
                      delim = ",", escape_double = FALSE, trim_ws = TRUE)

Acc_Car
summary(Acc_Car)
#View(Acc_Car) 

#"C:\CLASE\practicas_fuentes\seminario_fuentes\INPUT\DATA\AMR - 2023 Interactive dashboard_1.txt"