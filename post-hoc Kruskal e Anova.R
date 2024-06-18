# TESTE DE DUNNET ##=============##=============##=============##=============
library(multcomp)

teste = aov(Platô_A~Grupo, data=df)
valor_p = summary(teste)[[1]][["Pr(>F)"]][1] %>% retorne_p() %>% retorne_p_ajust()

dunnett_test = glht(teste, linfct = mcp(Grupo = "Dunnett"))
pos_teste = summary(dunnett_test)
tabela = pos_teste$test[["pvalues"]]
p_ab = tabela[1] %>% retorne_p()
p_ac = tabela[2] %>% retorne_p()

# TESTE DE DUNN ##=============##=============##=============##=============
library(dunn.test)

teste = kruskal.test(df$Platô_A~df$Grupo)

pos_teste = dunn.test(df$Platô_A, df$Grupo, method="bonferroni")
tabela = pos_teste$P.adjusted
p_ab = tabela[1] %>% retorne_p()
p_bc = tabela[3] %>% retorne_p()
p_ac = tabela[2] %>% retorne_p()

# TESTE DE BONFERRONI ##=============##=============##=============##=============
#qualquer teste
tabela = pairwise.t.test(df$Platô_A, df$Grupo, p.adjust.method = "bonferroni")
p_ab = tabela$p.value[1] %>% retorne_p()
p_bc = tabela$p.value[4] %>% retorne_p()
p_ac = tabela$p.value[2] %>% retorne_p()

# TESTE DE TUKEY ##=============##=============##=============##=============
teste = aov(Platô_A~Grupo, data=df)
tabela = TukeyHSD(teste)
print(tabela)
p_ab = tabela$Grupo[10] %>% retorne_p()
p_ac = tabela$Grupo[11] %>% retorne_p()
p_bc = tabela$Grupo[12] %>% retorne_p()

valores_p_pos_teste = data.frame(A_B = p_ab, A_C = p_ac, B_C = p_bc)
valores_p_pos_teste

############################################################################################################

l_y = 33
#traços
y_altura_ab = 29
y_altura_bc = 30
y_altura_ac = 32
summary(df$Platô_A)
texto_altura_ab = y_altura_ab + 1
texto_altura_bc = y_altura_bc + 1
texto_altura_ac = y_altura_ac + 1

subtitulo = paste(valor_p, '(Anova)')

ggplot(df, aes(x=as.factor(x=Grupo), y=Platô_A, fill=as.factor(Grupo))) + 
  geom_jitter(alpha=0.5, show.legend = F, size=2.5, position=position_jitter(0.25)) +
  geom_violin(alpha=0.2, show.legend = F, fill='white') +
  geom_boxplot(alpha=0.8, show.legend = F, width=0.5) + 
  geom_errorbar(stat = "summary", fun.data = "mean_se", width= 0.3, color="white") +
  geom_point(stat = "summary", fun = "mean", show.legend = F, color="red", size=2) +
  labs(x="Groups", y='Var', subtitle=subtitulo) + 
  theme(legend.position = "bottom") + theme_bw() +
  scale_y_continuous(limits = c(10, 33), breaks=seq(from = 10, to = 100, by = 2)) +
  # COMPARAÇÃO A e B
  geom_segment(aes(x='A',xend ='B', y=y_altura_ab, yend=y_altura_ab), color = "black") +
  geom_segment(aes(x='A',xend ='A', y=y_altura_ab, yend=y_altura_ab-.5), color = "black") +
  geom_segment(aes(x='B',xend ='B', y=y_altura_ab, yend=y_altura_ab-.5), color = "black") +
  annotate("text", x=1.5, y=texto_altura_ab, label=p_ab, vjust = 0.7, size = 4, color = "black") +
  # COMPARAÇÃO B e C
  geom_segment(aes(x='B',xend ='C', y=y_altura_bc, yend=y_altura_bc), color = "black") +
  geom_segment(aes(x='B',xend ='B', y=y_altura_bc, yend=y_altura_bc-.5), color = "black") +
  geom_segment(aes(x='C',xend ='C', y=y_altura_bc, yend=y_altura_bc-.5), color = "black") +
  annotate("text", x=2.5, y=texto_altura_bc, label=p_bc, vjust = 0.7, size = 4, color = "black") +
  # COMPARAÇÃO A e C
  geom_segment(aes(x='A',xend ='C', y=y_altura_ac, yend=y_altura_ac), color = "black") +
  geom_segment(aes(x='A',xend ='A', y=y_altura_ac, yend=y_altura_ac-.5), color = "black") +
  geom_segment(aes(x='C',xend ='C', y=y_altura_ac, yend=y_altura_ac-.5), color = "black") + 
  annotate("text", x=2, y=texto_altura_ac, label=p_ac, vjust = 0.7, size = 4, color = "black")

#ggsave("SAULOO.png", height=15, width=15, units="cm", dpi= 600)
########################################

y <- matrix(c(
  3.88, 5.64, 5.76, 4.25, 5.91, 4.33, 30.58, 30.14, 16.92,
  23.19, 26.74, 10.91, 25.24, 33.52, 25.45, 18.85, 20.45,
  26.67, 4.44, 7.94, 4.04, 4.4, 4.23, 4.36, 29.41, 30.72,
  32.92, 28.23, 23.35, 12, 38.87, 33.12, 39.15, 28.06, 38.23, 26.65),nrow=6, ncol=6,
dimnames=list(1:6, LETTERS[1:6]))


frdAllPairsNemenyiTest(y)
friedmanTest(y)
