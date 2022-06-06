# Linear model ----

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(stacks)

# Handle common conflicts
tidymodels_prefer()

# load required objects ----
load("data/general_setup.rda")

# usemodels::use_glmnet(revenue ~ . , data = shopper_dat, verbose = T, clipboard = T)


# Define model ----
glmnet_model <- logistic_reg(penalty = tune(), mixture = tune()) %>% 
  set_mode("classification") %>% 
  set_engine("glmnet") 

hardhat::extract_parameter_set_dials(glmnet_model)

# Recipe
glmnet_recipe <- 
  recipe(formula = revenue ~ ., data = shopper_train) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_nzv(all_predictors()) %>%
  step_normalize(all_numeric_predictors())

glmnet_recipe %>%
  prep(shopper_train) %>%
  bake(new_data = NULL) %>% view()

# workflow ----
glmnet_workflow <- workflow() %>%
  add_model(glmnet_model) %>%
  add_recipe(glmnet_recipe)


# set-up tuning grid ----
glmnet_params <- hardhat::extract_parameter_set_dials(glmnet_model) %>%
  update(mixture = mixture(range = c(0, 1)),
         penalty = penalty())

# define grid
glmnet_grid <- grid_regular(glmnet_params, levels = 4)



# Tuning/fitting ----
glmnet_res <- glmnet_workflow %>%
  tune_grid(
    resamples = shopper_folds,
    grid = glmnet_grid,
    control = stacks::control_stack_grid()
  )


# Write out results & workflow
save(glmnet_res, file = "data/glmnet_res.rda")
load("data/glmnet_res.rda")

glmnet_res %>%
  collect_metrics() %>%
  filter(.metric == "accuracy") %>%
  arrange(desc(mean))

# glmnet_workflow_tuned <- glmnet_workflow %>%
#   finalize_workflow(select_best(glmnet_res, metric = "accuracy"))
# glmnet_result <- fit(glmnet_workflow_tuned, shopper_train)
# 
# glmnet_result %>% 
#     extract_fit_parsnip() %>%
#     vip::vip()

# 
# glmnet_res %>% autoplot()
# 
# 
# glmnet_params <- 
#   tibble(
#     mixture = 1,
#     penalty = 0.00316
#   )
# 
# final_wflow <- 
#   glmnet_res %>% 
#   extract_workflow() %>% 
#   finalize_workflow(parameters = glmnet_params)
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

