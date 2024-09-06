# Suponha que você tenha o seguinte conjunto de dados
dados <- c(10, 12, 13, 14, 15, 16, 17, 18, 19, 100)

# Cálculo dos quartis
Q1 <- quantile(dados, 0.25)
Q3 <- quantile(dados, 0.75)

# Cálculo do IQR
IQR <- Q3 - Q1

# Definição dos limites superior e inferior
limite_inferior <- Q1 - 1.5 * IQR
limite_superior <- Q3 + 1.5 * IQR

# Identificação de outliers
outliers <- dados[dados < limite_inferior | dados > limite_superior]

# Filtrando os dados para remover os outliers
dados_sem_outliers <- dados[dados >= limite_inferior & dados <= limite_superior]

# Resultados
print(paste("Outliers identificados:", outliers))
print(paste("Dados sem outliers:", dados_sem_outliers))

#########################################

# Função para remover outliers usando IQR
remove_outliers <- function(dados) {
  Q1 <- quantile(dados, 0.25)
  Q3 <- quantile(dados, 0.75)
  IQR <- Q3 - Q1
  limite_inferior <- Q1 - 1.5 * IQR
  limite_superior <- Q3 + 1.5 * IQR
  dados[dados >= limite_inferior & dados <= limite_superior]
}