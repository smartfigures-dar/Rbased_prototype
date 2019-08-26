#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#install.packages (c("shiny","dplyr","readr","magick","rcrossref","blogdown","rdrop2", "pander"))
datasave ="on our server, it is safe"
if (!exists("deployed")){
    deployed =TRUE # deployed on shinyapps.io ?
    dropboxuse = deployed # should the dropbox integration be used
    datasave ="on dropbox, i.e. not safe"
}

library(shiny)
library(dplyr)
library(readr)
library (magick)
library(rcrossref)
library(blogdown)
source("functions.R")
library(rdrop2)
library(pdftools)

problematicpubli= c()
pathfolder ="./static/ResultGallery"
pathfigure = paste0(pathfolder,"/figures/")





if (deployed) blogdown::install_hugo()




# Define UI for application that draws a histogram
ui <- fluidPage(theme ="css/default.css",
    
    # Application title
    titlePanel("Result Gallery application"),
    fluidRow(column(8, offset = 0,
                    "Please do not share the information you would access here, not even talk about it without the consent of the authors."
    ),
    fluidRow(
        
        column (5,offset = 1,
                tags$a(href="https://github.com/smartfigures-dar/SmartFig_Rbased_prototype/issues", "Documentation and Bug reports")
        ),
        column (5,
                paste0(" V.0.1 beta, data stored ", datasave)
        )
        
        
        )
    ),
    
    
    # Sidebar with a slider input for number of bins
    
    
    # Show a plot of the generated distribution
    tabsetPanel(id="maintabset",
                
                tabPanel("Link with dropbox",
                         "Upload your dropbox token to read and save SmartFigures",
                         
                         fileInput("TOKENDROP", "upload your dropbox authentificator", accept = ".rds"),
                         actionButton("hallcreation", "Update website with new information"),
                         
                         "rest not implemented"
                )
                ,
                tabPanel(
                    "See  Gallery",
                    actionButton("reload", "reload gallery"),
                    #actionButton("hallcreation", "Update website with new information"),
                    fluidRow(htmlOutput("frame"))
                )
                ,
                
                tabPanel(
                    "Import new figures",
                    tagList(
                        
                         
                        fileInput("Panel1", "Choose Image",
                                  multiple = FALSE,
                                  accept = c('image/png', 'image/jpeg', 'application/pdf')  
                        ),  
                        textInput( "author", "Your name"),
                        selectInput("project", "part of the project:",
                                    "unique (values$projects_authors$project_title)"),
                        textInput("Title", "Title of the figure"),
                        selectInput("Status", "Status of the figure:",
                                    c("Published in peer-reviewed journal" = "Published",
                                      "Experiment is finished" = "preprint",
                                      "Early draft, review request" = "draft"),
                                    selected = "draft"),
                        checkboxInput("update", "Are you updating an existing entry", FALSE),
                        checkboxInput("highlight", "Is this a highlighted figure ?"),
                        textAreaInput("Caption", "Caption of the figure, copy-paste only from utf8 sources", ""),
                        textInput("Comment", "Comment about the figure", ""),
                        textInput("url", "doi or webaddress of the paper/preprint", "none"),
                        actionButton("button", "produce and save SER"),
                        verbatimTextOutput("valuesaved"),
                        verbatimTextOutput("dropboxmessage"),
                        
                        "Preview :",
                        verbatimTextOutput("valuetitle"),
                        plotOutput("plot3"),
                        verbatimTextOutput("valuecap")
                    )
                    
                )
                
                
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    if (!dropboxuse) {hideTab(inputId = "maintabset", target = "dropboxupload")}
    values <- reactiveValues(title = "upload file first", lab = "xxx")
    
    
    file.lines <- scan("./static/ResultGallery/info.r", what=character(),  nlines=1, sep='\n')
    source(textConnection(file.lines), local = TRUE)
    
    
    observe({
        imagename = input$Panel1$name
        imagename = titleify (imagename)$file
        updateTextInput(session, "Title", value  = imagename)
        values$projects_authors <- read_csv("./static/ResultGallery/projects_authors.csv")
        updateSelectInput(session, "project",
                          
                          choices = unique (values$projects_authors$project_title)
        )
    })
    
    observeEvent(input$button, {
        
        output$valuesaved <- renderText({
            "SmartFigure in preparation, be patient"
        })
        
        
    })
    
    
    observeEvent(input$button, {
        imagepath = input$Panel1$datapath
        title1 = input$Title
        output$valuecap <- renderText({
            input$Caption
        })
        status1 = input$Status
        caption = input$Caption
        url = input$url
        update = input$update
        comment = input$Comment
        highlight = input$highlight
        lab = values$lab
        author = tolower(abbreviate(input$author,3))
        updated_by = input$author
        if(dropboxuse) tokenRG <- readRDS(input$TOKENDROP$datapath)
       thisproject = input$project
        
        source("figureimport.R", local = TRUE)
        output$dropboxmessage<- renderText({
            dropboxmessage
        })
        
        source(file ="hallcreator.R", local = TRUE)
        blogdown::hugo_cmd("--config ./config.toml,./static/ResultGallery/info.r")
        output$frame <- renderUI({
            
            my_test <- tags$iframe(src="index.html", width = "100%", height= "2000")
            print(my_test)
            my_test
        })
        output$valuesaved <- renderText({
            "SmartFigure saved, Gallery updated"
        })
        
        
        
    })
    
    observeEvent(input$hallcreation, {
        #browser()
        tokenRG <- readRDS(input$TOKENDROP$datapath)
        source(file = "rdrop2use.R", local = TRUE)
        
        source(file ="hallcreator.R", local = TRUE)
        blogdown::hugo_cmd("--config ./config.toml,./static/ResultGallery/info.toml")
        output$frame <- renderUI({
            
            my_test <- tags$iframe(src="index.html", width = "100%", height= "2000")
            print(my_test)
            my_test
        })
        file.lines <- scan("./static/ResultGallery/info.r", what=character(),  nlines=1, sep='\n')
        source(textConnection(file.lines), local = TRUE)
        
        updateSelectInput(session, "project",
                          
                          choices = unique (values$projects_authors$project_title)
        )
    })
    
    output$frame <- renderUI({
        if(dropboxuse){
            tokenRG <- readRDS(input$TOKENDROP$datapath)
            if (!exists("tokenRG")) return (NULL)
        }
        
        my_test <- tags$iframe(src="index.html", width = "100%", height= "2000")
        #print(my_test)
        my_test
    })
    
    observeEvent(input$reload, {
        file.lines <- scan("./static/ResultGallery/info.r", what=character(),  nlines=1, sep='\n')
        source(textConnection(file.lines), local = TRUE)
        
        source(file ="hallcreator.R", local = TRUE)
        blogdown::hugo_cmd("--config ./config.toml,./static/ResultGallery/info.toml")
        output$frame <- renderUI({
            if(dropboxuse){
                tokenRG <- readRDS(input$TOKENDROP$datapath)
                if (!exists("tokenRG")) return (NULL)
            }
            
            my_test <- tags$iframe(src="index.html", width = "100%", height= "2000")
            #print(my_test)
            my_test
        })
    })
    
    
    
    output$plot3 <- renderImage({
        list(
            src = input$Panel1$datapath,
            contentType = 'image/png',
            width = 400,
            height = 300,
            alt = "This is alternate text"
        )
    }, deleteFile = FALSE)
    
    
    output$valuetitle <- renderText({
        paste0 (
            "Title:",
            input$Title,
            "
will be saved there:",
            values$lab,
            tolower(abbreviate(input$author,3)),
            titleify(input$Title)$folder,
            "/",
            titleify(input$Title)$file,
            ".png"
        )
        
    })
    
    
    
}

# Run the application
shinyApp(ui = ui, server = server)
