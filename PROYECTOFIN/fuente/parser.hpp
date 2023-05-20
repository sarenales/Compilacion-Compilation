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
    TIDENTIFIER = 258,             /* TIDENTIFIER  */
    TINTEGER = 259,                /* TINTEGER  */
    TDOUBLE = 260,                 /* TDOUBLE  */
    TLPAREN = 261,                 /* TLPAREN  */
    TRPAREN = 262,                 /* TRPAREN  */
    TLBRACE = 263,                 /* TLBRACE  */
    TRBRACE = 264,                 /* TRBRACE  */
    TCOMMA = 265,                  /* TCOMMA  */
    TDOT = 266,                    /* TDOT  */
    TCOLON = 267,                  /* TCOLON  */
    TSEMIC = 268,                  /* TSEMIC  */
    TASSIG = 269,                  /* TASSIG  */
    RPROGRAM = 270,                /* RPROGRAM  */
    RIS = 271,                     /* RIS  */
    RBEGIN = 272,                  /* RBEGIN  */
    RENDPROGRAM = 273,             /* RENDPROGRAM  */
    RVAR = 274,                    /* RVAR  */
    RINTEGER = 275,                /* RINTEGER  */
    RFLOAT = 276,                  /* RFLOAT  */
    RENDPROCEDURE = 277,           /* RENDPROCEDURE  */
    RPROCEDURE = 278,              /* RPROCEDURE  */
    RIN = 279,                     /* RIN  */
    ROUT = 280,                    /* ROUT  */
    RIF = 281,                     /* RIF  */
    RTHEN = 282,                   /* RTHEN  */
    RELSE = 283,                   /* RELSE  */
    RENDIF = 284,                  /* RENDIF  */
    RGET = 285,                    /* RGET  */
    RPUT_LINE = 286,               /* RPUT_LINE  */
    RDO = 287,                     /* RDO  */
    RWHILE = 288,                  /* RWHILE  */
    RENDWHILE = 289,               /* RENDWHILE  */
    REXIT = 290,                   /* REXIT  */
    TCEQ = 291,                    /* TCEQ  */
    TCNE = 292,                    /* TCNE  */
    TCLT = 293,                    /* TCLT  */
    TCLE = 294,                    /* TCLE  */
    TCGT = 295,                    /* TCGT  */
    TCGE = 296,                    /* TCGE  */
    TEQUAL = 297,                  /* TEQUAL  */
    TPLUS = 298,                   /* TPLUS  */
    TMINUS = 299,                  /* TMINUS  */
    TMUL = 300,                    /* TMUL  */
    TDIV = 301                     /* TDIV  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 36 "parser.y"

    string *str ; 
    vector<string> *list ;
    expresionstruct *expr ;
    int number ;
    vector<int> *numlist;

#line 118 "parser.hpp"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_HPP_INCLUDED  */
