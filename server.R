# stuff that runs once when app is launched
library(shiny)
library(ggplot2)
library(reshape2)
library(scales)
source("thy.R")
aboutTxt <- paste(readLines("about.txt"), collapse=' ')
instructTxt <- paste(readLines("instruct.txt"), collapse=' ')


shinyServer(function(input, output, session){
#everything in here run once each time a user visits the app
        myvalues <- reactiveValues()
        myvalues$df <-data.frame(Date=as.character("2012-01-01"), TSH=2.95, 
                                 FreeT4=1.25, FreeT3= 3.2,
                                 stringsAsFactors=FALSE)
        
        newEntry <- observe({
                if(input$update > 0) {
                        newLine <- isolate(list(as.character(input$Date),
                                                as.numeric(input$TSH),
                                                as.numeric(input$T4),
                                                as.numeric(input$T3)))
                        myvalues$df <- isolate(rbind(myvalues$df, newLine))
                }
        })

        
        output$testing <- renderText({
                        class(myvalues$df)
                })
        output$instruct <- renderText({instructTxt})
        output$about <- renderText({aboutTxt})
        output$graph <- renderPlot ({
        #everything in here changes each time a user changes a widget that this output relies on
                newdf <- data.frame(myvalues$df)
                t_graph(myvalues$df, input$tx, input$TxDate)
        })
        output$txtable <- renderTable({myvalues$df})
})