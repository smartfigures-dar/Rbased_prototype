# Result Galleries for research labs/consortium

This is a prototype aimed at gathering early feedback for the development of the Sdash system.

It is based on one Rshiny app (deployed here: https://colomb.shinyapps.io/Resultgallery_software/), communicating with a dropbox repository for data storage, or saving the data locally (if you like to run it on your own server). 

## first step in using the application

you need to upload your dropbox authentification rds file, you can get it in R via

``` 
library(rdrop2)
token <- drop_auth()
saveRDS(token, "droptoken.rds")
```

Your dropbox should contain a result gallery folder, you can see a template in this repo under static/resultgallery. Do not use capitals in any folder name, and keep the"resultgallery" has part of the folder name (the application will  look for that folder).

Nowe the application will download the data on the shinyapp.io server, and you can save new figures that will be saved on your dropbox. In the "slack" folder, a figure will also be uploaded, and you can use zapier to send that figure to (for example) slack. 

## Notes

The software was first developed on a private repository, so initial commit history is not available atm.
You can also install the application on your server running R (or a Rstuio server application), then use the Wesitecreator.R file to set some variables before starting the app.


## Installation


For development:
--------------

- install git, set git config --global options
- install R
- install Rstudio
- create a ssh key
- add key to Gin/github (browser, add it to your profile)
- install packages (see websitecerator.r)
- install hugo with blogdown::install_hugo()
- install MiKTeX

**Please contact me if you would like to contribute to the development of the application**
