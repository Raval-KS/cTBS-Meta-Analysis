# 1.0 INTRO TABLE:



# --- 1. SETUP: LOAD LIBRARIES ---
library(dplyr)
library(knitr)
library(kableExtra)
library(ggplot2)



# --- 2. LOAD & PREPARE DATA ---
# Load your clean overview CSV file
overview_dataIT <- read.csv("Overview- cTBS in Auditory hallucinations.csv")


# --- 3. CREATE THE DATA FOR THE TABLE ---
# This version is simpler: we select the age columns without trying to round them.
detailed_characteristicsIT <- overview_dataIT %>%
  select(
    Study,
    n_int,
    mean_age_int, # Using the original column as-is
    n_ctrl,
    mean_age_ctrl, # Using the original column as-is
    treatment_duration,
    total_sessions,
    Site,
    Intensity,
    Frequency,
    pps,
    total_pulses
  ) %>%
  # We only need to format the columns that are not already correct
  mutate(
    total_pulses = format(total_pulses, big.mark = ",")
  )


# make the table without scroll_box
detailed_tableIT <- detailed_characteristicsIT %>%
  kbl(
    caption = "Detailed Characteristics of Included Studies",
    booktabs = TRUE,
    col.names = c("Study", "N", "Mean Age (SD)", "N", "Mean Age (SD)", 
                  "Duration (weeks)", "Sessions", "Site", "Intensity", 
                  "Frequency", "PPS", "Total Pulses"),
    align = "lcrccccccccc"
  ) %>%
  add_header_above(c(
    " " = 1,
    "Intervention (cTBS) Group" = 2,
    "Control Group" = 2,
    " " = 1,
    "Intervention Methods" = 6
  )) %>%
  kable_styling(
    bootstrap_options = c("striped", "hover"),
    full_width = FALSE,
    position = "center",
    font_size = 9  # shrink font size a bit
  )

# save as pdf, scaling down the capture
kableExtra::save_kable(
  detailed_tableIT,
  file = "detailed_characteristics_table.pdf",
  zoom = 0.7,      # zoom < 1 shrinks the content
  vwidth = 2000,   # widen virtual browser if table is very wide
  vheight = 1500
)
