module_county_ui <- function(id) {
  ns <- NS(id)
  plotOutput(outputId = ns("plotcounty"))
}





module_county_server <- function(id, df_filtered) {
  moduleServer(id,
               function(input, output, session) {
                 output$plotcounty <- renderPlot(
                   df_filtered() |> 
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
               }
  )
}