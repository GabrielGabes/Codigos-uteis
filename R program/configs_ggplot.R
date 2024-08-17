Familias de fontes disponiveis
library(systemfonts)

# Listando fontes disponíveis
fontes_disponiveis <- system_fonts()

fontes_disponiveis = fontes_disponiveis[c('family')]
fontes_disponiveis = fontes_disponiveis %>% select(family) %>% distinct()
fontes_disponiveis$ID_x = NA
fontes_disponiveis$ID_y = NA

count = 0
count2 = 0
for (i in 1:nrow(fontes_disponiveis)){
  count = count + 1
  resto = count %% 10
  if (count %% 10 == 1){
    count2 = count2 + 1
  }
  print(paste(count, '-', resto, '-', count2))
  fontes_disponiveis$ID_y[i] = resto
  fontes_disponiveis$ID_x[i] = count2
}
fontes_disponiveis

# Criando o gráfico
font_plot <- ggplot(fontes_disponiveis, aes(x=ID_x, y=ID_y)) + #[c(1:40),]
  geom_text(aes(label=family, family=family)) +
  labs(title="Todas as Font Families", x=NULL, y=NULL) +
  theme_minimal() + theme(axis.title = element_blank(), 
                          axis.text.y = element_blank(), 
                          axis.ticks = element_blank(), 
                          panel.grid = element_blank())

font_plot
ggsave("fontes_para_graficos_HP.jpg", height=20, width=80, units="cm", dpi= 600)




CONFIGURAÇÃO GLOBAL DO TEMA
https://ggplot2-book.org/themes
https://ggplot2-book.org/themes#sec-themes

tema = theme_classic(base_family = "Times New Roman")

# faces de fontes: "plain","bold","italic","bold.italic"

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
  #legend.position = "bottom",
  legend.title = element_text(size = 12, face = "bold"),
  legend.text = element_text(size = 10),
  plot.margin = margin(10, 10, 10, 10) # Margem
)

theme_set(tema)

element_blank() #Nada
facet_wrap() facet_grid() -> https://ggplot2-book.org/themes#faceting-elements
font face -> https://ggplot2.tidyverse.org/articles/ggplot2-specs.html#font-face
themes -> https://ggplot2.tidyverse.org/reference/ggtheme.html

