# cTBS-Meta-Analysis
A systematic review and meta-analysis of cTBS for auditory hallucinations.



## 📖 Overview
This repository contains the full analysis workflow, data processing scripts, and outputs for a systematic review and meta-analysis investigating the **efficacy and safety of continuous theta burst stimulation (cTBS)** for treating **auditory hallucinations in schizophrenia**.  

The project was conducted entirely in **RStudio**, using a transparent, reproducible pipeline that covers everything from systematic searching to final GRADE assessment.  

---

## 🔍 Research Objectives
1. **Primary Aim:** Evaluate the impact of cTBS on the severity of auditory hallucinations, measured by standardized clinical scales.  
2. **Secondary Aims:** Assess effects on related clinical domains and safety:
   - PANSS-Positive symptoms
   - PANSS-Negative symptoms
   - PANSS-P3 subscale
   - AHRS/AVHRS (Auditory Hallucination Rating Scales)
   - Response Rate (≥25% reduction in PSYRATS score)
   - Adverse Events  
3. **Exploratory Aims:**  
   - Identify sources of heterogeneity  
   - Evaluate robustness of findings (sensitivity analyses)  
   - Assess certainty of evidence using the GRADE framework  

---

## 📂 Repository Structure

├── data/                 # Extracted datasets and cleaned CSVs
│   └── ctbs-rawdata.csv
├── scripts/              # All R scripts used in the analysis
│   ├── 1_primary_analysis.R
│   ├── 2_sensitivity_analysis.R
│   ├── 3_secondary_outcomes.R
│   ├── 4_risk_of_bias.R
│   ├── 5_grade_summary.R
│   └── utils/ (helper functions)
├── figures/              # Generated plots
│   ├── 1.1-finalforest_col1.pdf
│   ├── 1.3A-loo_ma_re_forestcol2.pdf
│   ├── 1.4baujat_plot6c.pdf
│   ├── 1.5-HKSJforest_col2.pdf
│   ├── 1.7SO_forestplots_*.pdf
│   └── 1.8Risk_of_Bias_Summary_Weighted.pdf
├── results/              # Summary tables (kableExtra exports, GRADE tables, etc.)
├── prisma/               # PRISMA 2020 flow diagram
└── README.md             # Project documentation (this file)

---

## 📊 Methods

### Systematic Search
- **Databases:** PubMed/MEDLINE, Embase, Web of Science, Scopus, Cochrane CENTRAL  
- **Other Sources:** ClinicalTrials.gov, reference list hand-searching, conference abstracts  
- **Search Terms:** `"cTBS" AND "auditory hallucinations" AND "schizophrenia"` (expanded with synonyms)  
- **Records Identified:** 319 → 5 included studies (PRISMA diagram in `/prisma/`)  

### Statistical Analysis
- **Software:** R (RStudio)  
- **Key Packages:** `meta`, `dplyr`, `ggplot2`, `kableExtra`  
- **Model:** Random-effects (REML) for pooled estimates  
- **Effect Measures:**  
  - Continuous: MD (Mean Difference) or SMD (Hedges’ g)  
  - Dichotomous: Risk Ratio (RR)  

### Sensitivity Analyses
- Leave-One-Out (LOO) meta-analysis  
- Baujat plot (influence diagnostics)  
- Hartung-Knapp adjustment  
- Subgroup analyses (e.g., stimulation site, session count, frequency)  

### Risk of Bias & Certainty
- Cochrane RoB 2 tool (weighted plot)  
- GRADE framework: 5 domains (risk of bias, inconsistency, indirectness, imprecision, publication bias)  

---

## 📈 Key Results

### Primary Outcome
- **Mean Difference (MD):** -2.97 (95% CI: -5.22 to -0.73), favoring cTBS  
- **Heterogeneity:** I² = 68.3% (substantial)  
- **Certainty:** Very Low (GRADE), downgraded for RoB, heterogeneity, and imprecision  

### Secondary Outcomes
- PANSS-Positive → Significant benefit (pooled MD negative)  
- PANSS-Negative, PANSS-P3, AHRS/AVHRS → No significant effect  
- Response Rate → Trend towards benefit, RR > 1 (not significant)  
- Adverse Events → No increase (favorable safety profile)  

### Sensitivity
- LOO showed Liu et al. (2023) as main driver of heterogeneity  
- HKSJ adjustment confirmed robustness of core effect  
- Subgroup analyses did not explain heterogeneity  

---

