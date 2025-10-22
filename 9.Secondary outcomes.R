# # # 1.7 :SECONDARY OUTCOMES: 07/09/25; 3:30 AM


# FINAL SCRIPT FOR SECONDARY OUTCOME META-ANALYSIS


# --- 1. SETUP: LOAD LIBRARIES ---

library(meta)
library(dplyr)
library(grid)
library(knitr)
library(kableExtra)
library(webshot2)


# --- 2. LOAD DATA ---
master_data


# --- 3. DEFINE PLOT STYLING ---
# A consistent style list for all forest plots
plot_stylingSO <- list(
  label.left = "Favours cTBS",
  label.right = "Favours control",
  label.e = "cTBS Group",
  label.c = "Sham Group",
  spacing = 1.2,
  prediction = TRUE,
  common = FALSE, # Use random-effects model only
  random = TRUE,
  test.effect.random = TRUE, # Display z-value and p-value
  col.square = "#3cb7a1",
  col.diamond = "#0D77DB",
  col.predict = "#405557",
  digits = 2,
  digits.stat = 2,
  digits.pval = 3,
  digits.pval.Q = 3
)


# --- 4. DEFINE HELPER FUNCTIONS ---

# ## Improved function for creating forest plots
make_plotSO <- function(ma_object, filename, label, reverse_labels = FALSE, 
                        # Add new arguments with default values
                        plot_width = 9.5, plot_height = 5) {
  
  current_style <- plot_stylingSO
  
  if (reverse_labels) {
    current_style$label.left <- "Favours control"
    current_style$label.right <- "Favours cTBS"
  }
  
  # The pdf() function now uses the new arguments
  pdf(filename, width = plot_width, height = plot_height)
  
  do.call(forest, c(list(x = ma_object, smlab = label), current_style))
  
  # This part for adding custom text remains the same
  grid.text(sprintf("Overall effect: Z = %.2f, p = %.3f",
                    ma_object$zval.random, ma_object$pval.random),
            x = 0.05, y = 0.125, just = c("left", "top"),
            gp = gpar(fontsize = 11, fontface = "italic"))
  dev.off()
}

# ## Corrected function for extracting table data
extract_meta_summarySO <- function(ma_object, outcome_name, effect_label) {
  
  # Correctly transform Risk Ratios from log scale
  if (effect_label == "RR") {
    TE    <- exp(ma_object$TE.random)
    lower <- exp(ma_object$lower.random)
    upper <- exp(ma_object$upper.random)
  } else {
    TE    <- ma_object$TE.random
    lower <- ma_object$lower.random
    upper <- ma_object$upper.random
  }
  
  data.frame(
    Outcome = outcome_name,
    k = ma_object$k,
    `Effect Measure` = effect_label,
    `Pooled Estimate (95% CI)` = sprintf("%.2f [%.2f, %.2f]", TE, lower, upper),
    `Heterogeneity (I²)` = sprintf("%.1f%%", ma_object$I2 * 100), # Correct I² math
    `p-value` = ifelse(ma_object$pval.random < 0.001,
                       "<0.001",
                       sprintf("%.3f", ma_object$pval.random)),
    pval_num = ma_object$pval.random
  )
}


# --- 5. RUN ALL META-ANALYSES ---
# This section creates the meta-analysis objects for each outcome.

