# Load package(s) ----
library(tidymodels)
library(tidyverse)
tidymodels_prefer()
set.seed(3013)

# Load & clean data
shopper_dat <- read_csv("data/unprocessed/online_shopper_intention.csv") %>% 
  janitor::clean_names() %>% 
  mutate(
    month = as.factor(month),
    weekend = as.factor(weekend),
    visitor_type = as.factor(visitor_type),
    revenue = as.factor(revenue)
  )


# Split & fold data 
shopper_split <- initial_split(shopper_dat, prop = 0.7, strata = revenue)

shopper_train <- training(shopper_split)
shopper_test <- testing(shopper_split)

shopper_folds <- vfold_cv(shopper_dat, v = 5, repeats = 3, strata = revenue)


# Recipe
shopper_recipe <- recipe(revenue ~ ., data = shopper_train) %>%  
  step_novel(all_nominal_predictors())%>%
  step_nzv(all_predictors()) %>%
  step_normalize(all_numeric_predictors())

# Save ----
save(shopper_train, shopper_test, shopper_folds, shopper_recipe, file = "data/general_setup.rda")