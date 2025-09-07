# # 1.4 - baujats plot visually proving liu is outlier



library(meta)

# # BAUJAT plot # #


baujat_data_6c <- baujat(ma_final)

library(ggplot2)




# --- Step 1: Assign the plot to an object ---
baujat_plot6c <- ggplot(data = baujat_data_6c, aes(x = x, y = y, color = studlab)) +
  geom_point(size = 8, alpha = 0.8) +
  theme_bw() +
  labs(
    x = "Contribution to overall heterogeneity",
    y = "Influence on overall result",
    title = "Baujat Plot of Included Studies",
    color = "Study"
  ) +
  scale_color_brewer(palette = "Set1") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title = element_text(size = 12),
    legend.title = element_text(size = 12, face = "bold"),
    legend.text = element_text(size = 10)
  )

# --- Step 2: Save the plot object to a PDF file ---
ggsave(
  filename = "1.4baujat_plot6c.pdf", # The name of your file. The .pdf extension is key.
  plot = baujat_plot6c,       # The plot object you just created.
  width = 8,                  # The width of the plot.
  height = 6,                 # The height of the plot.
  units = "in",               # The units for width and height (e.g., "in", "cm").
  dpi = 700                   # Dots per inch (resolution).
)