%define parse.error verbose

%{
   #include <stdio.h>
   #include <iostream>
   #include <vector>
   #include <string>
   using namespace std; 

   extern int yylex();
   extern int yylineno;
   extern char *yytext;
   extern int yyerrornum;
   void yyerror (const char *msg) {
     cout << "line " << yylineno <<": " << msg << " at token " << yytext << endl ;
     yyerrornum++;
   }

   #include "Codigo.hpp"
   #include "Exp.hpp"
   #include "TablaSimbolos.cpp"
   #include "TablaSimbolos.hpp"

   // funciones a utilizar
   expresionstruct makecomparison(std::string &s1, std::string &s2, std::string &s3) ;
   expresionstruct makearithmetic(std::string &s1, std::string &s2, std::string &s3) ;
   vector<int> *unir(vector<int>& lis1, vector<int>& lis2);

   Codigo codigo;
   PilaTablaSimbolos stPila;
   string procedimiento;
   bool errores = false;

%}

/* 
   qué atributos tienen los símbolos 
*/
%union {
    string *str ; 
    vector<string> *list ;
    expresionstruct *expr ;
    int number ;
    vector<int> *numlist;
}

/* declaración de tokens. Esto debe coincidir con tokens.l */
%token <str> TASSIG TASSIG2 TCOMMA TCOLON
%token <str> TIDENTIFIER TINTEGER TDOUBLE
%token <str> TOPEN TCLOSE TLFLE TRFLE
%token <str> TCEQ TCNE TCLT TCLE TCGT TCGE
%token <str> TPLUS TMINUS TMUL TDIV
%token <str> RPACKAGE RMAIN RFUNC RVAR RINTEGER RFLOAT RIF RFOR RBREAK RCONTINUE RREAD RPRINTLN RRETURN

// declaracion no terminal de la gramática
%type <str> programa
%type <sen> bloque_ppl
%type <sent> bloque
%type <str> decl_bl
%type <str> lista_decl
%type <str> declaracion
%type <lid> lista_de_ident
%type <lid> resto_lista_id
%type <str> tipo
%type <str> argumentos
%type <str> lista_de_param
%type <str> resto_lis_de_param
%type <sen> lista_de_sentencias
%type <sen> sentencia
%type <str> variable
%type <str> lista_expr
%type <str> resto_lista_expr
%type <expr> expresion
%type <number> M
%type <numlist> N 

// prioridades
%left <str> TCEQ TCNE TCLT TCLE TCGT TCGE
%left <str> TPLUS TMINUS
%left <str> TMUL TDIV TMINUS TPLUS 


%start program

%%

programa : RPACKAGE RMAIN
        {
               codigo.anadirInstruccion("goto 5");
               codigo.anadirInstruccion("Error en division entre 0;");
               codigo.anadirInstruccion("writeln");
               codigo.anadirInstruccion("goto");
               codigo.anadirInstruccion("proc main");
        }
          bloque_ppl
        {
                vector<int> v = new vector<int>;
                v.push_back(4);
                codigo.completarInstrucciones(v, codigo.obtenRef());

                if(errores == false){
                        codigo.anadirInstruccion("halt");
                        codigo.escribir();
                }else{
                        YYABORT;
                }
                -- stPila.desempilar();
        }
        ;

bloque_ppl : decl_bl subprogs;

subprogs : subprogs subprograma
         | subprograma
   ;

subprograma : TFUNC nombre argumentos tipo_opc bloque
            ;

nombre : RMAIN
       | TIDENTIFIER
       ;

bloque : RBEGIN decl_bl subprogs_anon lista_de_sentencias REND
        {
            $$ = new sentenciastruct;
            $$->breaks = * new vector<int>;
            $$->continues = * new vector<int>;
        }
       ;

subprogs_anon : subprogs_anon subprograma_anon
      | /* Vacío*/
      ;

subprograma_anon : TIDENTIFIER TASSIG TFUNC argumentos tipo_opc bloque     
      ;

decl_bl : RVAR TOPEN lista_decl TCLOSE decl_bl
        | RVAR declaracion decl_bl
        | /* Vacío*/
        ;

lista_decl : lista_decl declaracion
           | declaracion
           ;

declaracion : lista_de_ident tipo
                {
                  codigo.anadirDeclaraciones(?$1, *$2);
                }
            ;

lista_de_ident : TIDENTIFIER resto_lista_id
                {
                  $$ = new vector<string>();
                  $$.push_back(*$1);
                }
               ;

