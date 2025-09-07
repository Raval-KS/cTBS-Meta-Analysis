## The GRADE (Grading of Recommendations, Assessment, Development, and Evaluations) framework is the international standard for rating the certainty of evidence.

# Install packages if you haven't already

library(knitr)
library(kableExtra)


# --- 2. CREATE THE DATA FRAME FOR THE TABLE ---
# We'll manually input the data based on our GRADE assessment

# Using unicode for GRADE symbols and <br> for a line break in the cell
certainty_levelGRADE <- "\u2295\u25ef\u25ef\u25ef<br>**Very Low**" # ⊕◯◯◯

# The reasons for downgrading the evidence
downgrade_commentsGRADE <- "Downgraded due to serious risk of bias, unexplained inconsistency, and serious imprecision."

# Create the data frame with one row for our primary outcome
sof_dataGRADE <- data.frame(
  Outcome = "Auditory Hallucination Severity (PSYRATS Score)",
  Participants = "291 (5 RCTs)",
  Effect = "MD -2.97 [-5.22, -0.73]",
  Certainty = certainty_levelGRADE,
  Comments = downgrade_commentsGRADE
)


# --- 3. FORMAT THE TABLE WITH kableExtra ---
# This uses the same styling as your other tables

summary_of_findings_tableGRADE <- sof_dataGRADE %>%
  kbl(
    caption = "Summary of Findings: cTBS for Auditory Hallucinations",
    col.names = c("Outcome", "No. of Participants (Studies)", "Pooled Effect (95% CI)", 
                  "Certainty of the Evidence (GRADE)", "Comments"),
    booktabs = TRUE,
    escape = FALSE, # <<< CRUCIAL: This renders the symbols and line breaks correctly
    align = "lcccc"
  ) %>%
  kable_styling(
    bootstrap_options = c("striped", "hover"),
    full_width = FALSE,
    position = "center"
  ) %>%
  # Adjust column widths for better readability
  column_spec(1, width = "15em") %>% 
  column_spec(5, width = "20em")


# --- 4. DISPLAY THE TABLE ---
summary_of_findings_tableGRADE


kableExtra::save_kable(summary_of_findings_tableGRADE, file = "GRADE-Summary_of_Findings.pdf")
