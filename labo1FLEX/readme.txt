1. clase práctica: laboratorio LEX
1 Entrar en UNIX utilizando el usuario LDAP
2 Descargar los ficheros de la clase práctica 1 eGela y descomprimirlos.

EVALUACION
Hay que dejar los resultados de los ejercicios en estos ficheros:

ejerc1.1.l, ejerc1.2.l, ejerc2.1.l, ejerc2.2.l, ejerc2.3.l, ejerc2.4.l
ejerc1.1, ejerc1.2, ejerc2.1, ejerc2.2, ejerc2.3, ejerc2.4
Entregad un fichero comprimido con estos 12 ficheros. Nombre del fichero: NOMBRE_GRUPO.tar.gz

Primera parte

Sobre el fichero traza.l:

Consultar sus contenidos con un editor de texto.

Abre un terminal. Sitúate en el directorio donde se encuentren los ficheros descomprimidos.
Procesar con lex (flex -o traza.c traza.l)
Consultar los contenidos del fichero generado: traza.c
Compilar traza.c (gcc -o traza traza.c). ¿Se producen errores?
Compilar de nuevo con la referencia a la librería lex (gcc -o traza traza.c -ll)

Ejecutar traza introduciendo datos de prueba desde el teclado (./traza). Para finalizar, ctrl-D
Comprobar los contenidos del fichero ejemplo1.p.
Ejecutar traza redireccionando la entrada para que ésta sea el fichero ejemplo1.p
(./traza <ejemplo1.p). ¿Qué hace la especificación LEX?

1.1 Desarrollar una especificación LEX que sustituya secuencias de blancos y marcas de tabulación por un solo blanco. Puedes basarte en traza.l (cp traza.l ejerc1.1.l). Pruébalo a mano (la secuencia "*     *" debería devolver el string "* *") o con el ejemplo1.p (./ejerc1.1 < ejemplo1.p).

1.2 Desarrollar una especificación LEX que devuelva únicamente los identificadores de un programa (basarse en la especificación contenida en traza.l).  (Dejar el resultado en ejerc1.2.l)


Segunda parte


Desarrolla y prueba las siguiente especificaciones en LEX basándote en el fichero en egela "Tokens Cte entera Cte Real Id Comentarios".


2.1 Desarrollar una especificación LEX que decida si la entrada corresponde a un real o no. Podéis utilizar como base ejerc2.1.l. Probar con 5 ejemplos buenos y 5 malos.  (Dejar el resultado en ejerc2.1.l)

2.2 Desarrollar una especificación LEX que decida si la entrada corresponde a un identificador o no. Podéis utilizar como base ejerc2.1.l. Probar con 5 ejemplos buenos y 5 malos.  (Dejar el resultado en ejerc2.2.l)

2.3 Desarrollar una especificación LEX que decida si la entrada corresponde a un comentario o no. Probar con 5 ejemplos buenos y 5 malos.  (Dejar el resultado en ejerc2.3.l).

2.4 Desarrollar una especificación LEX a partir de la cual se genere un programa que cuente el número de identificadores (incluidas palabras reservadas que no sean procedure, begin,end) y de constantes reales de un programa del tipo de ejemplo1.p. Tener en cuenta que si no se procesan correctamente los comentarios, las cuentas no salen. El resultado para ejemplo1.p deberia ser 58 identificadores y 3 constantes reales. Se puede usar el esquema de solución dado en ejerc2.4.l.

Recursos

Para información sobre expresiones regulares basta acceder a Internet
Las versiones libres de Lex y Yacc se llaman Flex y Bison
En la biblioteca hay libros sobre las herramientas Lex / Flex y Yacc/Bison
En las distribuciones Linux vienen Flex y Bison
Para Windows: http://techapple.net/2014/07/flex-windows-lex-and-yacc-flex-and-bison-installer-for-windows-xp788-1/
