program                  ejemplo                   (input,output);
var estas,variables,no,sirven:integer;
    para,nada,ni,	   esta,pero_     esta_es_diferente:char;

procedure ahora (var vienen:integer;los:integer);
var procedimientos:integer;
# Como ves	 hay anidamiento
# y comentarios
# de una       sola 
# línea                                   

	procedure 	primer;
	var   		procedimiento:   	integer;
	begin
		no:=no+		1;
	end;  { primer }
 
	traza procedure segundo;
	var procedimiento:char		;
		i        :real;
		begin
		primer;
		# prueba de reales 
		i := 1.456 ;
		i := 0.001E-10 ;
		i := 100.0e2 ;
	end;
begin
  procedimientos := 0;
  while procedimientos < 10    do
        begin
           procedimientos := 	procedimientos + 1;
           segundo;
        end;
        # end 
end;

begin  #comienza el 	Programa      Principal 
  read(estas);
  ahora(estas,variables		);
  writeln(estas);
end.  # acaba el programa    	principal   
