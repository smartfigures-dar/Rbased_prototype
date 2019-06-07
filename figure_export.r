## figure export

pathfigure = "static/hall-of-results_data/Figures/"

##readmetadata

allresults <- list.files(path = "static/hall-of-results_data", full.names = TRUE, recursive = TRUE, pattern = ".tsv") 

tomodify = allresults [7]
metadata=readmeta(tomodify)
filename = strtrim(gsub("\\s", "_", tomodify) ,nchar(tomodify)-8)
filename = paste0(filename,"_V.pdf")

## render Rmarkdownfile to get pdf

rmarkdown::render("createfigurereport.Rmd", 
                  output_file = filename)


                  
                  #, knit_root_dir =pathfigure)
     

#rmarkdown::render("pdfreports/test.Rmd",output_file = filename ,output_format ="pdf_document",knit_root_dir =getwd())

