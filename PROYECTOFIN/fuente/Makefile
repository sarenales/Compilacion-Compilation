CFLAGS=-Wall
FUENTES=parser.cpp main.cpp tokens.cpp Codigo.cpp
TESTDIR=./pruebas

all: parser test

clean:
	rm parser.cpp parser.hpp parser tokens.cpp *~

parser.cpp parser.hpp: parser.y 
	bison -d -o $@ $<

tokens.cpp: tokens.l parser.hpp 
	flex --yylineno -o $@ $<

parser: $(FUENTES) Codigo.hpp Exp.hpp
	g++ $(CFLAGS) -o $@ $(FUENTES) 

test: parser $(TESTDIR)/*.in 

$(TESTDIR)/%.in: parser
	@echo "PROBANDO: ./$< < $@"
	./$< < $@
