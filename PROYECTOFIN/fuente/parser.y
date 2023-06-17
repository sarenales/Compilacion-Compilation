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
%token <str> TASSIG TASSIG2 TCOMMA TSEMIC
%token <str> CTE_INT CTE_FLOAT32 CTE_ID
%token <str> TIDENTIFIER TINT TREAL
%token <str> TCEQ TNEQ TCNE TCLT TCLE TCGT TCGE
%token <str> TOPEN TCLOSE TLFLE TRFLE
%token <str> TPLUS TMINUS TMUL TDIV

%token <str> RAND ROR RNOT
%token <str> RPACKAGE RMAIN RFUNC RVAR RIF RFOR RBREAK RCONTINUE RREAD RPRINTLN RRETURN RELSE RTHEN RENDIF RELSEIF RFLOAT32 RINTEGER

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

programa : RPACKAGE RMAIN
        {
               codigo.anadirInstruccion("package main");
        }
         bloque_ppl
        {
               codigo.escribir();
        }
        ;

bloque_ppl : decl_bl 
            {
                codigo.anadirInstruccion("goto");
            }    
            subprogs
            {
               vector<int> v({$2});
               codigo.completarInstrucciones(v, $4->at(0)); 
               delete $4;
            }
            ;

subprogs : subprogs subprograma
            {
               $$ = &unir(*$1,*$2);
               delete $2;
            }

         | subprograma
            {
               $$ = $1;
            }
   ;

subprograma : RFUNC nombre M
               {
                   if($2->compare("main")) codigo.anadirInstruccion("proc "+ (*$2));
               }
               argumentos tipo_opc bloque
               {
                   if($2->compare("main") == 0){
                         $$ = new vector<int>({$3});
                         codigo.anadirInstruccion("halt");
                         delete $2;
                     } else {
                         codigo.anadirInstruccion("endproc "+ (*$2));
                         $$ = new vector<int>();
                     }
                     delete $7;
               }
            ;

nombre : RMAIN {    
                  $$ = new string("main");
               }
       | CTE_ID {
                  $$ = $1;
                  }
       ;

bloque : TLFLE decl_bl subprogs_anon lista_de_sentencias TRFLE
        {
            $$ = $4;
            $$ = new sentenciastruct;
            $$->breaks = * new vector<int>();
            $$->continues = * new vector<int>();
        }
       ;

subprogs_anon : subprogs_anon subprograma_anon
      | %empty
      ;

subprograma_anon : CTE_ID TASSIG RFUNC 
                  {
                     codigo.añadirInstruccion("proc" + *$1);
                  }
                  argumentos tipo_opc bloque     
                  {
                     codigo.añadirInstruccion("endproc" + *$1);
                     delete $7;
                  }
      ;

decl_bl : RVAR TOPEN lista_decl TCLOSE decl_bl
        | RVAR declaracion decl_bl
        | %empty
        ;

lista_decl : lista_decl declaracion
           | declaracion
           ;

declaracion : lista_de_ident tipo
                {          
                    codigo.anadirDeclaraciones(*$1, *$2);
                    delete $1;
                }
            ;

lista_de_ident : CTE_ID resto_lista_id
                {
                     $$ = new vector<string>;
                     $$->insert($$->begin(), *$1);
                     $$ = $2; 
                }
               ;

resto_lista_id : TCOMMA CTE_ID resto_lista_id
                {
                     $3->insert($3->begin(), *$2); 
                     $$ = $3;
                }
               | %empty
                {
                  $$ = new vector<string>();
                };
               ;

tipo : RINTEGER 
               {  
                  $$ = new std::string("int");
               }
     | RFLOAT32 
               {
                  $$ = new std::string("float32");
               }
     ;

tipo_opc: tipo 
            {
                  $$ = $1;
            }
        | %empty
            {}
        ;

argumentos : TOPEN lista_de_param TCLOSE
           ;

lista_de_param : lista_de_ident tipo
             {  
                codigo.anadirParametros(*$1, *$2);
                delete $1;
              }
                resto_lis_de_param
               | %empty
               ;

