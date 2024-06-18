#==============================================================================
#  D'Cohen

niveis = df[[col_cat]] %>% as.factor() %>% levels()
medidas = df %>% group_by(!!sym(col_cat)) %>% summarize(med = mean(!!sym(col_num)))
p_value = t.test(df[[col_num]]~df[[col_cat]])$p.value %>% retorne_p() %>% retorne_p_ajust()
subtitulo = paste(p_value, '(T-Test)')
d_cohen = cohen.d(grupo1, grupo2)
estimador = as.character(rround(d_cohen$estimate,2))
IC_00 = as.character(rround(d_cohen$conf.int[1],2))
IC_01 = as.character(rround(d_cohen$conf.int[2],2))
d_cohen = paste0(estimador,' (',IC_00,' to ',IC_01,')')
subtitulo = paste(subtitulo, ';', "D'Cohen =", d_cohen)


#==============================================================================
#  HODGES LEHMANN

medidas = df %>% group_by(!!sym(col_cat)) %>% summarize(med = median(!!sym(col_num)))
teste_hip = wilcox.test(grupo2, grupo1, conf.int = TRUE)
p_value = teste_hip$p.value %>% retorne_p() %>% retorne_p_ajust()
subtitulo = paste(p_value, '(Mann-Whitney)')
estimador = as.character(rround(teste_hip$estimate,2))
IC_00 = as.character(rround(teste_hip$conf.int[1],2))
IC_01 = as.character(rround(teste_hip$conf.int[2],2))
hodges_lehmann = paste0(estimador,' (',IC_00,' to ',IC_01,')')
subtitulo = paste(subtitulo, ';', 'Hodges Lehmann =', hodges_lehmann)