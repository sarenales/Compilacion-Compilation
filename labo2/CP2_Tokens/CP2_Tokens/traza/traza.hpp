#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     TVAR26 = 256,
     TVAR28 = 257,
     TIDENTIFIER = 258,
     TINTEGER = 259,
     TDOUBLE = 260,
     TCEQ = 261,
     TCNE = 262,
     TCLT = 263,
     TCLE = 264,
     TCGT = 265,
     TCGE = 266,
     TEQUAL = 267,
     TLPAREN = 268,
     TRPAREN = 269,
     TLBRACE = 270,
     TRBRACE = 271,
     TCOMMA = 272,
     TDOT = 273,
     TPLUS = 274,
     TMINUS = 275,
     TMUL = 276,
     TDIV = 277,
     TCOLON = 278,
     TSEMIC = 279,
     TASSIG = 280,
     RPROGRAM = 281,
     RIS = 282,
     RBEGIN = 283,
     RENDPROGRAM = 284,
     RVAR = 285,
     RINTEGER = 286,
     RFLOAT = 287,
     RENDPROCEDURE = 288,
     RPROCEDURE = 289,
     RIN = 290,
     ROUT = 291,
     RIF = 292,
     RTHEN = 293,
     RELSE = 294,
     RENDIF = 295,
     RREPEAT = 296,
     RUNTIL = 297,
     RENDREPEAT = 298,
     RFOR = 299,
     RASCENDING = 300,
     RFROM = 301,
     RTO = 302,
     RDO = 303,
     RENDFOR = 304,
     RGET = 305,
     RPUT_LINE = 306
   };
#endif