resto_lista_id : TCOMMA TIDENTIFIER resto_lista_id
                {
                  $$ = new vector<string>();
                  $$.push_back(*$2);
                }
               | /* Vacío */
                {
                  $$ = new vector<string>;
                };
               ;

tipo : TINT 
               {  
                  $$ = new std::string("int");
               }
     | TFLOAT32 
               {
                  $$ = new std::string("real");
               }
     ;

tipo_opc: tipo 
        | /* Vacío*/
        ;

argumentos : TOPEN lista_de_param TCLOSE
           ;

lista_de_param : lista_de_ident tipo
                resto_lis_de_param
               | /* Vacío */
               ;

resto_lis_de_param : TCOMMA lista_de_ident tipo
                   resto_lis_de_param
                   | /*Vacío*/
                   ;

lista_de_sentencias : lista_de_sentencias sentencia
                     {
                        $$ = new sentenciastruct;
                        $$->breaks = *unir($1->breaks, $2->breaks);
                        $$->continues= *unir($1->continues, $2->continues);
                        delete $1;
                        delete $2;
                     }
                    | sentencia
                    {
                        $$ = new sentenciastruct;
                        $$->breaks = $1->breaks;
                        $$->continues = $2->continues;
                    }
                    ;

sentencia: variable TASSIG2 TIDENTIFIER TOPEN lista_expr TCLOSE
        {
         $$ = new sentenciastruct;
         codigo.anadirInstruccion(*$1 + " := " + $3->str + "(" + $5->str + ");") ;
         $$->breaks = * new vector<int>;
         $$->continues = * new vector<int>;
        }

         | variable TASSIG2 expresion
            {
               $$= new sentenciastruct;
               codigo.anadirInstruccion(*$1 + " = " + $3->str + ";") ;
               $$->breaks = * new vector<int>;
               $$->continues = * new vector<int>;
               delete $1 ; delete $3;
            }

         | TIDENTIFIER TOPEN lista_expr TCLOSE
                {
                  $$ = new sentenciastruct;
                  $$->breaks = * new vector<int>;
                  $$->continues = * new vector<int>;
                  codigo.anadirInstruccion($1->str + "(" + $3->str + ");") ;
               }

         | RIF expresion M bloque M
            {
               $$ = new sentenciastruct;
	      	   codigo.completarInstrucciones($2->trues,$3);
      	  	   codigo.completarInstrucciones($2->falses,$5);
	      	   $$->breaks = * new vector<int>;
               $$->continues = * new vector<int>;
            }

         | RFOR M expresion M bloque M
         {
            $$ = new sentenciastruct;
            codigo.completarInstrucciones($3->true, $4);
            codigo.completarInstrucciones($3->falses, $6+1);
            codigo.completarInstrucciones($5->breaks, $6+1);
            codigo.completarInstrucciones($5->continues, $6);
            anadirInstruccion("goto"+$2);
            $$->breaks = * new vector<int>;
            $$->continues = * new vector<int>;
         }

         | RFOR M bloque M
         {
            $$ = new sentenciastruct;
            codigo.completarInstrucciones($3->breaks, codigo.obtenRef()+1);
            codigo.completarInstrucciones($3->continues, codigo.obtenRef());
            anadirInstruccion("goto"+$2);
            $$->breaks = * new vector<int>;
            $$->continues = * new vector<int>;
         }

         | RBREAK expresion M
            {
               $$ = new sentenciastruct;
               codigo.completarInstrucciones($2->falses, codigo.obtenRef());
               $$->breaks =  trues;
               $$->continues = * new vector<int>;
            }

         | RCONTINUE M
            {
                $$ = new sentenciastruct;
                codigo.anadirInstruccion("goto");
                $$->breaks = * new vector<int>;
                $$->continues.push_back(codigo.obtenRef());
            }

         | RREAD TOPEN variable TCLOSE
            {
                $$ = new sentenciastruct;
                $$->breaks = * new vector<int>;
                $$->continues = * new vector<int>;
				   codigo.anadirInstruccion("read "+ *$3 + ";");
            }

         | RPRINTLN TOPEN expresion TCLOSE
            {
                $$ = new sentenciastruct;
                $$->breaks = * new vector<int>;
                $$->continues = * new vector<int>;
				   codigo.anadirInstruccion("write "+ $3->str + ";");
				   codigo.anadirInstruccion("writeln;");
            }

         | RRETURN expresion
         {
            añadirInstruccion("return"||expresion.nombre);
            $$->breaks = * new vector<int>;
            $$->continues = * new vector<int>;
         }
         ;

variable: TIDENTIFIER
        {
                $$=$1;
        }
        ;

lista_expr: expresion resto_lista_expr
          | /* Vacío */ 
          ;