resto_lis_de_param : TCOMMA lista_de_ident tipo
             {  
                codigo.anadirParametros(*$2, *$3);
                delete $2;
              }
                   resto_lis_de_param
                   | %empty
                   ;

lista_de_sentencias : lista_de_sentencias sentencia
                     {
                        $$ = new sentenciastruct;
                        $$ = $1;
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
                | %empty

sentencia: variable TASSIG2 CTE_ID TOPEN lista_expr TCLOSE
              {
                  codigo.añadirInstruccion($1->str+":= call"+$3->str);
                  $$ = new sentenciastruct;
                  $$->breaks = * new vector<int>;
                  $$->continues = * new vector<int>;
              }

         | variable TASSIG2 expresion
               {
                  codigo.añadirInstruccion($1->str+":="+$3->str);                
                  $$= new sentenciastruct;
                  $$->breaks = * new vector<int>;
                  $$->continues = * new vector<int>;
                  delete $1 ; delete $3;
               }

         | CTE_ID TOPEN lista_expr TCLOSE
                {
                  codigo.añadirInstruccion("call"+$1->str);
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
         | RFOR TOPEN tipo CTE_ID 
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

variable: CTE_ID
        {
            $$->str =  $1->str;                
        }
        ;

lista_expr: expresion resto_lista_expr
            {
                $$->str = añadirDeclaraciones($2*->str,$1->str);
            }
          | %empty
          {
              $$->str = * new vector<String>;
          }
          ;

resto_lista_expr : TCOMMA expresion resto_lista_expr
            {  
                $$->str = añadirDeclaraciones($3*->str,$2*->str);
            }
                  | %empty
             {
                 $$->str = * new vector<String>;
             }
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
               $$ = nuevo_id();
               codigo.anadirInstruccion($$->str+":="+$1->str+"+"+$3->str);
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
               $$ = nuevo_id();
               codigo.anadirInstruccion($$->str+":="+$1->str+"-"+$3->str);
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
               $$ = nuevo_id();
               codigo.anadirInstruccion($$->str+":="+$1->str+"*"+$3->str);
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
               $$ = nuevo_id();
               codigo.anadirInstruccion($$->str+":="+$1->str+"/"+$3->str);
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
               codigo.anadirInstruccion("if"+$1->str+"<"+$3->str);
               codigo.anadirInstruccion("goto");
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
               codigo.anadirInstruccion("if"+$1->str+">"+$3->str);
               codigo.anadirInstruccion("goto");
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
               codigo.anadirInstruccion("if"+$1->str+"<="+$3->str);
               codigo.anadirInstruccion("goto");
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
            codigo.anadirInstruccion("if"+$1->str+">="+$3->str);
            codigo.anadirInstruccion("goto");
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
               codigo.añadirInstruccion("if"+$1->str+"=="+$2->str);
               codigo.añadirInstruccion("goto");
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
               codigo.añadirInstruccion("if"+$1->str+"!="+$2->str);
               codigo.añadirInstruccion("goto");
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
         | CTE_INT
        {
                $$ = new expresionstruct;
                $$->trues = * new vector<int>();
                $$->falses = * new vector<int>();
                $$->str = *$1->str;
                $$->tipo = "numero";
        }
         | CTE_FLOAT32
        {
                $$ = new expresionstruct;
                $$->trues = * new vector<int>();
                $$->falses = * new vector<int>();
                $$->str = *$1->str;
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
               $$= new expresionstruct;
               codigo.completarInstrucciones($1->trues, $3);
               $$->trues = $4->trues;
               $$->falses = *unir($1->falses, $4->falses);
               $$->str = "";
               $$->tipo = "bool";               
        }
        
         | expresion ROR M expresion
        {
               $$= new expresionstruct;
               codigo.completarInstrucciones($1->falses, $3);
               $$->trues = *unir($1->trues, $4->trues);
               $$->falses = $4->falses;
               $$->str = "";
               $$->tipo = "bool";
        }
        
         | RNOT expresion
        {
              $$= new expresionstruct;
              $$->trues = $2->falses;
              $$->str = "";
              $$->tipo = "bool";
        }       
    ;

M: %empty
        {$$ = codigo.obtenRef();}
;


N: %empty
        {$$ = new vector<int>();
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
