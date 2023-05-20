#ifndef TABLASIMBOLOS_HPP_
#define TABLASIMBOLOS_HPP_

#include <string>
#include <map>
#include <vector>

/* Estructura de datos que representa la Tabla de Símbolos. Permite guardar y consultar
 * los símbolos (variables, subprogramas,...) que se declaran a lo largo del programa 
 * a compilar, e incluye información adicional (tipos, parámetros,...)
 */
class TablaSimbolos {

private:

	/**********************************/
	/* DEFINICION DE TIPOS A UTILIZAR */
	/**********************************/

	/* Nombre de la tabla de símbolos. Para guardar el nombre del bloque y poder dar mensajes más adecuados. */
    	std::string nombreTS;
 
 	/* tipo para expresar los tipos de parámetros */

	typedef std::vector<std::string> ClasesParametros;
	
	/* tipo para expresar la información de subprogramas. */
	typedef struct {
		ClasesParametros paramSubprog;
		std::string tipoVRetorno;
	} InfoSubProg;
	

	/* Estructura para guardar la información adicional de los símbolos. */
	typedef struct {
		std::string tipoId; 		// variable o subprograma
		std::string tipoVar; 		// si es variable, su tipo (int o real)
		InfoSubProg argsSubProg; 	// si es subprograma, los tipos de sus parámetros y del valor de retorno.
	} InfoSimbolo;

	/**************************/
	/* REPRESENTACION INTERNA */
	/**************************/

	/* Tabla hash formada por pares <IdSimbolo, InfoAdicional>. */
	std::map<std::string, InfoSimbolo> tabla;

public:

	/********************************************/
	/* METODOS PUBLICOS DE LA TABLA DE SIMBOLOS */
	/********************************************/

	/* Constructora */
	TablaSimbolos(std::string nombre = "");

    	/* Añade un nombre a la tabla de símbolos. */
    	void anadirNombreTS(std::string nombre);

	/* Añade un símbolo de tipo variable y su tipo (int o float). */
	void anadirVariable(std::string id, std::string tipo);

	/* Añade un símbolo (nombre) de tipo subprograma.
     	* La información adicional se añade mediante otros métodos. */
	void anadirSubprograma(std::string id);

	/* Añade el tipo de un parámetro a un subprograma ya añadido. */
	/* Los parámetros se añadirán en orden */
	void anadirParametro(std::string id, std::string tipo);

	/* Añade el tipo del valor de retorno a un subprograma ya añadido, cuando corresponda. */
	void anadirTipoVRetorno(std::string id, std::string tipo);

    	/* Obtiene el nombre a la tabla de símbolos. */
    	std::string obtenerNombreTS();

	/* Obtiene el tipo de una variable ya añadida. */
	std::string obtenerTipo(std::string id);

	/* Devuelve el tipo del parámetro en la posición numParametro correspondiente a un subprograma ya añadido. */
	std::string obtenerTipoParametro(std::string id, int numParametro);

	/* Devuelve el tipo del valor de retorno a un subprograma ya añadido. */
	std::string obtenerTipoVRetorno(std::string id);

	/* Devuelve el numero de parámetros correspondiente a un subprograma ya añadido. */
	int numArgsSubprograma(std::string subProg);

	/* Dado un Id nos dice si está definido en la T_S o no. */
	bool existeId(std::string id);

	/* Dado un Id lo borra de la T_S. */
	void borrarId(std::string id);

};

#endif /* TABLASIMBOLOS_HPP_ */
