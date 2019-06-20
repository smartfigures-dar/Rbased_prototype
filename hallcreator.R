##------------------- creating hall-of-results from data

##--- read metadata.

library(dplyr)
library(readr)
library (magick)
source("functions.R")

# readmeta <- function (path){
#   read_tsv (path, col_types = cols( .default = col_character()))
# }


allresults <- list.files(path = "static/hall-of-results_data", full.names = TRUE, recursive = TRUE, pattern = ".tsv") %>% 
  lapply(readmeta)%>% 
  bind_rows %>%
  arrange (desc(Highlighted), date_uploaded)

if (length(problematicpubli)>0){
  allresults$image [allresults$url %in% problematicpubli] = "../../images/copyright.png"
  ##redo thumbnail
  lit_results = allresults [allresults$url %in% problematicpubli,]
  
  a = image_read(paste0("static/images/copyright.png"))
  for (i in c(1:nrow(lit_results))) {
    headers = lit_results [i,]
    ## entered variables
    
    title1 = lit_results$Title [i]
    status1 = lit_results$status[i]
    thumbpath = lit_results$thumb[i]
    shortname = strtrim(gsub("\\s", "_", title1) , 27)
    
    thumb = makethumbnail(theimage = a,
                          status = status1,
                          title = shortname)
    image_write(
      thumb,
      path = paste0("static/hall-of-results_data/Figures/", thumbpath),
      format = "png"
    )
  }
}


data2 = allresults %>% filter(Highlighted =="TRUE" )
write_items_toml(data = data2, filename = "data/itemsH.toml")

data2 = allresults %>% filter(Highlighted =="FALSE" )
write_items_toml(data = data2, filename = "data/items.toml")

#allresults  <- read.delim("C:/Users/juliencolomb/gitstuff/sharefigure/static/hall-of-results_data/hall-of-resluts_metadata.csv.csv")

##------------------- filter data for specific halls

##-- Published figures

##-- Only results from finished experiments

##-------------------- create items.toml
data2 = allresults %>% filter(status == "Published")
write_items_toml(data = data2, filename = "data_pub/items.toml")



