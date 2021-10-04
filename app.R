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

source(here::here("signature.R")) # Load the signature
source(here::here("start.R"))

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
            ),
            radioButtons(inputId = "asthma",
                         label = "ND Asthma?",
                        choices = c("ja","nein")),
            radioButtons(inputId = "bekannt",
                         label = "Bekannter Pat.?",
                         choices = c("ja","nein")),
            dateInput(inputId = "einleitungDupi",
                      label = "Einleitung Dupi Datum",
                      format = "d.m.yyyy"),
            dateInput(inputId = "reduktion",
                      label = "seit wann Dupi Reduktion?",
                      format = "d.m.yyyy"),
            textInput(inputId = "interval",
                      label = "Spritzen interval in Wochen"),
            selectInput(inputId = "TCS_basis",
                      label = "Welche TCS als Basis-Tx?",
                      choices = c("Advantan 0,1% Creme",
                                  "")),
            selectInput(inputId = "Pflege",
                        label = "Welche Pflegeprodukt?",
                        choices = c("Excipial U10 Lipolotio",
                                    "Cetaphil® Feuchtigkeitscreme",
                                    "5% Polidocanol in Mischsalbe und Basiscreme DAC",
                                    "")),
            radioButtons(inputId = "Abschluss",
                         label = "Abschluss ?",
                         choices = c("nein","ja")),
            radioButtons(inputId = "Ciclosporin",
                         label = "Ciclosporin sine effectu ?",
                         choices = c("nein","ja")),
            textInput(inputId = "Wochen_zu_Verbesserung",
                      label = "Wochen zu Verbesserung"),
            textInput(inputId = "good_since",
                      label = "IGA 1 seit wieviel Wochen?"),
            textInput(inputId = "BSA",
                      label = "BSA %"),
            
        ),
        # Show Generated text in the main window
        mainPanel(
           htmlOutput("templateout")
        )
    )
)

# Define server logic required to generate text based on template
server <- function(input, output) {
        inpts <- reactive({ # start a rective env
            name <- file.path("templates", paste0(input$template, ".R")) # pick a file based on input selection
            source(name, local=TRUE) # source it retaining the text inside
            mget(ls()) # needed for retention 
        })
        empf <- reactive({ # start a rective env
            name <- file.path("empfehlung.R") # pick a file based on input selection
            source(name, local=TRUE) # source it retaining the text inside
            mget(ls()) # needed for retention 
        })
          
          
        output$templateout <- renderUI({ # render text output 
            o <- inpts() # store the generated text from the sourced file in obj
            e <- empf()
            HTML(paste0(
                start,
                o$text1,
                e$text2,
                "<p>&nbsp;</p><p>&nbsp;</p>",
                 sign)) # output the generated text from the sourced template
        })
}
# Run the application 
shinyApp(ui = ui, server = server)
