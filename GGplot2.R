# CONFIGURAÇÃO GLOBAL DO TEMA
# https://ggplot2-book.org/themes

tema = theme_classic(base_family = "Times New Roman") # https://ggplot2-book.org/themes#sec-themes

elementos_tema = theme_update( #theme(
  # Titulo
  plot.title = element_text(face = "bold", colour = "black"),
  # Painel -> https://ggplot2-book.org/themes#panel-elements
  panel.background = element_rect(fill = "white", color = NA), # Background - Plano de Fundo
  panel.grid.major = element_line(color = "grey80", linewidth = 2, linetype = "dotted"), # Grade
  panel.grid.minor = element_line(color = "grey90"), 
  # Eixos -> https://ggplot2-book.org/themes#sec-theme-axis
  axis.title.x = element_text(size = 12, face = "bold"), # Titulo
  axis.title.y = element_text(size = 12, face = "bold", angle = -30), 
  axis.text.x = element_text(size = 10), # Labels
  axis.text.y = element_text(size = 10), 
  axis.line = element_line(color = "black"), 
  # Legenda -> https://ggplot2-book.org/themes#legend-elements
  legend.position = "bottom", 
  legend.title = element_text(size = 12, face = "bold"), 
  legend.text = element_text(size = 10), 
  plot.margin = margin(10, 10, 10, 10) # Margem
)

#theme_set(tema)
# element_blank() #Nada

# facet_wrap() facet_grid() -> https://ggplot2-book.org/themes#faceting-elements
