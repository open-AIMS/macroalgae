## for interactive development within the docker container
## cd ~/Work/AIMS/MMP/Coral/2026
## singularity exec -B .:/home/Project gcrmn_alt2.sif R
## setwd("R")

# Load the targets package
library(targets)
library(tarchetypes)

# Set global options
tar_option_set(
  packages = c("tidyverse",
    "glmmTMB", "emmeans", "DHARMa", "patchwork",
    "brms", "rstan", "bayesplot", "tidybayes",
    "posterior", "HDInterval"),  # Load required packages
  format = "rds"                    # Default storage format
)
## lapply(packages, library, character.only = TRUE)

source("preparations.R")    # assign global vars (paths)
source("read_data.R")       # load data
source("process_data.R")    # process data
source("eda.R")             # EDA
## source("fit_models.R")      # fit models
## source("fit_models_ma_group.R")      # fit models
## source("fit_models_browns.R")      # fit models

list(
  preparations(),
  read_data(),
  process_data(),
  eda()
  ## fit_models()
  ## fit_models_ma_group()
  ## ## fit_models_browns()
)
