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
program                                     TOKEN(RPROGRAM);
main                                        TOKEN(RMAIN);
package                                     TOKEN(RPACKAGE);
func                                        TOKEN(RFUNC);
var                                         TOKEN(RVAR);
if                                          TOKEN(RIF);
for                                         TOKEN(RFOR);
break                                       TOKEN(RBREAK);
continue                                    TOKEN(RCONTINUE);
read                                        TOKEN(RREAD);
println                                     TOKEN(RPRINTLN);
return                                      TOKEN(RRETURN);


"{"                                         TOKEN(RBEGIN);
"}"	                                        TOKEN(RENDPROGRAM);
"("                                         TOKEN(TPARAB);
")"                                         TOKEN(TPARCER);
","                                         TOKEN(TCOMA);
"*"                                         TOKEN(TMUL);
"+"                                         TOKEN(TSUM); 
"-"                                         TOKEN(TRES); 
"/"                                         TOKEN(TDIV);
"="                                         TOKEN(TEQ);
"=="                                        TOKEN(CEQ);
"<"                                         TOKEN(CLT);
">"                                         TOKEN(CGT);
"<="                                        TOKEN(CLE);
">="                                        TOKEN(CGE);
"!="                                        TOKEN(CNE);


":="                                        TOKEN(TASSIG);

";"                                         TOKEN(TSEMIC);
[ \t\n]                                     ;


\$[a-zA-Z](-?[a-zA-Z0-9])*-?                TOKEN(TVAR26);
\$[a-zA-Z](_?_?[a-zA-Z0-9])*                TOKEN(TVAR28);

[a-zA-Z](_?[a-zA-Z0-9])*_?                  TOKEN(TID) ; 
([1-9][0-9]+|0)\.[0-9]+([eE][-+]?[0-9]+)?   TOKEN(TCTEFLOAT32);
[1-9][0-9]*|0                               TOKEN(TCTEINT);


.                        { yyerror("Token desconocido: ");}    
%%


