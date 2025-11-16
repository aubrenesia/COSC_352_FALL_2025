library(shiny)
library(dplyr)
library(ggplot2)
library(DT)

data <- read.csv("data/homicides.csv")

ui <- fluidPage(
  titlePanel("Baltimore Homicides Dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput("year", "Year", choices = unique(data$Year), selected = "2025"),
      selectInput("cause", "Cause of Death", choices = unique(data$Cause), multiple = TRUE)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Trend", plotOutput("trendPlot")),
        tabPanel("Table", DTOutput("dataTable"))
      )
    )
  )
)

server <- function(input, output) {
  filtered <- reactive({
    data %>%
      filter(Year == input$year, Cause %in% input$cause)
  })
  
  output$trendPlot <- renderPlot({
    ggplot(filtered(), aes(x = Date)) +
      geom_histogram(binwidth = 30, fill = "steelblue") +
      labs(title = paste("Monthly Homicides in", input$year), x = "Date", y = "Count")
  })
  
  output$dataTable <- renderDT({
    datatable(filtered())
  })
}

shinyApp(ui = ui, server = server)
