# dropbox use

library(rdrop2)
#token <- drop_auth()
#saveRDS(token, "droptoken.rds")

#import token
tokenRG <- readRDS("droptoken.rds")

#download RG on server
x <- drop_search("resultgallery", dtoken = tokenRG)
x2=drop_dir(x$matches[[1]]$metadata$path_display, recursive = TRUE, dtoken = tokenRG)

#downloading folder in static folder
folders = x2 %>% filter (.tag ==  "folder")
files = x2 %>% filter (.tag ==  "file")

for (j in folders$path_display){
  print(j)
  foldercreated <-dir.create(paste0("static",j))
}


for (j in files$path_display){
  print(j)
  drop_download(j,local_path = paste0("static",j), dtoken = tokenRG)
}

file.rename (paste0("static/",folders$name[1]), "static/ResultGallery")

#upload new figure to the dropbox

#orig:
#dir.create (directory)
#write.table(headers,file = paste0(directory,"/",filename,"_meta.tsv"), 
#            sep = "\t", , row.names = FALSE)
#image_write(a, path =pathimage, format = "png")

#paththumb = paste0(directory,"/",filename,"_nail.png")
#image_write(thumb, path =paththumb, format = "png")
#directory = "testing_new_figures"
#filename= "testing_new_figures"

library(rdrop2)
tokenRG <- readRDS("droptoken.rds")
dropboxfolder = paste0(x$matches[[1]]$metadata$name,"/Figures/",directory)
drop_create(dropboxfolder, dtoken = tokenRG)
drop_upload(file =paste0(pathfigure,"/",directory,"/",filename,"_meta.tsv"),path =paste0(dropboxfolder) , dtoken = tokenRG)
drop_upload(file =paste0(pathfigure,"/",directory,"/",filename,"_nail.png"),path =paste0(dropboxfolder), dtoken = tokenRG )
drop_upload(file =paste0(pathfigure,"/",directory,"/",filename,".png"),path =paste0(dropboxfolder) , dtoken = tokenRG)
