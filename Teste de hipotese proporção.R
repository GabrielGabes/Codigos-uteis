################################################################
binom.test (Y, n, p0, alternarive= c(“greater”, “less”, “two-sided”), conf.level)
################################################################

################################################################
binom.test(15, 100, p = 0.20, alternative = c("less")) #distribuição binomial
prop.test(15, 100, p = 0.20, alternative="less", correct="TRUE") #distrubuição qui-quadrado
prop.test(15, 100, p = 0.20, alternative="less", correct="FALSE") #distribuição normal

#manualmente - teste z - distribuição normal
x = 15
n = 100
p = 0.2
z = ((x/n)-p)/((p*(1-p))/n)^0.5
p_valor = pnorm(z)
print(paste('z:', z, '; p-valor:', p_valor))

prop.test(1630*0.2, 1630, p = 0.2, alternative="greater", correct="FALSE")
################################################################
################################################################
for (i in 1:322){
  teste = prop.test(i, 775, p = 0.20, alternative="greater", correct="FALSE")
  p_valor = teste$p.value 
  proporção = round(teste$estimate, 2)
  if (p_valor <= 0.06 && p_valor > 0.001){
    IC = paste0('[', round(teste$conf.int[1], 5), ' - 1]')
    print(paste('n:', i, '; p-valor:',round(p_valor,3), '; prob:',proporção, '; IC:',IC))
  }
  if (p_valor <= 0.06 && p_valor < 0.001 && p_valor != 0 && i%%20 == 0){
    IC = paste0('[', round(teste$conf.int[1], 2), ' - 1]')
    print(paste('n:', i, '; p-valor:','<0.001', '; prob:',proporção, '; IC:',IC))
  }
}
################################################################

################################################################
teste_z_1_amostra = function(x, n, p){
  z = ((x/n)-p)/((p*(1-p))/n)^0.5
  p_valor = pnorm(z)
  print(paste('z:', round(z, 2)))
  print(paste('p_valor:',round(p_valor, 4)))
}

teste_z_1_amostra(15, 100, 0.20)
teste_z_1_amostra(20, 300, 0.10)

prop.test(380, 621, p = 0.30, alternative="greater", correct="FALSE")

prop.test(330, 506, p = 0.30, alternative="greater", correct="FALSE")
################################################################

################################################################
(1.96)^2 * 0.20 * (1-0.20) / (0.05)^2

(qnorm(0.975)^2 * 0.3 * 0.7) / (0.05)^2
################################################################


################################################################
N <- 775
p <- 0.2
q <- 1-p
nivel_confianca <- 0.95
conf.width <- 0.05

Z <- qnorm((1 + nivel_confianca)/2)
E <- conf.width

(N*p*q*Z^2)/(p*q*Z^2+(N-1)*E^2)

################################################################

