# Load necessary libraries
library(tidyverse)  
library(DT)
library(shiny)
source("constants.R")

source("./modules/module_input.R")
source("./modules/module_countyplot.R")
source("./modules/module_yearlyplot.R")

dataset <- read.csv("./data/bfro_reports_geocoded.csv")

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
