# # # META _ REGRESSION - 8 # # #

# Load the 'meta' library if it's not already loaded
library(meta)

# --- Perform the Meta-Regression ---
# IMPORTANT: Replace 'total_pulses' with the actual name of the column 
# in your 'master_data' that contains the total stimulation dose for each study.

# We run the regression on our object of 4 sham-controlled studies (~ means 'by')
metareg_8a_dose <- metareg(ma_without_liu, ~ total_pulses)

# Print the summary of the regression results
summary(metareg_8a_dose)


# --- Visualize the Meta-Regression with a Bubble Plot ---
# This is the standard way to visualize the result
bubble(metareg_8a_dose)


# --- Create a data frame with the necessary data ---
# We'll pull data from our meta-analysis of the 4 sham-controlled studies

mr_8a_bbplot_data <- data.frame(
    # The study labels
    study = ma_without_liu$studlab,
    
    # The moderator values (our x-axis)
    moderator = metareg_8a_dose$X[, 2], 
    
    # The effect size for each study (our y-axis)
    effect_size = ma_without_liu$TE,
    
    # THE FIX: Use the pre-calculated weights directly from the object
    # Since I²=0, the common and random effects weights are the same.
    weight = ma_without_liu$w.common 
  )

# The Step 2 ggplot code block remains unchanged. 
# You can now run it using this corrected 'bubble_plot_data' object.


# Load the ggplot2 library
library(ggplot2)

# --- Create the custom, colorful bubble plot ---
bblplot_8a <- ggplot(data = mr_8a_bbplot_data, aes(x = moderator, y = effect_size)) +
  
  # Add the bubbles: map the 'weight' to the size aesthetic
  geom_point(aes(size = weight), shape = 21, fill = "dodgerblue", alpha = 0.7, color = "black") +
  
  # Add the regression line from our model
  geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dashed", formula = y ~ x) +
  
  # Control the range of bubble sizes for a better look
  scale_size(range = c(4, 12), name = "Study Precision (1/SE)") +
  
  # Add a horizontal line at 'no effect' (y=0)
  geom_hline(yintercept = 0, linetype = "solid", color = "grey50") +
  
  # Apply a clean theme and professional labels
  theme_bw() +
  labs(
    x = "Total Stimulation Pulses",
    y = "Mean Difference in PSYRATS Score",
    title = "Meta-Regression: Dose-Response Relationship",
    subtitle = "Among Sham-Controlled Trials"
  ) +
  
  # Final theme adjustments for polish
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5)
  )

ggsave(
  filename = "metaregression8a_bblplot_dose.pdf",
  plot = bblplot_8a,
  width = 8,
  height = 6,
  units = "in"
)


install.packages("ggrepel")


# Load the necessary libraries
library(ggplot2)
library(ggrepel)

# --- Create the final, labeled bubble plot ---
# This is the same code as before, with one new line for the labels

bblplot_8alab <- ggplot(data = mr_8a_bbplot_data, aes(x = moderator, y = effect_size)) +
  
  geom_point(aes(size = weight), shape = 21, fill = "dodgerblue", alpha = 0.7, color = "black") +
  
  geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dashed", formula = y ~ x) +
  
  # --- THIS IS THE NEW LINE ---
  # --- MODIFIED LINE ---
  # Add a positive nudge_y value to push labels upwards
  # Set min.segment.length to 0 to always draw the connecting line
  geom_text_repel(
    aes(label = study, size = 0.005), 
    nudge_y = 0.50, 
    box.padding = 0.5, 
    min.segment.length = 0,
    max.overlaps = Inf
  ) +
  
  scale_size(range = c(4, 12), name = "Study Precision (1/SE)") +
  
  geom_hline(yintercept = 0, linetype = "solid", color = "grey50") +
  
  theme_bw() +
  
  labs(
    x = "Total Stimulation Pulses",
    y = "Mean Difference in PSYRATS Score",
    title = "Meta-Regression: Dose-Response Relationship",
    subtitle = "Among Sham-Controlled Trials"
  ) +
  
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5)
  )

# --- Display the plot ---

bblplot_8alab

# --- And save it ---
ggsave(
  filename = "metaregression8a_bblplot_doselabeled.pdf",
  plot = bblplot_8alab,
  width = 10, # Increased width slightly to make room for labels
  height = 6,
  units = "in"
)




# Load the 'meta' library if it's not already loaded
library(meta)

# --- Perform the Meta-Regression for Mean Age ---
# IMPORTANT: Replace 'mean_age' with the actual name of the column 
# in your 'master_data' that contains the mean age for each study.

# Run the regression on our object of 4 sham-controlled studies
metareg_8b_age <- metareg(ma_without_liu, ~ age_mean)

# Print the summary of the regression results
summary(metareg_8b_age)


# --- Visualize the Meta-Regression with a Bubble Plot ---
bubble(metareg_8b_age)