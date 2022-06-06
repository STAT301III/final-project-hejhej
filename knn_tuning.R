# KNN Tuning ----

# Load package(s) ----
library(tidyverse)
library(tidymodels)

# Handle common conflicts
tidymodels_prefer()

# Set seed
set.seed(2022)

# Load required objects ----
load("model_info/loan_class_recipe.rda")
load("model_info/loan_class_folds.rda")

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
  update(neighbors = neighbors(range = c(1,40)))

# Define grid
knn_grid <- grid_regular(knn_params, levels = 15)

# Define workflow ----
knn_workflow <- workflow() %>%
  add_model(knn_model) %>%
  add_recipe(loan_class_recipe)

# Tuning/fitting ----
knn_res <- knn_workflow %>%
  tune_grid(
    resamples = loan_class_folds,
    grid = knn_grid
  )

# Write out results and workflow
save(knn_res, knn_workflow, file = "model_info/knn_res.rda")