ma_panpSO <- metacont(n.e=n_exp, mean.e=PANP_MC_exp, sd.e=PANP_sdc_exp, n.c=n_ctrl, mean.c=PANP_MC_ctrl, sd.c=PANP_sdc_ctrl, data=master_data, studlab=study_name, sm="MD")
ma_pannSO <- metacont(n.e=n_exp, mean.e=PANN_MC_exp, sd.e=PANN_sdc_exp, n.c=n_ctrl, mean.c=PANN_MC_ctrl, sd.c=PANN_sdc_ctrl, data=master_data, studlab=study_name, sm="MD")
ma_pan3SO <- metacont(n.e=n_exp, mean.e=PAN3_MC_exp, sd.e=PAN3_sdc_exp, n.c=n_ctrl, mean.c=PAN3_MC_ctrl, sd.c=PAN3_sdc_ctrl, data=master_data, studlab=study_name, sm="MD")
ma_ahrSO  <- metacont(n.e=n_exp, mean.e=AHR_MC_exp, sd.e=AHR_sdc_exp, n.c=n_ctrl, mean.c=AHR_MC_ctrl, sd.c=AHR_sdc_ctrl, data=master_data, studlab=study_name, sm="SMD", method.smd="Hedges")
ma_respSO <- metabin(event.e=resp_exp, n.e=n_exp, event.c=resp_ctrl, n.c=n_ctrl, data=master_data, studlab=study_name, sm="RR")
ma_aeSO   <- metabin(event.e=ae_exp, n.e=n_exp, event.c=ae_ctrl, n.c=n_ctrl, data=master_data, studlab=study_name, sm="RR")


# --- 6. GENERATE ALL FOREST PLOTS ---
# This will save 6 PDF files to your working directory.

make_plotSO(ma_panpSO, "1.7SO_forestplot_PANP.pdf", "Mean Difference (PANSS-P)", plot_width = 10, plot_height = 4.00 )
make_plotSO(ma_pannSO, "1.7SO_forestplot_PANN.pdf", "Mean Difference (PANSS-N)", plot_width = 10, plot_height = 4.00)
make_plotSO(ma_pan3SO, "1.7SO_forestplot_PAN3.pdf", "Mean Difference (PANSS-P3)", plot_width = 10, plot_height = 4.00)
make_plotSO(ma_ahrSO,  "1.7SO_forestplot_AHR.pdf", "SMD (AHRS/AVHRS)", plot_width = 10, plot_height = 4.00)
make_plotSO(ma_aeSO,   "1.7SO_forestplot_AE.pdf", "Risk Ratio (Adverse Events)", plot_width = 10, plot_height = 4.00)
make_plotSO(ma_respSO, "1.7SO_forestplot_Response.pdf", "Risk Ratio (Response Rate)", reverse_labels = TRUE, plot_width = 10, plot_height = 4.00) # Note the reversed labels

print("All 6 forest plots have been generated and saved as PDF files.")


# --- 7. GENERATE THE FINAL SUMMARY TABLE ---
# This builds and displays the final, corrected summary table.

secondary_tableSO <- bind_rows(
  extract_meta_summarySO(ma_panpSO, "PANSS-Positive", "MD"),
  extract_meta_summarySO(ma_pan3SO, "PANSS-P3", "MD"),
  extract_meta_summarySO(ma_pannSO, "PANSS-Negative", "MD"),
  extract_meta_summarySO(ma_ahrSO, "AHRS/AVHRS", "SMD (Hedges' g)"),
  extract_meta_summarySO(ma_respSO, "Response Rate", "RR"),
  extract_meta_summarySO(ma_aeSO, "Adverse Events", "RR")
)

# --- Format with kableExtra ---
secondary_table_kblSO <- secondary_tableSO %>%
  select(-pval_num) %>%
  kbl(
    caption = "Summary of Secondary Outcomes (Random-Effects Model)",
    # --- "N (Participants)" has been removed from the line below ---
    col.names = c("Outcome", "k (Studies)", "Effect Measure",
                  "Pooled Estimate (95% CI)", "Heterogeneity (I²)", "p-value"),
    booktabs = TRUE,
    align = "lccccc" # Alignment updated for fewer columns
  ) %>%
  kable_styling(
    bootstrap_options = c("striped", "hover"),
    full_width = FALSE,
    position = "center"
  ) %>%
  row_spec(
    which(secondary_tableSO$pval_num < 0.05),
    bold = TRUE,
    background = "#D3D3D3"
  )

# --- Display the final, correct table ---
secondary_table_kblSO


kableExtra::save_kable(secondary_table_kblSO, file = "1.7secondary_outcomes_summary.pdf")
