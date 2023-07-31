# Load necessary libraries
library(tidyverse)  
library(DT)
library(shiny)

dataset <- read.csv("./data/bfro_reports_geocoded.csv")

ui <- fluidPage(
  theme = bslib::bs_theme(version = 5,bootswatch = "flatly", primary = "#008080", bg = "#f7fdfd", fg = "black"),
  h1("Bigfoot Sightings in the United States", align="center"),
  hr(),
  fluidRow(
    column(2,
           selectizeInput(inputId = "state", label = "Select State", choices = unique(dataset$state),  selected = "Washington", multiple = FALSE)
    ),
    column(5,
           h4("Sightings for top 10 counties"),
           plotOutput(outputId = "plotcounty")
    ),
    column(5,
           h4("Sightings over time"),
           plotOutput(outputId = "plotyearly")
    )
  ),
  hr(),
  fluidRow(
    column(2,
           selectizeInput(inputId = "state2", label = "Select State to compare", choices = unique(dataset$state),  selected = "Ohio", multiple = FALSE)
    ),
    column(5,
           plotOutput(outputId = "plotcounty2")
    ),
    column(5,
           plotOutput(outputId = "plotyearly2")
    )
  )
)

# Define server logic ----
server <- function(input, output, session) {
  
  # filter data based on user selection
  data_filtered <- reactive({dataset |> filter(state == input$state)})

  # County plot
  output$plotcounty <- renderPlot(
    data_filtered() |> 
      count(county) |> 
      mutate(county = fct_reorder(as.factor(county), n)) |> 
      arrange(desc(n)) |> 
      top_n(10) |> 
      ggplot() +
      geom_col(aes(county, n, fill = n), colour = NA, width = 0.8)+
      geom_label(aes(county, n+1.5, label = n), size = 4, color = "black")+
      scale_fill_gradientn(colours = c("#008080",  high = "black")) +
      labs(y = "",x = "") +
      theme_minimal() +
      coord_flip() +
      ylim(c(0,85)) +
      theme(
        panel.grid = element_blank(),
        text = element_text(size = 20),
        axis.text.x = element_blank(),
        legend.position = "none",
        plot.background = element_rect(fill = "#e7fafa")
      )
  )
  
  # Yearly plot
  output$plotyearly <- renderPlot(
    data_filtered() |> 
      mutate(year = floor_date(as.Date(date), 'year')) |> 
      count(year) |> 
      filter(!is.na(year)) |> 
      arrange(desc(n)) |> 
      mutate(highest = ifelse(row_number()==1,str_glue("Highest yearly sighting: {n}\nYear: {substr(year, 1, 4)}"),NA),
             highest_count = ifelse(row_number()==1,n,NA))  |> 
      ggplot(aes(year, n)) + 
      geom_point(color = "#008080", alpha=0.3, size = 2) +
      geom_point(aes(year, highest_count), color = "red", alpha=1, size = 2) +
      stat_smooth(inherit.aes = TRUE, se = FALSE, span = 0.3, show.legend = TRUE, color = "#008080") +
      scale_y_continuous(breaks = function(z) seq(0, range(z)[2], by = 5)) +
      ylim(c(0,38)) +
      geom_text(aes(year, n+1, label = highest), hjust=0, size = 7, nudge_y = 2) +
      scale_x_date(date_labels = "%Y", breaks = "6 year", limits = as.Date(c("1989-01-01", "2023-01-01"))) +
      theme_minimal() +
      theme(
        panel.grid.major = element_blank(),
        text = element_text(size = 20),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        plot.background = element_rect(fill = "#e7fafa")
      )
  )
  
  # filter data based on user selection
  data_filtered2 <- reactive({dataset |> filter(state == input$state2)})
  
  # County plot
  output$plotcounty2 <- renderPlot(
    data_filtered2() |> 
      count(county) |> 
      mutate(county = fct_reorder(as.factor(county), n)) |> 
      arrange(desc(n)) |> 
      top_n(10) |> 
      ggplot() +
      geom_col(aes(county, n, fill = n), colour = NA, width = 0.8)+
      geom_label(aes(county, n+1.5, label = n), size = 4, color = "black")+
      scale_fill_gradientn(colours = c("#008080",  high = "black")) +
      labs(y = "",x = "") +
      theme_minimal() +
      coord_flip() +
      ylim(c(0,85)) +
      theme(
        panel.grid = element_blank(),
        text = element_text(size = 20),
        axis.text.x = element_blank(),
        legend.position = "none",
        plot.background = element_rect(fill = "#e7fafa")
      )
  )
  
  # Yearly plot
  output$plotyearly2 <- renderPlot(
    data_filtered2() |> 
      mutate(year = floor_date(as.Date(date), 'year')) |> 
      count(year) |> 
      filter(!is.na(year)) |> 
      arrange(desc(n)) |> 
      mutate(highest = ifelse(row_number()==1,str_glue("Highest yearly sighting: {n}\nYear: {substr(year, 1, 4)}"),NA),
             highest_count = ifelse(row_number()==1,n,NA))  |> 
      ggplot(aes(year, n)) + 
      geom_point(color = "#008080", alpha=0.3, size = 2) +
      geom_point(aes(year, highest_count), color = "red", alpha=1, size = 2) +
      stat_smooth(inherit.aes = TRUE, se = FALSE, span = 0.3, show.legend = TRUE, color = "#008080") +
      scale_y_continuous(breaks = function(z) seq(0, range(z)[2], by = 5)) +
      ylim(c(0,38)) +
      geom_text(aes(year, n+1, label = highest), hjust=0, size = 7, nudge_y = 2) +
      scale_x_date(date_labels = "%Y", breaks = "6 year", limits = as.Date(c("1989-01-01", "2023-01-01"))) +
      theme_minimal() +
      theme(
        panel.grid.major = element_blank(),
        text = element_text(size = 20),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        plot.background = element_rect(fill = "#e7fafa")
      )
  )
}

# Run the application 
shinyApp(ui = ui, server = server)