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



# Define UI for application that draws a histogram
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

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
