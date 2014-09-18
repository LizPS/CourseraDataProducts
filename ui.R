library(shiny)

shinyUI(fluidPage(theme="cerulean.css",
	titlePanel("How am I doing?"),
	fluidRow(
                column(3, wellPanel(
        		dateInput(inputId = "Date",
        			label = "Test Date",
                                startview="year"),    
        		textInput(inputId = "TSH",
        			label = "TSH test value",
        			value = ""),
        		textInput(inputId = "T4",
        			label = "Free T4 test value",
        			value = ""),
        		textInput(inputId = "T3",
        			label = "Free T3 test value",
        			value = ""),
        		checkboxInput(inputId = "tx",
        			label = "Include date you began treatment on graph?"),
        		conditionalPanel(
        			condition = "input.tx == true",
        			dateInput(inputId ="TxDate", label = "Date Treatment Began")),
                        actionButton("update", "Update Table")
	)),
	column(8,
		tabsetPanel(type = "tabs",
                        tabPanel("Instructions", htmlOutput("instruct")),
                        tabPanel("Your Results", plotOutput("graph")), #verbatimTextOutput("testing")),
			tabPanel("Your Data", tableOutput("txtable")),
                        tabPanel("About Graves\' Disease", htmlOutput("about"))
		)
	)
)))