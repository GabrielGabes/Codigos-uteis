########################################################################################################################
# Grafico de Barras -> para representar uma tabela de contagem simples (categorica)

coluna = ''

# Criando tabela de contagem
tabela = df %>% filter(!is.na(!!sym(coluna_x))) %>% 
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

ggsave("nome_grafico.png", height=15, width=20, units="cm", dpi= 600)

########################################################################################################################
# Grafico de Barras -> para representar uma tabela de contingencia (categorica vs categorica)

coluna_x = ''
coluna_y = ''

# Teste de hipotese
p_value = chisq.test(df[[coluna_y]], df[[coluna_x]])$p.value %>% retorne_p() %>% retorne_p_ajust()
subtitulo = paste(p_value, '(Chisq-Squared test)')

# Criando tabela de contagem
grafi = df %>% filter(!is.na(!!sym(coluna_x)) & !is.na(!!sym(coluna_y))) %>% 
  group_by(!!sym(coluna_y), !!sym(coluna_x)) %>% 
  summarise(n = n()) %>% mutate(Freq = round(n/sum(n)*100, 2)) %>% ungroup()

ggplot(grafi, aes(x=as.factor(!!sym(coluna_x)), y=Freq, fill=as.factor(!!sym(coluna_y)))) + 
  # Grafico
  geom_bar(stat="identity", position=position_dodge(), color='black') +
  # Outros
  geom_text(aes(y=Freq + 3, label = sprintf("%0.1f%%", Freq)), position=position_dodge(0.75), vjust=0) +
  theme_bw() + theme(legend.position = "bottom") +
  scale_y_continuous(limits = c(0, 100), breaks=seq(from=0, to=100, by=20)) +
  labs(x=NULL, y='Frequency (%)', subtitle=subtitulo, title=NULL, fill=NULL) +
  scale_x_discrete(labels = c("Não","Sim")) +
  scale_fill_manual(values=c("#DF5474","#118ab2"))

############################################################

ggplot(grafi, aes(x=as.factor(!!sym(coluna_y)), y=Freq, fill=as.factor(!!sym(coluna_x)))) + 
  # Grafico
  geom_bar(stat="identity", position=position_dodge(), color='black') +
  # Outros
  geom_text(aes(y=Freq + 3, label = sprintf("%0.1f%%", Freq)), position=position_dodge(0.75), vjust=0) +
  theme_bw() + theme(legend.position = "bottom") +
  scale_y_continuous(labels = scales::percent) +
  scale_y_continuous(limits = c(0, 100), breaks=seq(from=0, to=100, by=20)) +
  labs(x=NULL, y='Frequency (%)', subtitle=subtitulo, title=NULL, fill=NULL) 

ggsave("nome_grafico.png", height=15, width=20, units="cm", dpi= 600)

########################################################################################################################
# Graficos (Boxplot, Violino, Jitter) por Grupos -> para representar analise númerica por grupo (variavel: numerica vs categorica)

# Contagens adicionais
coluna_cat = ''
coluna_num = ''
!!sym(coluna_num)
!!sym(coluna_cat)
tabela = cont(df, coluna_analisada)
rotulo_respcor = paste0('rotulo_direito', '\n', tabela$percent[1], ' (', tabela$n[1], ')')
rotulo_respincor = paste0('rotulo_esquerdo', '\n', tabela$percent[2], ' (', tabela$n[2], ')')

# Testes de hipotese
p_value = wilcox.test(df[[coluna_num]]~df[[coluna_cat]])$p.value %>% retorne_p() %>% retorne_p_ajust()
subtitulo = paste0("P-value (Mann-Whitney) = ", p_value)

p_value = t.test(df[[coluna_num]]~df[[coluna_cat]])$p.value %>% retorne_p() %>% retorne_p_ajust()
subtitulo = paste0(subtitulo, " | (T-Test) = ", p_value)

ggplot(df, aes(x=as.factor(!!sym(coluna_cat)), y=!!sym(coluna_num), fill=as.factor(!!sym(coluna_cat)))) + 
  # Graficos
  geom_jitter(alpha=0.5, show.legend=F, size=2.5, position=position_jitter(0.25)) +
  geom_violin(alpha=0.2, show.legend=F, fill='white') +
  geom_boxplot(alpha=0.8, show.legend=F, width=0.5) + #outlier.shape = NA
  # Medias extras
  geom_errorbar(stat = "summary", fun.data = "mean_se", width= 0.3, color="white") + #desvio padrão 
  geom_point(stat = "summary", fun = "mean", show.legend=F, color="red", size=2) +#média
  # Outros
  theme_bw() + theme(legend.position = "bottom") +
  scale_y_continuous(limits = c(0, 100), breaks=seq(from = 0, to = 100, by = 25)) +
  scale_x_discrete(labels = c(rotulo_respincor,rotulo_respcor)) +
  scale_fill_manual(values=c("#DF5474","#118ab2")) +
  labs(x=NULL, y=NULL, subtitle=subtitulo, title=NULL) 

