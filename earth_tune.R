# Linear model ----

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(stacks)

# Handle common conflicts
tidymodels_prefer()

# load required objects ----
load("data/general_setup.rda")

# usemodels::use_earth(revenue ~ . , data = shopper_dat, verbose = T, clipboard = T)


# Define model ----
earth_model <- 
  mars(num_terms = tune(), prod_degree = tune(), prune_method = "none") %>% 
  set_mode("classification") %>% 
  set_engine("earth") 

hardhat::extract_parameter_set_dials(earth_model)

# Recipe
earth_recipe <- shopper_recipe %>% 
  step_select(revenue, page_values, bounce_rates, month, product_related, administrative, exit_rates) %>% 
  step_dummy(all_nominal_predictors()) %>% 
  step_nzv(all_predictors())

earth_recipe %>%
  prep(shopper_train) %>%
  bake(new_data = NULL) %>% view()

# workflow ----
earth_workflow <- workflow() %>%
  add_model(earth_model) %>%
  add_recipe(earth_recipe)


# set-up tuning grid ----
earth_params <- hardhat::extract_parameter_set_dials(earth_model) %>%
  update(num_terms = num_terms(range = c(2, 12)),
         prod_degree = prod_degree(range = c(1, 2)))

# define grid
earth_grid <- grid_regular(earth_params, levels = 5)



# Tuning/fitting ----
earth_res <- earth_workflow %>%
  tune_grid(
    resamples = shopper_folds,
    grid = earth_grid,
    control = stacks::control_stack_grid()
  )


# Write out results & workflow
save(earth_res, file = "data/earth_res.rda")
load("data/earth_res.rda")

earth_res %>%
  collect_metrics() %>%
  filter(.metric == "accuracy") %>%
  arrange(desc(mean))

# earth_workflow_tuned <- earth_workflow %>%
#   finalize_workflow(select_best(earth_res, metric = "accuracy"))
# earth_result <- fit(earth_workflow_tuned, shopper_train)
# 
# earth_result %>% 
#     extract_fit_parsnip() %>%
#     vip::vip()
  
# 
# earth_res %>% autoplot()
# 
# 
# earth_params <- 
#   tibble(
#     mixture = 1,
#     penalty = 0.00316
#   )
# 
# final_wflow <- 
#   earth_res %>% 
#   extract_workflow() %>% 
#   finalize_workflow(parameters = earth_params)
# 
# set.seed(3012)
# 
# final_model_fit <- 
#   final_wflow %>% 
#   fit(shopper_train)
# 
# 
# results <- test %>%
#   bind_cols(
#     predict(final_model_fit, new_data = test)
#   ) %>% 
#   mutate(Category = .pred_class) %>% 
#   select(id, Category)
# 
# write_csv(results, "data/results.csv")

