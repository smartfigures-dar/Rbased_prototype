##---------------- working with images
##-- notes
## if the upload is a pdf, only the first page will be used

#pathfigure = "static/hall-of-results_data/Figures/"

## entered variables
if (FALSE){
  title1 = "Active dCaAP impact on soma and a long suff here to be cut our...."
  status1 = "draft"
  caption = "something scientific, right"
  url = "none"
  imagepath= "static/hall-of-results_data/Figures/atg6-9_KD_in_brain/atg6-9_KD_in_brain.png"
  update=FALSE
  comment = ""
  #imagepath= "static/hall-of-results_data/Figures/metad/metad_exp.pdf"
  highlight = "FALSE"
  
}
size_thumb_here = ifelse (highlight,500, 250)
 

filename = strtrim(gsub("\\s", "_", title1) ,27)

##------------------------------------ create directory for the smartfigure

directory = paste0(pathfigure,filename)

numb=0
while( dir.exists (directory) && (!update)){
  numb=numb+1
  
  directory = paste0(pathfigure,filename,numb)
}

if (directory != paste0(pathfigure,filename) ) filename =paste0(filename,numb)
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
headers$image [1] <- paste0(filename,"/",filename,".png")
headers$thumb [1] <- paste0(filename,"/",filename,"_nail.png")
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


##dropbox

x <- drop_search("resultgallery", dtoken = tokenRG)
dropboxfolder = paste0(x$matches[[1]]$metadata$name,"/figures/",filename)
drop_acc(dtoken = tokenRG)
drop_create(dropboxfolder)
drop_upload(file =paste0(directory,"/",filename,"_meta.tsv"),path =paste0(dropboxfolder) , dtoken = tokenRG)
drop_upload(file =paste0(directory,"/",filename,"_nail.png"),path =paste0(dropboxfolder), dtoken = tokenRG)
drop_upload(file =paste0(directory,"/",filename,".png"),path =paste0(dropboxfolder), dtoken = tokenRG)
