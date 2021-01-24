#################
#Remake tracker #
#1/23/2021      #
#Corey Runkel   #
#################

library(openxlsx)
library(countrycode)
library(tidyverse)

internal_reconstruct <- bind_rows(map(getSheetNames("cfrt.xlsx"), function(x) readWorkbook("cfrt.xlsx", x, colNames = T, cols = 47))) #append sheets into one object
