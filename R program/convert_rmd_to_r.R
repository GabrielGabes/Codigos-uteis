# Carregar o pacote necessário
library(knitr)

# Caminho da pasta onde o arquivo está localizado
pasta <- 'C:/Users/gabri/OneDrive/Documentos/Codigos úteis/R program'

# Nome do arquivo (sem extensão)
arquivos = c("Graficos_GGplot", 'Funcoes')

for (arquivo in arquivos){
  
  # Construir o caminho do arquivo .Rmd
  rmd_file <- file.path(path.expand(pasta), paste0(arquivo, ".Rmd"))
  rmd_file
  
  # Construir o caminho do arquivo de saída .R
  output_file <- file.path(path.expand(pasta), paste0(arquivo, ".R"))
  output_file
  
  # Converter o .Rmd para .R usando a função purl
  purl(rmd_file, output = output_file)
  print(paste(arquivo, '-> ok'))
}