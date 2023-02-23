CFLAGS=-Wall

all: traza prueba

clean:
	rm traza traza.cpp *~

traza.cpp: traza.l traza.hpp
	flex -o $@ traza.l

traza: traza.cpp 
	g++ $(CFLAGS) -o $@ *.cpp -ll

prueba:  traza ../prueba1.in ../pruebaObj1.in ../pruebaObj2.in
	./traza <../prueba1.in
	./traza <../pruebaObj1.in
	./traza <../pruebaObj2.in
