library(tidyverse)
library(dbplyr)
df <- read.csv('PERM_Disclosure_Data_FY2020_Q2.csv')


emp <- df%>%select(CASE_STATUS, RECEIVED_DATE, DECISION_DATE,EMPLOYER_NAME:EMPLOYER_STATE_PROVINCE, EMPLOYER_POSTAL_CODE, EMPLOYER_NUM_EMPLOYEES:NAICS_CODE,PW_SOC_CODE:PW_UNIT_OF_PAY)

emp$EMPLOYER_POSTAL_CODE <- as.character(emp$EMPLOYER_POSTAL_CODE)
emp$EMPLOYER_CITY <- toupper(emp$EMPLOYER_CITY)
emp$EMPLOYER_STATE_PROVINCE <- toupper(emp$EMPLOYER_STATE_PROVINCE)
for (row in 1:nrow(emp)){
  zipcode <- emp$EMPLOYER_POSTAL_CODE[row]
  if (nchar(zipcode)==10){
    emp$EMPLOYER_POSTAL_CODE[row] <- substr(zipcode, 1,5)
  }
}

emp_loc <- emp %>% group_by(EMPLOYER_STATE_PROVINCE, EMPLOYER_CITY, EMPLOYER_POSTAL_CODE) %>%
  summarise(count = n()) %>%
  arrange(desc(count))
write.csv(emp_loc, "emp_loc2.csv", row.names = FALSE)

#####there are a lot of duplications and unclean data in state names
#####clean state names by each state
CA <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "CALI"))
##check the variable state names to make sure they are all California
CAs <- CA %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
##create a new column in original emp dataset to store correct state abbr.
emp$STATE_ABBR <- 'n'

for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'CALI')){
    emp$STATE_ABBR[row] <- 'CA'
  }
}
###############California ends here################
TX <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "TEXAS"))
TXs <-TX %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'TEXAS')){
    emp$STATE_ABBR[row] <- 'TX'
  }
}
###############Texas ends here################
NY <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "NEW YORK"))
NYs <-NY %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(NYs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'NEW YORK')){
    emp$STATE_ABBR[row] <- 'NY'
  }
}
###############New York ends here################
WA <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "WASH"))
WAs <-WA %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(WAs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'WASH')){
    emp$STATE_ABBR[row] <- 'WA'
  }
}
###############Washington ends here################
NJ <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "JERSEY"))
NJs <-NJ %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'JERSEY')){
    emp$STATE_ABBR[row] <- 'NJ'
  }
}
###############New Jersey ends here################
IL <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "ILLINOIS"))
ILs <-IL %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(ILs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'ILLINOIS')){
    emp$STATE_ABBR[row] <- 'IL'
  }
}
###############Illinois ends here################










