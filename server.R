# Load libraries
library(shiny)
library(tidyverse)

# Read in data
adult <- read_csv("adult.csv")
# Convert column names to lowercase for convenience 
names(adult) <- tolower(names(adult))

# Define server logic
shinyServer(function(input, output) {
  
  df_country <- reactive({
    adult %>% filter(native_country == input$country)
  })
  
  # TASK 5: Create logic to plot histogram or boxplot
  output$p1 <- renderPlot({
    if (input$graph_type == "histogram") {
      # Histogram
      ggplot(df_country(), color=I("black"),aes_string(x = input$continuous_variable)) +
        geom_histogram(colour="black") +  # labels
        facet_wrap(~prediction)+ # histogram geom
        ylab("Number of people")+
        if(input$continuous_variable=="hours_per_week"){
          ggtitle("Trends of hours_per_week")}
        else{
          ggtitle("Trends of age")}# facet by prediction
    }
    else {
      # Boxplot
      ggplot(df_country(), aes_string(y = input$continuous_variable)) +
        geom_boxplot() +  # boxplot geom
        coord_flip()+# labels 
        facet_wrap(~prediction) +  # flip coordinates
        labs(x="Number of people")+
        if(input$continuous_variable=="age"){
          ggtitle("Trends of age")}
        else{
          ggtitle("Trends of hours_per_week")}# facet by prediction
    }
    
  })


  
  # TASK 6: Create logic to plot faceted bar chart or stacked bar chart
  output$p2 <- renderPlot({
    # Bar chart
  #  p <- ggplot(df_country(), aes_string(x = input$categorical_variable)) +
  #    labs(title = "Trend of workclass") +  # labels
  #    theme(plot.title = element_text(face = "bold",color ="blue" ))    # modify theme to change text angle and legend position
    

    
    
    if (input$is_stacked) {
      ggplot(df_country(), aes_string(x=input$categorical_variable))+
        geom_bar(colour="black",aes(fill=prediction))+
        labs("y=Number of people")
      # add bar geom and use input$categorical_variables as fill 
      #,fill=input$categorical_variables
      # facet by prediction

     
    }
    else{
        ggplot(df_country(), 
               aes_string(x=input$categorical_variable))+ 
          geom_bar(position ="stack",colour="black",aes(fill=input$categorical_variable))+
          facet_wrap(~prediction)+
          labs(title = "Trend of workclass",y="Number of people")+
          #,fill=adult$PREDICTION
          theme(plot.title = element_text(face = "bold",color ="blue" ))    # modify theme to change text angle and legend position
        # add bar geom and use prediction as fill
      
      
    }
 })

})
