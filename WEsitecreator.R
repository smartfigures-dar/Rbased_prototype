deployed =FALSE # deployed on shinyapps.io ?
dropboxuse = deployed # should the dropbox integration be used
author = "jco"
shiny::runApp("shiny_resultgallery.R")


library(dplyr)
library(readr)
library (magick)
library(rcrossref) ## getting year published from doi
library(pander) ## creating reports
source("functions.R")
library (knitr)
library(rmarkdown)


#blogdown::new_site(theme="aerohub/hugrid", hostname = "github.com") #used to create the website,kept for reference
## give here url of publication where the copyrights issues were not cleared.
problematicpubli= c()
pathfolder ="static/ResultGallery"
pathfigure = paste0(pathfolder,"/figures/")
author = "jco"
file.lines <- scan("static/ResultGallery/info.toml", what=character(),  nlines=1, sep='\n')
source(textConnection(file.lines))


source (file ="hallcreator.R")
blogdown::hugo_cmd("--config ./config.toml,./static/ResultGallery/info.toml")

blogdown::hugo_build()

blogdown::hugo_cmd("--config config.toml,config_pub.toml") #bulid dat version
blogdown::hugo_cmd("--config ./config.toml,./static/ResultGallery/info.toml")
##setwd("website-cards")
#blogdown::new_site(theme="bul-ikana/hugo-cards", hostname = "github.com")
#blogdown::serve_site()

