# Tamanho da amostra
tamanho_amostra = 75
n = tamanho_amostra / 2

# Criando uma coluna de desfecho (não/sim)
desfecho = c(rep("não", n), rep("sim", n))

# Filtros para separar os grupos
filtro_nao = desfecho == "não"
filtro_sim = desfecho == "sim"

# Criando um DataFrame vazio com a coluna 'desfecho'
df = data.frame(desfecho = desfecho)

#### Preenchendo os dados numéricos ####

# Desfecho numerico
df$desfecho_num = NA
df$desfecho_num[filtro_nao] = round(rnorm(n, mean = 30, sd = 40))
df$desfecho_num[filtro_sim] = round(rnorm(n, mean = 60, sd = 40))

# Idade
df$idade = NA
df$idade[filtro_nao] = round(rnorm(n, mean = 30, sd = 10))
df$idade[filtro_sim] = round(rnorm(n, mean = 60, sd = 40))

df$terceira_idade = ifelse(df$idade >= 65, 1, 0)
df$idade_media = ifelse(df$idade >= mean(df$idade), 1, 0)

# Altura
df$altura = NA
df$altura[filtro_nao] = rpois(n, 150)
df$altura[filtro_sim] = rpois(n, 180)
df$altura = df$altura/100

df$alto = ifelse(df$altura >= 1.8, 1, 0)
df$alto_media = ifelse(df$altura >= mean(df$altura), 1, 0)

# Peso
df$peso = NA
df$peso[filtro_nao] = round(rnorm(n, mean = 50, sd = 20))
df$peso[filtro_sim] = round(rnorm(n, mean = 80, sd = 20))

df$peso_media = ifelse(df$peso >= mean(df$peso), 1, 0)

df$imc = df$peso / (df$altura^2)
df$obeso = ifelse(df$imc >= 35, 1, 0)

# Preenchendo os dados categóricos
df$genero = NA
df$genero[filtro_nao] = sample(c("F", "M"), size = n, replace = TRUE, prob = c(0.7, 0.3))
df$genero[filtro_sim] = sample(c("F", "M"), size = n, replace = TRUE, prob = c(0.4, 0.6))

df$genero_pcr = NA
df$genero_pcr[filtro_nao] = sample(c("F", "M"), size = n, replace = TRUE, prob = c(0.7, 0.3))
df$genero_pcr[filtro_sim] = sample(c("F", "M"), size = n, replace = TRUE, prob = c(0.4, 0.6))

df$tabagismo = NA
df$tabagismo[filtro_nao] = sample(c("não", "sim"), size = n, replace = TRUE, prob = c(0.4, 0.6))
df$tabagismo[filtro_sim] = sample(c("não", "sim"), size = n, replace = TRUE, prob = c(0.3, 0.7))

df$avc_previo = NA
df$avc_previo[filtro_nao] = sample(c("não", "sim"), size = n, replace = TRUE, prob = c(0.3, 0.7))
df$avc_previo[filtro_sim] = sample(c("não", "sim"), size = n, replace = TRUE, prob = c(0.5, 0.5))

df$hipo = NA
df$hipo[filtro_nao] = sample(c("não", "sim"), size = n, replace = TRUE, prob = c(0.2, 0.8))
df$hipo[filtro_sim] = sample(c("não", "sim"), size = n, replace = TRUE, prob = c(0.3, 0.7))

df$has = NA
df$has[filtro_nao] = sample(c("não", "sim"), size = n, replace = TRUE, prob = c(0.5, 0.5))
df$has[filtro_sim] = sample(c("não", "sim"), size = n, replace = TRUE, prob = c(0.2, 0.8))

df$dm = NA
df$dm[filtro_nao] = sample(c("não", "sim"), size = n, replace = TRUE, prob = c(0.8, 0.2))
df$dm[filtro_sim] = sample(c("não", "sim"), size = n, replace = TRUE, prob = c(0.3, 0.7))

df$doenca_cardiaca = NA
df$doenca_cardiaca[filtro_nao] = sample(c("não", "sim"), size = n, replace = TRUE, prob = c(0.2, 0.8))
df$doenca_cardiaca[filtro_sim] = sample(c("não", "sim"), size = n, replace = TRUE, prob = c(0.6, 0.4))

df$asa = NA
df$asa[filtro_nao] = sample(c("1", "2", "3"), size = n, replace = TRUE)
df$asa[filtro_sim] = sample(c("1", "2", "3"), size = n, replace = TRUE, prob = c(0.2, 0.3, 0.5))

df$FC = NA
df$FC[filtro_nao] = runif(n, min = 50, max = 90)
df$FC[filtro_sim] = runif(n, min = 30, max = 140)

df$momento_1 = NA
df$momento_1 = runif(n, min = 0, max = 100)
df$momento_2 = NA
df$momento_2 = runif(n, min = 50, max = 100)
df$momento_3 = NA
df$momento_3 = runif(n, min = 0, max = 50)

df$var_num = NA
df$var_num[filtro_nao] = round(rnorm(n, mean = 45, sd = 30))
df$var_num[filtro_sim] = round(rnorm(n, mean = 60, sd = 30))

df$tratamentos[filtro_nao] = sample(c('A','B','C'), size = n, replace = TRUE, prob = c(0.7, 0.2, 0.1))
df$tratamentos[filtro_sim] = sample(c('A','B','C'), size = n, replace = TRUE, prob = c(0.1, 0.2, 0.7))

#### Arrumando niveis
for (coluna in names(df)){
  classe = df[[coluna]] %>% class()
  levels = df[[coluna]] %>% as.factor() %>% levels()
  qtd_levels = levels %>% length()
  
  if (classe == 'numeric' & qtd_levels <= 3){
    df[[coluna]] = df[[coluna]] %>% as.factor()
  }
  else if ((classe == 'character' |  classe == 'factor') & qtd_levels == 2){
    df[[coluna]] = as.factor(df[[coluna]])
    df[[coluna]] = as.numeric(df[[coluna]]) - 1
    df[[coluna]] = as.factor(df[[coluna]])
  }
  else if (classe == 'character'){
    df[[coluna]] = df[[coluna]] %>% as.factor()
  }
}

df