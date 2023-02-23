CFLAGS=-Wall

all: traza prueba

clean:
	rm traza traza.cpp *~

traza.cpp: traza.l traza.hpp
	lex -o $@ traza.l

traza: traza.cpp 
	g++ $(CFLAGS) -o $@ *.cpp -ll

prueba:  traza ../prueba1.in ../prueba2.in ../prueba3.in
	./traza <../prueba1.in
	./traza <../prueba2.in
	./traza <../prueba3.in
