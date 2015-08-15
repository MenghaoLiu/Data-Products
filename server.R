library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
    
    DT <- reactive({
        dist <- switch(input$dist,
                       norm = rnorm,
                       binom = rbinom,
                       pois = rpois,
                       exp = rexp,
                       rnorm)
        
        n <- input$n
        nosim <- input$nosim
        set.seed(123456)
        
        if (input$dist == "norm") {
            mu <- input$mu; sigma <- input$sigma
            x <- c(apply(matrix(dist(nosim * n, mu, sigma), nosim), 1, mean))
        } else if (input$dist == "binom") {
            mu <- as.numeric(input$p); sigma <- sqrt(mu*( 1- mu))
            x <- c(apply(matrix(dist(nosim * n, 1, mu), nosim), 1, mean))
        } else if (input$dist == "pois") {
            mu <- input$lambda; sigma <- sqrt(input$lambda)
            x <- c(apply(matrix(dist(nosim * n, input$lambda), nosim), 1, mean))
        } else if (input$dist == "exp") {
            mu <- 1/(input$rate); sigma <- 1/(input$rate)
            x <- c(apply(matrix(dist(nosim * n, input$rate), nosim), 1, mean))
        }
        
        scale_x <- sqrt(n)*(x - mu)/sigma
        data.frame(x,  scale_x = sqrt(n)*(x - mu)/sigma)
        
    })
    
    
    sumTable <- reactive({
        dist <- switch(input$dist,
                       norm = rnorm,
                       binom = rbinom,
                       pois = rpois,
                       exp = rexp,
                       rnorm)
        
        n <- input$n
        nosim <- input$nosim
        set.seed(123456)
        
        if (input$dist == "norm") {
            mu <- input$mu; sigma <- input$sigma
            x <- c(apply(matrix(dist(nosim * n, mu, sigma), nosim), 1, mean))
        } else if (input$dist == "binom") {
            mu <- as.numeric(input$p); sigma <- sqrt(mu*( 1- mu))
            x <- c(apply(matrix(dist(nosim * n, 1, mu), nosim), 1, mean))
        } else if (input$dist == "pois") {
            mu <- input$lambda; sigma <- sqrt(input$lambda)
            x <- c(apply(matrix(dist(nosim * n, input$lambda), nosim), 1, mean))
        } else if (input$dist == "exp") {
            mu <- 1/(input$rate); sigma <- 1/(input$rate)
            x <- c(apply(matrix(dist(nosim * n, input$rate), nosim), 1, mean))
        }
        sample_mu <- mean(x); sample_var <- var(x)
        data.frame(
            Name = c("Average of sample means", 
                     "Theoretical mean", 
                     "Variance of sample means", 
                     "Theoretical variance (devided by n)"), 
            Value = round(c(sample_mu, mu, sample_var, (sigma/sqrt(n))^2), 
                          digits = 2), 
            stringsAsFactors = F)
    })
    
    output$plot <- renderPlot({
        g <- ggplot(DT(), aes(x = scale_x)) + 
            xlab("Value") + 
            ylab("Density")

        g + geom_histogram(alpha = 0.9, binwidth = 0.5, color = "white", 
                           fill = "tomato", aes(y = ..density..)) + 
            stat_function(fun = dnorm, size = 1.5) + 
            theme(axis.title.x = element_text(size = 14, vjust = 0.1)) + 
            theme(axis.title.y = element_text(size = 14, vjust = 1.5)) + 
            theme(axis.text.x = element_text(size = 12, color = "grey30")) + 
            theme(axis.text.y = element_text(size = 12, color = "grey30")) + 
            theme(panel.background = element_blank()) + 
            theme(panel.background = element_rect(color = "black"))

    })
    
    output$table <- renderTable({
        sumTable()
    })
    
})