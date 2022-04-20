# App -------------------------------------------------------------------------------------------------------------

library(shiny)
library(shinydashboard)
source('map.R')

header <- dashboardHeader(title = "Visualizing Homelessness", titleWidth = 300)

sidebar <- dashboardSidebar(disable = TRUE) # removing the sidebar as I won't really need one.

body <- dashboardBody(
    fluidRow(
        column(width = 4, 
               box(title = "Summary of Total Homelessness", verbatimTextOutput("summary"), width = NULL),
               valueBoxOutput("total", width = NULL), 
               box(title = "Total Homelessness, by Region", tableOutput("table"), width = NULL)),
        column(width = 8,
               box(title = "Rates of Homelessness, Overall",
                   leafletOutput("overall"), width = NULL))
        ), 
    
    fluidRow(
        tabBox(title = "Homelessness by Gender", 
               selected = "Female",
               side = "right",
               tabPanel("Male", leafletOutput("gender.male")), 
               tabPanel("Female", leafletOutput("gender.female"))), 
        
        tabBox(title = "Homelessness by Ethnicity", 
               selected = "Black", 
               side = "right", 
               tabPanel("White", leafletOutput("ethn.white")),
               tabPanel("Indian", leafletOutput("ethn.indian")), 
               tabPanel("Latin", leafletOutput("ethn.latin")), 
               tabPanel("Black", leafletOutput("ethn.black")))
    )
)

ui <- dashboardPage(header, sidebar, body)




server <- function(input, output) {
    # overall maps 
    output$overall <- renderLeaflet({total.homeless.map})
    
    # summary of the total homeless people in the country 
    output$summary <- renderPrint({
        summary(united.states.merged.home$Total.Homeless)
    })
    
    output$total <- renderValueBox({
        valueBox(as.character(sum(united.states.merged.home$Total.Homeless)),
                 subtitle = paste0("Total Homeless Individuals in the United States"))
    })
    
    # listing gender maps 
    output$gender.male <- renderLeaflet({male.homeless.map})
    output$gender.female <- renderLeaflet({female.homeless.map})
    
    output$ethn.white <- renderLeaflet({white.homeless.map})
    output$ethn.asian <- renderLeaflet({indian.homeless.map})
    output$ethn.latin <- renderLeaflet({lat.homeless.map})
    output$ethn.black <- renderLeaflet({black.homeless.map})
    
    # aggregates of homelessness per region
    output$table <- renderTable({
      values <-  aggregate(united.states.merged.home$Total.Homeless, 
                           by = list(Region = united.states.merged.home$Region), 
                           FUN = sum)
      values$x <- round(values$x, digits = 0)
      values <- values %>%
        rename(`Homeless Population` = x)
      
      values
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
