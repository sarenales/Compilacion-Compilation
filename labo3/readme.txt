3. Clase Práctica: Conexión Flex-Bison.
Este laboratorio tiene dos partes:

PRIMERA PARTE: Conexión Flex-Bison

Entrega la carpeta practicalexsin actualizada en el apartado 3). Súbelo en un fichero llamado: GrupoX.tar.gz

Estas son las actividades a realizar:
En el directorio traza (enlazando con el laboratorio anterior):
1) Observa traza.l, Makefile, traza.hpp
$ make
Debería analizar bien prueba1.in
Debería fracasar con prueba2.in (es un ejemplo con la gramática de la práctica)
Debería fracasar con  prueba3.in
En el directorio practicalexsin (Analizador léxico-sintáctico):
2) Analiza tokens.l, parser.y, main.cpp, Makefile
Objetivo2.1: Compara tokens.l y traza.l. ¿qué ha cambiado?
Objetivo2.2: Entiende cada instrucción de parser.y
$ make
Debería analizar bien prueba1.in
Debería fracasar con prueba2.in (es un ejemplo con la gramática de la práctica)
Debería fracasar con  prueba3.in

NOTAS:
NUNCA cambiar a mano parser.hpp, lo genera automáticamente bison
3) Modifica parser.y  tokens.l  para que acepte la siguiente gramática:

programa --> program id  {

                                        lista_de_sentencias  }

lista_de_sentencias --> lista_de_sentencias sentencia

                                      | vacío

sentencia --> id := exp ;

exp --> exp * exp

          | id

          | num_entero

          | num_real

NOTA: Es importante que pongas bien las prioridades y la asociatividad de los operadores (en este caso la multiplicación). Que no salgan conflictos.    Debería analizar bien prueba3.in          

SEGUNDA PARTE:

Construir el analizador léxico y sintáctico de la práctica
Puedes reutilizar los ficheros de la carpeta practicalexsin como base.

Completa/modifica con el léxico y la sintaxis de la práctica. Verifica que están todos los tokens  en tokens.l y reglas de producción en parser.y

Añade las directivas de prioridad necesarias para que las expresiones aritméticas se ejecuten  correctamente: %left %nonassoc

Al finalizar prueba2.in debería pasar correctamente.

Prueba con varios ejemplos más de la práctica.
