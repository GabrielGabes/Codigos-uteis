###################################################################### Bibliotecas Usadas
library(effsize) #tamanho do efeito d'cohen
#library(devtools) #criar e baixar pacotes de outros usuarios

library(readxl) #Importar arquvios excel ==> read_excel(".xlsx)
library(skimr) #resumo dos dados do dataframe => skim(df)
library(dplyr) #manipulação de dados
library(tidyr) #manipulação de dados
library(magrittr) #operador pipe line %>%

library(reshape2) #manipulação de formato de dataframe
library(janitor) #tabela de contigencia
library(RVAideMemoire) # shapiro por grupo ==> byf.shapiro(numerico~categorico, df)
library(clipr) #captura de dados
library(stringr) #manipulação de strings
library(vegan) #transformação de variaveis
library(forcats) #manipualação de factor

library(ggplot2) #graficos
library(ggpubr) #ggplot (+estatistica) facilitado
library(ggthemes) #temas ggplot
library(scales) #escalas dos eixos
library(patchwork) #Graficos lado a lado => (graf1 + graf2)/graf3
library(ggsignif) #significancia entre grupos

library(naniar) #analise de dados ausentes
library(DescTools) #canivete suiço

######################################################################

# Capturar tabelas ou medidas
capture = function(tabela){
  tabela %>% print() %>% write_clip(dec = ".", col.names = TRUE)
}

######################################################################

# Retornar valor de p
retorne_p = function(valor){
  valor_str = formatC(valor, format = "f", digits = 6)
  if (valor < 0.05){
    if (valor < 0.001 || valor == 0){"< 0.001"}
    else {
      if (valor < 0.01){substring(as.character(valor_str), 1, 5)}
      else {substring(as.character(valor_str), 1, 4)}
    }}
  else {
    if (valor < 0.06){substring(as.character(valor_str), 1, 5)}
    else {substring(as.character(valor_str), 1, 4)}}}

retorne_p(0.054)
retorne_p(0.050)
retorne_p(0.059)
retorne_p(0.045)
retorne_p(0.4)
retorne_p(0.3454149)
retorne_p(0.399949)
retorne_p(0.04)
retorne_p(0.002)
retorne_p(0.00002)


retorne_p_ajust = function(valor){
  if (valor == "< 0.001"){
    "P < 0.001"
  }
  else{
    paste("P =", valor)
  }
}

retorne_p_ajust(retorne_p(0.00002))
retorne_p_ajust(retorne_p(0.399949))
retorne_p_ajust(retorne_p(0.04))

# Aplicando a função a todos elementos da coluna
apply_retorne_p = function(data, colname) {
  data[[colname]] = sapply(data[[colname]], function(x) {
    if (!is.na(x) && is.numeric(x)) {
      retorne_p(x)
    } else {
      x
    }
  })
  return(data)
}

######################################################################

rround = function(valor, digitos){
  if (abs(valor) < 0.01 || abs(valor) > 1000){
    if (abs(valor) < 0.01){formatC(0, format = "f", digits = digitos)}
    else{formatC(valor, format = "e", digits = digitos)}}
  else{formatC(valor, format = "f", digits = digitos)}}

rround(0, 2)
rround(0.001, 2)
rround(0.0001, 2)
rround(0.041212, 2)
rround(0.1, 2)
rround(45.5151, 2)
rround(5115156, 2)

###############################

rround = function(valor, digitos){
  if (abs(valor) < 0.01 && abs(valor) > 0.0009) {formatC(valor, format = "f", digits = 3)} 
  else if (valor == 0){"0.00"}
  else if (abs(valor) <= 0.0009 && valor != 0 || abs(valor) > 1000) {formatC(valor, format = "e", digits = digitos)} 
  else {formatC(valor, format = "f", digits = digitos)}
}

rround(0, 2)
rround(0.001, 2)
rround(0.0001, 2)
rround(0.041212, 2)
rround(0.1, 2)
rround(45.5151, 2)
rround(5115156, 2)

###############################

# Aplicando a função a todos elementos da coluna 
apply_rround = function(data, colname, digitos = 2){
  data[[colname]] = sapply(data[[colname]], function(x) {
    if (!is.na(x) && is.numeric(x)) {
      rround(x, digitos)
    } else {
      x
    }
  })
  return(data)
}

#####################################################################

# Tabela contagem simples
cont = function(data_frame, variavel){
  data_frame %>% tabyl(.data[[variavel]], show_na = FALSE) %>% 
    adorn_pct_formatting(2) %>% as.data.frame()
}

#############################

