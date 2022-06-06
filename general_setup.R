# Load package(s) ----
library(tidymodels)
library(tidyverse)
library(lubridate)

# Handle common conflicts
tidymodels_prefer()

# Seed
set.seed(3013)

# Load data ----
shopper_dat <- read_csv("data/unprocessed/online_shoppers_intention.csv") %>% 
  mutate(
    Revenue = as.numeric(Revenue)
  ) %>% 
  janitor::clean_names()

# Data checks ----
# Outcome/target variable

shopper_dat %>% 
  mutate(revenue = as.factor(revenue)) %>% 
  ggplot(aes(revenue)) +
  geom_bar()

# check missingness & look for extreme issues
naniar::miss_var_summary(shopper_dat)

# EDA ----


shopper_dat %>%
  select_if(is.numeric) %>%
  cor() %>%
  corrplot::corrplot()

shopper_dat %>% 
  mutate(revenue = as.factor(revenue)) %>% 
  ggplot(aes(operating_systems, fill = revenue)) +
  geom_bar(position = "fill")

shopper_dat %>% 
  mutate(revenue = as.factor(revenue)) %>% 
  ggplot(aes(browser, fill = revenue)) +
  geom_bar(position = "fill")

shopper_dat %>% 
  mutate(revenue = as.factor(revenue)) %>% 
  ggplot(aes(traffic_type, fill = revenue)) +
  geom_bar(position = "fill")

shopper_dat %>% 
  mutate(revenue = as.factor(revenue)) %>% 
  ggplot(aes(visitor_type, fill = revenue)) +
  geom_bar(position = "fill")

shopper_dat %>% 
  mutate(revenue = as.factor(revenue)) %>% 
  ggplot(aes(weekend, fill = revenue)) +
  geom_bar(position = "fill")

shopper_dat %>% 
  mutate(revenue = as.factor(revenue)) %>% 
  ggplot(aes(month, fill = revenue)) +
  geom_bar(position = "fill")



# Folds ---- 
folds <- vfold_cv(shopper_dat, v = 5, repeats = 3, strata = revenue)




# Save ----
save(folds, file = "data/general_setup.rda")



