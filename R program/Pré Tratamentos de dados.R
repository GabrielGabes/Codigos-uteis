# Função para converter todas as colunas para o tipo character
convert_to_character <- function(df) {
  df[] <- lapply(df, as.character)
  return(df)
}

###########################################################################

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

###########################################################################



###########################################################################



###########################################################################



###########################################################################

df <- convert_to_character(df)
df <- normalize_column_names(df)