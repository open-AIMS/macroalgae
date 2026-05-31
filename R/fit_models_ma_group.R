fit_models_ma_group <- function() {
  targets <- list(
    tar_target(
      make_brms_dharma_res_, {
        ## ---- make_brms_dharma_res function
        make_brms_dharma_res <- function(brms_model, seed = 10, ...) {
          # equivalent to `simulateResiduals(lme4_model, use.u = FALSE)`
          # cores are set to 1 just to ensure reproducibility
          options(mc.cores = 1)
          on.exit(options(mc.cores = parallel::detectCores()))
          response <- brms::standata(brms_model)$Y
          ndraws <- nrow(as_draws_df(brms_model))
          manual_preds_brms <- matrix(0, ndraws, nrow(brms_model$data))
          random_terms <- insight::find_random(
            brms_model, split_nested = TRUE, flatten = TRUE
          )
          # for this to have a similar output to `glmmTMB`'s default, we need to
          #   create new levels in the hierarchical variables, so then we can
          #   use `allow_new_levels = TRUE` and `sample_new_levels = "gaussian"` in
          #   `brms::posterior_epred`. This is equivalent to
          #   `simulateResiduals(lme4_model, use.u = FALSE)`. See details in
          #   `lme4:::simulate.merMod` and `glmmTMB:::simulate.glmmTMB`
          new_data <- brms_model$data |>
            dplyr::mutate(across(
              all_of(random_terms), \(x)paste0("NEW_", x) |> as.factor()
            ))
          set.seed(seed)
          brms_sims <- brms::posterior_predict(
            brms_model, re_formula = NULL, newdata = new_data,
            allow_new_levels = TRUE, sample_new_levels = "gaussian"
          ) 
          fitted_median_brms <- apply(brms_sims, 2:3, median)
          ## fitted_median_brms <- apply(
          ##     t(brms::posterior_epred(brms_model, ndraws = ndraws, re.form = NA)),
          ##     1,
          ##     mean)
          l <- lapply(1:ncol(response), FUN = function(x) {
            DHARMa::createDHARMa(
              simulatedResponse = t(brms_sims[,,x]),
              observedResponse = response[,x],
              fittedPredictedResponse = fitted_median_brms[,x]
            )
          })
          return(l)
        }
        ## ----
        make_brms_dharma_res
      }
    ),

    tar_target(
      model_3_data_prep_v3b_, {
        data_ma_mmp <- process_mmp_ma_data_v3b_
        ## ---- fit model 3 data prep v3b
        Y <- data_ma_mmp |>
          mutate(across(matches("MA_.*_prop"), ~ ifelse(.x == 0, 0.001, ifelse(.x == 1, 0.999, .x)))) |>
          dplyr::select(matches("MA_.*_prop")) |>
          mutate(ma.points = rowSums(across(matches("MA_.*_prop")))) |>
          mutate(across(starts_with("MA_"), ~ .x / ma.points)) |>
          dplyr::select(matches("MA_.*_prop")) |>
          as.matrix()
        data_ma_mmp$Y <- Y
        ## ----end
        data_ma_mmp
      })
    
   ) 
}
