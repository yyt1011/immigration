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
FL <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "FLORIDA"))
FLs <-FL %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(FLs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'FLORIDA')){
    emp$STATE_ABBR[row] <- 'FL'
  }
}
###############Florida ends here################
PA <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "PENN"))
PAs <-PA %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(PAs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'PENN')){
    emp$STATE_ABBR[row] <- 'PA'
  }
}
###############Pennsylvania ends here################
MA <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "MASS"))
MAs <-MA %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(MAs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'MASS')){
    emp$STATE_ABBR[row] <- 'MA'
  }
}
###############Massachusetts ends here################
GA <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "GEORGIA"))
GAs <-GA %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(GAs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'GEORGIA')){
    emp$STATE_ABBR[row] <- 'GA'
  }
}
###############Georgia ends here################
VA <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "VIRGINIA"))
VAs <-VA %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(VAs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'VIRGINIA')){
    emp$STATE_ABBR[row] <- 'VA'
  }
}
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'WEST VIRGINIA')){
    emp$STATE_ABBR[row] <- 'WV'
  }
}
###############Virginia and West Virginia end here################
MI <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "MICHI"))
MIs <-MI %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(MIs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'MICHI')){
    emp$STATE_ABBR[row] <- 'MI'
  }
}
###############Michigan ends here################
NC <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "NORTH CAROLINA"))
NCs <-NC %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(NCs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'NORTH CAROLINA')){
    emp$STATE_ABBR[row] <- 'NC'
  }
}

SC <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "SOUTH CAROLINA"))
SCs <-SC %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(SCs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'SOUTH CAROLINA')){
    emp$STATE_ABBR[row] <- 'SC'
  }
}
###############North and South Carolina end here################
OH <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "OHIO"))
OHs <-OH %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(OHs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'OHIO')){
    emp$STATE_ABBR[row] <- 'OH'
  }
}
###############Ohio ends here################
MD <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "MARY"))
MDs <-MD %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(MDs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'MARY')){
    emp$STATE_ABBR[row] <- 'MD'
  }
}
###############Maryland ends here################
IN <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "INDI"))
INs <-IN %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(INs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'INDI')){
    emp$STATE_ABBR[row] <- 'IN'
  }
}
###############Indiana ends here################
MO <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "MISSOURI"))
MOs <-MO %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(MOs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'MISSOUR')){
    emp$STATE_ABBR[row] <- 'MO'
  }
}
###############Missouri ends here################
CT <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "CONNE"))
CTs <-CT %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(CTs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'CONNE')){
    emp$STATE_ABBR[row] <- 'CT'
  }
}
###############Connecticut ends here################
MN <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "MINNE"))
MNs <-MN %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(MNs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'MINNE')){
    emp$STATE_ABBR[row] <- 'MN'
  }
}
###############Minnesota ends here################
WI <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "WIS"))
WIs <-WI %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(WIs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'WIS')){
    emp$STATE_ABBR[row] <- 'WI'
  }
}
###############Wisconsin ends here################
CO <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "COLOR"))
COs <-CO %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(COs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'COLOR')){
    emp$STATE_ABBR[row] <- 'CO'
  }
}
###############Colorado ends here################
TN <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "TENN"))
TNs <-TN %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(TNs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'TENN')){
    emp$STATE_ABBR[row] <- 'TN'
  }
}
###############Tennessee ends here################
AZ <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "ARIZONA"))
AZs <-AZ %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(AZs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'ARIZONA')){
    emp$STATE_ABBR[row] <- 'AZ'
  }
}
###############Arizona ends here################
OR <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "OREGON"))
ORs <-OR %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(ORs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'OREGON')){
    emp$STATE_ABBR[row] <- 'OR'
  }
}
###############Oregon ends here################
NE <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "NEBRASKA"))
NEs <-NE %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(NEs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'NEBRASKA')){
    emp$STATE_ABBR[row] <- 'NE'
  }
}
###############Nebraska ends here################
UT <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "UTAH"))
UTs <-UT %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(UTs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'UTAH')){
    emp$STATE_ABBR[row] <- 'UT'
  }
}
###############Utah ends here################
AL<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "ALABAMA"))
ALs <-AL %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(ALs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'ALABAMA')){
    emp$STATE_ABBR[row] <- 'AL'
  }
}
###############Alabama ends here################
AR<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "ARKANSAS"))
ARs <-AR %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(ARs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'ARKANSAS')){
    emp$STATE_ABBR[row] <- 'AR'
  }
}
###############Arkansas ends here################
LA<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "LOUISIANA"))
LAs <-LA %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(LAs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'LOUISIANA')){
    emp$STATE_ABBR[row] <- 'LA'
  }
}
###############Louisiana ends here################
KY<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "KENTUCKY"))
KYs <-KY %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(KYs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'KENTUCKY')){
    emp$STATE_ABBR[row] <- 'KY'
  }
}
###############Kentucky ends here################
DC<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "COLUMBIA"))
DCs <-DC %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(DCs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'COLUMBIA')){
    emp$STATE_ABBR[row] <- 'DC'
  }
}
###############District of Columbia ends here################
KS<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "KANSAS"))
KSs <-KS %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(KSs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (st == 'KANSAS'){
    emp$STATE_ABBR[row] <- 'KS'
  }
}
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (st == 'KANSAS KS'){
    emp$STATE_ABBR[row] <- 'KS'
  }
}
###############Kansas ends here################
DE<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "DELAWARE"))
DEs <-DE %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(DEs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "DELAWARE")){
    emp$STATE_ABBR[row] <- 'DE'
  }
}
###############Delaware ends here################
IA<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "IOWA"))
IAs <-IA %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(IAs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "IOWA")){
    emp$STATE_ABBR[row] <- 'IA'
  }
}
###############Iowa ends here################
OK<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "OKLAHOMA"))
OKs <-OK %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(OKs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "OKLAHOMA")){
    emp$STATE_ABBR[row] <- 'OK'
  }
}
###############Okalahoma ends here################
ID<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "IDAHO"))
IDs <-ID %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(IDs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "IDAHO")){
    emp$STATE_ABBR[row] <- 'ID'
  }
}
###############Idaho ends here################
NV<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "NEVADA"))
NVs <-NV %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(NVs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "NEVADA")){
    emp$STATE_ABBR[row] <- 'NV'
  }
}
###############Nevada ends here################
NM<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "NEW MEXICO"))
NMs <-NM %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(NMs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "NEW MEXICO")){
    emp$STATE_ABBR[row] <- 'NM'
  }
}
###############New Mexico ends here################
ND <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "NORTH DAKOTA"))
NDs <-ND %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(NDs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'NORTH DAKOTA')){
    emp$STATE_ABBR[row] <- 'ND'
  }
}

