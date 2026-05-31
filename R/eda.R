eda <- function() {
  targets <- list(

    ## Data version 3b - k490 focussed
    ## Macroalgae
    tar_target(
      eda_plot_1b_, {
        ## ---- eda plot 1b function
        eda_plot_1b <- function(data) {
          g1 <- data |>
            ggplot(aes(x = ma.points / algae.point)) +
            geom_histogram() +
            theme_bw()
          g2 <- data |>
            group_by(Site, VISIT_NO, DEPTH) |>
            summarise(
              mean_ma_cover = mean(ma.points / algae.point, na.rm = TRUE),
              median_ma_cover = median(ma.points / algae.point, na.rm = TRUE),
              k490 = mean(k490),
              .groups = "drop"
            ) |>
            group_by(Site, DEPTH) |>
            summarise(
              mean_ma_cover = mean(mean_ma_cover),
              median_ma_cover = median(median_ma_cover),
              k490 = mean(k490),
              .groups = "drop"
            ) |>
            ggplot(aes(x = k490, y = mean_ma_cover,
              colour = factor(DEPTH), fill = factor(DEPTH))) +
            geom_point() +
            geom_smooth(method = "loess") +
            labs(x = "k490", y = "Proportion of MA") +
            theme_bw()

          g1 + g2
        }
        ## ----end
        eda_plot_1b
      }
    ),
    tar_target(
      eda_figure_1_v3b, {
       eda_plot_1b <- eda_plot_1b_ 
       data_mmp <- process_mmp_data_v3b_
       paths <- prepare_directories_
       ## ---- eda figure 1 v3b
       ggsave(file = paste0(paths$fig_dir, "eda_1_v3b.png"),
         eda_plot_1b(data_mmp),
         width = 10, height = 6)
       ## ----end
      }
    ),
    ## Macroalgae groups
    tar_target(
      eda_plot_2b_, {
        ## ---- eda plot 2b function
        eda_plot_2b <- function(data) {
          g1 <- data |>
            pivot_longer(
              cols = starts_with("MA_"),
              names_to = "MA_group",
              values_to = "MA_cover"
            ) |>
            filter(str_detect(MA_group, "prop")) |>
            ggplot(aes(x = MA_cover, fill = MA_group)) +
            geom_density(alpha = 0.4) +
            facet_grid(~DEPTH) +
            theme_bw()

          g2 <- data |>
            pivot_longer(
              cols = starts_with("MA_"),
              names_to = "MA_group",
              values_to = "MA_cover"
            ) |>
            filter(str_detect(MA_group, "prop")) |>
            group_by(Site, VISIT_NO, DEPTH, MA_group) |>
            summarise(
              mean_ma_cover = mean(MA_cover, na.rm = TRUE),
              median_ma_cover = median(MA_cover, na.rm = TRUE),
              k490 = mean(k490),
              .groups = "drop"
            ) |>
            group_by(Site, DEPTH, MA_group) |>
            summarise(
              mean_ma_cover = mean(mean_ma_cover),
              median_ma_cover = median(median_ma_cover),
              k490 = mean(k490),
              .groups = "drop"
            ) |>
            ggplot(aes(x = k490, y = mean_ma_cover,
              colour = MA_group, fill = MA_group)) +
            geom_point() +
            geom_smooth(method = "loess") +
            labs(x = "k490", y = "Proportion of MA") +
            facet_grid(~DEPTH) +
            theme_bw()

          g1 + g2 +
            plot_layout(guides = "collect")
        }
        ## ----end
        eda_plot_2b  
      }
    ),
    tar_target(
      eda_figure_2_v3b, {
       eda_plot_2b <- eda_plot_2b_ 
       data_mmp_ma <- process_mmp_ma_data_v3b_
       paths <- prepare_directories_
       ## ---- eda figure 2 v3b
       ggsave(file = paste0(paths$fig_dir, "eda_2_v3b.png"),
         eda_plot_2b(data_mmp_ma),
         width = 12, height = 4)
       ## ----end
      }
    ),

    ## Brown algae
    tar_target(
      eda_plot_3b_, {
        ## ---- eda plot 3b function
        eda_plot_3b <- function(data) {
          g1 <- data |>
            mutate(brown.points = MA_BROWN) |>
            mutate(across(c("Lobophora", "Sargassaceae", "Other_brown"),
              ~ .x / brown.points)) |> 
            pivot_longer(
              cols = c("Lobophora", "Sargassaceae", "Other_brown"),
              names_to = "Browns",
              values_to = "MA_cover"
            ) |>
            ## filter(str_detect(Browns, "prop")) |>
            ggplot(aes(x = MA_cover, fill = Browns)) +
            geom_density(alpha = 0.4) +
            facet_grid(~DEPTH) +
            theme_bw()

          g2 <- data |>
            mutate(brown.points = MA_BROWN) |>
            mutate(across(c("Lobophora", "Sargassaceae", "Other_brown"),
              ~ .x / brown.points)) |> 
            pivot_longer(
              cols = c("Lobophora", "Sargassaceae", "Other_brown"),
              names_to = "Browns",
              values_to = "MA_cover"
            ) |>
            ## filter(str_detect(Browns, "prop")) |>
            group_by(Site, VISIT_NO, DEPTH, Browns) |>
            summarise(
              mean_ma_cover = mean(MA_cover, na.rm = TRUE),
              median_ma_cover = median(MA_cover, na.rm = TRUE),
              k490 = mean(k490),
              .groups = "drop"
            ) |>
            group_by(Site, DEPTH, Browns) |>
            summarise(
              mean_ma_cover = mean(mean_ma_cover),
              median_ma_cover = median(median_ma_cover),
              k490 = mean(k490),
              .groups = "drop"
            ) |>
            ggplot(aes(x = k490, y = mean_ma_cover,
              colour = Browns, fill = Browns)) +
            geom_point() +
            geom_smooth(method = "loess") +
            labs(x = "k490", y = "Proportion of Brown algae") +
            facet_grid(~DEPTH) +
            theme_bw()

          g1 + g2 +
            plot_layout(guides = "collect")
        }
        ## ----end
        eda_plot_3b  
      }
    ),
    tar_target(
      eda_figure_3_v3b, {
       eda_plot_3b <- eda_plot_3b_ 
       data_mmp_ma <- process_mmp_ma_data_v3b_
       paths <- prepare_directories_
       ## ---- eda figure 3 v3b
       ggsave(file = paste0(paths$fig_dir, "eda_3_v3b.png"),
         eda_plot_3b(data_mmp_ma),
         width = 12, height = 4)
       ## ----end
      }
    )
    


  )
}



