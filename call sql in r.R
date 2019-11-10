rm(list=ls())
#call sql in r
#install.packages(c("DBI","odbc"))
install.packages("dplyr")
library(DBI)
library(dplyr)
#library(dbplyr)
library(odbc)
con <- dbConnect(odbc::odbc(), "Oracle DB")

dbGetQuery(con,'
  select "month_idx", "year", "month",
           sum(case when "term_deposit" = \'yes\' then 1.0 else 0.0 end) as subscribe,
           count(*) as total
           from "bank"
           group by "month_idx", "year", "month"
           ')