ggsave("nome_grafico.png", height=10, width=10.5, units="cm", dpi= 600)

########################################################################################################################
# Grafico Dinamite por Grupos -> para representar média e desvio padrão (variavel: numerico (categorica vs categorica) )

coluna_num = ''
coluna_cat_y = ''
coluna_cat_x = ''

# Tabela com medidas
tabela = df %>% filter(!is.na(!!sym(coluna_cat_y))) %>% 
  group_by(!!sym(coluna_cat_y), !!sym(coluna_cat_x)) %>%
  summarise(
    count = n(),
    min = min(!!sym(coluna_num), na.rm = TRUE),
    max = max(!!sym(coluna_num), na.rm = TRUE),
    mean = mean(!!sym(coluna_num), na.rm = TRUE),
    sd = sd(!!sym(coluna_num), na.rm = TRUE),
    median = median(!!sym(coluna_num), na.rm = TRUE),
    q1 = quantile(!!sym(coluna_num), 0.25, na.rm = TRUE),
    q3 = quantile(!!sym(coluna_num), 0.75, na.rm = TRUE)) %>% 
  mutate(ymin= mean - sd,
         ymax= mean + sd)
tabela$ymin = ifelse(tabela$ymin <= 0, 0.01, tabela$ymin)
print(tabela)

ggplot(tabela, aes(x=as.factor(!!sym(coluna_cat_x)), y=mean, fill=as.factor(!!sym(coluna_cat_y)))) +
  # Grafico
  geom_bar(stat="summary", fun="mean", color='black', position=position_dodge(0.75)) +
  geom_errorbar(aes(ymin=ymin, ymax=ymax), width=0.3, position=position_dodge(0.75)) +
  # Outros
  geom_text(aes(label= round(mean,0)), position= position_dodge(0.75), vjust=-0.1, hjust=-0.1) +
  theme_bw() + theme(legend.position= "none") +
  labs(x=NULL, y= "Mean", title=NULL) #+ coord_flip()



#Grafico de densidade (variavel: numerica vs categorica) =================================================================================
medias = df %>% group_by(variavel_categorica) %>% summarize(med = mean(variavel_numerica))
medianas = df %>% group_by(variavel_categorica) %>% summarize(med = median(variavel_numerica))

ggplot(df, aes(x=variavel_numerica, fill=as.factor(variavel_categorica))) +
  geom_density(position='identity', alpha =0.5)+
  labs(y='Probability Density', fill="Categorias:", 
       subtitle=paste0("P-value: (teste t) = ", retorne_p(t.test(variavel_numerica~variavel_categorica, df, var.equal=TRUE)$p.value),
                       "; (Mann Whitney) = ", retorne_p(wilcox.test(variavel_numerica~variavel_categorica, df)$p.value))) +
  theme_bw() + 
  theme(plot.title=element_text(face='italic'), axis.title=element_text(size=9, face='italic')) +
  #geom_vline(data = medias, aes(xintercept = med, color = as.factor(variavel_categorica)), 
  #    linetype="dashed", size=1) + #color=c("#40BCD8","#1978B3")
  geom_vline(data = medianas, aes(xintercept = med, color = as.factor(variavel_categorica)), 
             linetype="dashed", size=1) +
  scale_fill_discrete(labels = c("Não", "Sim")) + 
  scale_x_continuous(breaks=seq(from = min(df$variavel_numerica), 
                                to = max(df$variavel_numerica), 
                                by = (max(df$variavel_numerica) - min(df$variavel_numerica))/5))
#scale_fill_manual(values=c("#40BCD8","#1978B3")) 

#Grafico de timeline (variavel: data ou numerica vs categorica)
tabela = df %>% 
  group_by(variavel_data, variavel_categorica) %>% 
  summarise(n = n()) %>% mutate(Freq = round(n/sum(n), 2)) %>% 
  filter(variavel_categorica == 1) %>% ungroup()

ggplot(tabela, aes(x=variavel_data, n, label=n, y=n)) + geom_line() + geom_point(size=2) + theme_bw() +
  geom_text(aes(label = n), nudge_y = 1.5)



#ggsave("Diferenca_tempo_de_uso.png", height=10, width=20, units="cm", dpi= 600)