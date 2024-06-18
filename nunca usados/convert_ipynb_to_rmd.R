library(rmarkdown)
library(knitr)
library(xfun)

input <- "C:/Users/ADM/OneDrive/Documentos/Aprendizado/Probabilidades/alura/Curso_de_Estatística_Parte_2.ipynb"

# First convert to .Rmd...
convert_ipynb(input)

# ..then convert .Rmd into .R
#purl(with_ext(input, "Rmd"), output = with_ext(input, "R"))

# (Optional) Remove .Rmd file
#file.remove(with_ext(input, "Rmd"))