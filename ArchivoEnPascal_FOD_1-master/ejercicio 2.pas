program ejercicio2;
type
   numero = file of integer;

procedure procesar(var archLogico : numero; var cantidad : integer; var promedio : integer);
var
   total : integer;
   numero : integer;
   suma : integer;
begin
   promedio := 0;
   cantidad := 0;
   total := 0;
   suma := 0;
   while (not eof(archLogico)) do begin
      read(archLogico,numero);
      writeln(numero);
      suma := suma + numero;
      total := total + 1;
      if (numero < 1000) then cantidad := cantidad + 1;
   end;
   if (total >  0) then promedio := suma div total;
end;

var
   archFisico : String;
   archLogico : numero;
   cantidad, promedio : integer;
begin
   writeln('Ingrese el archivo que desea abrir : ');
   readln(archFisico);
   assign(archLogico,archFisico);
   reset(archLogico);
   procesar(archLogico,cantidad,promedio);
   writeln('Cantidad : ',cantidad,'  Promedio : ',promedio);
   close(archLogico);
   readln();
end.
