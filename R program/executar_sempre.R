#### cleaning desktop ####
# source("~/Codigos úteis/R program/Limpeza_area_de_trabalho.R", echo=F)
# URL do arquivo de código no GitHub # Baixar e executar o código diretamente do GitHub
source("https://raw.githubusercontent.com/GabrielGabes/Codigos-uteis/main/R%20program/Limpeza_area_de_trabalho.R")




#### Suprimir todos os warnings no script ####
options(warn = -1)




#### Facilitador de carregamento de pacotes ####
if(!require(pacman)) install.packages("pacman")
library(pacman)




#### Carregando meu pacote de analise ####
# dependents Packages
pacman::p_load(
  stats,
  rlang,
  dplyr,
  janitor,
  effsize,
  caret,
  DescTools,
  car,
  pROC,
  MuMIn,
  magrittr,
  tidyr
)
# Carregando meu pacote
tryCatch({
  if(!require(remotes)) install.packages("remotes")
  remotes::install_github("GabrielGabes/statgsa")
  suppressWarnings(library(statgsa))
}, error = function(e) {
  if(!require(pak)) install.packages("pak")
  pak::pak("GabrielGabes/statgsa")
  suppressWarnings(library(statgsa))
})




#### Outros Pacotes ####
pacman::p_load(
  tidyr, #manipulação de dados #pivot_longer
  tibble, #manipulação de dados
  broom, #tem a ver com a bibli tidy()
  devtools #criar e baixar pacotes de outros usuarios
)




## Criando dataframe ficticio para testes
# source("~/Codigos úteis/Gerador de Dados Ficticios/dataframe.R", echo=F)
source('https://raw.githubusercontent.com/GabrielGabes/Codigos-uteis/main/R%20program/df_ficticio.R')
# pacman::p_load(readxl)
# url <- "https://rawgithubusercontent.com/GabrielGabes/Codigos-uteis/main/Gerador%20de%20Dados%20Ficticios/df_ficticio.xlsx"
# temp_file <- tempfile(fileext = ".xlsx")
# download.file(url, destfile = temp_file, mode = "wb")
# dff <- read_excel(temp_file)




#### Compilando arquivos .RMD ####
pacman::p_load(knitr)
#knit("C:/Users/gabri/OneDrive/Documentos/Codigos úteis/R program/Funcoes.Rmd")
#knit("C:/Users/gabri/OneDrive/Documentos/Codigos úteis/R program/Graficos_GGplot.Rmd")
url <- "https://raw.githubusercontent.com/GabrielGabes/Codigos-uteis/main/R%20program/Graficos_GGplot.Rmd"
temp_file <- tempfile(fileext = ".Rmd")
download.file(url, destfile = temp_file, mode = "wb")
knit(temp_file)




#### BIBLIOTECAS SEMPRE USADAS ####
pacman::p_load(
  readxl, #Importar arquvios excel ==> read_excel(".xlsx)
  skimr, #resumo dos dados do dataframe => skim(df)
  
  reshape2, #manipulação de formato de dataframe
  stringr, #manipulação de strings
  vegan, #transformação de variaveis
  forcats, #manipulação de factor
  
  # Outros pacotes
  naniar, #analise de dados ausentes
  DescTools #canivete suiço
)




'AMBIENTE PRONTO PARA TRABALHO'