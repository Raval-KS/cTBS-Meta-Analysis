# --- Step 1 & 2: Load Tools and Data ---
library(metafor)
# # DIFFERENT  CORRELATION ASSUMPTIONS FOREST PLOT


# --- Analysis 1: Main Model (Moderate Correlation) ---

model_moderate <- rma(yi = psyrats_MD, vi = vi_md_mod, data = master_data, method = "REML")
summary(model_moderate)
forest((model_moderate))

# --- Step 2: Prepare the Custom Text for Your Columns ---
custom_textmod <- cbind(
  format(round(model_moderate$yi, 2), nsmall = 2),
  paste0("[", format(round(model_moderate$ci.lb, 2), nsmall = 2), ", ", format(round(model_moderate$ci.ub, 2), nsmall = 2), "]")
)

forest(model_moderate,
       slab = master_data$study_name,
       header = c("Study", "MD [95% CI]"),
       xlab = "Mean Difference (PSYRATS-AH)",
       
       # 1. Make the canvas even wider, from -20 to 25
       xlim = c(-20, 20),
       
       # (ilab is the same as before)
       ilab = custom_text,
       
       # 2. Push the text columns much further to the right
       ilab.xpos = c(-40, -30))



model_low <- rma(yi = psyrats_MD, vi = vi_md_low, data = master_data, method = "REML")
summary(model_low)

custom_textlow <- cbind(
  format(round(model_low$yi, 2), nsmall = 2),
  paste0("[", format(round(model_low$ci.lb, 2), nsmall = 2), ", ", format(round(model_low$ci.ub, 2), nsmall = 2), "]")
)

forest(model_low,
       slab = master_data$study_name,
       header = c("Study", "MD [95% CI]"),
       xlab = "Mean Difference (PSYRATS-AH)",
       
       # 1. Make the canvas even wider, from -20 to 25
       xlim = c(-20, 20),
       
       # (ilab is the same as before)
       ilab = custom_text,
       
       # 2. Push the text columns much further to the right
       ilab.xpos = c(-40, -30))




model_high <- rma(yi = psyrats_MD, vi = vi_md_high, data = master_data, method = "REML")
forest(model_high)


custom_textmod <- cbind(
  format(round(model_high$yi, 2), nsmall = 2),
  paste0("[", format(round(model_high$ci.lb, 2), nsmall = 2), ", ", format(round(model_high$ci.ub, 2), nsmall = 2), "]")
)

forest(model_high,
       slab = master_data$study_name,
       header = c("Study", "MD [95% CI]"),
       xlab = "Mean Difference (PSYRATS-AH)",
       
       # 1. Make the canvas even wider, from -20 to 25
       xlim = c(-20, 20),
       
       # (ilab is the same as before)
       ilab = custom_text,
       
       # 2. Push the text columns much further to the right
       ilab.xpos = c(-40, -30))


summary(model_low)


library(meta)


# 1. Create your meta-analysis object (replace with your own data)
# [cite_start]I'm using the data from your "remllow.pdf" plot [cite: 15, 16, 17, 18, 19]
m.reml_low <- metagen(TE = c(-3.30, -1.00, -1.47, -7.54, -2.62),
                  seTE = c(3.40, 1.63, 1.57, 2.37, 1.22), # Standard Errors are estimated from your CIs
                  studlab = c("Plewnia_2014", "Koops_2016", "Tyagi_2022", "Liu_2023", "Plewnia_2025"),
                  sm = "MD",
                  random = TRUE,
                  method.tau = "REML")

# 2. Generate the forest plot with the desired statistics
forest(m.reml_low,
       studlab = TRUE,
       comb.random = TRUE,
       print.I2 = TRUE,        # Show I^2
       print.tau2 = TRUE,      # Show tau^2
       print.Q = TRUE,         # Show Cochran's Q
       print.pval.Q = TRUE,    # Show p-value for Q
       smlab = "Random-Effects Model", # Label for the summary
       leftcols = c("studlab", "effect", "ci"),
       rightcols = FALSE,
       just = "right",
       digits = 2)


forest(m_first_from_csv, layout = "RevMan5", common = FALSE,
       label.left = "Favours cTBS", col.label.left = "darkgreen",
       label.right = "Favours control", col.label.right = "navyblue",
       test.overall.common = FALSE, test.overall.random = TRUE,
       prediction = TRUE,
)