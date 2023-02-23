/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_HPP_INCLUDED
# define YY_YY_PARSER_HPP_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    TID = 258,                     /* TID  */
    TINTEGER = 259,                /* TINTEGER  */
    TDOUBLE = 260,                 /* TDOUBLE  */
    TMUL = 261,                    /* TMUL  */
    TSEMIC = 262,                  /* TSEMIC  */
    TASSIG = 263,                  /* TASSIG  */
    RPROGRAM = 264,                /* RPROGRAM  */
    RBEGIN = 265,                  /* {     */
    RENDPROGRAM = 266,             /* }     */
    TVAR26 = 267,
    TVAR28 = 268,   
    TCOMA = 269,                   /* ,     */
    TPARAB = 270,                  /* (     */
    TPARCER = 271,                 /* )     */
    TCTEFLOAT32 = 272,             /* TCTE-FLOAT32 */
    TCTEINT = 273,                 /* TCTE-INT */
    RMAIN = 274,                   /* main */
    RPACKAGE = 275,                /* package */ 
    RFUNC = 276,                   /* func   */
    RVAR = 277,                    /* var   */
    RIF = 278,                     /* if    */
    RFOR = 279,                    /* for   */
    RBREAK =280,                   /* breack */
    RCONTINUE = 281,               /* continue*/
    RREAD = 282,                   /* read  */
    RPRINTLN = 283,                /* println */
    RRETURN = 284,                 /* return */
    TRES = 285,                    /* -     */
    TDIV = 286,                    /* /     */
    TEQ = 287,                     /* =     */
    CEQ = 288,                     /* ==    */
    CLT = 289,                     /* <     */
    CGT = 290,                     /* >     */
    CLE = 291,                     /* <=    */
    CGE = 292,                     /* >=    */
    CNE = 293                      /* !=    */
    
    
    
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 20 "parser.y"

    string *str ; 

#line 79 "parser.hpp"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_HPP_INCLUDED  */
