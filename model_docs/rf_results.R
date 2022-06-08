library(tidyverse)
library(tidymodels)

load(file = "model_info/rf_tune2.rda")

show_best(rf_tune, metric = "accuracy") 

rf_workflow_tuned <- rf_workflow %>%
  finalize_workflow(select_best(rf_tune, metric = "accuracy"))
rf_result <- fit(rf_workflow_tuned, shopper_train)

rf_result %>%
  extract_fit_parsnip() %>%
  vip::vip()

shopper_result <- predict(rf_result, new_data = shopper_test %>% select(-survived))

shopper_result <- bind_cols(shopper_result, shopper_test %>% select(survived))
accuracy(shopper_result, truth = survived, estimate = .pred_class)

save(rf_workflow_tuned, rf_result, file = "results/rf_result.rda")