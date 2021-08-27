# clase 1 de R
# vectores en R
# se empiezan a numerar desde 1

#  '#' para comentarios
# '<-' para asignacion
v1 <- c(1, 2, 3, 4)
v1

# lo mismo pero con notacion ":"
v1 = c(1:4)
v1

#
v2 <- c(55:151)
v2

# notacion []
# notacion [filas, columnas]
v2[c(4:7,15)] #multiples indices del vector: del 4 al 7 y 15
v2

v2[55]

# con seq ()
v3 <- seq(from=1, to=2, by=.2)
v3

# con rep()
v4 <- rep(4, times=3)
v4

# con string
v5 <- c('argentina', 'chile', 'brasil')
v5

# con notacion  []
v5[2:3]
v5[3]

# con valores NA
v6 <- c('argentina', NA, 'brasil')
v6

# con signo '-'
v7 <- v5
v7
v8 <- v5[-1]
v8
v9 <- v5[-2]
v9

# vectores logicos
v10 <- c(TRUE, FALSE, FALSE, TRUE)
v10
v10[1:4]

# consulto la class, attributes y el tamaño
length(v10)

class(v1)
class(v9)
class(v10)
