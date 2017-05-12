
library(shiny)

source("./input/constants cycling.R")
source("./input/user defined functions.R")



# Prepopulate the results data frame
# Need to change column labels for output to be 'prettier'
results_df <- data.frame(year = seq(1,max_years,1), 
                    buildup_ben = c(seq(0.2,1,0.2),rep(1, max_years - buildup_years)), 
                    propnew = rep(1,max_years),
                    protective_benefit=rep(1,max_years), 
                    started_cycling = rep(1,max_years), 
                    lives_saved = rep(0,max_years), 
                    money_saved = rep(0, max_years),
                    money_saved_discounted = rep(0, max_years))


shinyServer(function(input, output) {

  # Convert the distance or duration units to common base
  resp_q3 <- reactive({
    unit_standard (input$Q3a, as.numeric(input$Q3b), min(input$Q3c, 365))
  })
  
  # Calculate protective benefit
  benefit_q3 <- reactive({  
    # Have amalgamated the distance and duration radio buttons for question 2
    # and work out which one inputted based upon units specified - just a possibility
    if(input$Q3b=="1" | input$Q3b=="2") {
      benefit_duration (ref_rr_cycle, resp_q3(), ref_du_cycle, ref_weeks)
    } else {
      benefit_distance (ref_rr_cycle, resp_q3(), ref_du_cycle, ref_weeks, ref_sp_cycle)
    }
  })
  
  
  # Update the results data frame
  out_df <- reactive({
    update_data(results_df, benefit_q3(), mortality_data, input$Q7, as.numeric(input$Q8a), 
                input$Q8b, input$Q9a, vsl_data, input$Q9c, input$Q12)
  })
  
  output$results<-renderTable({out_df()})
  
  # ----------------------------------------------------
  # The following for testing
  # ----------------------------------------------------

  #output$LocalDu_Q3 <- renderPrint({resp_q3()})
  #output$PBen_Q3 <- renderPrint({  benefit_q3()  })
  #output$Q8a <- renderPrint({ input$Q8a })
  #output$Q8b <- renderPrint({ input$Q8b })
  #output$Q9a <- renderPrint({ input$Q9a })
  #output$Q9c <- renderPrint({ input$Q9c })
  #output$Q7 <- renderPrint({ input$Q7 })
  #output$list<-renderTable({as.data.frame(reactiveValuesToList(input))})
  #output$Q7 <- renderPrint({ values[["use_case"]] })
  

})
