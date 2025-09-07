# 1.1

# 1. Load the required library

library(meta)

# 3. (HIGHLY recommended) Check the column names as seen by R
# This command confirms the headers. They should match what's used below.
print(names(master_data))



# 4. Run the meta-analysis using the CORRECT column names from your file
ma_final <- metacont(
  n.e = n_exp,         # N in experimental group
  mean.e = meanchange_exp,   # Mean of experimental group
  sd.e = sdchange_exp_high,       # SD of experimental group
  n.c = n_ctrl,         # N in control group
  mean.c = meanchange_ctrl,   # Mean of control group
  sd.c = sdchange_ctrl_high,       # SD of control group
  studlab = study_name,       # Study labels
  data = master_data,        # <-- Tells R to use your loaded CSV data
  sm = "MD",             # We are calculating the Mean Difference
  method.tau = "REML"    # Use the robust REML estimator
)

## STEP 4: PREPARE CUSTOM LABELS FOR THE PLOT
# This step adds the p-value for the overall effect to the summary label.

# Extract the p-value from the meta-analysis object
summary(ma_final)

forest(ma_final,
       #column setups
       leftcols = c("studlab", "n.e", "mean.e", "sd.e", "n.c", "mean.c", "sd.c"),
       leftlabs = c("Study", "N", "Mean", "SD", "N", "Mean", "SD"),
       
       rightcols = c("effect", "ci", "w.random"),
       rightlabs = c("Mean Difference", "95% CI", "Weight %"),
       
       label.e = "cTBS Group",
       label.c = "Sham Group",
       label.left = "Favours cTBS", col.label.left = "black",
       label.right = "Favours control",col.label.right = "black",
       
       spacing = 1.1,
       
       common = FALSE,
       test.overall.common = FALSE, 
       test.overall.random = TRUE,
       
       prediction = TRUE,
       print.pred = TRUE,
       
       print.I2 = TRUE, print.tau2 = TRUE, print.Q = TRUE, print.pval.Q = TRUE,
       
       col.square = "#3cb7a1",
       col.diamond = "#0D77DB",
       col.predict = "#405557",

       digits = 2,
       digits.sd = 2,
       digits.mean = 2,
       digits.ci = 2,
       digits.pval.Q = 3,
       
       pdf("1.1-finalforest_col1.pdf", width = 11, height = 4),
       

       )



ma_final

## some colors that are also looking good :
col.square = "#53917E" "#13D898" 
col.diamond = "#3B3C36"
col.predict = "brown"





