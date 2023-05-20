#include "PilaTablaSimbolos.hpp"

#include <iostream>

using namespace std;


/****************/
/* Constructora */
/****************/

PilaTablaSimbolos::PilaTablaSimbolos() {}


/********/
/* tope */
/********/

TablaSimbolos& PilaTablaSimbolos::tope() {
	return pila.top().st;
}


/************/
/* empilar */
/************/

void PilaTablaSimbolos::empilar(const TablaSimbolos& st) {
	Elemento *ambitoSuperior;
	if (pila.empty()) {
		ambitoSuperior = 0;
	}
	else {
		ambitoSuperior = &(pila.top());
	}
	Elemento elemento;
	elemento.ambitoSuperior = ambitoSuperior;
	elemento.st = st;
	pila.push(elemento);
}


/**************/
/* desempilar */
/**************/

void PilaTablaSimbolos::desempilar() {
	pila.pop();
}


/***************/
/* obtenerTipo */
/***************/

string PilaTablaSimbolos::obtenerTipo(string id) {
	string tipo;

	if (pila.empty()) {
		throw string("Error semántico. Has intentado utilizar la variable " + id + " antes de declararla.");
	}

	Elemento *elemento = &pila.top();

	while (elemento != 0) {
		try {
			tipo = elemento->st.obtenerTipo(id);
			return tipo;
		}
		catch (string error) {
			elemento = elemento->ambitoSuperior;
		}
	}
	throw string("Error semántico. Has intentado utilizar la variable " + id + " antes de declararla.");
}

/*************************/
/* obtenerTipoParametro */
/*************************/

string PilaTablaSimbolos::obtenerTipoParametro(string id, int numParametro) {
	string tipo;

	if (pila.empty()) {
		throw string("Error semántico. Has intentado llamar al subprograma " + id + " antes de declararlo.");
	}

	Elemento *elemento = &pila.top();

	while (elemento != 0) {
		try {
			tipo = elemento->st.obtenerTipoParametro(id, numParametro);
			return tipo;
		}
		catch (string error) {
			elemento = elemento->ambitoSuperior;
		}
	}
	throw string("Error semántico. No se ha encontrado subprograma con esas características."
			     " Puede que el nombre o el número de parámetros sean incorrectos.");
}



/*************************/
/* obtenerTipoVRetorno */
/*************************/

string PilaTablaSimbolos::obtenerTipoVRetorno(string id) {
	string tipo;

	if (pila.empty()) {
		throw string("Error semántico. Has intentado llamar al subprograma " + id + " antes de declararlo.");
	}

	Elemento *elemento = &pila.top();

	while (elemento != 0) {
		try {
			tipo = elemento->st.obtenerTipoVRetorno(id);
			return tipo;
		}
		catch (string error) {
			elemento = elemento->ambitoSuperior;
		}
	}
	throw string("Error semántico. No se ha encontrado subprograma con esas características."
			     " Puede que el nombre o el número de parámetros sean incorrectos.");
}


/*******************/
/* anadirParametro */
/*******************/

void PilaTablaSimbolos::anadirParametro(string subProg, string idVar, string tipoVar) {
	pila.top().ambitoSuperior->st.anadirParametro(subProg, tipoVar);
	pila.top().st.anadirVariable(idVar, tipoVar);
}


/**********************/
/* anadirTipoVRetorno */
/**********************/

void PilaTablaSimbolos::anadirTipoVRetorno(string subProg, string tipoVar) {
	pila.top().ambitoSuperior->st.anadirTipoVRetorno(subProg, tipoVar);
}

/********************/
/* verificarNumArgs */
/********************/

void PilaTablaSimbolos::verificarNumArgs(string subProg, int numArgs) {
	int numArgsAutentico;
	
	if (pila.empty()) {
		throw string("Error semántico. Has intentado llamar al subprograma " + id + " antes de declararlo.");
	}

	Elemento *elemento = &pila.top();

	while (elemento != 0) {
		try {
		numArgsAutentico = elemento->st.numArgsSubprograma(subProg);
		if (numArgsAutentico != numArgs) {
			throw string("Error semántico. Número de argumentos incorrecto en la llamada al subprograma " + subProg);
		}
		else return;

		catch (string error) {
			elemento = elemento->ambitoSuperior;
		}
	}
	throw string("Error semántico. Has intentado llamar al subprograma " + id + " antes de declararlo.");
}


