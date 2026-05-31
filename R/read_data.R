read_data <- function() {
  targets <- list(
    # Target: Load libraries
    tar_target(
      load_libraries_, {
        ## ---- load libraries
        library(tidyverse)
        ## ----end
      }
    ),
    tar_target(
      load_pre_joined_data_, {
        data_dir <- prepare_directories_$data_dir
        ## ---- load dirichlet_dat 
        dirichlet_dat <- get(load(paste0(data_dir, "primary/dirichlet.dat 3.RData")))
        ## ----end
        dirichlet_dat
      }
    )
  )
}

