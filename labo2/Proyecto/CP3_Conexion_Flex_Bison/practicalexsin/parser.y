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

programa : package main bloque_ppl
        ;

bloque_ppl : decl_bl subprogs
      /* | /*Vacío*/
      ;

subprogs :  subprogs subprograma
         | subprograma
         ;

subprograma : TFUNC nombre argumentos tipo_opc bloque
     ;

nombre : TMAIN
      | id
      ;

bloque : RBEGIN decl_bl subprogs_anon lista_de_sentencias RENDPROGRAM
      ;

subprogs_anon : subprogs_anon subprograma_anon
      ;

subprograma_anon : TID TASSIG argumentos tipo_opc bloque
      ;

decl_bl : TVAR TPARAB lista_decl TPARCER decl_bl
      | TVAR declaracion decl_bl
      |
      ;

lista_decl : lista_decl declaracion
      | declaracion
      ;

declaracion : lista_de_ident tipo
      ;

lista_de_ident : TID resto_lista_id
      ;

resto_lista_id : TCOMA TID resto_lista_id
      |
      ;

tipo : TID
      | TCTE-FLOAT32
      ;

tipo_opc : tipo
      |
      ;

argumentos : TPARAB lista_de_param TPARCER
      ;

lista_de_param : lista_de_ident tipo resto_lista_de_param
      |
      ;

lista_de_sentencias : lista_de_sentencias lista_de_sentencias sentencia
      | sentencia
      ;

sentencia : variable TIGUAL TID TPARAB lista_expr TPARCER
      | variable TIGUAL expresion
      | TID TPARAB lista_expr TPARCER
      | TIF expresion bloque
      | TFOR expresion bloque
      | TFORS bloque
      | TBREAK expresion
      | TCONTINUE
      | TREAD TPARAB variable TPARCER
      | TPRINTLN TPARAB expresion TPARCER
      | TRETURN expresion
      ;

variable : TID
      ;

lista_expr : expresion resto_lista_expr
      |
      ;

resto_lista_expr : TCOMA expresion resto_lista_expr
      |
      ;

expresion : expresion == expresion
      | expresion > expresion
      | expresion < expresion
      | expresion >= expresion
      | expresion <= expresion
      | expresion != expresion
      | expresion + expresion
      | expresion - expresion
      | expresion * expresion
      | expresion / expresion
      | variable
      | TCTE-INT
      | TCTE-FLOAT32
      | ( expresion )
      ;