resto_lista_expr : TCOMMA expresion resto_lista_expr
                  | /* Vacío */
                 ;

expresion: expresion TPLUS expresion
            {
               $$= new expresionstruct;
               $$->trues = * new vector<int>;
               $$->falses = * new vector<int>;
               *$$ = makearithmetic($1->str,*$2,$3->str);
               delete $1;
               delete $3;
            }

         | expresion TMINUS expresion
            {
               $$= new expresionstruct;
               $$->trues = * new vector<int>;
               $$->falses = * new vector<int>;
               *$$ = makearithmetic($1->str,*$2,$3->str);
            }

         | expresion TMUL expresion
            {
               $$= new expresionstruct;
               $$->trues = * new vector<int>;
               $$->falses = * new vector<int>;
               *$$ = makearithmetic($1->str,*$2,$3->str);
            }


         | expresion TDIV expresion
            {  
               codigo.anadirInstruccion("if"+$3->str+"=0 goto"+codigo.obtenRef()+1);
               $$= new expresionstruct;
               $$->trues = * new vector<int>;
               $$->falses = * new vector<int>;
               *$$ = makearithmetic($1->str,*$2,$3->str);
            }


         | expresion TCLT expresion
            {
               $$= new expresionstruct;
               $$->trues = * new vector<int>;
               $$->falses = * new vector<int>;
               *$$ = makecomparison($1->str,*$2,$3->str);
            }


         | expresion TCGT expresion
            {
               $$= new expresionstruct;
               $$->trues = * new vector<int>;
               $$->falses = * new vector<int>;
               *$$ = makecomparison($1->str,*$2,$3->str);
            }


         | expresion TCLE expresion
            {
               $$= new expresionstruct;
               $$->trues = * new vector<int>;
               $$->falses = * new vector<int>;
               *$$ = makecomparison($1->str,*$2,$3->str);
            }


         | expresion TCGE expresion
            {
            $$= new expresionstruct;
            $$->trues = * new vector<int>;
            $$->falses = * new vector<int>;
            *$$ = makecomparison($1->str,*$2,$3->str);
         }

         | expresion TEQ expresion
            {
               $$= new expresionstruct;
               $$->trues = * new vector<int>;
               $$->falses = * new vector<int>;
               *$$ = makecomparison($1->str,*$2,$3->str);
            }


         | expresion TNEQ expresion
            {
               $$= new expresionstruct;
               $$->trues = * new vector<int>;
               $$->falses = * new vector<int>;
               *$$ = makecomparison($1->str,*$2,$3->str);
            }


         | variable
        {
                $$ = new expresionstruct;
                $$->trues = * new vector<int>;
                $$->falses = * new vector<int>;
                $$->str = *$1;
        }
         | TINTEGER
        {
                $$ = new expresionstruct;
                $$->trues = * new vector<int>;
                $$->falses = * new vector<int>;
                $$->str = *$1;
        }
         | TDOUBLE
        {
                $$ = new expresionstruct;
                $$->trues = * new vector<int>;
                $$->falses = * new vector<int>;
                $$->str = *$1;
        }
         | TOPEN expresion TCLOSE
        {
                $$ = new expresionstruct;
                $$->trues = $2->trues;
                $$->falses = $2->falses;
                $$->tipo = $2->tipo;
                $$->str = $2->str;
        }
    ;

M: /* empty */
        {$$ = codigo.obtenRef();}
;


N: /* empty */
        {$$ = new vector<int>;
        vector<int> tmp1;
        tmp1.push_back(codigo.obtenRef());
        *$$ = tmp1;
        codigo.anadirInstruccion("goto");
        };
%%

expresionstruct makecomparison(std::string &s1, std::string &s2, std::string &s3) {
  expresionstruct tmp ; 
  tmp.trues.push_back(codigo.obtenRef()) ;
  tmp.falses.push_back(codigo.obtenRef()+1) ;
  codigo.anadirInstruccion("if " + s1 + s2 + s3 + " goto") ;
  codigo.anadirInstruccion("goto") ;
  return tmp ;
}

expresionstruct makearithmetic(std::string &s1, std::string &s2, std::string &s3) {
  expresionstruct tmp ; 
  tmp.str = codigo.nuevoId() ;
  codigo.anadirInstruccion(tmp.str + ":=" + s1 + s2 + s3) ;     
  return tmp ;
}

//Falta la función unir
vector<int>* unir(vector<int> &lis1, vector<int> &lis2) {
    lis1.insert(lis1.end(), lis2.begin(), lis2.end());
    delete &lis2;
    return &lis1;
}
