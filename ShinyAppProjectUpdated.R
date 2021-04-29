library(tidyverse)
library(ggplot2)
library(shiny)
library(dplyr)
library(leaflet)
library(shinydashboard)


energy <- read_csv("UNData.csv")
q1 <- c("United States", "Sweden", "Australia", "Japan", "Germany")
q2 <- c("2005", "2000", "2006", "2010", "2016")


ui <- fluidPage(
  titlePanel("UNdata Solar Energy Outputs"),
  sidebarLayout(
    sidebarPanel(
      selectInput("country", "Select Country", choices = energy$Country),
    ),
    mainPanel(
      tableOutput("energydata"),
      plotOutput("plot", click = "plot_click"),
      tableOutput("data"),
      checkboxGroupInput("q1", "In 1999, which country had an output of '254.00'?", choices = q1),
      checkboxGroupInput("q2", "What year did Canada's output peak before declining?", choices = q2),
      textInput("country", "What country has the highest amount of output on the plot? Hint: 2018")
    )
  )
)

server <- function(input, output){
  output$countries <- renderTable(input$country)
  output$energydata <- renderTable({
    stateFilter <- subset(energy, energy$Country == input$country)})
  output$plot <- renderPlot({
    ggplot(energy, aes(x=Year, y=Quantity)) + geom_point(color = "steelblue") +
      ggtitle("Click on a variable to see each country's solar production summary each year") +
      ylab("Quantity in Kilotwatt hours")+
      theme(plot.title = element_text(hjust = 0.5))
  }, res = 98)
  
  output$data <- renderTable({
    req(input$plot_click)
    nearPoints(energy, input$plot_click)
  })
}

shinyApp(ui=ui, server=server)