tabelinha_ajust = function(tabelinha){
  nomes_colunas <- colnames(tabelinha)
  linha_nomes_colunas <- as.data.frame(t(nomes_colunas), stringsAsFactors = FALSE)
  colnames(linha_nomes_colunas) <- colnames(tabelinha)
  tabelinha <- rbind(linha_nomes_colunas, tabelinha)
  colnames(tabelinha) = c('Variable', 'medida1', 'medida2')
  tabelinha$medida1[1] = NA
  tabelinha$medida2[1] = NA
  return(tabelinha)
}

######################################################################

fisher_criterio = function(df, var1, var2){
  length1 = length(levels(as.factor(df[[var1]])))
  length2 = length(levels(as.factor(df[[var2]])))
  if (length1 >= 3 || length2 >= 3){
    FALSE
  }
  else{
    # Criar tabela de contingência
    tabela = table(df[[var1]], df[[var2]])
    # Calcular as expectativas de frequência
    total_geral = sum(tabela)
    expectativas = outer(rowSums(tabela), colSums(tabela), FUN = "*") / total_geral
    # Verificar se alguma célula tem expectativa de frequência < 5
    any(expectativas < 5)
  }
}

#################################

# Tabela contingencia
conti = function(data_frame, var_y, var_x, sentido_percent='col', apenas_fisher=F){
  #sentido_porcent => #col, row
  tabela = data_frame %>% 
    tabyl(.data[[var_x]], .data[[var_y]], show_na = FALSE) %>% 
    adorn_totals(c("row", "col")) %>% 
    adorn_percentages(sentido_percent) %>% 
    adorn_pct_formatting(2) %>% adorn_ns
  
  tabela = as.data.frame(tabela)
  tabela = rename(tabela, "Variable" = var_x)
  tabela = rbind(NA, tabela)
  tabela[["Variable"]] = as.character(tabela[["Variable"]])
  tabela[["Variable"]][1] = var_x
  tabela = tabela[-nrow(tabela), ] #excluindo ultima linha
  
  #Aplicando teste de hipotese adequado
  tabela[["P-value"]] = NA
  tabela[["Test_Used"]] = NA
  if(fisher_criterio(var_y, var_x) == F){
    if (nrow(tabela) <= 3 && apenas_fisher == T){
      tabela[["P-value"]][1] = retorne_p(fisher.test(data_frame[[var_x]],data_frame[[var_y]])$p.value)
      tabela[["Test_Used"]][1] = "Fisher Exact"}
    else {
      tabela[["P-value"]][1] = retorne_p(chisq.test(data_frame[[var_x]],data_frame[[var_y]])$p.value)
      tabela[["Test_Used"]][1] = "Chi-squared"}}
  else{
    tabela[["P-value"]][1] = retorne_p(fisher.test(data_frame[[var_x]],data_frame[[var_y]])$p.value)
    tabela[["Test_Used"]][1] = "Fisher Exact"}
  
  # Reordenando as colunas, colocando coluna total para primeira posicao
  # Determina a sequência de índices das colunas
  indices = seq_len(ncol(tabela))
  # Altera a sequência para colocar a coluna -3 na posição 2
  indices = c(indices[1], indices[length(indices)-2], indices[2:(length(indices)-3)], indices[(length(indices)-1):length(indices)])
  # Reordena as colunas do dataframe de acordo com a sequência
  tabela = tabela[, indices]
  tabela[["Variable"]][1] = var_x
  
  # Ultimos Ajustes
  colnames(tabela)[colnames(tabela) == 'Total'] = 'Overall'
  tabela[] = lapply(tabela, function(x) gsub("%", "", x))
  tabela[] = lapply(tabela, function(x) gsub("  ", " ", x))
  
  return(tabela)
}

# Exemplo
#conti(df, "Resíduo gástrico", "sintomas_gabriel")

######################################################################

normalidade_por_grupo_criterio = function(df, col_num, col_cat){
  if (any(byf.shapiro(df[[col_num]]~df[[col_cat]])$tab$`p-value` < 0.05)){return(FALSE)} #ALGUMA NÃO É NORMAL
  else{return(TRUE)}} #TODAS SÃO NORMAIS

normalidade_por_grupo_criterio_tab = function(df, col_num, col_cat){
  byf.shapiro(df[[col_num]]~df[[col_cat]])$tab}

##################################

summary_numerico_parametrico = function(dataframe, col_num){
  tabela = dataframe %>%
    filter(!is.na(.data[[col_num]])) %>%
    summarise(
      mean = round(mean(.data[[col_num]], na.rm = TRUE), 2),
      std = paste0('± ', round(as.numeric(sd(.data[[col_num]], na.rm = TRUE)), 2)))
  
  tabela[["Variable"]] = col_num
  rownames(tabela) = NULL
  tabela = tabela[, c(ncol(tabela), 1:(ncol(tabela)-1))]
  
  return(tabela)
}

