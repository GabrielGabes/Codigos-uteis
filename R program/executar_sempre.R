#### Limpando desktop ####

#source("https://raw.githubusercontent.com/GabrielGabes/Codigos-uteis/main/R%20program/Limpeza_area_de_trabalho.R")
rm(list = ls()) # Limpar o ambiente de espaço de trabalho
if(!is.null(dev.list())) dev.off() # Limpar a guia Gráficos 
cat("\014") #Limpar o console: Ctrl + L

######################################################################################

#### Suprimir todos os warnings no script ####
options(warn = -1)

######################################################################################

#### Facilitador de carregamento de pacotes ####
if(!require(pacman)) install.packages("pacman")
library(pacman)

######################################################################################

pacman::p_load(clipr) # captura dos dados => write_clip
capture = function(tabela, col_names=TRUE, pontuacao=','){
  tabela %>% print() %>% write_clip(dec = pontuacao, col.names = col_names)
}

######################################################################################

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

#### Outros Pacotes ####
pacman::p_load(
  tidyr, #manipulação de dados #pivot_longer
  tibble, #manipulação de dados
  broom, #tem a ver com a bibli tidy()
  devtools #criar e baixar pacotes de outros usuarios
)

#########################################

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

escolha = 1
if (escolha == 1){ ## MODO DIRETO
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
} else { ## MODO DRIBLANDO PROBLEMAS COM BLOQUEIO
  pacman::p_load(httr, xml2)
  
  url <- "https://github.com/GabrielGabes/statgsa/tree/master/R" # URL da página de arquivos no GitHub
  page <- httr::GET(url) # Obtenha o conteúdo da página
  
  # Parse o HTML da página
  content <- content(page, "text")
  parsed_page <- read_html(content)
  
  # Extraia os links dos arquivos .R
  files <- parsed_page %>%
    xml_find_all("//a[contains(@href, '/GabrielGabes/statgsa/blob/master/R/') and contains(text(), '.R')]") %>%
    xml_attr("href")
  
  # Transforme os links em URLs brutos
  raw_urls <- gsub("/blob", "", paste0("https://raw.githubusercontent.com", files))
  
  # Execute cada arquivo .R diretamente
  for (file_url in raw_urls) {
    print(file_url)
    message("Executando arquivo: ", file_url)
    source(file_url, local = TRUE)
  }
}
######################################################################################

## Criando dataframe ficticio para testes
# source("~/Codigos úteis/R program/Gerador de Dados Ficticios/dataframe.R", echo=F)
# source('https://raw.githubusercontent.com/GabrielGabes/Codigos-uteis/refs/heads/main/Gerador%20de%20Dados%20Ficticios/dataframe.R')
df <- read_excel("C:/Users/gabri/OneDrive/Documentos/Codigos úteis/Gerador de Dados Ficticios/df_ficticio.xlsx")
df
######################################################################################

#### Compilando arquivos .RMD ####
pacman::p_load(knitr)
library(lmerTest)
knit("C:/Users/gabri/OneDrive/Documentos/Codigos úteis/R program/Funcoes.Rmd")
knit("~/Codigos úteis/R program/Graficos_GGplot.Rmd")
# source('https://raw.githubusercontent.com/GabrielGabes/Codigos-uteis/refs/heads/main/R%20program/Funcoes.R')
# source('https://raw.githubusercontent.com/GabrielGabes/Codigos-uteis/refs/heads/main/R%20program/Graficos_GGplot.R')

######################################################################################

print('AMBIENTE PRONTO PARA TRABALHO')