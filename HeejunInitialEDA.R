library(readr)
online_shoppers_intention <- read_csv("data/unprocessed/online_shoppers_intention.csv")
View(online_shoppers_intention)

str(online_shoppers_intention)

skimr:: skim_without_charts(online_shoppers_intention)

library(ggplot2)
library(tidyverse)

online_shoppers_intention %>% 
  ggplot(aes(x = Informational_Duration, y = ProductRelated_Duration)) +
  geom_point(alpha = 0.5) +
  geom_smooth()

ggplot(data = online_shoppers_intention, mapping = aes(x = OperatingSystems, colour = Month)) +
  geom_freqpoly(binwidth = 0.1)

p1 <- ggplot(data = online_shoppers_intention, mapping = aes(x = Revenue)) + geom_bar(mapping = aes(fill = VisitorType)) + ggtitle("Revenue on visitor type") + xlab("Revenue") + ylab("Visitors") + theme(legend.position = "bottom")
p2 <- ggplot(data = online_shoppers_intention, mapping = aes(x = Revenue)) + geom_bar(mapping = aes(fill = Weekend)) + ggtitle("Revenue on weekend status") + xlab("Revenue") + ylab("Visitors") + theme(legend.position = "bottom")

library(patchwork)
(p1 + p2)

ggplot(data = online_shoppers_intention, mapping = aes(x = BounceRates, y = ExitRates)) + geom_point(mapping = aes(color = Revenue)) + geom_smooth(se = TRUE, alpha = 0.5) + theme_light() + ggtitle("Relationship between Exit Rates and Bounce Rates") + xlab("Exit Rates") + ylab("Bounce Rates")

