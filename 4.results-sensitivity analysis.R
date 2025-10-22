# 1.2

# # Taable representing the results of sensitivity analysis # # # 



# --- Pragmatic Sensitivity Analysis Table Workflow ---

# 1. Load the required libraries
# Ensure you have these installed: install.packages(c("kableExtra", "dplyr"))
library(meta)
library(kableExtra)
library(dplyr)
library(metafor)
library(magick)
library(webshot2)
library(rmarkdown)
library(tinytex)


model_low
model_moderate
model_high



# debugging

print("--- Starting Advanced Debugging Check (for metafor objects) ---")

if (!exists("model_low") || is.null(model_low$b)) {
  stop("DEBUG FAIL: The 'model_low' object is missing or did not compute correctly.")
} else {
  print("SUCCESS: 'model_low' was found and contains valid results.")
}

if (!exists("model_moderate") || is.null(model_moderate$b)) {
  stop("DEBUG FAIL: The 'model_moderate' object is missing or did not compute correctly.")
} else {
  print("SUCCESS: 'model_moderate' was found and contains valid results.")
}

if (!exists("model_high") || is.null(model_high$b)) {
  stop("DEBUG FAIL: The 'model_high' object is missing or did not compute correctly.")
} else {
  print("SUCCESS: 'model_high' was found and contains valid results.")
}

print("--- All models verified. Proceeding to create summary table. ---")



# 4. Create a data frame summarizing the results (Corrected for rma objects)
sensitivity_summary <- data.frame(
  Assumption = c("Low (Corr = 0.3)", "Moderate (Corr = 0.5)", "High (Corr = 0.7)"),
  MD = c(model_low$b, model_moderate$b, model_high$b),
  CI_lower = c(model_low$ci.lb, model_moderate$ci.lb, model_high$ci.lb),
  CI_upper = c(model_low$ci.ub, model_moderate$ci.ub, model_high$ci.ub),
  p_value = c(model_low$pval, model_moderate$pval, model_high$pval),
  I2 = c(model_low$I2, model_moderate$I2, model_high$I2)
)

# 5. Create and Save the Aesthetic Table
# This section remains the same as it correctly styles the final data frame.
final_sensitivity_table <- sensitivity_summary %>%
  # Combine CI into a single, nicely formatted column
  mutate(CI = paste0("[", round(CI_lower, 2), ", ", round(CI_upper, 2), "]")) %>%
  
  # Select and reorder the columns for the final table
  select(Assumption, MD, CI, p_value, I2) %>%
  
  # Round the remaining numeric columns for neatness
  mutate(across(where(is.numeric), ~ round(., 2))) %>%
  
  # Start the kable object with column names and a caption
  kbl(
    col.names = c("Correlation Assumption", "Pooled MD", "95% CI", "p-value", "I² (%)"),
    caption = "Sensitivity Analysis Based on Varying Correlation Assumptions for Imputed SDs",
    booktabs = TRUE # Use professional table formatting
  ) %>%
  
  # Add the same styling as your loo_table
  kable_styling(
    bootstrap_options = c("striped", "hover", "condensed"),
    full_width = FALSE,
    position = "center"
  ) %>%
  
  # Highlight the primary analysis (Moderate assumption)
  row_spec(2, bold = TRUE, background = "#D3D3D3")

# --- 6. Save the Table to a PDF ---

save_kable(final_sensitivity_table, file = "1.2B-sensitivity_analysis_table.pdf")


print(final_sensitivity_table)
