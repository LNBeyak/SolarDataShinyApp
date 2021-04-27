#Shiny App Project - Solar Output

library(shiny)
library(tidyverse)
library(dplyr)


setwd("/Users/lindsaybeyak/ShinyApp Projects")
energy <- read.csv("~/ShinyApp Projects/UNdata_Export_20210423_043803904.csv")

year <- energy$Year
quant <- energy$Quantity

ui <- fluidPage(
    headerPanel("Solar Output"),
    sidebarPanel("by Country", "Select Country", 
                 choices = c("Canada", "USA", "China")),
    sliderInput("Year", "Select Year to view", min = 2015, max = 2018, value = 1000, step = 100)
    mainPanel("With Histograms")
  )
server <- function(input, output)
  
shinyApp(ui = ui, server = server)

####

ui <- fluidPage(
  plotOutput("plot", click = "plot_click"),
  verbatimTextOutput("info")
)

server <- function(input, output) {
  output$plot <- renderPlot({
    plot(energy$Year, energy$Quantity)
  }, res = 96)
  
  output$info <- renderPrint({
    req(input$plot_click)
    x <- round(input$plot_click$x, 2)
    y <- round(input$plot_click$y, 2)
    cat("[", x, ", ", y, "]", sep = "")
  })
}
shinyApp(ui = ui, server = server)

#Clicking on the points in the graph shows the Year for each country!!!

ui <- fluidPage(
  plotOutput("plot", click = "plot_click"),
  tableOutput("data")
)
server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot(energy, aes(Year, Quantity)) + geom_point()
  }, res = 96)
  
  output$data <- renderTable({
    req(input$plot_click)
    nearPoints(energy, input$plot_click)
  })
}
shinyApp(ui = ui, server = server)

