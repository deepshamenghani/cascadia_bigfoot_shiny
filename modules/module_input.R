
module_input_ui <- function(id, df, defaultstate = "Washington") {
  # Namespace
  ns <- NS(id)
  # Input UI command
  selectizeInput(inputId = ns("stateinput"), label = "Select state", 
                 choices = unique(df$state),  
                 selected = defaultstate, multiple = FALSE)
}

module_input_server <- function(id, df) {
  moduleServer(id,
               function(input, output, session) {
                 # Filter data set based on input
                 table <- reactive({df |> filter(state == input$stateinput)})
                 return(table)
               }
  )
}

### Testing the modules

dataset <- read.csv("./data/bfro_reports_geocoded.csv")

ui_test_multiple <- fluidPage(
  # Call the ui module as a function
  module_input_ui("input_test1", df=dataset),
  module_input_ui("input_test2", df=dataset, defaultstate = "Ohio"),
  module_input_ui("input_test3", df=dataset, defaultstate = "California"))


server_test_multiple <- function(input, output, session) {
  # Call the server module as a function
  data_filtered1 <- module_input_server("input_test1", df=dataset)
  data_filtered2 <- module_input_server("input_test2", df=dataset)
  data_filtered3 <- module_input_server("input_test3", df=dataset)
}

# Call the shiny app
shinyApp(ui=ui_test_multiple, server=server_test_multiple)

ui_test <- fluidPage(
  # Call the ui module as a function
  module_input_ui("input_test", df=dataset))

server_test <- function(input, output, session) {
  # Call the server module as a function
  data_filtered <- module_input_server("input_test", df=dataset)
}

# Call the shiny app
shinyApp(ui=ui_test, server=server_test)