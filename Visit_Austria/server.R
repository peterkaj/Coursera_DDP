# by peterkaj
# 7.3.2017

weather <- read.csv(file="./weather_data.csv", sep=";", dec=",", stringsAsFactors = FALSE)

library(shiny)
library(dplyr)
suppressPackageStartupMessages(library(googleVis))

default <- data.frame(typ=c("none", "ski", "swim", "bike", "city"),
                      rain_min=c(0, 0, 0, 0, 0),
                      rain_max=c(69, 40, 10, 10, 30),
                      tmin_min=c(-28, -28, 5, 1, 0),
                      tmin_max=c(19, 0, 19, 14, 12),
                      tmax_min=c(-19, -10, 10, 5, 5),
                      tmax_max=c(35, 9, 35, 25, 30),
                      prob=c(80, 80, 80, 70, 50))


shinyServer(function(input, output, session) {
        output$calendar <- renderGvis({

                rain_prob <- group_by(weather, date) %>% summarise(sum(rain>=input$rain_ip[1] & rain<=input$rain_ip[2])/n()) #calc probability of rainvolumen between the input values
                tmin_prob <- group_by(weather, date) %>% summarise(sum(tmin>=input$tmin_ip[1] & tmin<=input$tmin_ip[2])/n())
                tmax_prob <- group_by(weather, date) %>% summarise(sum(tmax>=input$tmax_ip[1] & tmax<=input$tmax_ip[2])/n())
                names(rain_prob) <- c("date", "prain") #appropriate names for the dataframes
                names(tmin_prob) <- c("date", "ptmin")
                names(tmax_prob) <- c("date", "ptmax")
                pweather <- data.frame(rain_prob, ptmin=tmin_prob$ptmin, ptmax=tmax_prob$ptmax) #combine the probabilities
                days <- data.frame(date=strptime(pweather$date, "%m/%d", tz="CEST"), ok=FALSE)
                days$ok <- as.numeric(with(pweather, prain>=input$prob/100 & ptmin>=input$prob/100 & ptmax>=input$prob/100))
                days <- days[complete.cases(days),]
                gvisCalendar(days, datevar = "date", numvar = "ok",
                             options=list(
                                     title="Calendar",
                                     width=1000,
                                     colorAxis="{minValue:0, maxValue:1, colors:['white', 'lightgreen']}",
                                     calendar="{yearLabel: { fontName: 'Times-Roman',
                                     fontSize: 24, color: 'lightgreen', bold: true},
                                     cellSize: 17,
                                     cellColor: { stroke: 'red', strokeOpacity: 0.2 },
                                     focusedCellColor: {stroke:'red'}}")
                             )
        })
        observe({
                typ <- input$example

                updateSliderInput(session, "rain_ip", value = c(default$rain_min[default$typ==typ], default$rain_max[default$typ==typ]))
                updateSliderInput(session, "tmin_ip", value = c(default$tmin_min[default$typ==typ], default$tmin_max[default$typ==typ]))
                updateSliderInput(session, "tmax_ip", value = c(default$tmax_min[default$typ==typ], default$tmax_max[default$typ==typ]))
                updateSliderInput(session, "prob", value = default$prob[default$typ==typ])
        }, suspended = FALSE, priority = 10)

})
