#capturar tabela
capture = function(tabela){
  tabela %>% print() %>% write_clip(dec = ",", col.names = TRUE)
}

######################################################################

#função tabela contagem univariada
cont = function(var1){
  df %>% tabyl(.data[[var1]], show_na = FALSE) %>% adorn_pct_formatting() %>% 
    capture()
}

#função tabela contingencia
conti = function(var2, var1, sentido_porcentagem){
  df %>% tabyl(.data[[var1]], .data[[var2]], show_na = FALSE) %>% 
    adorn_totals(c("row", "col")) %>% adorn_percentages(sentido_porcentagem) %>% 
    adorn_pct_formatting(2) %>% adorn_ns %>% 
    capture()
  #sentido_porcentagem #col, row
}

######################################################################

#capturar p-valor
retorne_p = function(valor){
  if (valor < 0.05){
    if (valor < 0.001){"< 0.001"}
    else {as.numeric(substring(as.character(valor), 1,4))}}
  else{
    if (valor < 0.06){as.numeric(substring(as.character(valor), 1,5))}
    else{as.numeric(substring(as.character(valor), 1,4))
    }}}
#teste
retorne_p(0.054)
retorne_p(0.045)

######################################################################


########### FUNÇÕES GRAFICOS
teste_normalidade = function(dados, coluna){ ##grafico normalidade
  if(coluna>ncol(dados)){
    stop("numero da coluna informada maior que o numero de coluna do dataframe")
  }
  dados = as.data.frame(dados)
  var = dados[[coluna]]
  var.df = dados[coluna]
  
  shapiro = shapiro.test(var)
  p_valor.shapiro = format.pval(pv = shapiro$p.value, digits = 3, eps=0.001, nsmall=3)
  estatis.shapiro = round(shapiro$statistic,2)
  media = mean(var, na.rm=T)
  desvpad = sd(var, na.rm=T)
  
  ggplot(var.df, aes_string(x=names(var.df)))+
    geom_histogram(aes(y=..density..), bins=20, fill='#40BCD8', colour = "black") +
    #geom_function(fun=dnorm,args=list(mean=media,sd=desvpad),col='black',lwd=1.,lty=4) +
    geom_density(lwd = 1.2, linetype = 2, colour = "blue") +
    labs(y='Probability Density',subtitle=paste0("P-value(Shapiro-wilk) = ",p_valor.shapiro)) + #'Shapiro-Wilk = ',estatis.shapiro,
    theme_bw() + 
    theme(plot.title=element_text(face='italic'), plot.subtitle = element_text(size = 15), axis.title=element_text(size=9, face='italic'))
}# teste_normalidade(df, 35)

barras_dupla = function(base, COLUNA, COLUNA2){ ##graficos barras|*2
  base %>% group_by(.data[[COLUNA2]], .data[[COLUNA]]) %>% 
    summarise(n = n()) %>% 
    mutate(freq = round(n/sum(n)*100, 2)) %>% 
    ungroup() %>% 
    ggplot(aes(as.factor(.data[[COLUNA]]), freq, label=freq, fill=as.factor(.data[[COLUNA]]))) +
    geom_col(show.legend = FALSE, color="black") +
    geom_text(aes(y=freq), vjust=-0.1) +
    theme_grey(base_size = 10) + 
    facet_grid(. ~.data[[COLUNA2]]) +
    theme_minimal() + theme(plot.title=element_text(face='italic'), axis.title=element_text(size=9, face='italic')) +
    labs(y="Taxa Porcental(%)") + 
    scale_fill_manual(values=c("#0096C7","#023E8A")) + 
    scale_y_continuous(limits = c(0, 100), breaks=seq(from = 0, to = 100, by = 25))
}# barras_dupla(dff, "categorico0", "categorico2") + labs(title= "titulo", subtitle = "subtitulo", x= "titulo x") 

