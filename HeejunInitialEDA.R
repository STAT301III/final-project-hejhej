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

# Bounce rate is the overall percentage of visitors who enter the site from that page and leave without setting off any additional requests to the analytics server. Exit rates show the percentage of visitors on the site where they exit the website to a different website. The relationship showed here displays a positive one, where as exit rates increase, bounce rates increase. This could be the case as a high bounce rate means that user satisfaction was low whether it was due to site errors or very being slow. A high exit rate could mean lower performing sectors for the item, leading to customers leaving and never coming back. It is highly likely that these two are correlated. 


p1 <- ggplot(data = online_shoppers_intention, mapping = aes(x = Revenue)) + geom_bar(mapping = aes(fill = VisitorType)) + ggtitle("Revenue on visitor type") + xlab("Revenue") + ylab("Visitors") + theme(legend.position = "bottom")
p2 <- ggplot(data = online_shoppers_intention, mapping = aes(x = Revenue)) + geom_bar(mapping = aes(fill = Weekend)) + ggtitle("Revenue on weekend status") + xlab("Revenue") + ylab("Visitors") + theme(legend.position = "bottom")

library(patchwork)
(p1 + p2)

# These plots show the impact of loyal customers, especially throughout the weekend. It displays whether or not the companies had good retention rates with the customers and how much revenue they create. New customers at a frequent rate always mean higher revenue. According to the plots, more revenue was made during the weekday, being led by new customers instead of returning ones.
ggplot(data = online_shoppers_intention, mapping = aes(x = BounceRates, y = ExitRates)) + geom_point(mapping = aes(color = Revenue)) + geom_smooth(se = TRUE, alpha = 0.5) + theme_light() + ggtitle("Relationship between Exit Rates and Bounce Rates") + xlab("Exit Rates") + ylab("Bounce Rates")

# In this graph, we examined the relationship between time spent on the information page of the product vs time spent on pages that displayed product related items. This was hard to predict as not every customer is looking to buy an item related to the original product they intended on purchasing. It showed a rather unstable chart as though it ends on a positive relationship, there are small dips, especially before 1000 seconds for `Information_Duration`.