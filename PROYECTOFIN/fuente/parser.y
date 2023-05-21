%define parse.error verbose

%{
    #include <iostream>
    #include <vector>
    #include <string>
    using namespace std;
    extern int yylex();
    extern int yylineno;
    extern int yyerrornum;
    extern char *yytext;

    void yyerror (const char *msg) {
      printf("line %d: %s at '%s'\n", yylineno, msg, yytext) ;
      yyerrornum++;
    }
   #include "Codigo.hpp"
   #include "Exp.hpp"
   #include "PilaTablaSimbolos.hpp"
   #include "TablaSimbolos.hpp"

   // funciones a utilizar
   expresionstruct makecomparison(std::string &s1, std::string &s2, std::string &s3) ;
   expresionstruct makearithmetic(std::string &s1, std::string &s2, std::string &s3) ;
   vector<int> *unir(vector<int>& lis1, vector<int>& lis2);

   Codigo codigo;
   string procedimiento;
   bool errores = false;
   PilaTablaSimbolos stPila;
%}

/* 
   qué atributos tienen los símbolos 
*/
%union {
   int number;
   string *str;
   vector<string> *lid;
   vector<int> *numlist;
   expresionstruct *expr;
   sentenciastruct *sen;
}


/* declaración de tokens. Esto debe coincidir con tokens.l */
%token <str> TIDENTIFIER TINT TREAL
%token <str> TCEQ TNEQ TCNE TCLT TCLE TCGT TCGE
%token <str> TOPEN TCLOSE TLFLE TRFLE
%token <str> TPLUS TMINUS TMUL TDIV
%token <str> TASSIG TASSIG2 TCOMMA TSEMIC
%token <str> RAND ROR RNOT
%token <str> RPACKAGE RMAIN RFUNC RVAR RINTEGER RFLOAT RIF RFOR RBREAK RCONTINUE RREAD RPRINTLN RRETURN RELSE RTHEN RENDIF RELSEIF

// declaracion no terminal de la gramática
%type <str> programa
%type <sen> bloque_ppl
%type <sen> bloque
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
%type <sen> elseif_else_sentencia
%type <sen> sentencia
%type <str> variable
%type <str> lista_expr
%type <str> resto_lista_expr
%type <expr> expresion
%type <number> M
%type <numlist> N 

// prioridades
%left ROR
%left RAND
%left RNOT
%nonassoc TCEQ TCNE TCLT TCLE TCGT TCGE TNEQ
%left TPLUS TMINUS
%left TMUL TDIV


%start programa

%%

programa : RPACKAGE
        {
               TablaSimbolos st;
               stPila.empilar(st);
               st.anadirVariable(*$1, "programa");
               codigo.anadirInstruccion("goto 5");
               codigo.anadirInstruccion("Error en division entre 0;");
               codigo.anadirInstruccion("writeln");
               codigo.anadirInstruccion("goto");
               codigo.anadirInstruccion("package");
        }
        RMAIN bloque_ppl
        {
                vector<int> v;
                v.push_back(4);
                codigo.completarInstrucciones(v, codigo.obtenRef());
                
                if(!errores) {
                    codigo.anadirInstruccion("halt");                       
                    codigo.escribir();
                }
                stPila.desempilar(); 
                
        }
        ;

bloque_ppl : decl_bl subprogs;

subprogs : subprogs subprograma
         | subprograma
   ;

subprograma : RFUNC nombre argumentos tipo_opc bloque
            ;

nombre : RMAIN
       | TIDENTIFIER
       ;

bloque : TLFLE decl_bl subprogs_anon lista_de_sentencias TRFLE
        {
            $$ = new sentenciastruct;
            $$->breaks = * new vector<int>();
            $$->continues = * new vector<int>();
        }
       ;

subprogs_anon : subprogs_anon subprograma_anon
      | /* Vacío*/
      ;