##################################

summary_numerico_por_grupo_parametrico = function(df, col_num, col_cat, teste_extra="F"){
  # Sumário por grupo
  sumario_grupo = df %>%
    filter(!is.na(.data[[col_num]]), !is.na(.data[[col_cat]])) %>%
    group_by(.data[[col_cat]]) %>%
    summarise(
      resumo = paste0(
        sprintf("%.2f", round(mean(.data[[col_num]], na.rm = TRUE), 2)), 
        " ± ", sprintf("%.2f", round(as.numeric(sd(.data[[col_num]], na.rm = TRUE)), 2))
      )
    )
  sumario_grupo = rename(sumario_grupo, "coluna" = col_cat)
  
  # Sumário geral (total)
  sumario_geral = df %>%
    filter(!is.na(.data[[col_num]]), !is.na(.data[[col_cat]])) %>%
    summarise(
      coluna = 'Total',
      resumo = paste0(
        sprintf("%.2f", round(mean(.data[[col_num]], na.rm = TRUE), 2)), 
        " ± ", sprintf("%.2f", round(as.numeric(sd(.data[[col_num]], na.rm = TRUE)), 2))
      )
    )
  
  sumario_final = rbind(sumario_geral, sumario_grupo) # Combinar os sumários
  tabela = as.data.frame(t(sumario_final)) # Transpor o dataframe
  colnames(tabela) = tabela[1, ] # Ajustar os nomes das colunas
  tabela = tabela[-1, ]  # Remover a primeira linha
  rownames(tabela)[1] = col_num
  
  tabela[["P-value"]] = NA
  tabela[["Test_Used"]] = NA
  
  if ( length(levels(as.factor(df[[col_cat]]))) <= 2 ){
    pvalor = retorne_p(t.test(df[[col_num]]~df[[col_cat]])$p.value)
    tabela[["Test_Used"]][1] = "T Test"
    
    if (teste_extra == "T"){
      niveis = df[[col_cat]] %>% as.factor() %>% levels()
      grupo1 = df[[col_num]][df[[col_cat]] == niveis[1]]
      grupo2 = df[[col_num]][df[[col_cat]] == niveis[2]]
      d_cohen = cohen.d(grupo1, grupo2)
      estimador = as.character(rround(d_cohen$estimate,2))
      IC_00 = as.character(rround(d_cohen$conf.int[1],2))
      IC_01 = as.character(rround(d_cohen$conf.int[2],2))
      d_cohen = paste0(estimador,' (',IC_00,' to ',IC_01,')')
      tabela[["teste_extra"]] = NA
      tabela[["teste_extra"]] = d_cohen}
  }else { 
    pvalor = summary(aov(df[[col_num]]~df[[col_cat]]))[[1]][["Pr(>F)"]][1]
    pvalor = retorne_p(pvalor)
    tabela[["Test_Used"]][1] = "Anova"
  }
  
  tabela[["P-value"]] = pvalor
  
  tabela[["Variable"]] = rownames(tabela)
  rownames(tabela) = NULL
  tabela = tabela[, c(ncol(tabela), 1:(ncol(tabela)-1))] #ultima coluna para primeira
  
  colnames(tabela)[colnames(tabela) == 'Total'] = 'Overall'
  
  return(tabela)  
}
# Exemplo de uso:
#summary_numerico_por_grupo_parametrico("idade", "DM")
######################################################################

summary_numerico_n_parametrico = function(dataframe, col_num){
  tabela = dataframe %>%
    filter(!is.na(.data[[col_num]])) %>%
    summarise(
      median = round(median(.data[[col_num]], na.rm = TRUE), 2),
      q1_q3 = paste0(
        '[', round(as.numeric(quantile(.data[[col_num]], 0.25, na.rm = TRUE)), 2), 
        " - ", 
        round(as.numeric(quantile(.data[[col_num]], 0.75, na.rm = TRUE)), 2), ']'))
  
  tabela[["Variable"]] = col_num
  rownames(tabela) = NULL
  tabela = tabela[, c(ncol(tabela), 1:(ncol(tabela)-1))]
  
  return(tabela)
}

##################################

