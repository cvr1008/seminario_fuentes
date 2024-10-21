library(httr)
library(tidyverse)
library(jsonlite)
library(readxl)
library(rjson)

obtener_nombre<-function(carpeta){
  archivos <- as.list(list.files(path =carpeta))
  lista_nombres<-list()
  for(i in 1:length(archivos)){
    posicion1<-regexpr("_", archivos[[i]])
    posicion2<-regexpr("\\.", archivos[[i]])
    subcadena<-substr(archivos[[i]], posicion1+1, posicion2-1)
    lista_nombres[[i]]<-subcadena
  }
  
  return(lista_nombres)
  
}


obtener_archivo<-function(direccion){
  lista_paises<-obtener_nombre(direccion)
  lista_enlace<-list()
  direccion_archivos<-list()
  
  for(i in lista_paises){
    cada_pais<-paste0("AMR_",i,".json")
    lista_enlace[i]<-cada_pais
  }
  for(i in lista_enlace){
    
    cada_archivo<-paste0(direccion,"/",i)
    direccion_archivos[i]<-cada_archivo
  }
  
  
  for(i in direccion_archivos){
    pais<-fromJSON(file= i)
    enlace<-pais$links$archive
    respuesta_archivo <- GET(enlace)# Hacer la solicitud HTTP para descargar el archivo
    nombre_archivo<-basename(enlace)#Extrae el nombre del archivo de la URL
    
    if (status_code(respuesta_archivo) == 200) {# Verificar si la solicitud fue exitosa (código 200, código estándar HTTP que significa "OK")
      # Guardar el archivo ZIP localmente en formato binario
      writeBin(content(respuesta_archivo, "raw"), nombre_archivo)
      print("Archivo ZIP descargado correctamente.")
      unzip(nombre_archivo, exdir = "carpeta_destino", overwrite = TRUE)
    } else {
      print(paste("Error al descargar el archivo. Código de respuesta:", status_code(respuesta_archivo)))
    }
    
   
  }
  
}
obtener_archivo("INPUT/DATA/Resistecia_Antibioticos_UE")






leer_archivo <- function(carpeta) {
  carpeta_destino <- carpeta
  archivos_zip <- list.files(carpeta_destino, pattern = "\\.zip$", full.names = TRUE)
  
  # Iterar sobre los archivos .zip y descomprimirlos
  for (archivo in archivos_zip) {
    # Descomprimir el archivo .zip
    archivos_extraidos <- unzip(archivo, exdir = carpeta_destino, overwrite = TRUE)
    print(paste("Descomprimido:", archivo))  # Imprimir cada archivo que se descomprime
    
    # Filtrar el archivo .xlsx entre los extraídos
    archivo_xlsx <- archivos_extraidos[grepl("\\.xlsx$", archivos_extraidos)]#Aquí, grepl() busca archivos cuyos nombres terminen con .xlsx 
    
    # Verificar si hay algún archivo .xlsx descomprimido
    if (length(archivo_xlsx) > 0) {
      # Leer el archivo Excel como dataframe
      datos_xlsx <- read_excel(archivo_xlsx[1])  # Leer el primer archivo .xlsx encontrado
      
      # Asignar el dataframe al Global Environment usando el nombre del archivo como variable
      nombre_variable <- make.names(basename(archivo_xlsx[1]))  # Crear un nombre de variable válido
      assign(nombre_variable, datos_xlsx, envir = .GlobalEnv)  # Asignar el dataframe al Global Environment
      
    } 
  }
}


leer_archivo("carpeta_destino")


