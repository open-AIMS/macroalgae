preparations <- function() {
  targets <- list(
    # Target: prepare directories 
    tar_target(
      libraries_, {
        ## ---- libraries
        library(tidyverse)
        library(brms)
        ## ----end
      }
    ),
    tar_target(
      prepare_directories_, {
        ## ---- prepare directories
        assign("data_dir", value = "../data/", envir = .GlobalEnv)
        if (!dir.exists(paste0(data_dir, "processed"))) {
          dir.create(paste0(data_dir, "processed"))
        }
        assign("modelled_dir", value = "../data/modelled/", envir = .GlobalEnv)
        if (!dir.exists(paste0(modelled_dir))) {
          dir.create(paste0(modelled_dir))
        }
        assign("output_dir", value = "../output/", envir = .GlobalEnv)
        if (!dir.exists(paste0(output_dir))) {
          dir.create(paste0(output_dir))
        }
        assign("fig_dir", value = "../output/figures/", envir = .GlobalEnv)
        if (!dir.exists(paste0(fig_dir))) {
          dir.create(paste0(fig_dir))
        }
        paths <- list(
          data_dir =  data_dir,
          modelled_dir = modelled_dir,
          output_dir = output_dir,
          fig_dir = fig_dir
          )
        ## ----end
        paths
      }
    )
  )
}