densidade = function(base, coluna1, coluna2){ ##graficos densidades duplas
  medias = base %>% group_by(.data[[coluna2]]) %>% summarize(med = mean(.data[[coluna1]]))
  
  ggplot(base, aes(x=.data[[coluna1]], fill=as.factor(.data[[coluna2]])))+
    geom_density(position='identity', alpha =0.6)+
    labs(y='Probability Density', fill="nome da divisão", 
         subtitle=paste0("P-value(teste t) = ",
                         format.pval(pv= t.test(base[[coluna1]]~base[[coluna2]], base, var.equal=TRUE)$p.value, 
                                     digits= 3, eps=0.001, nsmall=3))) +
    theme_classic() + 
    theme(plot.title=element_text(face='italic'), axis.title=element_text(size=9, face='italic')) +
    geom_vline(data = medias, aes(xintercept = med, color = as.factor(.data[[coluna2]])), 
               linetype="dashed", size=1, color=c("#40BCD8","#1978B3")) +
    scale_fill_discrete(labels = c("No residue", "With residue")) + 
    scale_fill_manual(values=c("#40BCD8","#1978B3")) 
}# densidade(dff, "numerico", "categorico") + ggtitle("titulo") + scale_x_continuous(breaks=seq(from = inicio, to = fim, by = pula)) + xlab("titulo eixo x")

