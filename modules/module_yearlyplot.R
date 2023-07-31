module_yearly_ui <- function(id) {
  ns <- NS(id)
  plotOutput(outputId = ns("plotyearly"))
}

module_yearly_server <- function(id, df_filtered) {
  moduleServer(id,
               function(input, output, session) {
                 output$plotyearly <- renderPlot(
                   df_filtered() |> 
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
  )
}