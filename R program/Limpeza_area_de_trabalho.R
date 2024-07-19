# Limpe seu ambiente de espaço de trabalho 
rm(list = ls())

#Limpar a guia Gráficos 
if(!is.null(dev.list())) dev.off()

#Limpar o console: Ctrl+L
cat("\014")
