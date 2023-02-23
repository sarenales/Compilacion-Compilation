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

programa : RPACKAGE  
           RMAIN 
           bloque_ppl
           ;

bloque_ppl: decl_bl
            subprogs
            ;
            
decl_bl: subprogs
         subprograma
         | subprograma
         ;
         
subprograma: RFUNC
            nombre
            argumentos
            tipo_opc
            bloque
            ;
            
nombre: RMAIN
         | TID
         ;
         
bloque: RBEGIN
         decl_bl
         subprogs_anon
         lista_de_sentencias
         RENDPROGRAM
         ;
         
subprogs_anon: TID
               TASSIG
               RFUNC
               argumentos
               tipo_opc
               bloque
               ;
               
decl_bl: RVAR
         TPARAB
         lista_decl
         TPARCER
         decl_bl
         | RVAR
         declaracion
         decl_bl
         | /*Vacío*/
         ;
         
lista_decl: lista_decl
            declaracion
            | declaracion
            ;
      
declaracion: lista_de_ident
             tipo
             ;
             
lista_de_ident: TID
                resto_lista_id
                ;
                
                
resto_lista_id: TCOMA
                TID
                resto_lista_id
                | /*Vacío*/
                ;
                
tipo: TINTEGER
      | TCTEFLOAT32
      ;
      
tipo_opc: tipo
         | /*Vacío*/
         ;
         
argumentos: TPARAB
            lista_de_param
            TPARCER
            ;
            
lista_de_param: lista_de_ident
                tipo
                resto_lis_de_param
                | /*Vacío*/
                ;
                
resto_lis_de_param: TCOMA
                     lista_de_ident
                     tipo
                     resto_lis_de_param
                     | /*Vacío*/
                     ;
                     
lista_de_sentencias: lista_de_sentencias
                     sentencia
                     | sentencia
                     ;
                     
sentencia: variable TEQ TID TPARAB lista_expr TPARCER
            | variable TEQ expresion
            | TID TPARAB lista_expr TPARCER
            | RID expresion bloque
            | RFOR expresion bloque
            | RFOR bloque
            | RBREAK expresion
            | RCONTINUE 
            | RREAD TPARAB variable TPARCER
            | RPRINTLN TPARAB expresion TPARCER
            | RRETURN expresion
            ;

variable: TID
          ;

lista_expr: expresion
            resto_lista_expr
            | /*Vacío*/
            ;
            

resto_lista_expr: expresion
            resto_lista_expr
            | /*Vacío*/
            ;
            
expresion: expresion CEQ expresion
         | expresion CGT expresion
         | expresion CLT expresion
         | expresion CGE expresion
         | expresion CLE expresion
         | expresion CNE expresion
         | expresion TSUM expresion
         | expresion TREST expresion
         | expresion TMUL expresion
         | expresion TDIV expresion
         | variable
         | TCTEINT
         | TCTEFLOAT32
         | TPARAB expresion TPARCER
         ;

