#### cleaning desktop ####
# source("~/Codigos úteis/R program/Limpeza_area_de_trabalho.R", echo=F)
source("https://raw.githubusercontent.com/GabrielGabes/Codigos-uteis/main/R%20program/Limpeza_area_de_trabalho.R")




#### Suprimir todos os warnings no script ####
options(warn = -1)




#### Facilitador de carregamento de pacotes ####
if(!require(pacman)) install.packages("pacman")
library(pacman)


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
#### Outros Pacotes ####
pacman::p_load(
  tidyr, #manipulação de dados #pivot_longer
  tibble, #manipulação de dados
  broom, #tem a ver com a bibli tidy()
  devtools #criar e baixar pacotes de outros usuarios
)




## Criando dataframe ficticio para testes
# source("~/Codigos úteis/Gerador de Dados Ficticios/dataframe.R", echo=F)
source('https://raw.githubusercontent.com/GabrielGabes/Codigos-uteis/main/Gerador%20de%20Dados%20Ficticios/dataframe.R')




#### Compilando arquivos .RMD ####
pacman::p_load(knitr)
knit("C:/Users/gabri/OneDrive/Documentos/Codigos úteis/R program/Funcoes.Rmd")
#knit("C:/Users/gabri/OneDrive/Documentos/Codigos úteis/R program/Graficos_GGplot.Rmd")
source('https://raw.githubusercontent.com/GabrielGabes/Codigos-uteis/main/R%20program/Graficos_GGplot.R')




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

pacman::p_load(clipr) # captura dos dados => write_clip
capture = function(tabela, col_names=TRUE, pontuacao=','){
  tabela %>% print() %>% write_clip(dec = pontuacao, col.names = col_names)
}





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

escolha = 0
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
  
  # URL da página de arquivos no GitHub
  url <- "https://github.com/GabrielGabes/statgsa/tree/master/R"
  
  # Obtenha o conteúdo da página
  page <- httr::GET(url)
  
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
    message("Executando arquivo: ", file_url)
    source(file_url, local = TRUE)
  }
}