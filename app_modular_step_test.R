# Load necessary libraries
library(tidyverse)  
library(DT)
library(shiny)
source("constants.R")

source("./modules/module_input.R")
source("./modules/module_countyplot.R")
source("./modules/module_yearlyplot.R")

dataset <- read.csv("./data/bfro_reports_geocoded.csv")

# App with two sections

ui <- fluidPage(h1("Bigfoot Sightings in the United States", align="center"),
                fluidRow(
                  # Input state
                  column(2,module_input_ui("inputs", dataset)),
                  # Show county plot
                  column(5, module_county_ui("countyplot")),
                  # Show yearly plot
                  column(5, module_yearly_ui("timeplot"))
                ), hr(),
                fluidRow(
                  column(2,module_input_ui("inputs_2", dataset, defaultstate = "Ohio")),
                  column(5, module_county_ui("countyplot_2")),
                  column(5, module_yearly_ui("timeplot_2"))
                ))

# Define server logic ----
server <- function(input, output, session) {
  
  data_filtered <- module_input_server("inputs", dataset)
  module_county_server("countyplot", df_filtered = data_filtered)
  module_yearly_server("timeplot", df_filtered = data_filtered)
  
  data_filtered_2 <- module_input_server("inputs_2", dataset)
  module_county_server("countyplot_2", df_filtered = data_filtered_2)
  module_yearly_server("timeplot_2", df_filtered = data_filtered_2)
  
}

# Run the application 
shinyApp(ui = ui, server = server)


# App with single section

ui <- fluidPage(h1("Bigfoot Sightings in the United States", align="center"),
          fluidRow(
            # Input state
            column(2,module_input_ui("inputs", dataset)),
            # Show county plot
            column(5, module_county_ui("countyplot")),
            # Show yearly plot
            column(5, module_yearly_ui("timeplot"))
          ))

# Define server logic ----
server <- function(input, output, session) {
  
  data_filtered <- module_input_server("inputs", dataset)
  module_county_server("countyplot", df_filtered = data_filtered)
  module_yearly_server("timeplot", df_filtered = data_filtered)

}

# Run the application 
shinyApp(ui = ui, server = server)

# App with two selections

ui <- fluidPage(
  theme = bslib::bs_theme(version = 5,bootswatch = "flatly", primary = colors_theme$primary, bg = "#f7fdfd", fg = "black"),
  h1("Bigfoot Sightings in the United States", align="center"),
  hr(),
  fluidRow(
    column(2, module_input_ui("inputs", dataset)),
    column(5, h4("Sightings for top 10 counties"), module_county_ui("countyplot")),
    column(5, h4("Sightings over time"), module_yearly_ui("timeplot"))
  ),
  hr(),
  fluidRow(
    column(2, module_input_ui("inputs2", dataset, textstring = "Select state to compare", defaultstate = "Ohio")),
    column(5, module_county_ui("countyplot2")),
    column(5, module_yearly_ui("timeplot2"))
  )
)

# Define server logic ----
server <- function(input, output, session) {
  
  data_filtered <- module_input_server("inputs", dataset)
  module_county_server("countyplot", df_filtered = data_filtered)
  module_yearly_server("timeplot", df_filtered = data_filtered)
  
  data_filtered2 <- module_input_server("inputs2", dataset)
  module_county_server("countyplot2", df_filtered = data_filtered2)
  module_yearly_server("timeplot2", df_filtered = data_filtered2)
  
}


# Run the application 
shinyApp(ui = ui, server = server)


