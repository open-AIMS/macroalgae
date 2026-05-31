process_data <- function() {
  targets <- list(
    
    ## Version 3b of the data
    ## Macroalgae
    tar_target(
      process_data_v3b_, {
        dirichlet_dat <- load_pre_joined_data_
        ## ---- process data v3b
        data <- dirichlet_dat |>
          mutate(
            Site = paste(REEF, SITE_NO),
            Transect = paste(Site, TRANSECT_NO),
            DEPTH = factor(DEPTH)
          )

        ## ----end
        data
      }
    ),
    tar_target(
      process_mmp_data_v3b_, {
        data <- process_data_v3b_
        ## ---- process mmp data v3b
        data_mmp <- data |>
          filter(!is.na(k490)) |>
          droplevels()

        ## ----end
        data_mmp
      }
    ),
    
    ## Macroalgae groups
    tar_target(
      process_ma_data_v3b_, {
        dirichlet_dat <- load_pre_joined_data_
        ## ---- process ma data v3b
        data_ma <- dirichlet_dat |>
          mutate(
            Site = paste(REEF, SITE_NO),
            Transect = paste(Site, TRANSECT_NO),
            DEPTH = factor(DEPTH)
          ) |>
          mutate(ma.points2 = rowSums(across(starts_with("MA_")), na.rm = TRUE)) |>
          mutate(across(starts_with("MA_"), ~ .x / ma.points, .names = "{.col}_prop"))
        ## ----end
        data_ma
      }
    ),    

    tar_target(
      process_mmp_ma_data_v3b_, {
        data_ma <- process_ma_data_v3b_
        ## ---- process ma sites data v3b
        data_ma_mmp <- data_ma |>
          filter(!is.na(k490)) |>
          droplevels()
        ## ----end
        data_ma_mmp
      }
    )

  )
}

