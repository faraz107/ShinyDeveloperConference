# Exercise 3 - Solution

uploadModuleInput <- function(id) {
  ns <- NS(id)

  tagList(
    fileInput(ns("file"), "Select a csv file"),
    checkboxInput(ns("heading"), "Has header row"),
    checkboxInput(ns("strings"), "Coerce strings to factors"),
    textInput(ns("na.string"), "NA symbol", value = "NA")
  )
}

uploadModule <- function(input, output, session, ...) {

  userFile <- reactive({
    # If no file is selected, don't do anything
    req(input$file)
  })

  # The user's data, parsed into a data frame
  reactive({
    read.csv(userFile()$datapath,
      header = input$heading,
      stringsAsFactors = input$strings,
      na.string = input$na.string,
      ...)
  })
}

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      uploadModuleInput("datafile")
    ),
    mainPanel(
      dataTableOutput("table")
    )
  )
)

server <- function(input, output, session) {
  
  datafile <- callModule(uploadModule, "datafile")

  output$table <- renderDataTable({
    datafile()
  })
}

shinyApp(ui, server)