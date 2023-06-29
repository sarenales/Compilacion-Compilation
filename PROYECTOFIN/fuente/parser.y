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


   // funciones a utilizar
   expresionstruct makecomparison(std::string &s1, std::string &s2, std::string &s3) ;
   expresionstruct makearithmetic(std::string &s1, std::string &s2, std::string &s3) ;
   vector<int> &unir(vector<int>& lis1, vector<int>& lis2);

   Codigo codigo;
   string procedimiento;

%}

/* 
   qué atributos tienen los símbolos 
*/
%union {
    string *str ; 
    vector<int> *numlist;
    vector<string> *list ;
    sentenciastruct* jumps;
    expresionstruct *expr ;
    int number ;
}


/* declaración de tokens. Esto debe coincidir con tokens.l */
%token <str> TASSIG TASSIG2 TCOMMA TSEMIC
%token <str> RPACKAGE RMAIN CTE_INT CTE_FLOAT32 CTE_ID
%token <str> TCEQ TNEQ TCNE TCLT TCLE TCGT TCGE
%token <str> TOPEN TCLOSE TLFLE TRFLE
%token <str> TPLUS TMINUS TMUL TDIV

%token <str> RAND ROR RNOT
%token <str> RFUNC RVAR RIF RFOR RBREAK RCONTINUE RREAD RPRINTLN RRETURN RELSE RTHEN RENDIF RELSEIF RFLOAT32 RINTEGER RFROM RTO RDO RENDFOR

// declaracion no terminal de la gramática
%type <str> nombre tipo tipo_opc variable
%type <numlist> subprogs subprograma
%type <list> lista_de_ident resto_lista_id lista_expr resto_lista_expr
%type <jumps> bloque lista_de_sentencias sentencia
%type <expr> expresion
%type <number> M

// prioridades
%left ROR
%left RAND
%nonassoc RNOT
%nonassoc TCEQ TCNE TCLT TCLE TCGT TCGE TNEQ
%left TPLUS TMINUS
%left TMUL TDIV


%start programa

%%

programa : RPACKAGE RMAIN
        {
               codigo.anadirInstruccion("proc main");
        }
         bloque_ppl
        {
               codigo.escribir();
        }
        ;

bloque_ppl : decl_bl M
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
        }
       ;

subprogs_anon : subprogs_anon subprograma_anon
      | %empty
      ;

subprograma_anon : CTE_ID TASSIG RFUNC 
                  {
                     codigo.anadirInstruccion("proc " + *$1);
                  }
                  argumentos tipo_opc bloque     
                  {
                     codigo.anadirInstruccion("endproc " + *$1);
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
                     $2->insert($2->begin(), *$1);
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
                  $$ = new std::string("real");
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
                       $$ = $1;
                       unir($1->breaks, $2->breaks);
                       unir($1->continues, $2->continues); 
                       delete $2;
                  }
                    | sentencia { $$ = $1;}
                    ;

sentencia: variable TASSIG2 CTE_ID TOPEN lista_expr TCLOSE
              {
                  $$ = new sentenciastruct;
                  string param = "param";
                  codigo.anadirDeclaraciones(*$5, param);
                  codigo.anadirInstruccion(*$1+" := "+" call "+*$3);
                  delete $1; 
                  delete $5;
              }

         | variable TASSIG2 expresion
               {
                  $$= new sentenciastruct; 
                  codigo.anadirInstruccion(*$1+":="+$3->str); 
                  delete $1 ; 
                  delete $3;
               }

         | CTE_ID TOPEN lista_expr TCLOSE
                {
                  $$ = new sentenciastruct;
                  string param = "param";
                  codigo.anadirDeclaraciones(*$3, param);
                  codigo.anadirInstruccion("call "+*$1);
                  delete $3;
                }

         | RIF expresion M bloque M
            {
               $$ = $4;
               codigo.completarInstrucciones($2->trues,$3);
               codigo.completarInstrucciones($2->falses,$5);
               delete $2;
            }

         | RFOR M expresion M bloque M
         {           
            $$ = new sentenciastruct;
            codigo.completarInstrucciones($3->trues, $4);
            codigo.completarInstrucciones($3->falses, $6+1);
            codigo.anadirInstruccion("goto "+ to_string($2));
            codigo.completarInstrucciones($5->breaks, $6 + 1);
            codigo.completarInstrucciones($5->continues, $2); 
            delete $3;
            delete $5;
         }

         | RFOR M bloque M
         {
            $$ = new sentenciastruct;
            codigo.anadirInstruccion("goto "+to_string($2));    
            codigo.completarInstrucciones($3->breaks, $4+1);
            codigo.completarInstrucciones($3->continues, $2);
            delete $3;
         }
         
         | RFOR TOPEN tipo CTE_ID 
            {
               codigo.anadirInstruccion(*$3 + " "+ *$4 );
            }
          TASSIG expresion 
            {
               codigo.anadirInstruccion(*$4 +*$6 + $7->str);
            }
          TSEMIC M expresion TSEMIC variable TASSIG expresion TCLOSE TLFLE M lista_de_sentencias M TRFLE M
            {

                  codigo.completarInstrucciones($11->trues, $18);
                  codigo.completarInstrucciones($11->falses, $22);
                  codigo.anadirInstruccion("goto" +$10);
                  codigo.completarInstrucciones($19->breaks, $22);
                  codigo.completarInstrucciones($19->continues, $10);
                  codigo.anadirInstruccion(*$13 +" := " +$15->str);
                  $$ = new sentenciastruct;
                  delete $6;
                  delete $9;
                  delete $13;
            }
         
         | RBREAK expresion M
            {   
               $$ = new sentenciastruct;
               codigo.completarInstrucciones($2->falses, $3);
               $$->breaks = $2->trues;
               delete $2;
            }

         | RCONTINUE M
            {
                $$ = new sentenciastruct;
                $$->continues.push_back(codigo.obtenRef()); 
                codigo.anadirInstruccion("goto");
            }

         | RREAD TOPEN variable TCLOSE
            {
                $$ = new sentenciastruct;
                codigo.anadirInstruccion("read "+ *$3);
                delete $3;
            }

         | RPRINTLN TOPEN expresion TCLOSE
            {
                $$ = new sentenciastruct;
                codigo.anadirInstruccion("write "+ $3->str);
                codigo.anadirInstruccion("writeln");
                delete $3;
            }

         | RRETURN expresion
         {
            $$ = new sentenciastruct;
            codigo.anadirInstruccion("return"+$2->str);
            delete $2;
         }
         

         

         

         ;