caixa = function(base, COLUNA1, COLUNA2){ #grafico boxplot
  ggplot(base, aes(x=as.factor(x=.data[[COLUNA2]]), y=.data[[COLUNA1]], fill=as.factor(.data[[COLUNA2]]))) + 
    geom_boxplot(show.legend = FALSE) + 
    geom_jitter(alpha=0.5, show.legend = FALSE, size=2, position=position_jitter(0.25), color="#141514") +
    geom_errorbar(stat = "summary", fun.data = "mean_se", width= 0.3, color="white") + 
    geom_point(stat = "summary", fun = "mean", show.legend = FALSE, color="red", size=2) + 
    theme(plot.title=element_text(face='italic'), axis.title=element_text(size=9, face='italic'),
          legend.position = "bottom") + 
    theme_minimal() + 
    theme(axis.line = element_line(colour = "black"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          panel.background = element_blank())
}# caixa(df, "numerica", "categorica") + labs(y='numerica', x="categorica") + scale_fill_manual(values=c("#40BCD8","#1978B3")) + scale_x_discrete(labels = c("categorico 0 ","categorico 1")) + scale_y_continuous(breaks=seq(from = inicio, to = fim, by = pula))

vioplot = function(base, categorica, numerico){ # grafico violino + boxpot
  ggplot(df, aes(y=as.factor(categorica), x=numerico, fill=as.factor(categorica))) + 
    geom_boxplot(show.legend = FALSE) + geom_violin(alpha=0.2, show.legend = FALSE) +
    geom_point(stat = "summary", fun = "mean", show.legend = FALSE) + 
    geom_errorbar(stat = "summary", fun.data = "mean_se", width= 0.3) +
    theme(plot.title=element_text(face='italic'), axis.title=element_text(size=9, face='italic'), 
          legend.position = "bottom") +
    labs(subtitle=paste0("P-value(teste t) = ", 
                         format.pval(pv= t.test(base[[numerico]]~as.factor(base[[categorica]]), base, var.equal=TRUE)$p.value, 
                                     digits= 3, eps=0.001, nsmall=3))) + 
    scale_x_continuous(breaks=seq(from = 15, to = 90, by = 5)) +
    scale_fill_manual(values=c("#40BCD8","#023E8A")) + 
    scale_y_discrete(labels = c("Uso", "Sem uso"))
}# vioplot(base, 'categorica', 'numerico') + labs(title="", x='', y="Desfecho", fill = "Pontos de QSOFA:",)


###########
#função que captura medidas de modelo logistico
analise_mod = function(modelo){
  estimadores = as.data.frame(summary(modelo)$coefficients)
  odds = as.data.frame((exp(cbind(OR= coef(modelo), confint(modelo)))))
  estimadores = round(estimadores, 4)
  odds = round(odds, 4)
  
  cbind(estimadores, odds) %>% print() %>% write_clip(dec = ".", col.names = TRUE)
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

densi_dupla = function(coluna_categorica, coluna_numerica){
  pressuposto_norm = byf.shapiro(df[[coluna_numerica]]~df[[coluna_categorica]], df)[["tab"]][["p-value"]]
  pressuposto_norm2 = var.test(df[[coluna_numerica]]~df[[coluna_categorica]])$p.value #homogenedade 
  if(pressuposto_norm[1] > 0.001 & pressuposto_norm[2] > 0.001 & pressuposto_norm2 > 0.001){
    p_valor = paste0("P-value(Teste T): ", format.pval(pv= t.test(df[[coluna_numerica]]~df[[coluna_categorica]], var.equal=TRUE)$p.value, 
                                                       digits= 3, eps=0.001, nsmall=3))
  }else{
    p_valor = paste0("P-value(Mann Whitney):", format.pval(pv= wilcox.test(df[[coluna_numerica]]~df[[coluna_categorica]])$p.value,
                                                           digits= 3, eps=0.001, nsmall=3))
  }
  ggplot(df, aes(x=df[[coluna_numerica]], fill=as.factor(df[[coluna_categorica]]))) + 
    geom_density(position='identity', alpha =0.6) + labs(title=coluna_categorica,
                                                         subtitle= p_valor) +
    theme(legend.position = 'none') + xlab(coluna_numerica)}


regressão_uni_p_factor_odds = function(coluna){
  mod = glm(hipo~as.factor(df[[coluna]]), family=binomial(link='logit'), data=df)
  exp(cbind(OR= coef(mod), confint(mod))) %>% 
    print() %>% write_clip(dec = ".", col.names = FALSE)
} #regressão_uni_p_factor_odds('id')


#Regressão logistica
p_logistico = function(coluna){
  tab = summary(glm(Residuo_gastrico~df_obeso[[coluna]], family=binomial(link='logit'), data=df_obeso))
  tab = as.data.frame(tab$coefficients)
  tab$`Pr(>|z|)`[2]
}

#capture_p(p_logistico("Idade"))

#verificar dados ausentes #gg_miss_var(df, show_pct = TRUE)


# Função para adicionar "\n" em frases muito longas
adicionar_quebra_de_linha <- function(frase, comprimento_maximo = 40) {
  if (nchar(frase) > comprimento_maximo) {
    palavras <- strsplit(frase, " ")[[1]]
    frase_final <- ""
    linha_atual <- ""
    
    for (palavra in palavras) {
      if (nchar(paste(linha_atual, palavra, sep = " ")) <= comprimento_maximo) {
        linha_atual <- paste(linha_atual, palavra, sep = " ")
      } else {
        frase_final <- paste(frase_final, linha_atual, "\n", sep = "")
        linha_atual <- palavra
      }
    }
    frase_final <- paste(frase_final, linha_atual, sep = "")
    return(frase_final)
  } else {
    return(frase)
  }
}

adicionar_quebra_de_linha2 <- function(frase, comprimento_maximo = 70) {
  if (nchar(frase) > comprimento_maximo) {
    palavras <- strsplit(frase, " ")[[1]]
    frase_final <- ""
    linha_atual <- ""
    
    for (palavra in palavras) {
      if (nchar(paste(linha_atual, palavra, sep = " ")) <= comprimento_maximo) {
        linha_atual <- paste(linha_atual, palavra, sep = " ")
      } else {
        frase_final <- paste(frase_final, linha_atual, "\n", sep = "")
        linha_atual <- palavra
      }
    }
    frase_final <- paste(frase_final, linha_atual, sep = "")
    return(frase_final)
  } else {
    return(frase)
  }
}

# Exemplo de uso da função
frase_longa <- "Esta é uma frase muito longa que deve ser quebrada em várias linhas para melhor visualização."
frase_curta <- "Essa é uma frase curta."
frase_quebrada_longa <- adicionar_quebra_de_linha(frase_longa)
frase_quebrada_curta <- adicionar_quebra_de_linha(frase_curta)
cat(frase_quebrada_longa)
cat("\n\n")
cat(frase_quebrada_curta)

####################################

