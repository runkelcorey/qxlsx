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
  mutate(code = countrycode(ifelse(`Country(ies)` == "Other (please specify)", `Country(ies).Other`, gsub("[,:].*", "", `Country(ies)`)), origin = "country.name.en", destination = "iso3c", #convert country names to ISO 3-char codes
                            custom_match = c("EU" = "EUR", #add CFRT-specific interveners
                                             "African Development Bank" = "BAD",
                                             "Asian Development Bank" = "ADB",
                                             "Asian Infrastructure Investment Bank" = "AII",
                                             "Bank for International Settlements" = "BIS",
                                             "Development Bank of Latin America" = "CAF",
                                             "Inter-American Development Bank" = "IDB",
                                             "International Accounting Standards Board" = "ASB",
                                             "International Monetary Fund" = "IMF",
                                             "International Organization of Securities Commissions" = "SCO",
                                             "Nordic Investment Bank" = "NIB",
                                             "Paris Club" = "PAR",
                                             "World Bank Group" = "WBG",
                                             "Plata Basin Financial Development Fund" = "FON",
                                             "Central American Bank for Economic Integration (CABEI)" = "CEI",
                                             "European Bank for Reconstruction and Development" = "ERD",
                                             "Financial Stability Board" = "FSB",
                                             "Council of Europe Development Bank" = "CEB",
                                             "Bank of Central African States" = "XAF",
                                             "Central Bank of West African States" = "XOF",
                                             "Micronesia" = "FSM",
                                             "Kosovo" = "KOS",
                                             "Palestine" = "PAL"))) %>%
  mutate(id = paste(code, substr(`Institutional.Role(s)`, 1, 1), `Adoption/Proposal.Date.(MM-DD-YYYY)`, substr(ResponseID, 3, 6), sep = "_")) #construct unique persistent id: country-code_role_date_random-string

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
                    "Steven" = c("Mexico", "United States"),
                    "Lily" = c("EU", "African Development Bank", "Asian Development Bank", "Bank for International Settlements", "Development Bank of Latin America", "Inter-American Development Bank",
                               "International Accounting Standards Board", "International Monetary Fund", "International Organization of Securities Commissions", "Nordic Investment Bank", "Paris Club",
                               "Plata Basin Financial Development Fund", "Central American Bank for Economic Integration (CABEI)", "European Bank for Reconstruction and Development",
                               "Financial Stability Board", "Council of Europe Development Bank"))

#create blank workbook
cfrt <- createWorkbook()

#create function to make one sheet
for (i in names(assignments)) {
  addWorksheet(cfrt, i)
  writeData(cfrt, i, filter(internal, gsub("[,:].*", "", `Country(ies)`) %in% assignments[[i]]), colNames = T) #create a sheet named i filled with entries assigned to i, and keep the column names
}
