theme_set <- function(){
  theme_classic()+
    theme(legend.position = c(0.9, 0.9),
          plot.title = element_text(face = "bold", size = 18, vjust = 1, 
                                    family = "Times New Roman", hjust = 0.5),
          legend.text = element_text(face = 'bold', size = 12, family = 'Times New Roman'),
          legend.title = element_text(face = 'bold', size = 12, family = 'Times New Roman'),
          legend.box.background = element_rect(fill = "transparent", colour = 'transparent'),
          legend.background = element_rect(fill = "transparent", colour = 'transparent'),
          axis.title.x = element_text(face = 'bold', size = 12, family = 'Times New Roman'),
          axis.title.y = element_text(face = 'bold', size = 12, family = 'Times New Roman'),
          axis.text.x = element_text(size = 12, family = 'Times New Roman'),
          axis.text.y = element_text(size = 12, family = 'Times New Roman'),
          plot.margin = margin(5, 35, 5, 5))
}
