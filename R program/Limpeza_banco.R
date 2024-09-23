####################################################


####################################################
# Função para normalizar os nomes das colunas
library(stringr)
normalize_column_names <- function(df) {
  # Remover acentuação
  colnames(df) <- iconv(colnames(df), from = "UTF-8", to = "ASCII//TRANSLIT")
  # Converter para minúsculas
  colnames(df) <- tolower(colnames(df))
  # Substituir espaços por underscores
  colnames(df) <- str_replace_all(colnames(df), " ", "_")
  # Remover caracteres especiais, mantendo apenas letras, números e underscores
  colnames(df) <- gsub("[^a-z0-9_]", "", colnames(df))
  # Substituir múltiplos underscores consecutivos por um único underscore
  colnames(df) <- gsub("_+", "_", colnames(df))
  # Remover underscores no início ou fim dos nomes de colunas
  colnames(df) <- gsub("^_|_$", "", colnames(df))
  
  return(df)
}

####################################################


####################################################


####################################################


####################################################

#Função para converter "hh:mm" em minutos
hhmm_to_minutes <- function(x) {
  # Verificar se é NA ou se o formato é válido
  if (is.na(x) || !grepl("^\\d{2}:\\d{2}$", x)) {
    return(NA)
  } else {
    # Separar horas e minutos
    partes <- strsplit(x, ":")[[1]]
    horas <- as.numeric(partes[1])
    minutos <- as.numeric(partes[2])
    
    # Converter para minutos
    total_minutos <- horas * 60 + minutos
    return(total_minutos)
  }
}


library(lubridate)

#fd$semana_do_mes <- week(fd$datahora)
fd$semana <- ceiling(day(fd$datahora) / 7)
fd$mes <- month(fd$datahora)
table(fd$semana, fd$mes)
fd

####################################################


####################################################


####################################################


####################################################


####################################################


####################################################


####################################################


####################################################


####################################################


####################################################


####################################################


####################################################