subprograma_anon : TIDENTIFIER TASSIG RFUNC argumentos tipo_opc bloque     
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
                     for(vector<string>::iterator i = $1->begin(); i != $1->end(); i++){
                        if (!stPila.tope().existeId(*i)){
                           stPila.tope().anadirVariable(*i, *$2);
                        }else{
                           yyerror("Id duplicado.");
                           errores=true;
                        }
                     }                
                    codigo.anadirDeclaraciones(*$1, *$2);
                }
            ;

lista_de_ident : TIDENTIFIER resto_lista_id
                {
                   procedimiento= *$1;
                   if (!stPila.tope().existeId(*$1)){
                             stPila.tope().anadirSubprograma(*$1);
                   }else{
                      yyerror("Id duplicado.");
                      errores=true;
                   }
                   TablaSimbolos st; 
                   stPila.empilar(st);
                   codigo.anadirInstruccion("proc " + *$1); 
                   
                  $$ = new vector<string>();
                  $$->push_back(*$1);
                }
               ;

resto_lista_id : TCOMMA TIDENTIFIER resto_lista_id
                {
                   procedimiento= *$2;
                   if (!stPila.tope().existeId(*$2)){
                             stPila.tope().anadirSubprograma(*$2);
                   }else{
                      yyerror("Id duplicado.");
                      errores=true;
                   }
                   TablaSimbolos st; 
                   stPila.empilar(st);
                   codigo.anadirInstruccion("proc " + *$2); 
                   
                  $$ = new vector<string>();
                  $$->push_back(*$2);
                }
               | /* Vacío */
                {
                  $$ = new vector<string>();
                };
               ;

tipo : RINTEGER 
               {  
                  $$ = new std::string("int");
               }
     | RFLOAT 
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
             {  
                for(vector<string>::iterator i = $1->begin(); i != $1->end(); i++){
                   if (!stPila.tope().existeId(*i)){
                      stPila.anadirParametro(procedimiento,*i, *$2);
                   }else{
                       yyerror("Id duplicado.");
                       errores=true;
                    }
                }

                codigo.anadirParametros(*$1, *$2);
              }
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
                        $$->breaks= *unir($1->breaks, $2->breaks);
                        $$->continues= *unir($1->continues, $2->continues);
                        delete $1;
                        delete $2;
                     }
                    | sentencia
                    {
                        $$ = new sentenciastruct;
                        $$->breaks = $1->breaks;
                        $$->continues = $1->continues;
                    }
                    ;
                    

elseif_else_sentencia: RELSEIF expresion RTHEN M bloque N M elseif_else_sentencia M 
                    {
                        if($2->tipo != "comparacion" && $2->tipo != "bool"){
                            yyerror("Error semántico");
                            errores = true;
                        }                      
                        $$ = new sentenciastruct;
                        codigo.completarInstrucciones($2->trues, $4);
                        codigo.completarInstrucciones($2->falses, $7);
                        codigo.completarInstrucciones(*$6, $9);
                        $$->breaks = * new vector<int>;
                        $$->continues = * new vector<int>;
                    }
                | RELSE  M bloque M 
                    {
                        $$ = new sentenciastruct;
                        $$->breaks = * new vector<int>;
                        $$->continues = * new vector<int>;
                    }
                | /*Vacio*/

