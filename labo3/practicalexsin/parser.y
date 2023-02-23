%{
   #include <stdio.h>
   #include <iostream>
   #include <vector>
   #include <string>
   using namespace std; 

   extern int yylex();
   extern int yylineno;
   extern char *yytext;
   void yyerror (const char *msg) {
     printf("line %d: %s at '%s'\n", yylineno, msg, yytext) ;
   }

%}

/* 
   qué atributos tienen los tokens 
*/
%union {
    string *str ; 
}

/* 
   declaración de tokens. Esto debe coincidir con tokens.l 
*/
%token <str> TIDENTIFIER TINTEGER TDOUBLE 

%left TMUL
%token <str> TSEMIC TASSIG
%token <str> RPROGRAM RBEGIN RENDPROGRAM



%start programa

%%

programa : RPROGRAM  
           TIDENTIFIER 
	   RBEGIN
	   listasentencias
	   RENDPROGRAM 
        ;

listasentencias :  listasentencias sentencia 
      | /*Vacío*/
      ;

sentencia :  TIDENTIFIER TASSIG expr TSEMIC;

expr : expr TMUL expr
     | TIDENTIFIER 
     | TINTEGER
     | TDOUBLE
     ;

