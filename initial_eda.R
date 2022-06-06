# Load package(s) ----
library(tidymodels)
library(tidyverse)
tidymodels_prefer()
set.seed(3013)

# Load data ----
shopper_dat <- read_csv("data/unprocessed/online_shoppers_intention.csv") %>% 
  janitor::clean_names() %>% 
  mutate(
    revenue = as.numeric(revenue)
  ) 

# Data checks ----
# Outcome/target variable

shopper_dat %>% 
  mutate(revenue = as.factor(revenue)) %>% 
  ggplot(aes(revenue)) +
  geom_bar()

# check missingness & look for extreme issues
naniar::miss_var_summary(shopper_dat)

# Multivariate analysis ----

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

shopper_dat %>% 
  mutate(revenue = as.factor(revenue)) %>% 
  ggplot(aes(month, fill = revenue)) +
  geom_bar()
