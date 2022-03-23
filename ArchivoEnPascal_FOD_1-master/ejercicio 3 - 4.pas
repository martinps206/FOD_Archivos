program ejercicio3y4;
type
   // Registro de empleados
   empleado = record
      numero : integer;
      apellido : string;
      nombre : string;
      edad : integer;
      dni : integer;
   end;

   archivo = file of empleado;

// realizamos la lecturas del registo de cada empleado
procedure leerEmpleado(var e : empleado);
begin
   writeln('Ingrese apellido del empleado : ');
   readln(e.apellido);
   if(e.apellido <> '') then begin
      writeln('Ingrese el nombre del empleado : ');
      readln(e.nombre);
      writeln('Ingrese el numero del empleado : ');
      readln(e.numero);
      writeln('Ingrese la edad del empleado : ');
      readln(e.edad);
      writeln('Ingrese el DNI del empleado');
      readln(e.dni);
      writeln('Ingrese apellido del empleado : ');
      readln(e.apellido);
   end;
end;

// cargamos los empleados en el archivo
procedure CargarArchivoEmpleados(var archEmpleados : archivo);
var
   e : empleado;
begin
   leerEmpleado(e);
   while(e.apellido <> '') do begin
      write(archEmpleados, e);
      leerEmpleado(e);
   end;
end;

// Realizamos la busqueda de un empleado por medio de su apellido
procedure buscarEmpleado(var archEmpleados : archivo);
var
   ape : string;
   e : empleado;
begin
   writeln('Ingrese un nombre o apellido a buscar : ');
   readln(ape);
   while(not eof(archEmpleados)) do begin
      read(archEmpleados,e);
      if (ape = e.apellido) then
         writeln('Se encontro el Sr. ',e.apellido,' con el DNI : ',e.dni)
      else
          writeln('No se encuentra en nuestros datos...');
   end;
end;

// Realizamos la lectura de todos los registro de empleados para imprimir por pantalla a los que son mayores de 60 años
procedure aJubilarse(var archEmpleados : archivo);
var
   e :empleado;
begin
   while(not eof(archEmpleados)) do Begin
      read(archEmpleados, e);
      if (e.edad > 60) then writeln('El Sr. ',e.nombre,', ',e.apellido,'con la edad de ',e.edad);
   end;
end;

// Imprimimos por pantalla a todos los empleados registrados en el archivo
procedure imprimirArchivoEmpleados(var archEmpleados : archivo);
var
   e : empleado;
begin
   writeln('Listado de todos los empleados');
   writeln('------------------------------');
   while(not eof(archEmpleados)) do Begin
      read(archEmpleados,e);
      writeln('|',e.nombre,'  ',e.apellido, ' ', ' --> ', e.dni, '|');
   end;
   writeln('------------------------------');
end;

// Agregamos un nuevo empleado al archivo
procedure agregarEmpleado(var archEmpleados : archivo);
var
   e : empleado;
begin
   seek(archEmpleados, filesize(archEmpleados));
   leerEmpleado(e);
   while(e.apellido <> '') do begin
      write(archEmpleados, e);
      leerEmpleado(e);
   end;
end;

// Realizamos una busqueda en el archivo de empleados por medio del numero de empleado, del cual modificaremos su edad
procedure modificarEdad(var archEmpleados : archivo);
var
   e : empleado;
   nro, newedad : integer;
   ok : boolean;
begin
   ok := true;
   writeln('Ingrese el numero del empleado a modificar edad');
   readln(nro);
   while (nro <> 0) do begin
      while (not eof(archEmpleados) and ok) do read(archEmpleados, e);
      if(e.numero = nro) then begin
         writeln('Ingrese la edad del empleado :');
         readln(newedad);
         e.edad := newedad;
         seek(archEmpleados, filepos(archEmpleados) - 1);
         write(archEmpleados, e);
      end;
      writeln('Ingrese otro numero de empleado :');
      readln(nro);
      seek(archEmpleados,0);
   end;
end;

// Realizamos la exportacion del archivo de empleados a un nuevo archivo en TXT
procedure exportarEmpleados(var archEmpleados : archivo; var archExporta : text);
var
   e : empleado;
begin
   while (not eof(archEmpleados)) do begin
      read(archEmpleados, e);
      with e do begin
         writeln(archExporta, 'Numero de empleado : ',numero, ' Nombre : ', nombre, ' Apellido : ', apellido, ' DNI : ', dni, ' Edad : ', edad);
         writeln();
      end;
   end;
end;

// Realizamos la exportacion a un archivo TXT, a los empleados con DNI igual cero.
procedure sinDNI(var archEmpleados : archivo);
var
   e : empleado;
   texto : text;
begin
   assign(texto, 'sindni.txt');
   rewrite(texto);
   while (not eof(archEmpleados)) do begin
      read(archEmpleados, e);
      if (e.dni = 0) then begin
         writeln(texto, e.apellido, ' ', e.numero, ' ', e.edad, ' ',e.nombre);
         writeln();
      end;
   end;
   close(texto);
end;

procedure menu();
var
   archEmpleados : archivo;
   archExporta : text;
   archFisico : string;
   opcion : integer;
begin
   writeln('0. Ingresar los empleados al archivo.');
   writeln('1. Imprimir lista de empleados.');
   writeln('2. Buscar un empleado por apellido.');
   writeln('3. Imprimir los empleados a Jubilarse.');
   writeln('4. Agregar un nuevo empleado.');
   writeln('5. Modificar la edad de un empleado.');
   writeln('6. Exportar el archivo, a un archivo de texto.');
   writeln('7. Exportar el archivo  a un archivo de texto que tengan DNI.');
   writeln('8. Cerrar el programa.');
   writeln('Ingrese la opcion adesaroolar');
   readln(opcion);
   case(opcion) of
      0 : begin
             writeln('Ingrese el nombre del archivo : ');
             readln(archFisico);
             assign(archEmpleados,archFisico);
             rewrite(archEmpleados);
             CargarArchivoEmpleados(archEmpleados);
             close(archEmpleados);
          end;
      1 : begin
             assign(archEmpleados,'empleados');
             reset(archEmpleados);
             seek(archEmpleados,0);
             imprimirArchivoEmpleados(archEmpleados);
             close(archEmpleados);
          end;
      2 : begin
             reset(archEmpleados);
             seek(archEmpleados,0);
             buscarEmpleado(archEmpleados);
             close(archEmpleados);
          end;
      3 : begin
             reset(archEmpleados);
             seek(archEmpleados,0);
             aJubilarse(archEmpleados);
             close(archEmpleados);
          end;
      4 : begin
             reset(archEmpleados);
             writeln('Ingrese el empleado que desea agregar.-');
             agregarEmpleado(archEmpleados);
             close(archEmpleados);
          end;
      5 : begin
             reset(archEmpleados);
             writeln('Ingrese los datos para modificar la edad.-');
             modificarEdad(archEmpleados);
             close(archEmpleados);
          end;
      6 : begin
             reset(archEmpleados);
             rewrite(archExporta);
             writeln('Exportando el archivo');
             exportarEmpleados(archEmpleados, archExporta);
             writeln('Fin de la exportacion...');
             close(archExporta);
             close(archEmpleados);
          end;
      7 : begin
             writeln('Exportar los empleados sin DNI');
             reset(archEmpleados);
             sinDNI(archEmpleados);
             close(archEmpleados);
          end;
       else writeln('La opcion no es valida...');
   end;
end;

begin
   menu();
   readln();
end.
