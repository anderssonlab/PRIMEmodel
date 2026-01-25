# config.sh

### 0 ### _0_validate_ctss_and_region.r
CTSS_RSE_RDS="PRIMEmodel_results/ctss_rse.rds"
REGION_RDS="PRIMEmodel_results/K562-10pct_on_PRIMEmodel_pred_all_K562_C1_combined_thresh0.75_d0.1_extfromthick.rds"
OUTPUT_DIR="PRIMEmodel_results"

### 4 ### _4_get_profile.r
# CTSS_RSE_NAME, TC_GRL_NAME, OUTPUT_DIR from above
PROFILE_MAIN_DIR="PRIMEmodel_focal_profiles"
PROFILE_FORMAT="npz"
# add --save_count_profiles if you want to save count profiles

### 5 ### _5_predict_profile_probability.py
# OUTPUT_DIR, PROFILE_MAIN_DIR, PROFILE_SUB_DIR, and PROFILE_FILE_TYPE from above
PYTHON_PATH="/usr/bin/python3"
MODEL_PATH=$(Rscript -e 'cat(system.file("model", "PRIME_GM12878_model_1.0.sav", package = "PRIMEmodel"))')
PREFIX_OUT_NAME="focal"
