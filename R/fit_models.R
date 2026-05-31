fit_models <- function() {
  targets <- list(
    ## Model 1 ============================================================================

    ## Version 3b
    tar_target(
      model_1_priors_v3b_, {
        data_mmp <- process_mmp_data_v3b_
        ## ---- fit model 1 priors v3b
        data_mmp |>
          group_by(DEPTH) |>
          summarise(
            mean_ma_cover = qlogis(mean(ma.points / algae.point, na.rm = TRUE)),
            mean_ma_cover2 = mean(qlogis(ma.points / algae.point), na.rm = TRUE),
            median_ma_cover = qlogis(median(ma.points / algae.point, na.rm = TRUE)),
            median_ma_cover2 = median(qlogis(ma.points / algae.point), na.rm = TRUE),
            mad_ma_cover2 = mad(qlogis(ma.points / algae.point), na.rm = TRUE),
            .groups = "drop"
          )
        priors <- prior(normal(0, 2), class = "Intercept") +
          ## prior(normal(0, 1), class = "b") +
          prior(student_t(3, 0, 2), class = "sd")
        ## ----end
        priors
      }
    ),
    tar_target(
      model_1_fit_v3b_, {
        data_mmp <- process_mmp_data_v3b_
        priors <- model_1_priors_v3b_
        paths <- prepare_directories_
        ## ---- fit model 1 fit v3b
        form <-
          bf(ma.points | trials(algae.point) ~ 1 + DEPTH +
               s(VISIT_NO, k = 10) +
               s(k490, by = DEPTH, k =  6) +
               (1 | REEF) +
               ## (1 | Site) +
               (1 | Transect),
            family = binomial(link = "logit")
          )
        mod <- brm(
          form,
          prior = priors,
          init = 0,
          sample_prior = "no",
          data = data_mmp,
          cores = 3, chains = 3,
          iter = 4000,
          warmup = 1000,
          thin = 10,
          seed =  123,
          threads = threading(10),
          control = list(adapt_delta = 0.95, max_treedepth = 15)
        )
        path <- paste0(paths$modelled_dir, "model_1_fit_v3b_.rds")
        saveRDS(mod, file = path)
        ## ----end
        path
      },
      format = "file"
    ),
    tar_target(
      model_1_priors_explore_v3b_, {
        mod <- readRDS(model_1_fit_v3b_)
        paths <- prepare_directories_
        ## ---- fit model 1 explore v3b
        ce <- conditional_effects(mod, effects = "k490:DEPTH")
        p <- plot(ce)
        ggsave(paste0(paths$fig_dir, "model_1_priors_explore2_v3b.png"),
          plot = p[[1]],
          width = 6, height = 4)
        ## ----end
      }
    ),
    tar_target(
      model_1_mcmc_diagnostics_1_v3b_, {
        mod <- readRDS(model_1_fit_v3b_)
        paths <- prepare_directories_
        ## ---- MCMC diagnostics model 1 1 v3b
        p <- stan_trace(mod$fit)
        ggsave(paste0(paths$fig_dir, "model_1_mcmc_diagnostics_1_v3b.png"),
          plot = p,
          width = 10, height = 6)
        ## ----end
      }
    ),
    tar_target(
      model_1_mcmc_diagnostics_2_v3b_, {
        mod <- readRDS(model_1_fit_v3b_)
        paths <- prepare_directories_
        ## ---- MCMC diagnostics model 1 2 v3b
        p <- stan_ac(mod$fit)
        ggsave(paste0(paths$fig_dir, "model_1_mcmc_diagnostics_2_v3b.png"),
          plot = p,
          width = 10, height = 6)
        ## ----end
      }
    ),
    tar_target(
      model_1_mcmc_diagnostics_3_v3b_, {
        mod <- readRDS(model_1_fit_v3b_)
        paths <- prepare_directories_
        ## ---- MCMC diagnostics model 1 3 v3b
        p <- stan_rhat(mod$fit)
        ggsave(paste0(paths$fig_dir, "model_1_mcmc_diagnostics_3_v3b.png"),
          plot = p,
          width = 10, height = 6)
        ## ----end
      }
    ),
    tar_target(
      model_1_mcmc_diagnostics_4_v3b_, {
        mod <- readRDS(model_1_fit_v3b_)
        paths <- prepare_directories_
        ## ---- MCMC diagnostics model 1 4 v3b
        p <- stan_ess(mod$fit)
        ggsave(paste0(paths$fig_dir, "model_1_mcmc_diagnostics_4_v3b.png"),
          plot = p,
          width = 10, height = 6)
        ## ----end
      }
    ),
    tar_target(
      model_1_mcmc_diagnostics_5_v3b_, {
        mod <- readRDS(model_1_fit_v3b_)
        paths <- prepare_directories_
        ## ---- MCMC diagnostics model 1 5 v3b
        p <- pp_check(mod, plotfun = "dens_overlay")
        ggsave(paste0(paths$fig_dir, "model_1_mcmc_diagnostics_5_v3b.png"),
          plot = p,
          width = 10, height = 6)
        ## ----end
      }
    )

  )
}

