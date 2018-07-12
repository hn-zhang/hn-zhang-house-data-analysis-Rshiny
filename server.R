library(shiny)
library(ggplot2)
library(scales)
library(tidyr)
source('helpers.R')


states_map <- map_data("state")
states_map$Mean<-NA
states_map$Median<-NA
states_map$Stdev<-NA
mydata1<-read.csv('kaggle_gross_rent.csv',header = TRUE)
mydata1<-na.omit(mydata1)
mydata1$State_Name<-tolower(mydata1$State_Name)
stata_label<-data.frame(table(mydata1$State_Name))
stata_label$Var1<-as.character(stata_label$Var1)
mydata1$State_Name<-tolower(mydata1$State_Name)
stata_label<-data.frame(table(mydata1$State_Name))
stata_label$Var1<-as.character(stata_label$Var1)
for (state_name in stata_label$Var1) {
    temp<-subset(mydata1,mydata1$State_Name==state_name)
    if (length(states_map[states_map$region==state_name,]$group)!=0) {
        states_map[states_map$region==state_name,]$Mean<-sum(temp$Mean)/length(temp$Mean)
        states_map[states_map$region==state_name,]$Median<-sum(temp$Median)/length(temp$Median)
        states_map[states_map$region==state_name,]$Stdev<-sum(temp$Stdev)/length(temp$Stdev)
    }
}

mydata2<-read.csv('Stock_prices_2017.csv',header = TRUE)
mydata2$Date<-as.character(mydata2$Date)
mydata2$Date<-as.Date(mydata2$Date,"%d/%m/%Y")
mydata2<-mydata2 %>% gather(company,closeprice,-Date)
names(mydata2)<-c("Date","Company","closeprice")
mydata2$Date<-as.POSIXct(mydata2$Date)





function(input, output) {

  #one
 # output$sum<-renderPrint({
    #summary(mydata1)
  #})
  
 
  output$table <- DT::renderDataTable({
    DT::datatable(data = mydata1,
                  options = list(pageLength = 8, lengthMenu = c(10, 15, 50)), 
                  rownames = FALSE)
  })
  
  
  output$plot12<-renderPlot({
      ggplot(data=mydata1, aes(mydata1[input$var2])) + 
          geom_histogram(col="red", 
                         aes(fill=..count..))+xlab("gross rent")+ggtitle(input$var2)})
  
  plotdata131<-data.frame(table(mydata1$State_Name))
  plotdata132<-data.frame(table(mydata1$Type))
  
  plotdata<-reactive({
      if (input$var3=="state") {
          plotdata131
      }else{
          plotdata132
      }
  })
  
  output$plot13<-renderPlot({
      ggplot(plotdata(), aes(x = factor(1), y=Freq,fill=factor(Var1)) ) +
          geom_bar(width = 1,stat="identity")+coord_polar(theta = "y")+theme_void()
  })
  
  output$plot<-renderPlot({
      mean_place<-c(mean(mydata1$Lon),mean(mydata1$Lat))
      mapImageData3 <-get_map(mean_place,zoom = input$Zooms)
      map_data <- ggmap(mapImageData3) +
          geom_point(data=mydata1, aes(x=Lon, y=Lat), colour="Deep Pink", fill="red",pch=21, size=2, alpha=0.5)+
          ggtitle('Available Locations in Selected Area.')
      map_data
  })
  
  # Display data table tab only if show_data is checked
  observeEvent(input$show_location, {
    if(input$show_location){
      showTab(inputId = "analysisTabs", target = "Location", select = TRUE)
    } else {
      hideTab(inputId = "analysisTabs", target = "Location")
    }
  })
  
  
  mapmean <- mydata1$Mean
  mapmedian <- mydata1$Median
  mapstdev <- mydata1$Stdev
  
  mapdata<-reactive({
      if (input$map_var=="Mean") {
          mapmean
      }
      if (input$map_var=="Median"){
          mapmedian
      }
      if (input$map_var=="Stdev"){
          mapstdev
      }
  })
  
  output$areamap <- renderPlot({
      var_name<-input$var1
      ggplot(states_map, aes(x=long,y=lat,group=group)) +
          geom_polygon(aes(fill = states_map[var_name], group=group))+
          labs(title ="Rent Stat in US") + 
          guides(fill=guide_legend(title=input$var1))
  })
  
  #two
  x_variable_company<-reactive({
    input$x_variable2
  })
  x_variable_time <- reactive({
    timetemp1<-input$timeRange[1]
    timetemp2<-input$timeRange[2]
    temp<-c(timetemp1,timetemp2)
    temp
  })

  plotdata2<-reactive({
    time_label<-x_variable_time()
    temp<-subset(mydata2,mydata2$Company==x_variable_company())
    the_temp<-subset(temp,temp$Date>time_label[1]&temp$Date<time_label[2])
    the_temp
  })
  
  output$plot2<-renderPlot({
    ggplot(plotdata2(), aes(x=Date, y=closeprice))+geom_line(size=1.5)+ggtitle(x_variable_company())
  })
  #there
}
