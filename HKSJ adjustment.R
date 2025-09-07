# # 1.5 : Hartung-knapp adjustment  # # 

# Run the meta-analysis with the HKSJ adjustment
ma_hksj6d <- update(ma_final, method.random.ci = "HK")

# Print the summary of the new, more conservative results
summary(ma_hksj6d)

library(meta)


# Step 1: Re-run the meta-analysis, excluding the Liu et al. study
# We use the 'subset' argument to select all studies EXCEPT Liu et al.
ma_without_liu <- update(ma_final, 
                         subset = study_name != "Liu et al, 2023")



# Step 2: Apply the HKSJ adjustment to this new, cleaner dataset
ma_without_liu_hksj <- update(ma_without_liu, 
                              method.random.ci = "HK")


# Step 3: Print the final, robust summary
forest(ma_without_liu_hksj,
       label.e = "cTBS Group",
       label.c = "Sham Group",
       label.left = "Favours cTBS",
       label.right = "Favours Sham",
       
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
       
       pdf("1.5-HKSJforest_col2.pdf", width = 10, height = 3.2),
       
       )