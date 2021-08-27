# figura global de confirmados
# clase 1
# 2020-03-15  version actual:   2021-04-08
# GAD 
###############################################
# options(allow_html=TRUE)
# Bibliotecas a cargar
rm(list = ls()) 
gc()

##          used (Mb) gc trigger (Mb) max used (Mb)
## Ncells 451344 24.2     967730 51.7   643648 34.4
## Vcells 813163  6.3    8388608 64.0  1648619 12.6

check_packages <- function(packages) {
  if (all(packages %in% rownames(installed.packages()))) {
    TRUE
  } else{
    cat(
      "Instalar los siguientes packages antes de ejecutar el presente script\n",
      packages[!(packages %in% rownames(installed.packages()))],
      "\n"
    )
  }
}
packages_needed <- c("ggplot2", "ggrepel", "plotly",
                     "lubridate", "htmlwidgets" , "RColorBrewer",
                     "sqldf", "data.table", "readr" )

# llamo a la funcion check_packages
check_packages(packages_needed)

## [1] TRUE

library(ggplot2)
library(ggrepel)
library(plotly)

## 
## Attaching package: 'plotly'

## The following object is masked from 'package:ggplot2':
## 
##     last_plot

## The following object is masked from 'package:stats':
## 
##     filter

## The following object is masked from 'package:graphics':
## 
##     layout

library(lubridate)

## 
## Attaching package: 'lubridate'

## The following objects are masked from 'package:base':
## 
##     date, intersect, setdiff, union

library(htmlwidgets)
library(RColorBrewer)
library(sqldf)

## Loading required package: gsubfn

## Loading required package: proto

## Loading required package: RSQLite

library(data.table)

## 
## Attaching package: 'data.table'

## The following objects are masked from 'package:lubridate':
## 
##     hour, isoweek, mday, minute, month, quarter, second, wday, week,
##     yday, year

library(readr)
#library(reshape2)

############################################## Leer
# time_series_covid19_confirmed_global.csv


URL <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/"
url_archivo  <- paste(URL,"time_series_covid19_confirmed_global.csv", sep = "")
COVID_19_h   <- read.csv(url_archivo, sep = ",", header = TRUE)

############################################## preparo los datos

COVID_19_h$Lat  <- NULL 
COVID_19_h$Long <- NULL
COVID_19_h$Province.State <- NULL

#colnames(COVID_19_h)

#head(COVID_19_h, 5) 

library(tidyr)
COVID_19  <- COVID_19_h %>% gather(date, casos, 2:ncol(COVID_19_h))


colnames(COVID_19) <- c(  "pais", "date", "confirmados")

COVID_19$date <- as.Date(as.character(COVID_19$date), format = "X%m.%d.%y")

# agrupo por fecha 

casos_por_fecha <- COVID_19 %>% group_by(date) %>% summarise(confirmados = sum(confirmados))

# lo anterior  en SQL seria:

# casos_por_fecha <- sqldf( "select  date, sum(confirmados) confirmados
#                           from COVID_19
#                           group by date")

# -- ordenamos
#library(tidyverse)
datos <- arrange(casos_por_fecha, (casos_por_fecha$date) )


###############################################
# genero  figura dinamica

g1 <- ggplot(datos ,aes(x = date, y = confirmados/1000000)) +
  
  geom_point( size=1, color="blue") +
  
  ggtitle("COVID_19 - confirmados confirmados a nivel mundial") +
  scale_x_date(date_breaks = "14 day", date_labels =  "%d %b") +
  #scale_y_continuous(limits = c(0, 100), breaks = seq(1, 5, 1)) +
  theme(plot.title = element_text(lineheight = 1,face ='bold'))   +
  ylab("cantidad de confirmados en M") +
  xlab("") +
  labs(caption = "\nFuente: The Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 

# + geom_text(aes(label = round(porDiezMil,1)), position = position_stack(vjust = .5))

g1 <- ggplotly(g1, tooltip = c("confirmados")) %>%
  layout(legend = list(
    orientation = "h",
    x = 0.7,
    y = 1
  )
  )

g1
