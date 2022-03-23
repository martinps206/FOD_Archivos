program ejercicio7;
const
   valorAlto = 9999;
type
   str = string[20];

   novela = record
      codigo : integer;
      nombre : str;
      genero : str;
      precio : double;
   end;

   archivo = file of novela;

/////////////////////////////////////////////////////////////////

procedure leerNovela(var n : novela);
begin
   writeln('Ingrese el codigo de la novela : ');
   readln(n.codigo);
   if (n.codigo <> 0) then begin
      writeln('Ingrese el nombre de la novela : ');
      readln(n.nombre);
      writeln('Ingrese el genero de la novela : ');
      readln(n.genero);
      writeln('Ingrese el precio de la novela : ');
      readln(n.precio);
   end;
end;

/////////////////////////////////////////////////////////////////

procedure cargarArchivoBinarioNovela(var archNovela : archivo; var textoNovela : text);
var
   n : novela;
begin
   rewrite(archNovela);     // archivo binario
   reset(textoNovela);      // archivo texto
   while (not eof(textoNovela)) do begin
      with n do begin
         read(textoNovela, codigo, precio, genero);
         read(textoNovela, nombre);
      end;
      write(archNovela, n);
   end;
   close(textoNovela);
   close(archNovela);
end;

procedure agregarArchivoNovela(var archNovela : archivo);
var
   n : novela;
begin
   reset(archNovela);
   seek(archNovela, filesize(archNovela));
   leerNovela(n);
   while (n.codigo <> 0) do begin
      write(archNovela, n);
      leerNovela(n);
   end;
   close(archNovela);
end;

procedure modificarArchivoNovela(var archNovela : archivo);
var
   n : novela;
   cod, nro : integer;
begin
   reset(archNovela);
   writeln('Ingrese el codigo de la novela a modificar : ');
   readln(cod);
   read(archNovela, n);

   while (n.codigo <> valorAlto) and (cod <> n.codigo) do read(archNovela, n);

   if (cod = n.codigo) then begin
      writeln('1. Editar codigo.');
      writeln('2. Editar nombre.');
      writeln('3. Editar genero.');
      writeln('4. Editar precio.');
      writeln('0. Para salir.');
      readln(nro);
      case (nro) of
         1 : begin
                writeln('Ingrese un nuevo codigo : ');
                readln(n.codigo);
             end;
         2 : begin
                writeln('Ingrese un nuevo nombre : ');
                readln(n.nombre);
             end;
         3 : begin
                writeln('Ingrese un nuevo genero : ');
                readln(n.genero);
             end;
         4 : begin
                writeln('Ingrese un nuevo precio : ');
                readln(n.precio);
             end;
         else writeln('la opcion no es valida...');
      end;
      seek(archNovela, filepos(archNovela) - 1);
      write(archNovela, n);
   end
   else writeln('El codigo no se encuentra en el archivo...');
   close(archNovela);
end;

var
   archNovela : archivo;
   opcion : integer;
   textoNovela : text;
begin
   assign(archNovela, 'novelas');
   assign(textoNovela, 'novelas.txt');

   writeln('  MENU');
   writeln('  ----');
   writeln('1. Cargar desde un archove de texto aun beinario.');
   writeln('2. Modifica datos de una novela.');
   writeln('3. Agregar una nueva novela alarchivo.');
   writeln('0. Si desea salir.');
   writeln('Seleccione una opcion');
   readln(opcion);
   while (opcion <> 0) do begin
      case (opcion) of
         1 : cargarArchivoBinarioNovela(archNovela, textoNovela);
         2 : modificarArchivoNovela(archNovela);
         3 : agregarArchivoNovela(archNovela);
         else
            writeln('La opcion no es valida. Ingrese 0 si desea Salir')
      end;
      writeln('  MENU');
      writeln('  ----');
      writeln('1. Cargar desde un archove de texto aun beinario.');
      writeln('2. Modifica datos de una novela.');
      writeln('3. Agregar una nueva novela alarchivo.');
      writeln('0. Si desea salir.');
      writeln('Seleccione una opcion');
      readln(opcion);
   end;
   readln();
end.
