laboratorio 2
2. Clase Práctica: Tokens
Estas son las actividades a realizar:
1. En el directorio traza:
1) analiza traza.l, Makefile, traza.hpp
$ make
Debería analizar bien prueba1.in
Debería dar un error léxico con pruebaObj1.in
Debería dar un error léxico con pruebaObj2.in

Objetivo 1
Realiza los ejercicios 2.6 y 2.8. Mételos como dos nuevos tokens en traza.l
Amplía traza.hpp con los dos nuevos tokens.
$make
Debería analizar bien prueba1.in
Debería analizar bien pruebaObj1.in
Debería dar un error léxico con pruebaObj2.in

Objetivo 2
Extiende traza.l y traza.hpp para que admita los token identificador, constante entera, constante real y comentario de línea de la práctica.
$make
Debería analizar bien los tres ficheros de prueba.
Añade más ficheros de pruebas para asegurarte el resultado.
