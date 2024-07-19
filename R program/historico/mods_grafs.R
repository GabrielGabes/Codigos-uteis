#Grafico de barra (variavel: categorica vs categorica) ====================================================================================
grafi = df %>% 
  group_by(variavel_resposta, variavel_entrada) %>% 
  summarise(n = n()) %>% mutate(Freq = round(n/sum(n), 2)) %>% ungroup()
grafi
grafi$variavel_entrada = ifelse(grafi$variavel_entrada == 1, "Sim", "Não")
grafi$variavel_resposta = ifelse(grafi$variavel_resposta == 1, "Sim", "Não")

ggplot(grafi, aes(as.factor(variavel_entrada), Freq, label=Freq, fill=as.factor(variavel_entrada))) + 
  geom_col(show.legend = FALSE, color="black") + facet_grid(~variavel_resposta) +
  geom_text(aes(y=Freq, label = scales::percent(Freq), vjust=-0.1)) + scale_y_continuous(labels = scales::percent) +
  theme_bw() + theme(plot.title=element_text(face='italic'), axis.title=element_text(size=9, face='italic')) +
  scale_y_continuous(limits = c(0, 1), breaks=seq(from = 0, to = 1, by = 0.25)) +
  labs(x="variavel_entrada",
       subtitle = paste0("P-Valor (Qui-Quadrado) = ", retorne_p(chisq.test(df$variavel_resposta, df$variavel_entrada)$p.value))) +
  #scale_fill_manual(values=c("#0096C7","#023E8A")) #cores

#Grafico de boxplot (variavel: numerica vs categorica) ===================================================================================
ggplot(df, aes(x=as.factor(x=variavel_categorica), y=variavel_numerica, fill=as.factor(variavel_categorica))) + 
    geom_jitter(alpha=0.5, show.legend = F, size=2.5, position=position_jitter(0.25)) +
    geom_boxplot(alpha=0.9, show.legend = F) + 
    geom_errorbar(stat = "summary", fun.data = "mean_se", width= 0.3, color="white") + #desvio padrão 
    geom_point(stat = "summary", fun = "mean", show.legend = F, color="white", size=2) +#média
    labs(y='variavel_numerica', x="variavel_categorica") + 
    theme(plot.title=element_text(face='italic'), axis.title=element_text(size=9, face='italic'), 
          legend.position = "bottom",axis.line = element_line(colour = "black")) +
    theme_bw() +
    scale_x_discrete(labels = c("Não","Sim")) + 
    scale_y_continuous(breaks=seq(from = min(df$variavel_numerica), 
                                  to = max(df$variavel_numerica), 
                                  by = (max(df$variavel_numerica) - min(df$variavel_numerica))/5))
    #scale_fill_manual(values=c("#40BCD8","#1978B3")) #cores

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