summary_numerico_por_grupo_n_parametrico = function(col_num, col_cat, teste_extra="F"){
  # Sumário por grupo
  sumario_grupo = df %>%
    filter(!is.na(.data[[col_num]]), !is.na(.data[[col_cat]])) %>%
    group_by(.data[[col_cat]]) %>%
    summarise(
      resumo = paste0(
        sprintf("%.2f", round(median(.data[[col_num]], na.rm = TRUE), 2)), 
        " [", sprintf("%.2f", round(as.numeric(quantile(.data[[col_num]], 0.25, na.rm = TRUE)), 2)), 
        " - ", 
        sprintf("%.2f", round(as.numeric(quantile(.data[[col_num]], 0.75, na.rm = TRUE)), 2)),"]"
      )
    )
  sumario_grupo = rename(sumario_grupo, "coluna" = col_cat)
  
  # Sumário geral (total)
  sumario_geral = df %>%
    filter(!is.na(.data[[col_num]]), !is.na(.data[[col_cat]])) %>%
    summarise(
      coluna = 'Total',
      resumo = paste0(
        sprintf("%.2f", round(median(.data[[col_num]], na.rm = TRUE), 2)), 
        " [", sprintf("%.2f", round(as.numeric(quantile(.data[[col_num]], 0.25, na.rm = TRUE)), 2)), 
        " - ", 
        sprintf("%.2f", round(as.numeric(quantile(.data[[col_num]], 0.75, na.rm = TRUE)), 2)),"]"
      )
    )
  
  sumario_final = rbind(sumario_geral, sumario_grupo) # Combinar os sumários
  tabela = as.data.frame(t(sumario_final)) # Transpor o dataframe
  colnames(tabela) = tabela[1, ] # Ajustar os nomes das colunas
  tabela = tabela[-1, ]  # Remover a primeira linha
  rownames(tabela)[1] = col_num
  
  tabela[["P-value"]] = NA
  tabela[["Test_Used"]] = NA
  if (length(levels(as.factor(df[[col_cat]]))) > 2){
    pvalor = retorne_p(kruskal.test(df[[col_num]]~df[[col_cat]])$p.value)
    tabela[["Test_Used"]][1] = "Kruskal-Wallis"}
  else{
    pvalor = retorne_p(wilcox.test(df[[col_num]]~df[[col_cat]])$p.value)
    tabela[["Test_Used"]][1] = "Mann-Whitney"
    
    if (teste_extra == "T"){
      #Teste de Hipotese - Teste Mann Whitney
      teste_man = wilcox.test(df[[col_num]]~df[[col_cat]], conf.int = TRUE)
      
      #Estimador Hodges Lehmann
      estimador = as.character(rround(teste_man$estimate,2))
      IC_00 = as.character(rround(teste_man$conf.int[1],2))
      IC_01 = as.character(rround(teste_man$conf.int[2],2))
      hodges_lehmann = paste0(estimador,' (',IC_00,' to ',IC_01,')')
      tabela[["teste_extra"]] = NA
      tabela[["teste_extra"]] = hodges_lehmann
      }
    }
  tabela[["P-value"]] = pvalor
  
  tabela[["Variable"]] = rownames(tabela)
  rownames(tabela) = NULL
  tabela = tabela[, c(ncol(tabela), 1:(ncol(tabela)-1))] #ultima coluna para primeira
  
  colnames(tabela)[colnames(tabela) == 'Total'] = 'Overall'
  
  return(tabela)  
}
# Exemplo de uso:
#summary_numerico_por_grupo_n_parametrico("idade", "Metadona")

######################################################################

# Capturar medidas de modelo de Regressão Logistica
analise_mod = function(modelo){
  estimadores = as.data.frame(summary(modelo)$coefficients)
  odds = as.data.frame((exp(cbind(OR= coef(modelo), confint(modelo)))))
  
  estimadores = apply_retorne_p(estimadores, "Pr(>|z|)")
  #estimadores = estimadores[, "Pr(>|z|)", drop = FALSE]
  
  odds = odds[rowSums(is.na(odds)) != ncol(odds), ] # Apagando as linhas quando um dado estiver NA
  odds = apply_rround(odds, "OR")
  odds = apply_rround(odds, "2.5 %")
  odds = apply_rround(odds, "97.5 %")
  
  #odds$ODDS = paste0(odds$OR, " (", odds$`2.5 %`, " - ", odds$`97.5 %`, ")")
  #odds = odds[, "ODDS", drop = FALSE]
  
  tabela = cbind(odds, estimadores)
  tabela = tabela[-1, ] #apagando primeira linha
  
  tabela$Estimate = NULL
  tabela$`Std. Error` = NULL
  tabela$`z value` = NULL
  
  return(tabela)
}


# Versão antiga
analise_mod_antiga = function(modelo){
  estimadores = as.data.frame(summary(modelo)$coefficients)
  odds = as.data.frame((exp(cbind(OR= coef(modelo), confint(modelo)))))
  
  return(cbind(odds, estimadores))
}

######################################################################

