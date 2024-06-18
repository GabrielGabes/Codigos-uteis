https://chat.openai.com/c/fbb1b4e2-f18a-4e98-9282-f09fc0bd2f7f

print('============== Teste de qui-quadrado ==============')
teste_qui_quadrado = chisq.test(df$idade_10em10, df$q12_01)
print(teste_qui_quadrado)

#######################################################################################################
											ANALISE DE RESIDUOS
#######################################################################################################

# Valores observados
print('============== Valores observados ==============')
valores_observados = teste_qui_quadrado$observed
print(valores_observados)

# Valores esperados
print('============== Valores esperados ==============')
valores_esperados = teste_qui_quadrado$expected
print(valores_esperados)

# Resíduos
print(' ============== Resíduos ==============')
residuos = teste_qui_quadrado$residuals
print(residuos)

# Resíduos padronizados
print('============== Resíduos padronizados ==============')
residuos_padronizados = teste_qui_quadrado$stdres
print(residuos_padronizados)


#######################################################################################################
								Multiple Comparisons using multcomp in R
#######################################################################################################

# Carregar o pacote necessário
if (!requireNamespace("multcomp", quietly = TRUE)) install.packages("multcomp")
library(multcomp)

# Transformar Resultado em fator binário
dados_brutos$Resultado_bin = as.numeric(dados_brutos$Resultado == "Positivo")

# Ajustar um modelo linear generalizado
glm_model <- glm(Resultado_bin ~ Grupo, family = binomial, data = dados_brutos)

# Realizar comparações múltiplas
comp <- glht(glm_model, linfct = mcp(Grupo = "Tukey"))

# Sumarizar os resultados das comparações múltiplas
summary(comp)

# Ajustar para múltiplas comparações
confint(comp)

```

#######################################################################################################
							pairwise Nominal Independence with rcompanion
#######################################################################################################

if (!requireNamespace("rcompanion", quietly = TRUE)) install.packages("rcompanion")
library(rcompanion)

tabela = table(dados_brutos$Grupo, dados_brutos$Resultado)

resultados = pairwiseNominalIndependence(tabela,
                            fisher = FALSE,
                            gtest  = FALSE,
                            chisq  = TRUE,
                            method = "holm")

resultados = apply_retorne_p(resultados, "p.Chisq")
resultados = apply_retorne_p(resultados, "p.adj.Chisq")
resultados

#######################################################################################################
									pairwise.prop.test in R
#######################################################################################################

tabela = table(dados_brutos$Grupo, dados_brutos$Resultado)

pairwise.prop.test(tabela)

#######################################################################################################
								Anova
#######################################################################################################

resultados = aov(formula = as.numeric(df[[coluna]])~df$Grupo, data = df) 
resultados %>% summary()
resultados %>% TukeyHSD()