# Load package(s) ----
library(tidymodels)
library(tidyverse)
library(stacks)

# Handle common conflicts
tidymodels_prefer()

# Load candidate model info ----
load("model_info/rf_result.rda")

# Load split data object & get testing data
load("data/shopper_split.rda")

shopper_test <- shopper_split %>% testing()

# Create data stack ----
shopper_data_st <- stacks() %>% 
  add_candidates(knn_res) %>% 
  add_candidates(svm_res) %>% 
  add_candidates(lin_reg_res)

# Fit the stack ----
# penalty values for blending (set penalty argument when blending)
blend_penalty <- c(10^(-6:-1), 0.5, 1, 1.5, 2)

# Blend predictions using penalty defined above (tuning step, set seed)
set.seed(9876)

# Save blended model stack for reproducibility & easy reference (Rmd report)
shopper_model_st <-
  shopper_data_stack %>%
  blend_predictions()

# Explore the blended model stack
autoplot(shopper_model_st, type = "weights")

# fit to ensemble to entire training set ----
shopper_fit <-
  shopper_model_st %>%
  fit_members()

# Save trained ensemble model for reproducibility & easy reference (Rmd report)
save(shopper_model_st, shopper_fit, file = 'model_info/ensemble_model.rda')

# Explore and assess trained ensemble model
