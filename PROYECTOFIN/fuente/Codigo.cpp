#include "Codigo.hpp"

using namespace std;


/****************/
/* Constructora */
/****************/

Codigo::Codigo() {
  siguienteId = 1;
}


/***********/
/* nuevoId */
/***********/

string Codigo::nuevoId() {
  string nId("__t");
  nId += to_string(siguienteId++);
  return nId;
}


/*********************/
/* anadirInstruccion */
/*********************/

void Codigo::anadirInstruccion(const string &instruccion) {
  string cadena;
  cadena = to_string(obtenRef()) + ": " + instruccion;
  instrucciones.push_back(cadena);
}

/***********************/
/* anadirDeclaraciones */
/***********************/

void Codigo::anadirDeclaraciones(const vector<string> &idNombres, const string &tipoNombre) {
  vector<string>::const_iterator iter;
  for (iter=idNombres.begin(); iter!=idNombres.end(); iter++) {
    anadirInstruccion(tipoNombre + " " + *iter );
  }
}

/*********************/
/* anadirParametros  */
/*********************/

void Codigo::anadirParametros(const vector<string> &idNombres, const string &tipoNombre) {
  vector<string>::const_iterator iter;
  for (iter=idNombres.begin(); iter!=idNombres.end(); iter++) {
    anadirInstruccion("param_" + tipoNombre + " " + *iter );
  }
}

/**************************/
/* completarInstrucciones */
/**************************/

void Codigo::completarInstrucciones(vector<int> &numInstrucciones, const int valor) {
  string referencia = " " + to_string(valor) ;
  vector<int>::iterator iter;
 
  for (iter = numInstrucciones.begin(); iter != numInstrucciones.end(); iter++) {
    instrucciones[*iter-1].append(referencia);
  }
}


/************/
/* escribir */
/************/

void Codigo::escribir() const {
  vector<string>::const_iterator iter;
  for (iter = instrucciones.begin(); iter != instrucciones.end(); iter++) {
    cout << *iter << " ;" << endl;
  }
}


/************/
/* obtenRef */
/************/

int Codigo::obtenRef() const {
    return instrucciones.size() + 1;
}


