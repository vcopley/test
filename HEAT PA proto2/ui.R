
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(markdown)

mortality_rate_a <- list("average population (about 20-64 years old)" = 2, 
                         "younger average population (about 20-44 years old)" = 4,
                         "older average population (about 45-64 years old)" = 5)

# Mortality and VSL data need to be visible to server.R
mortality_data <<- read.csv("./input data/mortality rates 10June2015.csv")
vsl_data <<- read.csv("./input data/selectedVSL_2014.csv")

ui<-shinyUI(fluidPage(
  navbarPage("HEAT Cycling",
             
          tabPanel("Introduction",
                      fluidRow(
                        column(8,
                            img(src="HEAT.png", align = "left"),
                            br(),
                            br(),
                            br(),
                            br(),
                            br(),
                            br(),
                            includeMarkdown("about.md")
                        )
                      )

           ),   # end of Introduction tab panel
  
          tabPanel("Cycling data input",
            fluidRow(
              column(6,
                     
                radioButtons("Q1", label = h4("Q1: Single point in time or pre/post"), 
                             choices = list("Single" = 1, "Pre/post" = 2), 
                             selected = 1),
          
          
                radioButtons("Q2", label = h4("Q2: Please specify duration, distance, or trips"), 
                            choices = list("Duration or distance" = 1, "Trips (not yet implemented)" = 3), 
                            selected = 1),
                
                numericInput("Q3a", label = h4("Q3a: Enter the average distance or duration of cycling per person per day"), value = 1),
                
                radioButtons("Q3b", label = h4("Q3b: Units for Q3a"), 
                            choices = list("minutes" = "1", "hours" = "2", "km" = "3", "miles" = "4", "metres" = "5"), 
                            selected = 1),
                
                # Numeric input does not respect the max when value entered by keyboard
                numericInput("Q3c", label = h4("Q3c: How many days per year do people cycle this amount?"), value = 100, max=365),
                
                numericInput("Q7", label = h4("Q7: Total number of individuals regularly doing this amount of cycling"), value = 1500)
               )
              )
            ),  # End tab panel
          
            tabPanel("Other data input",
              fluidRow(
                column(5,  
          
                  radioButtons("Q8a", label = h4("Q8a: Mortality age group"), 
                              choices = mortality_rate_a, 
                              selected = 5),
                  
                  selectInput("Q8b", label = h4("Q8b: Mortality region"), 
                              choices = mortality_data$Area, 
                              selected = 1),
                  
                  selectInput("Q9a", label = h4("Q9a: Value of a statistical life country defaults"), 
                              choices = vsl_data$Area, 
                              selected = 1),
                  
                  selectInput("Q9b", label = h4("Q9b: Value of a statistical life currency"), 
                              choices = list("EUR" = "1", "USD" = "2", "DKK" = "3"), 
                              selected = 1)
                  ),   # end column 
              
                  column(5,  
                     numericInput("Q9c", label = h4("Q9c: Value of a statistical life user specified (overrides Q9a if value greater than 0)"), 
                                  value = 0),
                     
                     
                     selectInput("Q10", label = h4("Q10: Number of years over which benefits are calculated"), 
                                 choices = c(1:25), 
                                 selected = 1),
                     
                     numericInput("Q11a", label = h4("Q11a: Please enter the total costs of the intervention"), 
                                  value = 15000),
                     
                     selectInput("Q11b", label = h4("Q11b: Number of years over which cost savings are calculated"), 
                                 choices = c(1:25), 
                                 selected = 1),
                     
                     numericInput("Q12", label = h4("Q12: Discount rate to apply to future benefits"), 
                                  value=0.05, min=0, max=0.2)

               ))
            ),  # End of tab panel 'other data input'
          
        tabPanel("Results summary"),  # Not yet implemented
        tabPanel("Results table",      
                 tableOutput("results"))
        
        )       # End of tab panel 'Results table'
))
