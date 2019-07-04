#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(readr)
library (magick)
library(rcrossref)
library(blogdown)
source("functions.R")
library(rdrop2)
tokenRG <- readRDS("droptoken.rds")

pathfolder ="static/ResultGallery"
pathfigure = paste0(pathfolder,"/Figures/")

# Define UI for application that draws a histogram
ui <- fluidPage(
    # Application title
    titlePanel("Result Gallery application"),
    
    
    # Sidebar with a slider input for number of bins

    
    # Show a plot of the generated distribution
    tabsetPanel(
        
        tabPanel(
            "See  Gallery",
            #actionButton("hallcreation", "Update website with new information"),
            fluidRow(htmlOutput("frame"))
        )
        ,
        
        tabPanel(
            "Import new figures",
            tagList(
                checkboxInput("update", "Are you updating an existing entry", FALSE), 
                fileInput("Panel1", "Choose Image",
                          multiple = FALSE,
                          accept = c('image/png', 'image/jpeg')  
                ),  
                textInput("Title", "Title of the figure", "keep it short, no more than 30 characters please"),
                selectInput("Status", "Status of the figure:",
                            c("Published" = "Published",
                              "Experiment is finished" = "preprint",
                              "Draft, review request" = "draft")),
                checkboxInput("highlight", "Is this a highlighted figure ?"),
                textAreaInput("Caption", "Caption of the figure", ""),
                textInput("Comment", "Comment about the figure", ""),
                textInput("url", "doi or webaddress of the paper/preprint", "none"),
                actionButton("button", "produce and save SER"),
                verbatimTextOutput("valuesaved"),
                
                "Preview :",
                verbatimTextOutput("valuetitle"),
                plotOutput("plot3"),
                verbatimTextOutput("valuecap")
            )
            
        )
        ,
        tabPanel(
            "Update figure",
            actionButton("hallcreation", "Update website with new information"),
            fileInput("TOKENDROP", "upload your dropbox authentificator"),
            "rest not implemented"
        )
        
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    
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
        source("figureimport.R", local = TRUE)

        source(file ="hallcreator.R", local = TRUE)
        blogdown::hugo_build()
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
        blogdown::hugo_build()
        output$frame <- renderUI({
            
            my_test <- tags$iframe(src="index.html", width = "100%", height= "2000")
            print(my_test)
            my_test
        })
        
        })
        
    output$frame <- renderUI({
        
        my_test <- tags$iframe(src="index.html", width = "100%", height= "2000")
        print(my_test)
        my_test
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
        input$Title
    })
    
    
    
}

# Run the application
shinyApp(ui = ui, server = server)
