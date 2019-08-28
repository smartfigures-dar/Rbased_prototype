##---------------- working with images
##-- notes
## if the upload is a pdf, only the first page will be used

#pathfigure = "static/hall-of-results_data/Figures/"

## entered variables
if (FALSE){
  pathfolder ="static/ResultGallery"
  pathfigure = paste0(pathfolder,"/figures/")
  title1 = "Active dCaAP impact on soma and a long suff here to be cut our...."
  status1 = "draft"
  caption = "something scientific, right"
  url = "none"
  imagepath= "static/images/copyright.png"
  update=FALSE
  comment = ""
  #imagepath= "static/hall-of-results_data/Figures/metad/metad_exp.pdf"
  highlight = "FALSE"
  author = "jco"
  lab="lkm"
  thisproject = "no_project"
  updated_by = "julien colomb"
  
}
dropboxmessage = "Beware files were not saved on dropbox, token not uploaded."

size_thumb_here = ifelse (highlight,500, 250)
 

filename = titleify(title1)$file

##------------------------------------ create directory for the smartfigure

directory = paste0(pathfigure,lab,author,titleify(title1)$folder)
dirname= paste0(lab,author,titleify(title1)$folder)
numb=0
while( dir.exists (directory) && (!update)){
  numb=numb+1
  
  directory = paste0(pathfigure,lab,author,titleify(title1)$folder,numb)
  dirname= paste0(lab,author,titleify(title1)$folder,numb)
}

filename =paste0(filename,formatC(numb, width=2, flag="0"))


dir.create (directory)

##------------------------------------ write metadata

headers =  read.delim(paste0(pathfolder,"/head_hall-of-resluts_metadata.csv"),
                      colClasses = "character")
# work with doi
yearpub = "NA"
if (url != "none"){
  a= cr_cn(url, format="citeproc-json")
  yearpub= a$issued$`date-parts`[1,1]
  yearpub = ifelse (is.null(yearpub), "unknown", yearpub)
  }




## save all
headers$Title [1] <- title1

headers$image [1] <- paste0(dirname,"/",filename,".png")
headers$thumb [1] <- paste0(dirname,"/",filename,"_nail.png")

headers$alt [1] <- "something went wrong"
headers$description [1] <- caption
headers$comment [1] <- comment
headers$url [1] <- url
headers$status [1] <- status1
headers$date_uploaded [1] <- paste0(Sys.time())
headers$date_published [1] <- paste0(yearpub)
headers$Highlighted [1] <- highlight

#View(headers)
write.table(headers,file = paste0(directory,"/",filename,"_meta.tsv"), 
            sep = "\t", , row.names = FALSE)

projects_authors <- read_csv("./static/ResultGallery/projects_authors.csv")
projects_authors <- projects_authors %>% filter (project_title == thisproject) %>% select(- project_title)
sink (file = paste0(directory,"/",filename,".yml"), append = FALSE)

source ("write_yml.r", local = TRUE)
sink()



##------------------------------------ create figures

#library (magick)
#source("functions.r")

imagetype = substr(imagepath, nchar(imagepath)-3, nchar(imagepath))

if (imagetype == ".pdf"){
  a= image_read_pdf(imagepath)[1]
  oripath = paste0(directory,"/",filename, ".pdf")
  image_write(a, path =oripath, format = "pdf")
  headers$originaldoc [1] <- paste0(oripath)
  
} else {
  a= image_read(imagepath)
  
}




pathimage =paste0(directory,"/",filename,".png")
image_write(a, path =pathimage, format = "png")


thumb = makethumbnail(theimage = a, status= status1, title = title1, size_thumb = size_thumb_here)
paththumb = paste0(directory,"/",filename,"_nail.png")
image_write(thumb, path =paththumb, format = "png")

#a= image_read("static/images/thumbs/4.png")



##dropbox, only done if dropbox token is given.

if(exists("tokenRG")){
  x <- drop_search("resultgallery", dtoken = tokenRG)
  dropboxfolder = paste0(x$matches[[1]]$metadata$name,"/figures/",dirname)
  # drop_acc(dtoken = tokenRG)
  # drop_create(dropboxfolder)
  # drop_upload(file =paste0(directory,"/",filename,"_meta.tsv"),path =paste0(dropboxfolder) , dtoken = tokenRG)
  # drop_upload(file =paste0(directory,"/",filename,"_nail.png"),path =paste0(dropboxfolder), dtoken = tokenRG)
  # drop_upload(file =paste0(directory,"/",filename,".png"),path =paste0(dropboxfolder), dtoken = tokenRG)
  # drop_upload(file =paste0(directory,"/",filename,".yml"),path =paste0(dropboxfolder), dtoken = tokenRG)
  
  metadata= headers
  filepath = paste0(directory,"/",filename,"exp.pdf")
  
  ## render Rmarkdownfile to get pdf, save a copy of second page as an image (trimmed)
  
  rmarkdown::render("createfigurereport_pdf2.Rmd", 
                    output_file = filepath)
  #drop_upload(file =filepath,path =paste0(dropboxfolder), dtoken = tokenRG)
  
  exportimage= magick::image_read_pdf(filepath)
  magick::image_write(image_trim(exportimage[2]), format = "png", path=paste0(directory,"/",filename,"exp.png"))
  
  #zip and upload folder
  file = zip::zipr (paste0(directory, ".dar"),files=directory)
  dropboxfoldershort = paste0(x$matches[[1]]$metadata$name,"/figures/")
  drop_upload(file =file,path =paste0(dropboxfoldershort), dtoken = tokenRG)
  
  # upload pdf for slack integration
  drop_upload(file =paste0(directory,"/",filename,"exp.png"),path =paste0(x$matches[[1]]$metadata$name,"/slack"), dtoken = tokenRG)
  dropboxmessage = "file saved on dropbox"
  
  ## save original pdf if existant
  if (imagetype == ".pdf"){
    drop_upload(file =paste0(oripath),path =paste0(dropboxfolder), dtoken = tokenRG)
  }
}