SD <- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "SOUTH DAKOTA"))
SDs <-SD %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(SDs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, 'SOUTH DAKOTA')){
    emp$STATE_ABBR[row] <- 'SD'
  }
}
###############North Dakota and South Dakota end here################
NH<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "HAMPSHIRE"))
NHs <-NH %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(NHs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "HAMPSHIRE")){
    emp$STATE_ABBR[row] <- 'NH'
  }
}
###############New Hampshire ends here################
RI<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "RHODE"))
RIs <-RI %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(RIs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "RHODE")){
    emp$STATE_ABBR[row] <- 'RI'
  }
}
###############Rhode Island ends here################
VM<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "VERMONT"))
VMs <-VM %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(VMs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "VERMONT")){
    emp$STATE_ABBR[row] <- 'VM'
  }
}
###############Vermont ends here################
MT<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "MONTANA"))
MTs <-MT %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(MTs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "MONTANA")){
    emp$STATE_ABBR[row] <- 'MT'
  }
}
###############Montana ends here################
ME<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "MAINE"))
MEs <-ME %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(MEs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "MAINE")){
    emp$STATE_ABBR[row] <- 'ME'
  }
}
###############Maine ends here################
HI<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "HAWAII"))
HIs <-HI %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(HIs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "HAWAII")){
    emp$STATE_ABBR[row] <- 'HI'
  }
}
###############Hawaii ends here################
MS<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "MISSISSIPPI"))
MSs <-MS %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(MSs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "MISSISSIPPI")){
    emp$STATE_ABBR[row] <- 'MS'
  }
}
###############Mississippi ends here################
AK<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "ALASKA"))
AKs <-AK %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(AKs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "ALASKA")){
    emp$STATE_ABBR[row] <- 'AK'
  }
}
###############Alaska ends here################
WY<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "WYOMING"))
WYs <-WY %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(WYs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "WYOMING")){
    emp$STATE_ABBR[row] <- 'WY'
  }
}
###############Wyoming ends here################
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (st == 'GUAM'){
    emp$STATE_ABBR[row] <- 'GU'
  }
}

PR<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "PUERTO RICO"))
PRs <-PR %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(PRs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "PUERTO RICO")){
    emp$STATE_ABBR[row] <- 'PR'
  }
}
MARIANA<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "MARIANA"))
MARIANAs <-MARIANA %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(MARIANAs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "MARIANA")){
    emp$STATE_ABBR[row] <- 'MARIANA'
  }
}

VLAND<- emp %>% filter(str_detect(emp$EMPLOYER_STATE_PROVINCE, "VIRGIN ISLANDS"))
VLANDs <-VLAND %>% group_by(EMPLOYER_STATE_PROVINCE) %>% summarise(count = n())
View(VLANDs)
for (row in 1:nrow(emp)){
  st <- emp$EMPLOYER_STATE_PROVINCE[row]
  if (str_detect(st, "VIRGIN ISLANDS")){
    emp$STATE_ABBR[row] <- 'VLAND'
  }
}

write.csv(emp, "emp_loc3.csv", row.names = FALSE)

################process time######################
emp_clean <- read.csv('emp_loc3.csv')
View(emp_clean)
emp_clean$RECEIVED_DATE2 <- strftime(as.Date(emp_clean$RECEIVED_DATE, format = "%m/%d/%Y"), format = "%m/%d/%Y")
emp_clean$DECISION_DATE2 <- strftime(as.Date(emp_clean$DECISION_DATE, format = "%m/%d/%Y"), format = "%m/%d/%Y")
emp_clean$PROCESS_TIME <- as.Date(emp_clean$DECISION_DATE2, format = "%m/%d/%Y") - as.Date(emp_clean$RECEIVED_DATE2,format = "%m/%d/%Y")
emp_clean$PROCESS_YEAR <- emp_clean$PROCESS_TIME/365

write.csv(emp_clean, "emp_loc4.csv", row.names = FALSE)
