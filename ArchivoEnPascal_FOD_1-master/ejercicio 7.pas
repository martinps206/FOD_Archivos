program exerciseSeven;
uses crt;
const
   tallValue = 9999;
type
   str20 = string[20];

   novel = record
      code : integer;
      name : str20;
      gender : str20;
      price : integer;
   end;

   novelFile = file of novel;

procedure fileLoad(var novelFile : novelFile; var textoFile : text);
var
   n : novel;
begin
   rewrite(novelFile);
   reset(textoFile);
   while (not eof(textoFile)) do begin
      with n do begin
         readln(textoFile, code, gender, price);
         readln(textoFile, name);
      end;
      write(novelFile, n);
   end;
   close(textoFile);
   close(novelFile);
end;

procedure loadRegister(var n : novel);
begin
   writeln('Ingrese el codigo de la novela : ');
   readln(n.code);
   if n.code <> 0 then begin
      writeln('Ingrese el nombre de la novela : ');
      readln(n.name);
      writeln('Ingrese el genero de al novela : ');
      readln(n.gender);
      writeln('Ingrese el precio de la novela : ');
      readln(n.price);
   end;
end;

procedure readFile(var novelFile : novelFile; var n : novel);
begin
   if (not eof(novelFile)) then read(novelFile, n)
   else  n.code := tallValue;
end;

procedure modifyFile(var novelFile : novelFile);
var
   n : novel;
   cod, opc : integer;
begin
   reset(novelFile);
   writeln('Ingrese el codigo de la novela a modificar : ');
   readln(cod);
   readFile(novelFile, n);
   while (n.code <> tallValue) and (cod <> n.code) do readFile(novelFile, n);
   if (n.code = cod) then begin
      writeln('1. Editar codigo.');
      writeln('2. Editar nombre.');
      writeln('3. Editar genero.');
      writeln('4. Editar precio.');
      writeln('0. Salir.');
      writeln('Ingrese opcion : ');
      readln(opc);
      case opc of
         1 : begin
                write('Ingrese el nuevo codigo : ');
                readln(n.code);
             end;
         2 : begin
                write('Ingrese el nuevo nombre : ');
                readln(n.name);
             end;
         3 : begin
                write('Ingrese el nuevo genero : ');
                readln(n.gender);
             end;
         4 : begin
                write('Ingrese el nuevo precio : ');
                readln(n.price);
             end;
      end;
      seek(novelFile, filepos(novelFile)-1);
      write(novelFile, n);
   end;
   close(novelFile);
end;

procedure loadNovel(var novelFile : novelFile);
var
   n : novel;
begin
   reset(novelFile);
   seek(novelFile, filesize(novelFile));
   loadRegister(n);
   while (n.code <> 0) do begin
      write(novelFile, n);
      loadRegister(n);
   end;
   close(novelFile);
end;

var
   textoFile : text;
   novelFile_ : novelFile;
   option : integer;
begin
   assign(textoFile, 'novelas.txt');
   assign(novelFile_, 'novelas');
   writeln('MENU');
   writeln('----');
   writeln('0. Salir');
   writeln('1. Cargar desde archivo de texto.');
   writeln('2. Modificar una novela existente.');
   writeln('3. Cargar nueva novela.');
   write('Seleccionar opcion: ');
   readln(option);
   case option of
      1 : fileLoad(novelFile_, textoFile);
      2 : modifyFile(novelFile_);
      3 : loadNovel(novelFile_);
   end;
   writeln('Ejecucion finalizada, presione cualquier tecla para continuar');
   readln;
end.
