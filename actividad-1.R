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

