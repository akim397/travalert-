#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(calendar)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Travalert!"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            fileInput('file1', "Submit .ical file",
                      accept = "co.ical")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            dataTableOutput('table')
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    infile <- reactive({
        infile <- input$file1
        if (is.null(infile)) {
            # User has not uploaded a file yet
            return(NULL)
        } else {
        cFrame <- ic_read(infile$name) 
        # the above returns a char vector with names of objects loaded
        cFrameFinal <-  data.frame(cFrame[substring(cFrame$DTSTART,1,10) > Sys.Date() | cFrame$'DTSTART;VALUE=DATE' > Sys.Date(), names(cFrame) %in% c("LOCATION","DTSTART","DTEND","SUMMARY","DTSTART;VALUE=DATE","DTEND;VALUE=DATE")])
        #cFrameFinal <- cFrameFinal[cFrameFinal$LOCATION != "NA",1:2]
        # the above finds the first object and returns it
        return(cFrameFinal)
        }
    })
    
    myData <- reactive({
        df<-infile()
        if (is.null(df)) return(NULL)
        return(df)
    })
    
    output$table <- renderDataTable({
        myData()
    })
}


# Run the application 
shinyApp(ui = ui, server = server)