variable: CTE_ID
        {
            $$ =  $1;                
        }
        ;

lista_expr: expresion resto_lista_expr
            {
               $2->insert($2->begin(), $1->str); 
               $$ = $2;
               delete $1;
            }
          | %empty
          {
              $$ = new vector<string>();
          }
          ;

resto_lista_expr : TCOMMA expresion resto_lista_expr
            {  
               $3->insert($3->begin(), $2->str); 
               $$ = $3; 
               delete $2;
            }
            | %empty
             {
                 $$ = new vector<string>();
             }
                 ;

expresion: expresion TPLUS expresion
            {

               $$= new expresionstruct;
               *$$ = makearithmetic($1->str,*$2,$3->str);
               delete $1;
               delete $3;
            }

         | expresion TMINUS expresion
            {
               $$= new expresionstruct;
               *$$ = makearithmetic($1->str,*$2,$3->str);
               delete $1;
               delete $3;
            }

         | expresion TMUL expresion
            {

               $$= new expresionstruct;
               *$$ = makearithmetic($1->str,*$2,$3->str);
               delete $1;
               delete $3;
            }


         | expresion TDIV expresion
            {  
               $$= new expresionstruct;
               *$$ = makearithmetic($1->str,*$2,$3->str);
               delete $1;
               delete $3;
            }


         | expresion TCLT expresion
            {
               $$= new expresionstruct;               
               *$$ = makecomparison($1->str,*$2,$3->str);
               delete $1;
               delete $3;
            }


         | expresion TCGT expresion
            {
               $$= new expresionstruct;
               *$$ = makecomparison($1->str,*$2,$3->str);
               delete $1;
               delete $3;
            }


         | expresion TCLE expresion
            {
               $$= new expresionstruct;
               *$$ = makecomparison($1->str,*$2,$3->str);
               delete $1;
               delete $3;
            }


         | expresion TCGE expresion
            {
            $$= new expresionstruct;
            *$$ = makecomparison($1->str,*$2,$3->str);
            delete $1;
            delete $3;
         }

         | expresion TCEQ expresion
            {
               $$= new expresionstruct;
               string eq = "=";
               *$$ = makecomparison($1->str,eq,$3->str);
               delete $1;
               delete $3;
            }


         | expresion TNEQ expresion
            {
               $$= new expresionstruct;
               *$$ = makecomparison($1->str,*$2,$3->str);
               delete $1;
               delete $3;
               
            }


         | variable
        {
                $$ = new expresionstruct;
                $$->str = *$1;
        }
         | CTE_INT
        {
                $$ = new expresionstruct;
                $$->str = *$1;
        }
         | CTE_FLOAT32
        {
                $$ = new expresionstruct;
                $$->str = *$1;               
        }
         | TOPEN expresion TCLOSE
        {
                $$ = new expresionstruct;
                $$->trues = $2->trues;
                $$->falses = $2->falses;
                $$ = $2;              
        }
           
           
         | expresion RAND M expresion
         {
             $$ = new expresionstruct;
             codigo.completarInstrucciones($1->trues, $3);
             $$->trues = $4->trues;
             $$->falses = unir($1->falses, $4->falses);
             delete $1;
             delete $4;
         }
         
         | expresion ROR M expresion
        {
               $$= new expresionstruct;
               codigo.completarInstrucciones($1->falses, $3);
               $$->trues = unir($1->trues, $4->trues);
               $$->falses = $4->falses;
               delete $1;
               delete $4;
        }
        
         | RNOT expresion
        {
              $$= new expresionstruct;
              $$->trues = $2->falses;
              $$->falses = $2->trues;
              delete $2;
        }    
      
    ;

M: %empty
        {$$ = codigo.obtenRef();}
;



%%

expresionstruct makecomparison(std::string &s1, std::string &s2, std::string &s3) {
  expresionstruct tmp ; 
  tmp.trues.push_back(codigo.obtenRef()) ;
  tmp.falses.push_back(codigo.obtenRef()+1) ;
  codigo.anadirInstruccion("if " + s1 + " " + s2 + " " + s3 + " goto") ;
  codigo.anadirInstruccion("goto") ;
  return tmp ;
}


expresionstruct makearithmetic(std::string &s1, std::string &s2, std::string &s3) {
  expresionstruct tmp ; 
  tmp.str = codigo.nuevoId() ;
  codigo.anadirInstruccion(tmp.str + ":=" + s1 + " " + s2 + " " + s3) ;     
  return tmp ;
}

vector<int>& unir(vector<int>& lis1, vector<int>& lis2) {
    lis1.insert(lis1.end(), lis2.begin(), lis2.end());
    return lis1;
}
