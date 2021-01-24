#################
#Split tracker  #
#1/22/2021      #
#Corey Runkel   #
#################

library(openxlsx)
library(countrycode)
library(tidyverse)


#create sensible unique persistent identifier
internal <- readWorkbook("internal-cfrt.xlsx", sheet = "Data", detectDates = T) %>% #read database
  separate(`Country(ies)`, into = c("country", NA), remove=FALSE, sep = ",", extra = "drop") %>%
  group_by(country, `Institutional.Role(s)`, `Adoption/Proposal.Date.(MM-DD-YYYY)`) %>%
  add_tally() %>% #add number for each entry within country-role-date group, remove subsequent countries
  ungroup() %>%
  inner_join(codelist[,c(29,32)], by = c("country" = "iso.name.en")) %>% #keep countries that have ISO name equivalents (for naming purposes)
  mutate(id=paste(countrycode(country, origin="country.name", destination = "iso3c"), substr(`Institutional.Role(s)`, 1, 1), `Adoption/Proposal.Date.(MM-DD-YYYY)`, n, sep = "_")) #construct unique persistent id: country_role_date_number

#assign people to countries
assignments <- list("Priya" = c("Argentina", "Chile", "Peru", "Spain"),
                    "Mallory" = c("Australia", "Canada", "South Africa", "United Kingdom"),
                    "Corey" = c("Belgium", "France", "Germany", "Switzerland"),
                    "Sean" = c("Brazil", "Italy", "Luxembourg", "Sweden"),
                    "Sharon" = c("China", "Singapore", "Taiwan"),
                    "Natalie" = c("Czech Republic", "Greece", "Hungary", "Netherlands", "Poland"),
                    "Alex" = c("Egypt", "Qatar", "Saudi Arabia", "Turkey", "United Arab Emirates"),
                    "Junko" = c("India", "Japan", "Korea", "Pakistan", "Russia"),
                    "Adam" = c("Indonesia", "Malaysia", "Philippines", "Thailand"),
                    "Steven" = c("Mexico", "United States"))

#create blank workbook
cfrt <- createWorkbook()

#create function to make one sheet
for (i in names(assignments)) {
  addWorksheet(cfrt, i)
  writeData(cfrt, i, filter(internal, country %in% assignments[[i]]), colNames = T) #create a sheet named i filled with entries assigned to i, and keep the column names
}
