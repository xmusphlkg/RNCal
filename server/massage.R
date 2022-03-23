

theme_set <- function() {
  theme_classic() +
    theme(
      legend.position = c(0.9, 0.9),
      plot.title = element_text(
        face = "bold",
        size = 18,
        vjust = 1,
        hjust = 0.5
      ),
      legend.text = element_text(face = 'bold', size = 12),
      legend.title = element_text(face = 'bold', size = 12),
      legend.box.background = element_rect(fill = "transparent", colour = 'transparent'),
      legend.background = element_rect(fill = "transparent", colour = 'transparent'),
      axis.title.x = element_text(face = 'bold', size = 12),
      axis.title.y = element_text(face = 'bold', size = 12),
      axis.text.x = element_text(size = 12),
      axis.text.y = element_text(size = 12),
      plot.margin = margin(5, 35, 5, 5)
    )
}