sentencia: variable TASSIG2 TIDENTIFIER TOPEN lista_expr TCLOSE
        {
         $$ = new sentenciastruct;
         $$->breaks = * new vector<int>;
         $$->continues = * new vector<int>;
        }

         | variable TASSIG2 expresion
            {
               $$= new sentenciastruct;
               $$->breaks = * new vector<int>;
               $$->continues = * new vector<int>;
               delete $1 ; delete $3;
            }

         | TIDENTIFIER TOPEN lista_expr TCLOSE
                {
                  $$ = new sentenciastruct;
                  $$->breaks = * new vector<int>;
                  $$->continues = * new vector<int>;
               }

         | RIF expresion M bloque M
            {
                if($2->tipo != "comparacion" && $2->tipo != "bool"){
                    yyerror("Error semántico");
                    errores = true;
                }
               $$ = new sentenciastruct;
               codigo.completarInstrucciones($2->trues,$3);
               codigo.completarInstrucciones($2->falses,$5);
               $$->breaks = * new vector<int>;
               $$->continues = * new vector<int>;
            }

         | RFOR M expresion M bloque M
         {
            if($3->tipo != "comparacion" && $3->tipo != "bool"){
                yyerror("Error semántico");
                errores = true;
            }             
            $$ = new sentenciastruct;
            codigo.completarInstrucciones($3->trues, $4);
            codigo.completarInstrucciones($3->falses, $6+1);
            codigo.completarInstrucciones($5->breaks, $6+1);
            codigo.completarInstrucciones($5->continues, $6);
            codigo.anadirInstruccion("goto"+$2);
            $$->breaks = * new vector<int>();
            $$->continues = * new vector<int>();
         }

         | RFOR M bloque M
         {
            $$ = new sentenciastruct;
            codigo.completarInstrucciones($3->breaks, codigo.obtenRef()+1);
            codigo.completarInstrucciones($3->continues, codigo.obtenRef());
            codigo.anadirInstruccion("goto"+$2);
            $$->breaks = * new vector<int>();
            $$->continues = * new vector<int>();
         }

         | RBREAK expresion M
            {
               if ($2->tipo != "comparacion" && $2->tipo != "bool"){
                  yyerror("Error semántico en break.");
                  errores=true;
               }      
               $$ = new sentenciastruct;
               codigo.completarInstrucciones($2->falses, codigo.obtenRef());
               $$->breaks =  $2->trues;
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
            codigo.anadirInstruccion("return"+$2->str);
            $$->breaks = * new vector<int>();
            $$->continues = * new vector<int>();
         }
         | RIF expresion RTHEN M bloque N M elseif_else_sentencia M RENDIF
         {
                if($2->tipo != "comparacion" && $2->tipo != "bool"){
                    yyerror("Error semántico");
                    errores = true;
                }
               $$ = new sentenciastruct;
	      	   codigo.completarInstrucciones($2->trues,$4);
      	  	   codigo.completarInstrucciones($2->falses,$7);
               codigo.completarInstrucciones(*$6, $9);            
               $$->breaks = * new vector<int>;
               $$->continues = * new vector<int>;
         }
         | RFOR TOPEN tipo TIDENTIFIER 
         {
             codigo.anadirInstruccion(*$3 + " " + *$4);
         }
         TASSIG2 expresion 
         {
            if($7->tipo != "numero" && $7->tipo != "variable" && $7->tipo != "operacion"){
                yyerror("Error semántico");
                errores = true;
            }        
            codigo.anadirInstruccion(*$4 + *$6 + $7->str);
         }
         TSEMIC M expresion TSEMIC variable TASSIG2 expresion TCLOSE TLFLE M lista_de_sentencias N TRFLE M
         {
               if ($11->tipo != "comparacion" && $11->tipo != "bool"){
                  yyerror("Error semántico en el for. La expresiṕn no puede ser una operación.");
                  errores=true;
               }else if (*$4 != *$13) {
			         yyerror("Error semántico en el for. Se debe actualizar la variable de la expresión.");
                  errores=true;
               }
               if ( $15->tipo!= "operacion"){
                  yyerror("Error semántico en el for. La actualización de la variable debe ser una operación");
                  errores=true;
               }
               else{
                 codigo.completarInstrucciones($11->trues, $18);
                 codigo.completarInstrucciones($11->falses, $22);
                 codigo.completarInstrucciones(*$20, $10);
            
                 codigo.completarInstrucciones($19->breaks, $22);
                 codigo.completarInstrucciones($19->continues, $10);
                 
                 $$ = new sentenciastruct;
                 $$->breaks = * new vector<int>;
                 $$->continues = * new vector<int>;
               }
             
         }
         

         ;

