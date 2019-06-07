##------------------- creating hall-of-results from data

##--- read metadata.

library(dplyr)
library(readr)
source("functions.r")

# readmeta <- function (path){
#   read_tsv (path, col_types = cols( .default = col_character()))
# }


allresults <- list.files(path = "static/hall-of-results_data", full.names = TRUE, recursive = TRUE, pattern = ".tsv") %>% 
  lapply(readmeta)%>% 
  bind_rows %>%
  arrange (date_uploaded)

write_items_toml()

#allresults  <- read.delim("C:/Users/juliencolomb/gitstuff/sharefigure/static/hall-of-results_data/hall-of-resluts_metadata.csv.csv")

##------------------- filter data for specific halls

##-- Published figures

##-- Only results from finished experiments

##-------------------- create items.toml
data2 = allresults %>% filter(status == "Published")
write_items_toml(data = data2, filename = "data_pub/items.toml")