analise_fisher = function(teste){
  odds = rround(test_f$estimate, 2)
  ic_0 = rround(test_f$conf.int[1], 2)
  ic_1 = rround(test_f$conf.int[2], 2)
  valores = paste0(odds, " (", ic_0, " - ", ic_1, ")")
  return(valores)
}
#analise_fisher(fisher.test(table(df$estenose, df$sexo), conf.int = TRUE))

######################################################################

teste_normalidade = function(df, coluna, qtd_bins=20){
  if (nrow(df) > 3 & nrow(df) < 5000){
    media = mean(df[[coluna]], na.rm=T)
    desvpad = sd(df[[coluna]], na.rm=T)
    p_valor = shapiro.test(df[[coluna]])$p.value %>% retorne_p() %>% retorne_p_ajust()
    subtitulo = paste(p_valor, '(Shapiro-wilk)')
  }else{
    media = mean(df[[coluna]], na.rm=T)
    desvpad = sd(df[[coluna]], na.rm=T)
    p_valor = ks.test(df$p1_soma, "pnorm", mean= mean(df$p1_soma), sd= sd(df$p1_soma))$p.value %>% retorne_p() %>% retorne_p_ajust()
    subtitulo = paste(p_valor, '(Kolmogorov-Smirnov)')
  }
  
  ggplot(df, aes(x=!!sym(coluna)))+
    geom_histogram(aes(y=..density..), bins= qtd_bins, fill='#40BCD8', colour = "black") +
    #geom_histogram(aes(y=..density..), bins= qtd_bins, fill='tomato', colour = alpha("red",0.9)) +
    geom_function(fun= dnorm, args=list(mean=media,sd=desvpad), col='black', lwd=1, lty=4) +
    geom_density(lwd = 1.2, linetype = 2, colour = "blue") +
    #geom_density(lwd = 1.2, linetype = 2, colour = "red") +
    theme_bw() +
    labs(x=NULL, y='Probability Density', subtitle= subtitulo)
}
#teste_normalidade(df, 'idade', 30)

##################################################################################################
# Grafico de Barras -> para representar uma tabela de contagem simples (categorica)

cont_grafi = function(df, coluna){
  # Criando tabela de contagem
  tabela = df %>% filter(!is.na(!!sym(coluna))) %>% 
    group_by(!!sym(coluna)) %>% 
    summarise(n = n()) %>% mutate(Freq = round(n/sum(n)*100, 2)) %>% ungroup()
  
  ggplot(tabela, aes(x=as.factor(!!sym(coluna)), y=Freq, label=Freq, fill=as.factor(!!sym(coluna)))) + 
    # Grafico
    geom_col(show.legend=FALSE, color="black") + 
    # Outros
    geom_text(aes(y=Freq, label = sprintf("%0.1f%%", Freq), vjust=-0.1)) + 
    theme_bw() + theme(legend.position = "bottom") +
    scale_y_continuous(limits = c(0, 100), breaks=seq(from = 0, to = 100, by = 20)) +
    labs(x=NULL, y="Frequency (%)", title =NULL)
}
#ggsave("nome_grafico.png", height=15, width=20, units="cm", dpi= 600)

##################################################################################################
# Grafico de Barras -> para representar uma tabela de contingencia (categorica vs categorica)

conti_grafi = function(df, coluna_x, coluna_y, sentido_percent='col'){
  # Teste de hipotese
  p_value = chisq.test(df[[coluna_y]], df[[coluna_x]])$p.value %>% retorne_p() %>% retorne_p_ajust()
  subtitulo = paste(p_value, '(Chisq-Squared)')
  
  if (sentido_percent == 'row'){ #fazendo troca a troca kkkkkkkkkkkkkkkkkkkkk #kapa pride #la ele
    temp <- coluna_x
    coluna_x <- coluna_y
    coluna_y <- temp
  }
  
  # Criando tabela de contagem
  grafi = df %>% filter(!is.na(!!sym(coluna_x)) & !is.na(!!sym(coluna_y))) %>% 
    group_by(!!sym(coluna_y), !!sym(coluna_x)) %>% 
    summarise(n = n()) %>% mutate(Freq = round(n/sum(n)*100, 2)) %>% ungroup()
  
  ggplot(grafi, aes(x=as.factor(!!sym(coluna_y)), y=Freq, fill=as.factor(!!sym(coluna_x)))) + 
    # Grafico
    geom_bar(stat="identity", position=position_dodge(), color='black') +
    # Outros
    geom_text(aes(y=Freq + 3, label = sprintf("%0.1f%%", Freq)), position=position_dodge(0.75), vjust=-0.3) +
    theme_bw() + theme(legend.position = "bottom") +
    scale_y_continuous(labels = scales::percent) +
    scale_y_continuous(limits = c(0, 100), breaks=seq(from=0, to=100, by=10)) #+
    #labs(x=NULL, y='Frequency (%)', subtitle=subtitulo, title=NULL, fill=NULL)
}
#ggsave("nome_grafico.png", height=15, width=20, units="cm", dpi= 600)

