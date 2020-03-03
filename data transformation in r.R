# data transformation

rm(list=ls())
#logical operators
library(dplyr)
x<-c(1,1,3,4)
y<-c(0,1,1,6)
data<-cbind.data.frame(x,y)
data
filter(data,y==1) #rows where y is 1
filter(data,x==y) #rows where x equals y
filter(data,x==1 & y==1) #rows where x AND y both equal 1
filter(data,x==1|y==1) #rows where either x or y is 1 inclusive
filter(data,xor(x==1,y==1)) #rows where either x or y is 1 exclusive
filter(data,y!=1) #y is not equal to 1
filter(data,x!=1 & y!=1) #neither x nor y equals 1


#missing values
df<-tibble(x=c(1,NA,3),y=c(NA,2,4))
df
is.na(df)
#check which variable has missing values at any point
colnames(df)[apply(df,2,anyNA)]
filter(df,x>1) #NA does not show up
filter(df,is.na(x)|x>1)
filter(df,is.na(y)|x>1)
filter(df,is.na(y) & x>1) # no such value


rm(list=ls())
install.packages("tidyverse")
#install.packages("nycflights13")
library(tidyverse)
library(nycflights13)
#data
flights
#subset of the data
jan1<-filter(flights, month==1, day==1)
dec25<-filter(flights, month==12, day==25)
nov_dec<-filter(flights, month==11|month==12)
nov_dec<-filter(flights, month %in% c(11,12))

filter(flights, !(arr_delay>120|dep_delay>120))
#gives the same subset as
filter(flights, arr_delay<=120, dep_delay<=120)


# Arraging rows with arrange
rm(list=ls())
library(tidyverse)
library(nycflights13)
library(dplyr)
arrange(flights, year, month, day)
arrange(flights, desc(arr_delay)) #arrange descendant by arr_delay
# missing values are always sorted at the end


# select the specific variables
vars<-c("year", "month")
flights[,vars]
#equivalently
select(flights, vars)
# Selecting specific columns/variables
select(flights, year, month, day)
# select a range of variables
head(flights)
select(flights, year:day)
# omit the range from viewing
select(flights, -(year:day))
# select variables with a common starting character
select(flights, starts_with("dep_"))
# select variables with a commong ending character
select(flights, ends_with("delay"))
# select variables with a common character in the name
select(flights, contains("dep"))
# select variables that match a regular expression
select(flights, matches("time"))
# select variables with consecutive names
df<-tibble(x1=1,x2=1,x3=1,x4=1)
df
select(df,num_range("x",1:2))


# renaming a variable
rename(flights, jahr=year, dau=day)

# moving variables to the beginning of the data frame
select(flights, time_hour, air_time, everything())

# adding new variables with mutate
head(flights)
# doesn't show all variables
# see all variables
View(flights)
# create a data frame with fewer variables
flights_sml<-select(flights, 
                    ends_with("delay"), 
                    distance, 
                    air_time)
head(flights_sml)
# generate gain and speed variables
mutate(flights_sml,
       gain=arr_delay-dep_delay,
       speed=distance/air_time*60)
# putting the new variables into calculation
mutate(flights_sml,
       gain=arr_delay-dep_delay,
       hours=air_time/60,
       gai_per_hour=gain/hours)

# use of modular arithmetic in variable creation
transmute(flights,
          dep_time,
          hour = dep_time %/% 100, #integer division
          minute = dep_time %% 100, #reminder
          log_dep_time=log(dep_time)
)

# lead and lag values
abc<-transmute(flights,
          dep_time,
          lag_dt=lag(dep_time), #lag
          lead_dt=lead(dep_time), #lead
          cumsum_dt=cumsum(dep_time), #cumulative sum
          cummean_dt=cummean(dep_time) #cumulative mean
)

# Ranking in the data
y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
min_rank(desc(y))
row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)

# Grouped summaries with summarize()
# removes na values
summarize(flights, delay=mean(dep_delay, na.rm=TRUE))
# grouping
by_day<-group_by(flights, year, month, day)
# mean by group
summarize(by_day, delay=mean(dep_delay, na.rm=TRUE))
# sum by group
summarize(by_day, delay=sum(dep_delay, na.rm=TRUE))
# combining multiple summaries
by_dest<-group_by(flights, dest)
delay<-summarize(by_dest,
                 count=n(),
                 dist=mean(distance, na.rm=TRUE),
                 delay=mean(arr_delay, na.rm=TRUE)
                 )
delay
# removing outlier honolulu
delay<-filter(delay, count>20, dest!="HNL")
delay
library(ggplot2)
ggplot(data=delay,aes(x=dist,y=delay))+
#  geom_point(aes(size=count), alpha=1/3)+
  geom_smooth(se=FALSE)+
  geom_text(aes(label=dest),hjust=0,vjust=0)

# Using pipe for the same problem
# This way we don't have to give names
delays<-flights %>%
  group_by(dest) %>%
  summarize(
    count=n(),
    dist=mean(distance,na.rm=TRUE),
    delay=mean(arr_delay,na.rm=TRUE)
  ) %>%
  filter(count>20,dest!="HNL")
delays


# missing values
flights %>% 
#  na.omit() %>% 
  group_by(year, month, day) %>% 
  summarize(mean=mean(dep_delay,na.rm=T))
# we can as well remove the missing values beforehand
not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(mean = mean(dep_delay))

# replace missing values to zero
# first create another data set
flights1<-select(flights, year:arr_time)
head(flights1)
# check for missing values
colnames(flights1)[apply(flights1,2,anyNA)]
flights1$dep_delay[is.na(flights1$dep_delay)]<-0
# missing values are gone!
colnames(flights1)[apply(flights1,2,anyNA)]

# Summarize with last non-missing value
d<-data.frame(matrix(c("a","a","a","b","b",NA,5,1,3,4),ncol=2))
d
d %>%
  mutate_all(as.character) %>%
  group_by(X1) %>%
  summarise_all(~last(.[!is.na(.)])) %>%
  ungroup()
