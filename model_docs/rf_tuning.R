# Load package(s) ----
library(tidymodels)
library(tidyverse)
library(doMC)

# register cores/threads for parallel processing
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# Handle common conflicts
tidymodels_prefer()

# seed
set.seed(3013)

# load

load("data/general_setup.rda")

# Recipe
shopper_recipe <- recipe(revenue ~ ., data = shopper_train) %>%  
  step_novel(all_nominal_predictors()) %>% 
  step_nzv(all_predictors()) %>%
  step_normalize(all_numeric_predictors())


# Define model ----
rf_model <- rand_forest(mode = "classification",
                        mtry = tune()) %>%
  set_engine("ranger", importance = "impurity")

## tune mtry and min_n

# set-up tuning grid ----
rf_params <- parameters(rf_model) %>% 
  update(mtry = mtry(c(1, 10)))

# define tuning grid
rf_grid <- grid_regular(rf_params, levels = 2)

# workflow ----
rf_workflow <- workflow() %>% 
  add_model(rf_model) %>% 
  add_recipe(shopper_recipe)

# Tuning/fitting ----
rf_tune <- rf_workflow %>% 
  tune_grid(
    resamples = shopper_folds,
    grid = rf_grid,
    control = stacks::control_stack_grid()
  )

# Write out results & workflow
save(shopper_split, rf_workflow, rf_tune, file = "model_info/rf_tune.rda")
