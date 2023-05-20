#include "TablaSimbolos.hpp"

using namespace std;


/*****************/
/* Constructora */
/*****************/

TablaSimbolos::TablaSimbolos(string nombre) { nombreTS = nombre; }

/******************/
/* anaditNombreTS */
/******************/

void TablaSimbolos::anadirNombreTS(string nombre) {
   nombreTS = nombre;
}

/******************/
/* anadirVariable */
/******************/

void TablaSimbolos::anadirVariable(string id, string tipo) {
	InfoSimbolo infoSimbolo;
	infoSimbolo.tipoId = string("variable");
	infoSimbolo.tipoVar = tipo;
	if (!tabla.insert(pair<string, InfoSimbolo> (id, infoSimbolo)).second) {
		throw string("Error semántico. Has intentado declarar más de una vez el símbolo " + id);
	}
}


/***********************/
/* anadirSubprograma */
/***********************/

void TablaSimbolos::anadirSubprograma(std::string id) {
	InfoSimbolo infoSimbolo;
	infoSimbolo.tipoId = string("subprograma");
	if (!tabla.insert(pair<string, InfoSimbolo> (id, infoSimbolo)).second) {
		throw string("Error semántico. Has intentado declarar más de una vez el símbolo " + id);
	}
}


/*******************/
/* anadirParametro */
/*******************/

void TablaSimbolos::anadirParametro(string id, string tipo) {
	if (tabla.count(id) == 0) {
		throw string("Error semántico. Has intentado utilizar el subprograma " + id + " antes de declararlo.");
	}
	if (tabla.find(id)->second.tipoId != "subprograma") {
		throw string("Error semántico. El símbolo " + id + " está declarado pero no es un subprograma.");
	}
	tabla.find(id)->second.argsSubProg.paramSubprog.push_back(tipo);
}

/**********************/
/* anadirTipoVRetorno */
/**********************/

void TablaSimbolos::anadirTipoVRetorno(string id, string tipo) {
	if (tabla.count(id) == 0) {
		throw string("Error semántico. Has intentado utilizar el subprograma " + id + " antes de declararlo.");
	}
	if (tabla.find(id)->second.tipoId != "subprograma") {
		throw string("Error semántico. El símbolo " + id + " está declarado pero no es un subprograma.");
	}
	tabla.find(id)->second.argsSubProg.tipoVRetorno = tipo;
}


/***************/
/* obtenerTipo */
/***************/

string TablaSimbolos::obtenerTipo(string id) {
	if (tabla.count(id) == 0) {
		throw string("Error semántico. Has intentado utilizar la variable " + id + " antes de declararla.");
	}
	if (tabla.find(id)->second.tipoId != "variable") {
		throw string("Error semántico. El símbolo " + id + " está declarado pero no es una variable.");
	}
	return tabla.find(id)->second.tipoVar;
}


/*************************/
/* obtenerTipoParametro */
/*************************/

string TablaSimbolos::obtenerTipoParametro(string id, int numParametro) {
	if (tabla.count(id) == 0) {
		throw string("Error semántico. Has intentado utilizar el subprograma " + id + " antes de declararlo.");
	}
	if (tabla.find(id)->second.tipoId != "subprograma") {
		throw string("Error semántico. El símbolo " + id + " está declarado pero no es un subprograma.");
	}
	ClasesParametros clasesParametros = tabla.find(id)->second.argsSubProg.paramSubprog;
	if (clasesParametros.size() <= unsigned(numParametro)) {
		throw string("Error semántico. Número incorrecto de parámetros en la llamada al subprograma " + id);
	}
	return clasesParametros[numParametro];
}

/*************************/
/* obtenerTipoVRetorno */
/*************************/

string TablaSimbolos::obtenerTipoVRetorno(string id) {
	if (tabla.count(id) == 0) {
		throw string("Error semántico. Has intentado utilizar el subprograma " + id + " antes de declararlo.");
	}
	if (tabla.find(id)->second.tipoId != "subprograma") {
		throw string("Error semántico. El símbolo " + id + " está declarado pero no es un subprograma.");
	}
	string tipo = tabla.find(id)->second.argsSubProg.tipoVRetorno;
	if (tipo.size() == 0) {
		throw string("Error semántico. El subprograma " + id + "no tiene declarado valor de retorno.");
	}
	return tipo;
}


/************************/
/* numArgsSubprograma */
/************************/

int TablaSimbolos::numArgsSubprograma(std::string proc) {
	return tabla.find(proc)->second.argsSubProg.paramSubprog.size();
}



/************/
/* existeId */
/************/

bool TablaSimbolos::existeId(string id) {
	return tabla.count(id) > 0;
}


/************/
/* borrarId */
/************/

void TablaSimbolos::borrarId(string id) {
	tabla.erase(id);
}
