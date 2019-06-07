##functions

## making thumbnail from an image 

makethumbnail <- function(theimage, status= "draft", title= " ", size_thumb =250) {
  if (class (status) != "character") status = "draft"
  #set color code for status:
  colorstatus = ifelse(status == "draft", "red", "blue")
  colorstatus = ifelse(status == "Published", "yellow", colorstatus)
  colorstatus
  
  background = image_graph(width = size_thumb, height = size_thumb, bg = "white",
                           pointsize = 12, res = 72, clip = TRUE, antialias = TRUE)
  plot.new()
  dev.off()
  #background
  
  
  a= theimage
  ainfo= image_info(a)
  
  if (ainfo$width < ainfo$height){
    b=a %>% image_scale(geometry_size_pixels(height = size_thumb))
  } else {
    b=a %>% image_scale(geometry_size_pixels(width = size_thumb))
  }
  b
  
  
  c=image_info(b)
  xoff= (250 - c$width)/2
  yoff= (250 - c$height)/2
  
  thumb=image_composite(background, b, offset = geometry_point(xoff, yoff))
  
  thumb= thumb %>% 
    image_annotate(status, gravity = 'southeast',
                   color = 'black',boxcolor = colorstatus)%>%
    image_annotate(title, gravity = 'north',
                   color = 'black',boxcolor = "white", size = min(20,500/nchar(title)))
}



write_items_toml <- function(data = allresults, filenamepath = "data/items.toml") {
  
  fileConn = file (filenamepath)
  cat("",file=filenamepath,append=FALSE)
  
  for (i in c(1:nrow(data))){
    text = "\n[[items]]"
    text = paste0 (text,  '\n ', 'title = "', data$Title [i], '"')
    text = paste0 (text,  '\n ', 'image = "hall-of-results_data/Figures/', data$image [i], '"')
    text = paste0 (text,  '\n ', 'thumb = "hall-of-results_data/Figures/', data$thumb [i], '"')
    text = paste0 (text,  '\n ', 'alt = "', data$alt [i], '"')
    text = paste0 (text,  '\n ', 'description = "', data$description [i], '"')
    text = paste0 (text,  '\n ', 'url = "', data$url [i], '"')
    cat(text,file=filenamepath,append=TRUE)
  }
}


readmeta <- function (path){
  read_tsv (path, col_types = cols( .default = col_character()))
}