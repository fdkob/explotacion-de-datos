# Actividad 1
# Dataset: Llamados de violencia sexual
# Grupo 2
# Integrantes:
#   Candela Lauría
#   Fernando Kobylnik
#   David Labra Gaona
# Fecha de creación: 2021-08-25

rm(list = ls()) 
gc()

library(ggplot2)
library(dplyr)
library(lubridate)
library(tidyverse)

archivo <- "llamados-atendidos-abuso-sexual-2021.csv"
path_completo <- paste(getwd(),  "/datasets/", archivo, sep="")

ataques <- read.csv(path_completo, sep=",", header=TRUE, encoding = "UTF-8")

ataquesFechas <- ataques[3:2]
ataquesFechas$llamado_fecha_hora <- as.Date(as.character(ataquesFechas$llamado_fecha_hora), format = "%Y-%m-%d %H:%M:%S")
colnames(ataquesFechas) <- c("provincia", "fecha")
ataquesFechas$cant <- 1

ataquesFechas <- arrange(ataquesFechas, ataquesFechas$provincia)
ataquesFechas <- ataquesFechas %>% group_by(fecha) %>% summarise(cant = sum(cant))

ataquesFechas

g1 <- ggplot(ataquesFechas, aes(x = fecha, y = cant)) +
  
  geom_point( size=1, color="blue") +
  geom_line() +
  
  ggtitle("Linea 137 - Víctimas de Violencia Sexual - Llamados atendidos") +
  scale_x_date(date_breaks = "14 day", date_labels =  "%d %b") +
  #scale_y_continuous(limits = c(0, 100), breaks = seq(1, 5, 1)) +
  theme(plot.title = element_text(lineheight = 1,face ='bold'))   +
  ylab("Llamados atendidos") +
  xlab("") +
  labs(caption = "\nFuente: Ministerio de Justicia y Derechos Humanos") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 
g1

# Mapa de calor de número de casos por mes calendario
totales <- ataquesFechas %>%
  mutate(wday = str_sub(weekdays(fecha), 1, 3),
         month_day = day(fecha),
         month = month(fecha),
         week_increment = ifelse(month_day == 1 | wday == "Sun", 1, 0)) %>%
  group_by(month) %>%
  mutate(week = cumsum(week_increment),
         text_month = months(fecha)) %>%
  ungroup()

vec_dias <- c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
totales$wday <- factor(totales$wday, levels = vec_dias)
month_vec <- c("January", "February", "March", "April", "May", "June",
               "July", "August", "September", "October", "November", "December")
totales$text_month <- factor(totales$text_month, levels = month_vec)

calendario <- ggplot(totales, aes(x = wday, y = week)) +
  geom_tile(aes(fill = cant), colour = "white") +
  facet_wrap(~text_month, scales = "free") +
  scale_y_reverse() + 
  theme_minimal() +
  #scale_fill_viridis_c(labels = "dollar") +
  scale_x_discrete(position = "top") 
calendario