variable: TIDENTIFIER
        {
            $$ =  $1;                
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
               if ($1->tipo== "bool" || $1->tipo=="operacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               if ($3->tipo== "bool" || $3->tipo=="operacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               $$= new expresionstruct;
               $$->trues = * new vector<int>();
               $$->falses = * new vector<int>();
               *$$ = makearithmetic($1->str,*$2,$3->str);
               delete $1;
               delete $3;
               $$->tipo = "operacion";
            }

         | expresion TMINUS expresion
            {
                if ($1->tipo== "bool" || $1->tipo=="operacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               if ($3->tipo== "bool" || $3->tipo=="operacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               $$= new expresionstruct;
               $$->trues = * new vector<int>();
               $$->falses = * new vector<int>();
               *$$ = makearithmetic($1->str,*$2,$3->str);
               $$->tipo = "operacion";
            }

         | expresion TMUL expresion
            {
                if ($1->tipo== "bool" || $1->tipo=="operacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               if ($3->tipo== "bool" || $3->tipo=="operacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               $$= new expresionstruct;
               $$->trues = * new vector<int>();
               $$->falses = * new vector<int>();
               *$$ = makearithmetic($1->str,*$2,$3->str);
               $$->tipo = "operacion";
            }


         | expresion TDIV expresion
            {  
                if ($1->tipo== "bool" || $1->tipo=="operacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               if ($3->tipo== "bool" || $3->tipo=="operacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               codigo.anadirInstruccion("if"+$3->str+"=0 goto 2");
               $$= new expresionstruct;
               $$->trues = * new vector<int>();
               $$->falses = * new vector<int>();
               *$$ = makearithmetic($1->str,*$2,$3->str);
               $$->tipo = "operacion";
            }


         | expresion TCLT expresion
            {
                 if ($1->tipo== "bool" || $1->tipo=="comparacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               if ($3->tipo== "bool" || $3->tipo=="comparacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               $$= new expresionstruct;               
               $$->str= "";
               $$->trues = * new vector<int>(codigo.obtenRef());
               $$->falses = * new vector<int>(codigo.obtenRef()+1);
               *$$ = makecomparison($1->str,*$2,$3->str);
               $$->tipo = "comparacion";
            }


         | expresion TCGT expresion
            {
                 if ($1->tipo== "bool" || $1->tipo=="comparacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               if ($3->tipo== "bool" || $3->tipo=="comparacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               $$= new expresionstruct;
               $$->str= "";
               $$->trues = * new vector<int>(codigo.obtenRef());
               $$->falses = * new vector<int>(codigo.obtenRef()+1);
               *$$ = makecomparison($1->str,*$2,$3->str);
               $$->tipo = "comparacion";
            }


         | expresion TCLE expresion
            {
                 if ($1->tipo== "bool" || $1->tipo=="comparacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               if ($3->tipo== "bool" || $3->tipo=="comparacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               $$= new expresionstruct;
               $$->str= "";
               $$->trues = * new vector<int>(codigo.obtenRef());
               $$->falses = * new vector<int>(codigo.obtenRef()+1);
               *$$ = makecomparison($1->str,*$2,$3->str);
               $$->tipo = "comparacion";
            }


         | expresion TCGE expresion
            {
                 if ($1->tipo== "bool" || $1->tipo=="comparacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               if ($3->tipo== "bool" || $3->tipo=="comparacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
            $$= new expresionstruct;
            $$->str= "";
            $$->trues = * new vector<int>(codigo.obtenRef());
            $$->falses = * new vector<int>(codigo.obtenRef()+1);
            *$$ = makecomparison($1->str,*$2,$3->str);
            $$->tipo = "comparacion";
         }

         | expresion TCEQ expresion
            {
                 if ($1->tipo== "bool" || $1->tipo=="comparacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               if ($3->tipo== "bool" || $3->tipo=="comparacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               $$= new expresionstruct;
               $$->str= "";
               $$->trues = * new vector<int>(codigo.obtenRef());
               $$->falses = * new vector<int>(codigo.obtenRef()+1);
               *$$ = makecomparison($1->str,*$2,$3->str);
               $$->tipo = "comparacion";
            }


         | expresion TNEQ expresion
            {
                 if ($1->tipo== "bool" || $1->tipo=="comparacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               if ($3->tipo== "bool" || $3->tipo=="comparacion"){
                  yyerror("Tipos incompatibles");
                  errores=true;
               }
               $$= new expresionstruct;
               $$->str= "";
               $$->trues = * new vector<int>(codigo.obtenRef());
               $$->falses = * new vector<int>(codigo.obtenRef()+1);
               *$$ = makecomparison($1->str,*$2,$3->str);
               $$->tipo = "comparacion";
               
            }


         | variable
        {
                $$ = new expresionstruct;
                $$->trues = * new vector<int>();
                $$->falses = * new vector<int>();
                $$->str = *$1;
                $$->tipo = "variable";
        }
         | TINT
        {
                $$ = new expresionstruct;
                $$->trues = * new vector<int>();
                $$->falses = * new vector<int>();
                $$->str = *$1;
                $$->tipo = "numero";
        }
         | TREAL
        {
                $$ = new expresionstruct;
                $$->trues = * new vector<int>();
                $$->falses = * new vector<int>();
                $$->str = *$1;
                $$->tipo = "numero";                
        }
         | TOPEN expresion TCLOSE
        {
                $$ = new expresionstruct;
                $$->trues = $2->trues;
                $$->falses = $2->falses;
                $$->str = $2->str;
                $$->tipo = $2->tipo;               
        }
        
         | expresion RAND M expresion 
        {
             if ($1->tipo== "bool" || $1->tipo=="comparacion"){
                  yyerror("Tipos incompatibles AND ");
                  errores=true;
               }
               if ($4->tipo== "bool" || $4->tipo=="comparacion"){
                  yyerror("Tipos incompatibles AND");
                  errores=true;
               }
               $$= new expresionstruct;
               codigo.completarInstrucciones($1->trues, $3);
               $$->trues = $4->trues;
               $$->falses = *unir($1->falses, $4->falses);
               $$->str = "";
               $$->tipo = "bool";               
        }
        
         | expresion ROR M expresion
        {
             if ($1->tipo== "bool" || $1->tipo=="comparacion"){
                  yyerror("Tipos incompatibles OR");
                  errores=true;
               }
               if ($4->tipo== "bool" || $4->tipo=="comparacion"){
                  yyerror("Tipos incompatibles OR");
                  errores=true;
               }
               $$= new expresionstruct;
               codigo.completarInstrucciones($1->falses, $3);
               $$->trues = *unir($1->trues, $4->trues);
               $$->falses = $4->falses;
               $$->str = "";
               $$->tipo = "bool";
        }
        
         | RNOT expresion
        {
             if ($2->tipo!= "comparacion" && $2->tipo!="bool" ){
                  yyerror("Tipos incompatibles NOT");
                  errores=true;
               }
              $$= new expresionstruct;
              $$->trues = $2->falses;
              $$->falses = $2->trues;
              $$->str = "";
              $$->tipo = "bool";
        }       
    ;

M: /* empty */
        {$$ = codigo.obtenRef();}
;


N: /* empty */
        {$$ = new vector<int>();
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

vector<int>* unir(vector<int> &lis1, vector<int> &lis2){
        vector<int>* res= new vector<int>;
        res->insert(res->begin(), lis1.begin(), lis1.end());
        res->insert(res->begin(), lis2.begin(), lis2.end());
        return res;
}
