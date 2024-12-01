library(PubMedWordcloud)
library(purrr) 
library(readr)




# Vector con las rutas a los archivos de texto
rutas <- c(
  "INPUT/ARTICULOS/abstract-33348801.txt",
  "INPUT/ARTICULOS/abstract-36963007.txt",
  "INPUT/ARTICULOS/abstract-37353202.txt",
  "INPUT/ARTICULOS/abstract-38217891.txt"
)



# Leer los contenidos de los archivos
abstracts <- map_chr(rutas, read_file)

# Limpiar los textos
cleanAbs <- cleanAbstracts(abstracts)

# Generar la nube de palabras
plotWordCloud(cleanAbs, min.freq = 2, scale = c(2, 0.3))
