library(shiny)

shinyUI(fluidPage(
    
    titlePanel("Simulation of the Central Limit Theorem (CLT)"),
    
    sidebarLayout(
        sidebarPanel(
            
            radioButtons("dist", "Distribution type",
                         c("Normal" = "norm",
                           "Binominal" = "binom",
                           "Poisson" = "pois",
                           "Exponential" = "exp")),
            
            conditionalPanel(
                condition = "input.dist == 'norm'",
                numericInput("mu", "Mean", 
                             value = 0
                             ), 
                numericInput("sigma", "Standard deviation", 
                             value = 1, 
                             min = 1)
            ), 
            
            conditionalPanel(
                condition = "input.dist == 'binom'",
                selectInput("p", "P", 
                            choices = seq(0.05, 0.95, 0.05), 
                            selected = 0.5)
            ), 
            
            conditionalPanel(
                condition = "input.dist == 'pois'",
                sliderInput("lambda", "Lambda", 
                             value = 1, 
                             min = 0.01, 
                             max = 20)
            ), 
            
            conditionalPanel(
                condition = "input.dist == 'exp'",
                sliderInput("rate", "Rate", 
                             value = 0.2, 
                             min = 0.01, 
                             max = 100)
            ), 
            
            sliderInput("n", 
                        "Sample size", 
                        min = 1, 
                        max = 100, 
                        value = 2), 
            
            sliderInput("nosim", 
                        "Number of simulations", 
                        min = 1, 
                        max = 1000, 
                        value = 500)

        ),
        
        mainPanel(
            tabsetPanel(
                tabPanel(p(icon("book"), "Documentation"), 
                         br(), 
                         h4("Central Limit Theorem"), 
                         p(a("The central limit theorem", href = "https://en.wikipedia.org/wiki/Central_limit_theorem"), 
                           "(CLT) states that the arithmetic mean of a sufficiently large number of iterates of 
                           independent and identically distributed (i.i.d.) random variables, each with a well-defined 
                           expected value and well-defined variance, will be approximately normally distributed, 
                           regardless of the underlying distribution."), 
                         p("To have a better understanding of the CLT, you can do some simple simulation examples with 
                           this shiny app following the steps below."), 
                         br(), 
                         h4("Instruction"), 
                         tags$div(
                             tags$ul(
                                 tags$li(strong("Distribution type: "), "choose the distribution type of your random 
                                         variable to be generated."),
                                 tags$li(strong("Distribution parameter: "), "specify some parameters of the selected 
                                         distribution above, like mean and standard deviation for a normal distribution."),
                                 tags$li(strong("Sample size: "), "assign the number of random variables."),
                                 tags$li(strong("Number of simulations: "), "select the repeat times.")
                             )), 
                         br(), 
                         h4("Outputs"), 
                         tags$div(
                             tags$ul(
                                 tags$li(strong("Density plot: "), "comparison of the standard normal 
                                         distribution with the distribution 
                                         of sample means, which substract off 
                                         the population mean and devide by the 
                                         standard error of the mean."),
                                 tags$li(strong("Summary table: "), "comparison of the 
                                         average of sample means with theoretical 
                                         mean, the variance of sample means with 
                                         theoretical variance (devided by n).")
                                 ))
                         ), 
                
                tabPanel(p(icon("bar-chart"), "Density plot"), 
                         br(), 
                         plotOutput("plot")
                         ),
                
                tabPanel(p(icon("table"), "Summary table"), 
                         br(), 
                         tableOutput("table")
                         )
                )
            )
        )
))

