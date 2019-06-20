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
source("functions.R")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("upload one figure to sarefigure repository"),
    

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            checkboxInput("update", "Are you updating an existing entry", FALSE)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            fileInput("Panel1", "Choose Image",
                      multiple = FALSE,
                      accept = c('image/png', 'image/jpeg'),  
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
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    observeEvent(input$button, {
        imagepath = input$Panel1$datapath
        title1 = input$Title
        output$valuecap <- renderText({ input$Caption})
        status1 = input$Status
        caption = input$Caption
        url =input$url
        update = input$update
        comment= input$Comment
        highlight = input$highlight
        source("figureimport.R", local = TRUE)
        output$valuesaved <- renderText({"SmartFigure saved"})
    })
    
    
    

    
    output$plot3 <- renderImage({
        list(src = input$Panel1$datapath,
             contentType = 'image/png',
             width = 400,
             height = 300,
             alt = "This is alternate text")
    }, deleteFile = FALSE)
    
    
    output$valuetitle <- renderText({ input$Title })
    
    

}

# Run the application 
shinyApp(ui = ui, server = server)