########################################################################################################################
# Graficos (Boxplot, Violino, Jitter) por Grupos -> para representar analise númerica por grupo (variavel: numerica vs categorica)

box_vin_jit = function(df, col_num, col_cat){
  # Contagens adicionais
  levels = df[[col_cat]] %>% as.factor() %>% levels()
  tabela = cont(df, col_cat)
  rotulo_respcor = paste0(levels[1], '\n', tabela$percent[1], ' (', tabela$n[1], ')')
  rotulo_respincor = paste0(levels[2], '\n', tabela$percent[2], ' (', tabela$n[2], ')')
  
  # Testes de hipotese
  if (df %>% normalidade_por_grupo_criterio(col_num, col_cat) == TRUE){
    niveis = df[[col_cat]] %>% as.factor() %>% levels()
    grupo1 = df[[col_num]][df[[col_cat]] == niveis[1]]
    grupo2 = df[[col_num]][df[[col_cat]] == niveis[2]]
    medidas = df %>% group_by(!!sym(col_cat)) %>% summarize(med = mean(!!sym(col_num)))
    p_value = t.test(df[[col_num]]~df[[col_cat]])$p.value %>% retorne_p() %>% retorne_p_ajust()
    subtitulo = paste(p_value, '(T-Test)')
    d_cohen = cohen.d(grupo1, grupo2)
    estimador = as.character(rround(d_cohen$estimate,2))
    IC_00 = as.character(rround(d_cohen$conf.int[1],2))
    IC_01 = as.character(rround(d_cohen$conf.int[2],2))
    d_cohen = paste0(estimador,' (',IC_00,' to ',IC_01,')')
    subtitulo = paste(subtitulo, ';', "D'Cohen =", d_cohen)
  }else{
    medidas = df %>% group_by(!!sym(col_cat)) %>% summarize(med = median(!!sym(col_num)))
    teste_hip = wilcox.test(grupo2, grupo1, conf.int = TRUE)
    p_value = teste_hip$p.value %>% retorne_p() %>% retorne_p_ajust()
    subtitulo = paste(p_value, '(Mann-Whitney)')
    estimador = as.character(rround(teste_hip$estimate,2))
    IC_00 = as.character(rround(teste_hip$conf.int[1],2))
    IC_01 = as.character(rround(teste_hip$conf.int[2],2))
    hodges_lehmann = paste0(estimador,' (',IC_00,' to ',IC_01,')')
    subtitulo = paste(subtitulo, ';', 'Hodges Lehmann =', hodges_lehmann)
  }
  
  ggplot(df, aes(x=as.factor(!!sym(col_cat)), y=!!sym(col_num), fill=as.factor(!!sym(col_cat)))) + 
    # Graficos
    geom_jitter(alpha=0.5, show.legend=F, size=2.5, position=position_jitter(0.25)) +
    geom_violin(alpha=0.2, show.legend=F, fill='white') +
    geom_boxplot(alpha=0.8, show.legend=F, width=0.5) + #outlier.shape = NA
    # Medias extras
    geom_errorbar(stat = "summary", fun.data = "mean_se", width= 0.3, color="white") + 
    geom_point(stat = "summary", fun = "mean", show.legend=F, color="red", size=2) +
    # Outros
    theme_bw() + theme(legend.position = "bottom") +
    scale_x_discrete(labels = c(rotulo_respincor,rotulo_respcor)) +
    scale_fill_manual(values=c("#DF5474","#118ab2")) +
    labs(x=NULL, y=NULL, subtitle=subtitulo, title=NULL) 
}

#ggsave("nome_grafico.png", height=10, width=10.5, units="cm", dpi= 600)

########################################################################################################################
# Grafico Dinamite por Grupos -> para representar média e desvio padrão (variavel: numerico (categorica vs categorica) )

