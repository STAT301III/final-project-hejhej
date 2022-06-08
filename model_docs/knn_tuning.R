# KNN Tuning ----

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(dOMC)

# Handle common conflicts
tidymodels_prefer()

# Set seed
set.seed(2022)

# Load required objects ----
load("data/general_setup.rda")

# Define model ----
knn_model <- nearest_neighbor(
  mode = "classification",
  neighbors = tune()
) %>%
  set_engine("kknn")

# Check tuning parameters
parameters(knn_model)

# Set-up tuning grid ----
knn_params <- parameters(knn_model) %>%
  update(neighbors = neighbors(range = c(1,20)))

# Define grid
knn_grid <- grid_regular(knn_params, levels = 5)

# Define workflow ----
knn_workflow <- workflow() %>%
  add_model(knn_model) %>%
  add_recipe(shopper_recipe)

# Tuning/fitting ----
knn_res <- knn_workflow %>%
  tune_grid(
    resamples = shopper_folds,
    grid = knn_grid,
    control = stacks::control_stack_grid()
  )

# Write out results and workflow
save(knn_res, knn_workflow, file = "results/knn_res.rda")