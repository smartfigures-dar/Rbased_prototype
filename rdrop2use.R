# dropbox use

library(rdrop2)
#token <- drop_auth()
#saveRDS(token, "droptoken.rds")

#import token
#tokenRG <- readRDS("droptoken.rds")

#download RG on server
x <- drop_search("resultgallery", dtoken = tokenRG)
x2=drop_dir(x$matches[[1]]$metadata$path_display, recursive = TRUE, dtoken = tokenRG)

#downloading folder in static folder
folders = x2 %>% filter (.tag ==  "folder")
files = x2 %>% filter (.tag ==  "file")

for (j in folders$path_display){
  print(j)
  foldercreated <-dir.create(paste0("./static",j))
}


for (j in files$path_display){
  print(j)
  drop_download(j,local_path = paste0("./static",j), dtoken = tokenRG)
}

file.rename (paste0("./static/",folders$name[1]), "./static/ResultGallery")

