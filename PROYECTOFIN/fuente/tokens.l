%option yylineno
%option nounput

%{
 #include <string>
 #include <vector>
 #include <algorithm>
 using namespace std ;
 #include "Exp.hpp"
 #include "parser.hpp"
 #include "Sent.hpp"

 #define TOKEN(t) yylval.str = new std::string(yytext, yyleng) ; return t 
 extern "C" int yywrap() { return(1) ; }  
%}

%%

\/\*+([^*/](\*|\/)*)*\*\/       ;
\/\/.+\n                ;

package                 TOKEN( RPACKAGE ) ;
main                    TOKEN( RMAIN ) ;
func                    TOKEN( RFUNC ) ;
var                     TOKEN( RVAR ) ;
cte_integer             TOKEN( RINTEGER ) ;
cte_float               TOKEN( RFLOAT ) ;
if                      TOKEN( RIF ) ;
for                     TOKEN( RFOR ) ; 
break                   TOKEN( RBREAK ) ;  
continue                TOKEN( RCONTINUE ) ;  
read                    TOKEN( RREAD ) ;
println                 TOKEN( RPRINTLN ) ;
return                  TOKEN( RRETURN ) ;

 
[ \t\n]                 ;
[a-zA-Z][a-zA-Z0-9]*([_]?[a-zA-Z0-9])*          TOKEN( TIDENTIFIER ) ; 
([1-9][0-9]+|0)\.[0-9]+([eE][-+]?[0-9]+)?       TOKEN( TFLOAT32 ) ;
(([1-9][0-9]*)|0)\.[0-9]*[1-9]((Ee)[+-]?[1-9][0-9]*)? TOKEN(TDOUBLE);

[0-9]+                  TOKEN( TINT ) ;

"=="                    TOKEN( TCEQ ) ;
"!="                    TOKEN( TNEQ ) ;
"<"                     TOKEN( TCLT ) ;
"<="                    TOKEN( TCLE ) ;
">"                     TOKEN( TCGT ) ;
">="                    TOKEN( TCGE ) ;

"("                     TOKEN( TOPEN ) ;
")"                     TOKEN( TCLOSE ) ;

"{"                     TOKEN(TLFLE);
"}"                     TOKEN(TRFLE);

","                     TOKEN( TCOMMA ) ;    

":"                     TOKEN( TCOLON ) ;
";"                     TOKEN( TSEMIC ) ;

":="                    TOKEN( TASSIG ) ;
"="                     TOKEN( TASSIG2 ) ;
"+"                     TOKEN( TPLUS ) ;
"-"                     TOKEN( TMINUS ) ;
"*"                     TOKEN( TMUL ) ;
"/"                     TOKEN( TDIV ) ;

.                       { yyerror("Token desconocido: ");} 

%%