dinamite = function(df, col_num, col_cat_y, col_cat_x){
  # Tabela com medidas
  tabela = df %>% filter(!is.na(!!sym(col_cat_y))) %>% 
    group_by(!!sym(col_cat_y), !!sym(col_cat_x)) %>%
    summarise(
      count = n(),
      min = min(!!sym(col_num), na.rm = TRUE),
      max = max(!!sym(col_num), na.rm = TRUE),
      mean = mean(!!sym(col_num), na.rm = TRUE),
      sd = sd(!!sym(col_num), na.rm = TRUE),
      median = median(!!sym(col_num), na.rm = TRUE),
      q1 = quantile(!!sym(col_num), 0.25, na.rm = TRUE),
      q3 = quantile(!!sym(col_num), 0.75, na.rm = TRUE)) %>% 
    mutate(ymin= mean - sd,
           ymax= mean + sd)
  tabela$ymin = ifelse(tabela$ymin <= 0, 0.01, tabela$ymin)
  print(tabela)
  
  ggplot(tabela, aes(x=as.factor(!!sym(col_cat_x)), y=mean, fill=as.factor(!!sym(col_cat_y)))) +
    # Grafico
    geom_bar(stat="summary", fun="mean", color='black', position=position_dodge(0.75)) +
    geom_errorbar(aes(ymin=ymin, ymax=ymax), width=0.3, position=position_dodge(0.75)) +
    # Outros
    geom_text(aes(label= round(mean,0)), position= position_dodge(0.75), vjust=-0.1, hjust=-0.1) +
    theme_bw() + theme(legend.position= "bottom") +
    labs(x=NULL, y= "Mean", title=NULL) #+ coord_flip()
}

########################################################################################################################
#Grafico de densidade (variavel: numerica vs categorica) 

densidade_grafi = function(df, col_num, col_cat){
  niveis = df[[col_cat]] %>% as.factor() %>% levels()
  grupo1 = df[[col_num]][df[[col_cat]] == niveis[1]]
  grupo2 = df[[col_num]][df[[col_cat]] == niveis[2]]
  
  if (df %>% normalidade_por_grupo_criterio(col_num, col_cat) == TRUE){
    medidas = df %>% group_by(!!sym(col_cat)) %>% summarize(med = mean(!!sym(col_num)))
    p_value = t.test(df[[col_num]]~df[[col_cat]])$p.value %>% retorne_p() %>% retorne_p_ajust()
    subtitulo = paste(p_value, '(T-Test)')
    d_cohen = cohen.d(grupo1, grupo2)
    estimador = as.character(rround(teste_t$estimate,2))
    IC_00 = as.character(rround(teste_t$conf.int[1],2))
    IC_01 = as.character(rround(teste_t$conf.int[2],2))
    d_cohen = paste0(estimador,' (',IC_00,' to ',IC_01,')')
    subtitulo = paste(subtitulo, ';', "D'Cohen =", d_cohen)
  }else{
    medidas = df %>% group_by(!!sym(col_cat)) %>% summarize(med = median(!!sym(col_num)))
    teste_hip = wilcox.test(grupo2, grupo1, conf.int = TRUE)
    p_value = teste_hip$p.value %>% retorne_p() %>% retorne_p_ajust()
    subtitulo = paste(p_value, '(Mann Whitney)')
    estimador = as.character(rround(teste_hip$estimate,2))
    IC_00 = as.character(rround(teste_hip$conf.int[1],2))
    IC_01 = as.character(rround(teste_hip$conf.int[2],2))
    hodges_lehmann = paste0(estimador,' (',IC_00,' to ',IC_01,')')
    subtitulo = paste(subtitulo, ';', 'Hodges Lehmann =', hodges_lehmann)
  }
  
  ggplot(df, aes(x=!!sym(col_num), fill=as.factor(!!sym(col_cat)))) +
    geom_density(position='identity', alpha =0.5)+
    geom_vline(data = medidas, aes(xintercept = med, color = as.factor(!!sym(col_cat))), 
               linetype="dashed", size=1, show.legend=F) +
    geom_text(data = medidas, aes(x = med, label = round(med, 2), y = 0), 
              color="black", vjust = -0.5, hjust = 1) +
    theme_bw() + theme_bw() + theme(legend.position = "bottom") +
    labs(x=NULL, y=NULL, fill=NULL, subtitle=subtitulo)
}

########################################################################################################################

#Grafico de timeline (variavel: data ou numerica vs categorica)
time_line_grafi = function(df, col_num, col_cat){
  tabela = df %>% 
    group_by(!!sym(col_num), !!sym(col_cat)) %>% 
    summarise(n = n()) %>% mutate(Freq = round(n/sum(n), 2)) %>% ungroup()
  #filter(variavel_categorica == 1) %>% ungroup()
  
  ggplot(tabela, aes(x=!!sym(col_num), n, label=n, y=n)) + 
    geom_line() + geom_point(size=2) + 
    geom_text(aes(label = n), nudge_y = 1.5) +
    theme_bw()
}



