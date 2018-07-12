library(shiny)
library(shinydashboard)
library(ggmap)
library(maps)
library(mapproj)
library(DT)

dashboardPage(
  skin="blue",
  
  #Title
  dashboardHeader(title="Shiny App by Haining",titleWidth=550,
                  dropdownMenu(type = "messages",
                               messageItem(
                                   from = "Sales Dept",
                                   message = "Sales are steady this month."
                               ),
                               messageItem(
                                   from = "New User",
                                   message = "How do I register?",
                                   icon = icon("question"),
                                   time = "13:45"
                               ),
                               messageItem(
                                   from = "Support",
                                   message = "The new server is ready.",
                                   icon = icon("life-ring"),
                                   time = "2018-2-5"
                               )
                  ),
                  dropdownMenu(type = "notifications",
                               notificationItem(
                                   text = "5 new users today",
                                   icon("users")
                               ),
                               notificationItem(
                                   text = "12 items delivered",
                                   icon("truck"),
                                   status = "success"
                               ),
                               notificationItem(
                                   text = "Server load at 86%",
                                   icon = icon("exclamation-triangle"),
                                   status = "warning"
                               )
                  ),
                  dropdownMenu(type = "tasks", badgeStatus = "success",
                               taskItem(value = 90, color = "green",
                                        "Documentation"
                               ),
                               taskItem(value = 17, color = "aqua",
                                        "Project X"
                               ),
                               taskItem(value = 75, color = "yellow",
                                        "Server deployment"
                               ),
                               taskItem(value = 80, color = "red",
                                        "Overall project"
                               )
                  )
    ),
  
  #Sidebar
  dashboardSidebar(
    width = 221,
    sidebarMenu(
      menuItem("Rent Analysis", tabName = "one", icon = icon("th")),
      menuItem("Time Series", tabName = "two", icon = icon("industry")),
      menuItem("Self Intro", tabName = "three", icon = icon("user-circle")),
      menuItem("Source code", icon = icon("file-code-o"), 
               href = "https://github.com/rannie-zhang/rent_shiny"),
      
     
      
      br(),
      
      # Show data table
      checkboxInput(inputId = "show_location",
                    label = "Show avaliable locations",
                    value = TRUE),
    
      # Built with Shiny by RStudio
      br(),
      h5("Built with",
         img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "20px"),
         "by",
         img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "20px"),
         ".",align = "center")
      
    )),
  
  #Content within the tabs
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
    ),
    
    tabItems(
      tabItem(tabName = "one",
              mainPanel(width=12,
                tabsetPanel(id ="analysisTabs", 
                            tabPanel(title = "Map", 
                                     sidebarLayout(
                                         sidebarPanel( 
                      
                                             selectInput("var1", 
                                                         label = "Metric to Display for Rent Stat",
                                                         choices = c("Mean", "Median",
                                                                     "Stdev"),
                                                         selected = "Mean")),
                                        
                                       mainPanel(fluidRow(box(title = "rent map",width = 50, solidHeader = TRUE,
                                                              status = "primary",plotOutput("areamap"))
                                                ))
                                       )),
                            tabPanel(title = "Location", 
                                     
                                     sidebarLayout(
                                       sidebarPanel(
                                       sliderInput("Zooms","Zoom value:",min = 1,
                                                   max = 20,value = 8) ),
                                    mainPanel(fluidRow(box(title = "avaliable location",width = 50, solidHeader = TRUE,
                                                  status = "success",plotOutput(outputId="plot"))))
                                     )),
                            
                            tabPanel(title = "EDA",
                                     fluidRow(box(width = 6,
                                       selectInput("var2", 
                                                   label = "Variable for Histgram",
                                                   choices = c("Mean", "Median",
                                                               "Stdev"),
                                                   selected = "Mean"),
                                      collapsible = TRUE,plotOutput("plot12"))
                                       ,
                                       box(width = 6,
                                       selectInput("var3", 
                                                   label = "Variable for Pie Chart",
                                                   choices = c("state", "type"),
                                                   selected = "type"),
                                      collapsible = TRUE,plotOutput("plot13"))
                                       )
                                   )
                                  ,
                            tabPanel(title = "Data", 
                                     br(),
                                     DT::dataTableOutput("table"))
                            
                ) 
              )
            ),
      tabItem(tabName = "two",
            fluidRow(
                box(
                  selectInput("x_variable2","Company",
                              list(variable=c("AMZN","KMX","GOOG","GE"))
                              )),
                column(width = 12,sliderInput("timeRange", label = "Time range",
                            min = as.POSIXct("2017-01-01"),
                            max = as.POSIXct("2017-12-31"),
                            value = c(
                              as.POSIXct("2017-01-01"),
                              as.POSIXct("2017-12-31")
                            ))),
                box(plotOutput("plot2"))
                )
      )
      ,
      tabItem(tabName = "three",
              fluidPage(
                mainPanel(
                  img(src='IMG.JPG', align = "center",width=500, height=400)
                ),
                column(width = 12,h3("Haining Zhang"),
                       h4("Love challenges, have huge passion on statistical analysis and programing."))
              )
      )
  )
 )
)

