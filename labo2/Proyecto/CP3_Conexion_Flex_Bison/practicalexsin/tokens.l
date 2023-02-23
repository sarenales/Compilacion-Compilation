%option yylineno 
%option nounput

%{
 #include <string>
 #include <iostream>
 #include <vector>
 using namespace std ;
 #include "parser.hpp" 
 using namespace std;

 #define TOKEN(t) yylval.str = new string(yytext, yyleng) ; return t 

 extern "C" int yywrap() { return(1) ; }  
 extern int yyerror(const char *); 

%}

%%
program                TOKEN(RPROGRAM) ;
"{"                   TOKEN(RBEGIN) ;
"}"	                TOKEN(RENDPROGRAM) ;
"("                     TOKEN(TPARAB);
")"                     TOKEN(TPARCER);
","                     TOKEN(TCOMA);

"*"                     TOKEN(TMUL);

":="                     TOKEN(TASSIG);
"="                      TOKEN(TIGUAL);

";"                     TOKEN(TSEMIC);
[ \t\n]                 ;

[a-zA-Z](_?[a-zA-Z0-9])*_?    TOKEN(TID) ;
([1-9][0-9]+|0)\.[0-9]+([eE][-+]?[0-9]+)?         TOKEN(TCTE-FLOAT32);
[1-9][0-9]*|0                  TOKEN(TCTE-INT);

.                        { yyerror("Token desconocido: ");}    
%%


