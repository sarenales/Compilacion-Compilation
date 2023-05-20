#ifndef CODIGO_HPP_
#define CODIGO_HPP_
#include <iostream>
#include <sstream>
#include <fstream>
#include <set>
#include <vector>

/* Estructura de datos para el código generado. El código, en vez de escribirlo directamente, 
 * se guarda en esta estructura y, al final, se escribirán en un fichero.
 */
class Codigo {

private:

	/**************************/
	/* REPRESENTACION INTERNA */
	/**************************/

	/* Instrucciones que forman el código. */
	std::vector<std::string> instrucciones;

	/* Clave para generar identificaciones nuevos. Cada vez que se crea un idse incrementa. */
	int siguienteId;


public:

	/************************************/
	/* METODOS PARA GESTIONAR EL CODIGO */
	/************************************/

	/* Constructora */
	Codigo();

	/* Crea un nuevo identificador del tipo "__t1, __t2, ...", siempre diferente. */
	std::string nuevoId() ;

	/* Añade una nueva instrucción a la estructura. */
	void anadirInstruccion(const std::string &instruccion);

	/* Dada una lista de variables y su tipo, crea y añade las instrucciones de declaración */
	void anadirDeclaraciones(const std::vector<std::string> &idNombres, const std::string &tipoNombre);

	/* Dada una lista de parámetros y su tipo, crea y añade las instrucciones de declaración */
	void anadirParametros(const std::vector<std::string> &idNombres, const std::string &tipoNombre) ;


	/* Añade a las instrucciones que se especifican la referencia que les falta.
	 * Por ejemplo: "goto" => "goto 20;" */
	void completarInstrucciones(std::vector<int> &numInstrucciones, const int valor);

	/* Escribe las instrucciones acumuladas en la estructura en el fichero de salida. */
	void escribir() const;

	/* Devuelve el número de la siguiente instrucción. */
	int obtenRef() const;

};

#endif /* CODIGO_HPP_ */
