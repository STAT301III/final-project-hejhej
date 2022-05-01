library(readr)
library(ggplot2)
library(tidyverse)
library(patchwork)

shop_dat <- 
  read_csv("data/unprocessed/online_shoppers_intention.csv") %>% 
  janitor::clean_names()

skim(shop_dat)

ggplot(shop_dat, aes(revenue)) +
  geom_bar()

ggplot(shop_dat, aes(visitor_type)) +
  geom_bar()

ggplot(shop_dat, aes(month)) +
  geom_bar()

ggplot(shop_dat, aes(weekend)) +
  geom_bar()

ggplot(shop_dat, aes(special_day)) +
  geom_bar()

ggplot(shop_dat, aes(bounce_rates)) +
  geom_histogram()

ggplot(shop_dat, aes(exit_rates)) +
  geom_histogram()