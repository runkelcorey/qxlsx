####################
#Find archived URLs#
#2/1/2021          #
#Corey Runkel      #
####################

source(file = "getback.R") #source local function

#construct dataframe of IDs and links
linkavailability <- internal %>%
  select(id, `Adoption/Proposal.Date.(MM-DD-YYYY)`, Link.1:Link.20) %>% #select the ID, date, and links
  mutate(across(.cols = Link.1:Link.20, .fns = ~ gsub("$", ".avail", .x), .names = "{.col}.avail")) #add columns (filled w/ NA by default) named Link.#.avail

#get links (use loop to prevent losing all data when API hits max)
for (i in 1:170) {
  linkavailability[50*i-49:50*i, 22+1] <- map2(linkavailability[50*i-49:50*i, 2+1], linkavailability[50*i-49:50*i, 2], getback)
}