############
fore_plot = function(tabela){
  plot1 = ggplot(tabela, aes(y = variavel, x = OR)) +
    geom_point(shape = 18, size = 5, color = 'navyblue') +  
    geom_errorbarh(aes(xmin = `2.5 %`, xmax = `97.5 %`), height = 0.25) +
    geom_vline(xintercept = 1, color = "red", linetype = "dashed", cex = 1, alpha = 0.5) +
    xlab("Odds Ratio (95% CI)") + 
    ylab(" ") + 
    theme_bw() +
    theme(panel.border = element_blank(),
          panel.background = element_blank(),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          axis.line = element_line(colour = "black"),
          axis.text.y = element_text(size = 12, colour = "black"),
          axis.text.x.bottom = element_text(size = 12, colour = "black"),
          axis.title.x = element_text(size = 12, colour = "black")) + 
    scale_x_continuous(trans='log10') #+ geom_text(aes(label = pvalor))
  
  table_base <- ggplot(tabela, aes(y=variavel)) +
    ylab(NULL) + xlab("  ") + 
    theme(plot.title = element_text(hjust = 0.5, size=12), 
          axis.text.x = element_text(color="white", hjust = -3, size = 25), ## This is used to help with alignment
          axis.line = element_blank(),
          axis.text.y = element_blank(), 
          axis.ticks = element_blank(),
          axis.title.y = element_blank(), 
          legend.position = "none",
          panel.background = element_blank(), 
          panel.border = element_blank(), 
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(), 
          plot.background = element_blank())
  
  tab1 <- table_base +
    geom_text(aes(x = 1, label = pvalor), size = 4) + 
    ggtitle("P-valor")
  
  tab2 <- table_base + 
    labs(title = "space") +
    geom_text(aes(x = 1, label = OR_IC), size = 4) +
    ggtitle("OR(IC)")
  
  lay <-  matrix(c(1,1,1,1,1,1,1,1,1,1,2,3,3), nrow = 1)
  grid.arrange(plot1, tab1, tab2, layout_matrix = lay)
}

######################################################################

# Adicionar "\n" em frases muito longas
#df$coluna <- sapply(df$coluna, function(x) adicionar_quebra_de_linha(x, 40))
adicionar_quebra_de_linha <- function(frase, comprimento_maximo = 20) {
  # Verifica se frase é NA e retorna NA se for o caso
  if (is.na(frase)) {
    return(NA)
  }
  
  if (nchar(frase) > comprimento_maximo) {
    palavras = strsplit(frase, " ")[[1]]
    frase_final = ""
    linha_atual = ""
    
    for (palavra in palavras) {
      if (nchar(paste(linha_atual, palavra, sep = " ")) <= comprimento_maximo) {
        linha_atual = paste(linha_atual, palavra, sep = " ")
      } else {
        frase_final = paste(frase_final, linha_atual, "\n", sep = "")
        linha_atual = palavra
      }
    }
    frase_final = paste(frase_final, linha_atual, sep = "")
    return(frase_final)
  } else {
    return(frase)
  }
}
#teste
frase_longa = "Esta é uma frase muito longa que deve ser quebrada em várias linhas para melhor visualização."
adicionar_quebra_de_linha(frase_longa,50)

############################################################################################################################################
# BIBLIOTECAS NÃO USADAS

#library(RcmdrMisc) #summary diferenciado ==> numSummary()
# #bibliotecas para extrair descrições das variaveis
# library(purrr)
# library(lmtest)
# 
# library(cowplot) #graficos lado a lado ==> plot_grid(graf1, graf2, graf3, graf4, ncol=2, nrow=2)
# library(MatchIt) #propensity score matchit
# 
# #forestplot
# library(sjPlot)
# library(sjlabelled)
# library(sjmisc)
# # ==> plot_model(modelo, show.values = TRUE, value.offset = .3)
# 
# library(epiR) #analise epidemiológica
# library(car) #"An R Companion to Applied Regression"
# library(rstatix) #pacote com testes de hipotese inutil
# library(emmeans) #pós-analise de modelos lineares e lineares generalizados
# library(exact2x2) # qui-quadrado pareado #ajuste para variaveis pequena
# library(vcd) #coefientes de tamanho de efeito para cruzamento categorico (CRAMER, PHI, COEF CONTI)
# library(effsize) #tamanho de efeito
# ###########
# library(DescTools) #==> PseudoR2(mod, which='Nagelkerke')
# library(QuantPsyc) #ClassLog
# library(rcompanion) # ==> compareGLM(mod3, mod4)
# library(pROC) #curva roc ==> roc()
# library(caret) #avaliação de ml (matrix confusão) ==> confusionMatrix()
# library(forestmodel) #grafico forestplot
# library(psych) # matrix de correlação==> pairs.panels(matrix)
# library(corrplot) #matriz/graficos de correlação
# 
# library(ggradar) #grafico de radar
# library(fmsb) #grafico de radar
# library(gridExtra)
# 
# library(nnet) #treinar modelos; multinom
# 
# #################ANTIGO ABANDONADOS#######################
# library(tableone) #criação de tabelas
                    