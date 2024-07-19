#### Compilando arquivos .R ####
source("~/Codigos úteis/R program/Limpeza_area_de_trabalho.R", echo=TRUE)
source("~/Codigos úteis/R program/funs.R", echo=TRUE)

## Criando dataframe ficticio para testes
#source("~/Codigos úteis/R program/df_ficticio.R", echo=TRUE)

#### Compilando arquivos .RMD ####
library(knitr)
knit("C:/Users/gabri/OneDrive/Documentos/Codigos úteis/R program/Graficos_GGplot.Rmd")

#### BIBLIOTECAS SEMPRE USADAS ####

# Facilitador de carregamento de pacotes
if(!require(pacman)) install.packages("pacman")
library(pacman)

#pacman::p_load(devtools,broom,readxl,skimr,dplyr,tidyr,tibble,magrittr,reshape2,janitor,RVAideMemoire,clipr,stringr,vegan,forcats,ggplot2,ggthemes,scales,patchwork,ggsignif,ggpubr,naniar,DescTools,multcomp,effsize)

library(broom) #tem a ver com a bibli tidy()
#library(devtools) #criar e baixar pacotes de outros usuarios

# Pacotes para manipulação de dados e analise
library(readxl) #Importar arquvios excel ==> read_excel(".xlsx)
library(skimr) #resumo dos dados do dataframe => skim(df)

library(tidyr) #manipulação de dados
library(tibble) #manipulação de dados

library(reshape2) #manipulação de formato de dataframe
library(RVAideMemoire) # shapiro por grupo ==> byf.shapiro(numerico~categorico, df)
library(stringr) #manipulação de strings
library(vegan) #transformação de variaveis
library(forcats) #manipualação de factor

# Pacotes de graficos
library(ggplot2) #graficos
library(ggthemes) #temas ggplot
library(scales) #escalas dos eixos
library(ggsignif) #significancia entre grupos
library(patchwork) #Graficos lado a lado => (graf1 + graf2)/graf3
library(gridExtra) # graficos lado a lado 2 => grid.arrange(p1, p2, ncol=2)
#library(ggpubr) #ggplot (+estatistica) facilitado

# Outros pacotes
library(naniar) #analise de dados ausentes
library(DescTools) #canivete suiço
library(multcomp) #pós teste estatistico