program ejercicio1;
type
   numero = file of integer;
// Modulo donde se evaluan los numeros ingresados, corta con el ingreso de 0 que no se alamacena
procedure procesar(var archLogico : numero);
var
   numero : integer;
begin
   writeln('Ingrese un numero : ');
   readln(numero);
   while(numero <> 0)do begin
      write(archLogico,numero);
      writeln('Ingrese un numero : ');
      readln(numero);
   end;
end;

var
   archFisico : String;
   archLogico : numero;
Begin
   writeln('Ingresse nombre del archivo : ');
   readln(archFisico);   // nombre del achivo
   assign(archLogico,archFisico);
   rewrite(archLogico);  // crea el archivo logico
   procesar(archLogico); // asignamos el nombre al archivo logico
   close(archLogico);   // cierra el archivo logico
   readln();
end.
