# # # 1.8 RISK OF BIAS - VISUALIZATION 

# --- 1. SETUP: LOAD LIBRARIES ---
# Install packages if you haven't already

install.packages("robvis")
# install.packages("dplyr")

library(robvis)
library(dplyr)

library(ggplot2)


# --- 2. LOAD & CLEAN YOUR ROB DATA ---

rob_data_raw <- read.csv("ROB- cTBS in Auditory hallucinations.csv")

names(rob_data_raw) <- c("Study", "Overall", "D1", "D2", "D3", "D4", "D5")

rob_data_cleaned <- rob_data_raw %>%
  mutate(across(everything(), ~ case_when(
    . == "Low Risk" ~ "Low",
    . == "High Risk" ~ "High",
    . == "Some Concerns" ~ "Some concerns",
    TRUE ~ .
  )))

# --- 3. CREATE A WEIGHTS DATA FRAME ---
# IMPORTANT: Make sure you have run your main meta-analysis and have the
# object 'ma_final' in your R environment.
ma_final

study_weights <- data.frame(
  Study = ma_final$studlab,
  # We use the random-effects model weights and convert to percentage
  Weight = ma_final$w.random * 100 
)

# --- 4. JOIN WEIGHTS TO YOUR ROB DATA ---
# A 'left_join' safely matches the weights to the correct study by name
rob_data_weighted <- left_join(rob_data_cleaned, study_weights, by = "Study")


# --- 5. CREATE THE WEIGHTED SUMMARY PLOT ---
# The rob_summary function will automatically find and use the "Weight" column
rob_summary_weighted_plot <- rob_summary(
  data = rob_data_weighted,
  tool = "ROB2",
  overall = TRUE,
  weighted = TRUE, # Explicitly tell the function the bars are weighted
  colour = c("#69d78b", "#ffb266", "#f48070")
)


colour = c("#027a6a", "#fcad3e", "#ff4e3a")



# Display the weighted plot
print(rob_summary_weighted_plot)

# Save the weighted plot
ggsave("Risk_of_Bias_Summary_Weighted.pdf", plot = rob_summary_weighted_plot, width = 8, height = 5)


# --- 4. CREATE TRAFFIC LIGHT PLOT ---
# This plot provides a detailed, study-by-study breakdown
rob_traffic_plot <- rob_traffic_light(
  data = rob_data_cleaned,
  tool = "ROB2"
)

# Display the traffic light plot in RStudio
# looks unncecessaaaaaaaaaary tbh 

print(rob_traffic_plot)

# Save the plot as a high-quality PDF
ggsave("Risk_of_Bias_Traffic_Light_Plot.pdf", plot = rob_traffic_plot, width = 8, height = 4)

print("Risk of Bias plots have been generated and saved as PDF files.")
