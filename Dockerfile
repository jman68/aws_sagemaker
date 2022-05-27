FROM rocker/tidyverse:latest

ENTRYPOINT ["Rscript", "run_pred_pipeline.R"]
