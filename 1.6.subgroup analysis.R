# # # 1.6 SUB GROUP ANALYSIS 06/09/25

library(meta)
library(dplyr)


# --- 2. LOAD DATA ---
master_data

# --- 3. DATA PREPARATION ---
# This step creates the categorical variables needed for the subgroup analyses


master_data_SGA <- master_data %>%
  mutate(
    # Rule 1: For 'Site' (with improved labels)
    label_site = case_when(
      Site == 1 ~ "Single Site Stimulation", #for renaming the crude variable for more appropriate info in graph
      Site == 2 ~ "Dual Site Stimulation",
      TRUE ~ as.character(Site) # Fallback
    ),
    
    # --- THIS IS THE UPDATED PART ---
    # Rule 2: For 'pps' with clearer labels
    label_pps = ifelse(pps < 1000, "Pulses Per Session: < 1000", "Pulses Per Session: ≥ 1000"),
    
    # --- AND THIS IS THE UPDATED PART ---
    # Rule 3: For 'total_pulses' with clearer labels
    label_total_pulses = ifelse(total_pulses < 15000, "Total Intervention Pulses: < 15000", "Total Intervention Pulses: ≥ 15000"),
    
    # Rule 4: For Risk of Bias (with improved labels)
    label_rob = case_when(
      RoB_assesment == "Low" ~ "Low Risk of Bias",
      RoB_assesment == "High_or_Some_Concerns" ~ "Some Concerns or High Risk",
      TRUE ~ RoB_assesment # Fallback
    )
  )




# --- 4. CREATE THE BASE META-ANALYSIS OBJECT ---
# This object calculates the Mean Difference (sm = "MD") for the PSYRATS outcome
# for every study. This will be the foundation for all subgroup analyses.

ma_final_SGA <- metacont(
  n.e = n_exp,
  mean.e = meanchange_exp,
  sd.e = sdchange_exp_high, # Using moderate SD assumption
  n.c = n_ctrl,
  mean.c = meanchange_ctrl,
  sd.c = sdchange_ctrl_high,
  data = master_data_SGA, # Use the enhanced data frame
  studlab = study_name,
  sm = "MD"
)


# --- 5. RUN ANALYSES AND GENERATE "PRETTY" FOREST PLOTS ---

# Define a consistent styling for all forest plots
plot_stylingSGA <- list(
  print.subgroup.name = FALSE,
  test.effect.subgroup = TRUE,
  label.left = "Favours cTBS",
  label.right = "Favours control",
  label.e = "cTBS Group",
  label.c = "Sham Group",
  spacing = 1.2,
  prediction = TRUE,
  common = FALSE,
  random = TRUE,
  col.square = "#3cb7a1",
  col.diamond = "#0D77DB",
  col.predict = "#405557",
  digits = 2,
  digits.sd = 2,
  digits.mean = 2,
  digits.ci = 2,
  digits.stat = 2,
  digits.pval = 3,
  digits.pval.Q = 3
)

# Analysis & Plot 1: Site
pdf("1.6subgrpanalysis_site.pdf", width = 11, height = 7)
ma_sg_site <- update(ma_final_SGA, subgroup = label_site)
do.call(forest, c(list(x = ma_sg_site, smlab = "Subgroup by No. of Site(s)"), plot_stylingSGA))
dev.off()

# Analysis & Plot 2: PPS (Pulses Per Session)
pdf("1.6subgrpanalysis_pps.pdf", width = 11, height = 7)
ma_sg_pps <- update(ma_final_SGA, subgroup = label_pps)
do.call(forest, c(list(x = ma_sg_pps, smlab = "Subgroup by PPS"), plot_stylingSGA))
dev.off()

# Analysis & Plot 3: Total Pulses
pdf("1.6subgrpanalysis_totalpulses.pdf", width = 11, height = 7)
ma_sg_total_pulses <- update(ma_final_SGA, subgroup = label_total_pulses)
do.call(forest, c(list(x = ma_sg_total_pulses, smlab = "Subgroup by Total Pulses"), plot_stylingSGA))
dev.off()

# Analysis & Plot 4: Risk of Bias (RoB)
# Reminder: Interpret this specific analysis with caution due to the 4:1 study split.
pdf("1.6subgrpanalysis_rob.pdf", width = 11, height = 7)
ma_sg_rob <- update(ma_final_SGA, subgroup = label_rob)
do.call(forest, c(list(x = ma_sg_rob, smlab = "Subgroup by Risk of Bias"), plot_stylingSGA))
dev.off()
