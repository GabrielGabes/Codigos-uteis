df_ficticio = function(tamanho_amostra = 100){
  # Tamanho da amostra
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
  
  df$tratamentos[filtro_nao] = sample(c('A','B','C'), size = n, replace = TRUE, prob = c(0.6, 0.3, 0.1))
  df$tratamentos[filtro_sim] = sample(c('A','B','C'), size = n, replace = TRUE, prob = c(0.1, 0.3, 0.6))
  
  # Filtros para separar os grupos tratamentos
  filtro_A = df$tratamentos == "A"
  filtro_B = df$tratamentos == "B"
  filtro_C = df$tratamentos == "C"
  
  # Preenchendo os momentos
  df$momento_1 = rnorm(tamanho_amostra, mean = 50, sd = 10) #runif(tamanho_amostra, min = 0, max = 100)
  
  df$momento_2 = df$momento_1
  df$momento_2[filtro_A] = df$momento_2[filtro_A] + rnorm(sum(filtro_A), mean = 50, sd = 10)
  df$momento_2[filtro_B] = df$momento_2[filtro_B] + rnorm(sum(filtro_B), mean = 65, sd = 10)
  df$momento_2[filtro_C] = df$momento_2[filtro_C] - rnorm(sum(filtro_C), mean = 90, sd = 10)
  
  df$momento_3 = df$momento_2
  df$momento_3[filtro_A] = df$momento_3[filtro_A] - rnorm(sum(filtro_A), mean = 70, sd = 10)
  df$momento_3[filtro_B] = df$momento_3[filtro_B] + rnorm(sum(filtro_B), mean = 40, sd = 10)
  df$momento_3[filtro_C] = df$momento_3[filtro_C] + rnorm(sum(filtro_C), mean = 100, sd = 10)
  
  df$var_num = NA
  df$var_num[filtro_nao] = round(rnorm(n, mean = 45, sd = 30))
  df$var_num[filtro_sim] = round(rnorm(n, mean = 60, sd = 30))
  

  ##################################################################################################

  df$fixed_effects = runif(tamanho_amostra, min = 0, max = 20)
  df$group = sample(c(1:5), size = tamanho_amostra, replace = TRUE)
  
  filtro_1 = df$group == 1
  filtro_2 = df$group == 2
  filtro_3 = df$group == 3
  filtro_4 = df$group == 4
  filtro_5 = df$group == 5
  ##################################################################################################
  # Interceptos Aleatórios
  df$response = NA
  df$response[filtro_1] = df$fixed_effects[filtro_1] * rnorm(sum(filtro_1), mean=0.4, sd=0.05) + 2
  df$response[filtro_2] = df$fixed_effects[filtro_2] * rnorm(sum(filtro_2), mean=0.4, sd=0.05) + 7
  df$response[filtro_3] = df$fixed_effects[filtro_3] * rnorm(sum(filtro_3), mean=0.4, sd=0.05) + 10
  df$response[filtro_4] = df$fixed_effects[filtro_4] * rnorm(sum(filtro_4), mean=0.4, sd=0.05) + 5
  df$response[filtro_5] = df$fixed_effects[filtro_5] * rnorm(sum(filtro_5), mean=0.4, sd=0.05) + 9
  ##################################################################################################
  # Interceptos e Inclinações Aleatórias & Efeito Aleatórios Correlacionados
  df$response2 = NA
  df$response2[filtro_1] = df$fixed_effects[filtro_1] * rnorm(sum(filtro_1), mean=0.4, sd=0.05) + 2
  df$response2[filtro_2] = df$fixed_effects[filtro_2] * rnorm(sum(filtro_2), mean=-0.1, sd=0.05) + 7
  df$response2[filtro_3] = df$fixed_effects[filtro_3] * rnorm(sum(filtro_3), mean=-0.2, sd=0.05) + 10
  df$response2[filtro_4] = df$fixed_effects[filtro_4] * rnorm(sum(filtro_4), mean=0.3, sd=0.05) + 5
  df$response2[filtro_5] = df$fixed_effects[filtro_5] * rnorm(sum(filtro_5), mean=0.4, sd=0.05) + 9
  ##################################################################################################
  # Inclinações Aleatórias
  df$response3 = NA
  df$response3[filtro_1] = df$fixed_effects[filtro_1] * rnorm(sum(filtro_1), mean=0.05, sd=0.05)
  df$response3[filtro_2] = df$fixed_effects[filtro_2] * rnorm(sum(filtro_2), mean=0.1, sd=0.05)
  df$response3[filtro_3] = df$fixed_effects[filtro_3] * rnorm(sum(filtro_3), mean=0.3, sd=0.05)
  df$response3[filtro_4] = df$fixed_effects[filtro_4] * rnorm(sum(filtro_4), mean=0.5, sd=0.05)
  df$response3[filtro_5] = df$fixed_effects[filtro_5] * rnorm(sum(filtro_5), mean=0.7, sd=0.05)
  ##################################################################################################
  # Efeitos Aleatório Cruzado
  df$group2 = sample(c(1:3), size = tamanho_amostra, replace = TRUE)
  df$response4 = NA

  filtro_1 = df$group == 1 & df$group2 == 1
  filtro_2 = df$group == 2 & df$group2 == 1
  filtro_3 = df$group == 3 & df$group2 == 1
  filtro_4 = df$group == 4 & df$group2 == 1
  filtro_5 = df$group == 5 & df$group2 == 1
  df$response4[filtro_1] = df$fixed_effects[filtro_1] * rnorm(sum(filtro_1), mean=0.4, sd=0.05) + 3
  df$response4[filtro_2] = df$fixed_effects[filtro_2] * rnorm(sum(filtro_2), mean=0.4, sd=0.05) + 5
  df$response4[filtro_3] = df$fixed_effects[filtro_3] * rnorm(sum(filtro_3), mean=0.4, sd=0.05) + 15
  df$response4[filtro_4] = df$fixed_effects[filtro_4] * rnorm(sum(filtro_4), mean=0.4, sd=0.05) + 14
  df$response4[filtro_5] = df$fixed_effects[filtro_5] * rnorm(sum(filtro_5), mean=0.4, sd=0.05) + 2

  filtro_1 = df$group == 1 & df$group2 == 2
  filtro_2 = df$group == 2 & df$group2 == 2
  filtro_3 = df$group == 3 & df$group2 == 2
  filtro_4 = df$group == 4 & df$group2 == 2
  filtro_5 = df$group == 5 & df$group2 == 2
  df$response4[filtro_1] = df$fixed_effects[filtro_1] * rnorm(sum(filtro_1), mean=0.5, sd=0.05) + 10
  df$response4[filtro_2] = df$fixed_effects[filtro_2] * rnorm(sum(filtro_2), mean=0.5, sd=0.05) + 7
  df$response4[filtro_3] = df$fixed_effects[filtro_3] * rnorm(sum(filtro_3), mean=0.5, sd=0.05) + 5
  df$response4[filtro_4] = df$fixed_effects[filtro_4] * rnorm(sum(filtro_4), mean=0.5, sd=0.05) + 4
  df$response4[filtro_5] = df$fixed_effects[filtro_5] * rnorm(sum(filtro_5), mean=0.5, sd=0.05) + 5

  filtro_1 = df$group == 1 & df$group2 == 3
  filtro_2 = df$group == 2 & df$group2 == 3
  filtro_3 = df$group == 3 & df$group2 == 3
  filtro_4 = df$group == 4 & df$group2 == 3
  filtro_5 = df$group == 5 & df$group2 == 3
  df$response4[filtro_1] = df$fixed_effects[filtro_1] * rnorm(sum(filtro_1), mean=0.7, sd=0.05) + 10
  df$response4[filtro_2] = df$fixed_effects[filtro_2] * rnorm(sum(filtro_2), mean=0.7, sd=0.05) + 7
  df$response4[filtro_3] = df$fixed_effects[filtro_3] * rnorm(sum(filtro_3), mean=0.7, sd=0.05) + 8
  df$response4[filtro_4] = df$fixed_effects[filtro_4] * rnorm(sum(filtro_4), mean=0.7, sd=0.05) + 5
  df$response4[filtro_5] = df$fixed_effects[filtro_5] * rnorm(sum(filtro_5), mean=0.7, sd=0.05) + 11
  ##################################################################################################
  # Efeitos Aleatorios Aninhados
  df$group1 = NA
  filtro_1 = df$group == 1 | df$group == 2
  filtro_2 = df$group == 3 | df$group == 4
  filtro_3 = df$group == 5
  df$group1[filtro_1] = 'A'
  df$group1[filtro_2] = 'B'
  df$group1[filtro_3] = 'C'
  
  filtro_1 = df$group1 == 'A' & df$group == 1
  filtro_2 = df$group1 == 'A' & df$group == 2
  df$response5[filtro_1] = df$fixed_effects[filtro_1] * rnorm(sum(filtro_1), mean=0.4, sd=0.05) + 3
  df$response5[filtro_2] = df$fixed_effects[filtro_2] * rnorm(sum(filtro_2), mean=0.4, sd=0.05) + 9
  
  filtro_1 = df$group1 == 'B' & df$group == 3
  filtro_2 = df$group1 == 'B' & df$group == 4
  df$response5[filtro_1] = df$fixed_effects[filtro_1] * rnorm(sum(filtro_1), mean=0.5, sd=0.05) + 10
  df$response5[filtro_2] = df$fixed_effects[filtro_2] * rnorm(sum(filtro_2), mean=0.5, sd=0.05) + 7

  filtro_1 = df$group1 == 'C'
  df$response5[filtro_1] = df$fixed_effects[filtro_1] * rnorm(sum(filtro_1), mean=0.5, sd=0.05) + 4
  ##################################################################################################

  df$group = factor(df$group)
  df$group1 = factor(df$group1)
  df$group2 = factor(df$group2)
  
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
  
  return(df)
}

dff = df_ficticio(150)

## library(openxlsx)
## openxlsx::write.xlsx(dff, 'df_ficticio.xlsx')
