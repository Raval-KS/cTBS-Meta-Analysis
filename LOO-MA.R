# # 1.3A - forest plot of LOO-MA & 1-3B : summary table of sensitivity analysis using random effects model and DL for tau



# Load the required libraries
library(meta)
library(kableExtra)
library(dplyr)

# 'ma_final' is your main meta-analysis object from metacont() ref: 1.1 -> main forest plot

# --- STEP 1: Perform the CORRECT Leave-One-Out Analysis ---

# - using DL method for tau calculation, although not recomended

ma_final_stableDL <- update(ma_final, method.tau = "DL")


# - using REML method for tau calculation, recomended: not working

ma_final_stableREML <- update(ma_final, method.tau = "REML")

#exp

# PM method : not working
ma_final_stablePM <- update(ma_final, method.tau = "PM")

#HE method
ma_final_stableHE <- update(ma_final, method.tau = "HE")



# Then re-run your 'metainf' and 'forest' code




ma_final_stableDL

ma_final_stableREML

help(rma)

# we will obviously use reml model
# --- STEP 1: Perform the CORRECT Leave-One-Out Analysis ---
# We create ONE object, based EXPLICITLY on the random-effects model,
# using our new STABLE model object to prevent convergence errors.
loo_analysis_random <- metainf(ma_final_stableDL, pooled = "random")


# Then re-run your 'metainf' and 'forest' code


# --- STEP 2: Generate the Publication-Quality Forest Plot ---
#for supplementary material
# We use our single, correct object ('loo_analysis_random') to create the plot.

pdf("1.3A-loo_ma_re_forestcol2.pdf", width = 9, height = 3.3)


forest(loo_analysis_random,
       studlab = TRUE,
       comb.random = TRUE, # We now correctly show the random-effects diamond
       comb.fixed = FALSE,# We hide the incorrect common-effect diamond
       
       
       label.left = "Favours cTBS",
       label.right = "Favours control",
       
       
       col.bg = "#3cb7a1",
       col.diamond = "#0D77DB",
       col.predict = "#405557",
       
       # --- Layout and Precision ---
       spacing = 1.1,
       digits = 2,
       digits.ci = 2,
       digits.tau2 = 2,
       digits.tau = 2,
       
       
)


dev.off()



# --- STEP 2: Generate the Publication-Quality Summary Table ---
# We use the EXACT SAME object ('loo_analysis_random') to create the table.

# Extract original random-effects results from the STABLE object for comparison
original_md_random <- ma_final_stableDL$TE.random
original_i2_random <- ma_final_stableDL$I2

# Create the clean data frame with the correct results
loo_table_final <- data.frame(
  Omitting = loo_analysis_random$studlab,
  MD = loo_analysis_random$TE,
  CI_lower = loo_analysis_random$lower,
  CI_upper = loo_analysis_random$upper,
  I2 = loo_analysis_random$I2 * 100
)

# Calculate percentage changes
loo_table_final$MD_Percent_Change <- ((loo_table_final$MD - original_md_random) / original_md_random) * 100
loo_table_final$I2_Percent_Change <- ((loo_table_final$I2 - (original_i2_random * 100)) / (original_i2_random * 100)) * 100

# Create the final, styled table object
sensi_table_2 <- loo_table_final %>%
  mutate(across(where(is.numeric), ~ round(., 2))) %>%
  kbl(
    col.names = c("Omitted Study", "MD", "CI Lower", "CI Upper", "I² (%)", "% Change MD", "% Change I²"),
    caption = "Leave-One-Out Sensitivity Analysis (Random-Effects Model)",
    booktabs = TRUE
  ) %>%
  kable_styling(
    bootstrap_options = c("striped", "hover"),
    full_width = FALSE,
    position = "center"
  ) %>%
  row_spec(4, bold = TRUE, background = "#D3D3D3")


# View the final table in the RStudio Viewer
print(sensi_table_2)


library(webshot2)
# --- Save the Table to a PDF ---
save_kable(sensi_table_2, file = "1.3B-re-loo_table.pdf")



