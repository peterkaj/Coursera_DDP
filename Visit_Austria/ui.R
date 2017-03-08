# by peterkaj
# 7.3.2017

library(shiny)
shinyUI(navbarPage("Best time to visit Austria",
                   title="Best days to visit Austria",
                   tabPanel("Application",
                            fluidRow(
                                column(4,
                                       wellPanel(
                                        h4(HTML("Please specify <br> the desired weather conditions"))
                                       ),
                                       wellPanel(
                                        helpText(HTML("The Application will show <br>
                                                        the best days to visit Austria <br>
                                                        (which fits the specified weather conditions)<br>
                                                        in the calendar below"))
                                       )
                                ),
                                column(5,
                                      wellPanel(
                                        sliderInput('rain_ip', 'Range of rainfall quantity [mm]', min=0, max=69, value=c(0,69), step=1),
                                        sliderInput('tmin_ip', 'Range of the lowest daily temperature [°C]', min=-28, max=19, value=c(-28,19), step=1),
                                        sliderInput('tmax_ip', 'Range of the highest daily temperature [°C]', min=-19, max=35, value=c(-19,35), step=1),
                                        sliderInput('prob', 'Probability of occurence [%]:', min=0, max=100, value=80, step=5)
                                       )

                                ),
                                column(3,
                                        wellPanel(
                                                radioButtons("example", "Some default settings :-)",
                                                             c("None"="none", "Skiing"="ski", "Swimming"="swim", "Biking"="bike", "CityTrip"="city"),
                                                             selected = "none")
                                        )
                                )
                            ),

                            br(),
                            htmlOutput("calendar"),
                            #put calendar in the page center
                            tags$script(HTML("var p = document.getElementById('calendar')
                                                $(p).attr('align', 'center');"))

                   ),
                   tabPanel("About",
                            mainPanel(
                                    includeHTML("about.html")
                            )
                   )
))
