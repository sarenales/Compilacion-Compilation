#ifndef PILATABLASIMBOLOS_HPP_
#define PILATABLASIMBOLOS_HPP_

#include <stack>
#include "TablaSimbolos.hpp"

/* Estructura que representa la pila de tablas de símbolos. Se posiciona entre el analizador/traductor
 * y la tabla de símbolos. Así, cuando se le pide la información de un símbolo, lo busca en la tabla
 * del tope de la pila. Si no lo encuentra, sigue buscando en la tabla enlazada a esta (ambitoSuperior)
 * hasta analizar la pila completa.
 */
class PilaTablaSimbolos {

private :

	/*************************************/
	/* DEFINICION DE TIPOS A UTILIZAR */
	/*************************************/

	/* Elemento de la pila. Este elemento tiene dos componenetes, la tabla de símbolos y la referencia
     * al elemento de ámbito superior (tabla de símbolos + otra referencia).
	 */
	typedef struct par {
		TablaSimbolos st;
		par* ambitoSuperior;
	} Elemento;


	/**************************/
	/* REPRESENTACION INTERNA */
	/**************************/

	/* Pila formada por pares <tabla de símbolos,referencia>. */
	std::stack<Elemento> pila;

public:

	/********************/
	/* METODOS PUBLICOS */
	/********************/

	/* Constructora */
	PilaTablaSimbolos();

	/* Devuelve la tabla de símbolos del tope. */
	TablaSimbolos& tope();

	/* Introduce una nueva tabla de símbolos en la pila, sieno su referencia de ámbito superior
     * el elemento en el tope en ese momento. */
	void empilar(const TablaSimbolos& st);

	/* Borra de la pila el elemento del tope. */
	void desempilar();

	/* Dada una variable, intenta encontrar su tipo empezando desde la tabla de símbolos en el
	 * tope de la pila y lo devuelve, si lo encuentra. */
	std::string obtenerTipo(std::string id);

	/* Este método añade el identificador como valor de retorno al subprograma que se está declarando en la 
	 * tabla de símbolos en vigor al declarar el subprograma (en ambitoSuperior).	 */
	void anadirTipoVRetorno(std::string proc, std::string tipo);

	/* Devuelve el tipo del valor de retorno del subprograma id. */
	std::string obtenerTipoVRetorno(std::string id);

	/* Este método tiene dos funciones:
	 * => Añade el identificador como un nuevo parámetro al subprograma que se está declarando en la 
	 * tabla de símbolos en vigor al declarar el subprograma (en ambitoSuperior).
	 * => Añade el identificador como variable local en la tabla de símbolos actual (la correspondiente
	 * al subprograma que se está declarando).
	 */
	void anadirParametro(std::string subProg, std::string idVar, std::string tipo);

	/* Devuelve el tipo del parámetro en la posición numParametro del subprograma id. */
	std::string obtenerTipoParametro(std::string id, int numParametro);

	/* Verifica que el número de argumentos del subprograma proc es numArgs. Si no coincide
	 * eleva una excepción. */
	void verificarNumArgs(std::string subProg, int numArgs);

};

#endif /* PILATABLASIMBOLOS_HPP_ */
