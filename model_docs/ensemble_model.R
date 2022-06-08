# Load package(s) ----
library(tidymodels)
library(tidyverse)
library(stacks)

# Handle common conflicts
tidymodels_prefer()

# Load candidate model info ----
load("results/rf_tune.rda")
load("results/glmnet_res.rda")
load("results/knn_res.rda")

# Load split data object & get testing data
load("data/general_setup.rda")

shopper_test <- shopper_split %>% testing()

# Create data stack ----
shopper_data_st <- stacks() %>% 
  add_candidates(glmnet_res) %>% 
  add_candidates(knn_res) %>%
  add_candidates(rf_tune)

# Fit the stack ----
# penalty values for blending (set penalty argument when blending)
blend_penalty <- c(10^(-6:-1), 0.5, 1, 1.5, 2)

# Blend predictions using penalty defined above (tuning step, set seed)
set.seed(9876)

# Save blended model stack for reproducibility & easy reference (Rmd report)
shopper_model_st <-
  shopper_data_st %>%
  blend_predictions(penalty = blend_penalty)

save(shopper_model_st, file = "results/shopper_model_st.rda")

# Explore the blended model stack
autoplot(shopper_model_st)
autoplot(shopper_model_st, type = "members")
autoplot(shopper_model_st, type = "weights")

shopper_model_st %>% 
  show_best(metric = metric_set(accuracy))



# fit to ensemble to entire training set ----
shopper_fit <-
  shopper_model_st %>%
  fit_members()

# Save trained ensemble model for reproducibility & easy reference (Rmd report)
save(shopper_model_st, shopper_fit, file = 'model_info/ensemble_model.rda')

# Explore and assess trained ensemble model
