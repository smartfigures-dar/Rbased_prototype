## working with multipage pdf

imagepath= "~/figures-tables/colomb_notpublished/allpdf.pdf"


filename = strtrim(imagepath ,(nchar(imagepath)-4))

a= image_read_pdf(imagepath)

pdfdir= dir.create (filename)
for (i in seq_along(a)){
  
  print (i)
  image_write(a[i], path =paste0(filename,"/fig_",i, ".png"), format = "png")
}



## update all tsv files

allresults <- list.files(path = "static/hall-of-results_data", 
                         full.names = TRUE, recursive = TRUE, pattern = ".tsv")

for ( i in c(1:length(allresults))){
  file = allresults [i]
  headers=readmeta(file)
  a= cr_cn(headers$url, format="citeproc-json")
  yearpub= a$issued$`date-parts`[1,1]
  #headers$date_uploaded = NA
  #headers$date_uploaded [1] <- paste0(Sys.time())
  headers$date_published = NA
  headers$date_published [1] <- paste0(yearpub)
  #View(headers)
  write.table(headers,file = allresults [i], 
              sep = "\t", , row.names = FALSE) 
  
}

## update all tsv files

allresults <- list.files(path = "static/hall-of-results_data", 
                         full.names = TRUE, recursive = TRUE, pattern = ".tsv")
headers =  read.delim("static/hall-of-results_data/head_hall-of-resluts_metadata.csv",
                      colClasses = "character")

for ( i in c(1:length(allresults))){
  file = allresults [i]
  data=readmeta(file)
  
  temp= bind_rows(headers,data)
  temp[2,is.na (temp[2,])] <- "Null"
  temp[2,(temp[2,] == "Null")] <- temp[1,(temp[2,] == "Null")]
  
  output = temp [2,]
  write.table(output,file = allresults [i], 
              sep = "\t", , row.names = FALSE) 
  
}

## update all thumbnails
allresults <- list.files(
  path = "static/hall-of-results_data",
  full.names = TRUE,
  recursive = TRUE,
  pattern = ".tsv"
)
for (i in c(1:length(allresults))) {
  file = allresults [i]
  headers = readmeta(file)
  ## entered variables
  title1 = headers$Title
  status1 = headers$status
  caption =  headers$description
  url = headers$url
  imagepath = headers$image
  thumbpath = headers$thumb
  shortname = strtrim(gsub("\\s", "_", title1) , 27)
  #library (magick)
  #source("functions.r")
  
  a = image_read(paste0("static/hall-of-results_data/Figures/", imagepath))
  thumb = makethumbnail(theimage = a,
                        status = status1,
                        title = shortname)
  image_write(
    thumb,
    path = paste0("static/hall-of-results_data/Figures/", thumbpath),
    format = "png"
  )
}
