#include <stdio.h>
#include <iostream>
extern int yyparse();
using namespace std;

int yyerrornum = 0;

int main(int argc, char **argv)
{
  cout << "ha comenzado..." << endl ;
  if (yyparse() == 0 && yyerrornum == 0) 
  	{ cout << "ha finalizado bien..." << endl <<endl;}
  else
  	{ cout << "ha finalizado mal..." << endl << "Num.errores: " << yyerrornum << endl << endl;}
  return 0;
}
