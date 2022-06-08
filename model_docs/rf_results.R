library(tidyverse)
library(tidymodels)

load(file = "results/rf_res.rda")

show_best(rf_result, metric = "accuracy") 

rf_workflow_tuned <- rf_workflow %>%
  finalize_workflow(select_best(rf_tune, metric = "accuracy"))
rf_result <- fit(rf_workflow_tuned, shopper_train)

rf_result %>%
  extract_fit_parsnip() %>%
  vip::vip()

shopper_result <- predict(rf_result, new_data = shopper_test)

shopper_result <- bind_cols(shopper_result, shopper_test)
accuracy(shopper_result, truth = revenue, estimate = .pred_class)

save(rf_workflow_tuned, rf_result, file = "results/rf_result.rda")
save(shopper_result, file = "results/shopper_result.rda")
load("results/rf_res.rda")
