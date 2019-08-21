rm(list = ls())
require(dplyr)
require(tidyr)
require(ggplot2)
require(CHAID)
require(kableExtra) # just to make the output nicer
theme_set(theme_bw()) # set theme for ggplot2

#find missing data
churn %>%
  select_if(anyNA) %>% summary

#impute missing values with median and knn
xxx <- churn %>%
  filter_all(any_vars(is.na(.))) %>% 
  select(customerID)
xxx <- as.vector(xxx$customerID)
xxx
churn %>% filter(customerID %in% xxx)
churn %>% 
  filter(customerID %in% xxx) %>% 
  summarise(median(MonthlyCharges))
median(churn$MonthlyCharges, na.rm = TRUE)
churn %>% 
  filter(customerID %in% xxx) %>% 
  summarise(median(tenure))
median(churn$tenure, na.rm = TRUE)
# using k nearest neighbors
pp_knn <- preProcess(churn, method = c("knnImpute", "YeoJohnson", "nzv"))
# simple output
pp_knn
# more verbose
pp_knn$method
# using medians
pp_median <- preProcess(churn, method = c("medianImpute", "YeoJohnson", "nzv"))
pp_median
pp_median$method
nchurn1 <- predict(pp_knn,churn) #put predicted values in the missing places
nchurn2 <- predict(pp_median,churn)
nchurn2 %>% 
  filter(customerID %in% xxx) %>% 
  summarise(median(TotalCharges))
median(nchurn2$TotalCharges, na.rm = TRUE)
nchurn1 %>% 
  filter(customerID %in% xxx) %>% 
  summarise(median(TotalCharges))
median(nchurn1$TotalCharges, na.rm = TRUE)
nchurn1 %>%
  select_if(is.numeric) %>%
  gather(metric, value) %>%
  ggplot(aes(value, fill = metric)) +
  geom_density(show.legend = FALSE) +
  facet_wrap( ~ metric, scales = "free")
nchurn2 %>%
  select_if(is.numeric) %>%
  gather(metric, value) %>%
  ggplot(aes(value, fill = metric)) +
  geom_density(show.legend = FALSE) +
  facet_wrap( ~ metric, scales = "free")
churn <- predict(pp_knn,churn)
churn$customerID <- NULL
str(churn)
churn <- churn %>%
  mutate_if(is.numeric, 
            funs(factor = cut_number(., n=5, 
                                     labels = c("Lowest","Below Middle","Middle","Above Middle","Highest"))))
summary(churn)
