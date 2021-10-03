#
# This is a Shiny web application.
# This app will help you generate Briefe for clinc 
# Generally it uses templates that you can modify and change using additional 
# inputs
#
# 

library(shiny)
library(tidyverse)

### Load the templates
template_list <- list.files(path = "templates") %>% 
    gsub(pattern = ".R", replacement = "")



# Define UI 
ui <- fluidPage(

    # Application title
    titlePanel("Derma Template App"),

    # Sidebar with a list of inputs 
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "template",
                        label = "Wähle ein Template",
                        choices = c(
                            template_list
                        )
            )
            
        ),

        # Show Generated text in the main window
        mainPanel(
           textOutput("templateout")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    
    
        inpts <- reactive({
            name <- file.path("templates", paste0(input$template, ".R"))
            source(name, local=TRUE)
            mget(ls())
            #source(file = here::here("templates",paste0(input$template,".R")))
            #paste0(text1, " reading file ", input$template)
        })
    
        output$templateout <- renderText({
            
            o <- inpts()
            o$text1
        })
}



# Run the application 
shinyApp(ui = ui, server = server)
