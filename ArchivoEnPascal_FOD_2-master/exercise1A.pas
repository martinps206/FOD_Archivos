program exerciseOneA;
const
   max := 9999;
type
   str = string[25];

   student = record;
      code : integer;
      name : str;
      score : integer;
   end;

   scoreFile = file of student;

procedure readStudent(var s : student);
begin
   writeln('Ingrese el codigo del alumno : ');
   readln(s.code);
   if(s.code <> 0) then begin
      writeln('Ingrese el nombre del alumno : ');
      readln(s.name);
      writeln('Ingrese la puntuacion del alumno : ');
      readln(s.score);
   end;
end;

procedure createDetail(var studentFile : scoreFile);
var
   s : student;
begin
   rewrite(studentFile);
   readStudent(s);
   while(s.code <> 0) do begin
      write(studentFile, s);
      readStudent(s);
   end;
end;

procedure readFile(var studentFile : scoreFile; var s : student);
begin
   if (not eof(studentFile)) then read(studentFile, s);
   else e.code := max;
end;

procedure compactFile(var detailFile : scoreFile, var masterFile : scoreFile);
var
   masterS : student;
   detailS : student;
begin
   reset(detailFile);
   rewrite(masterFile);
   readFile(detailFile, detailS);
   while (detailS.code < max) do begin
      masterS.code := detailS.code;
      masterS.name :=  detailS.name;
      masterS.score := 0;
      while (masterS.code = detailS.code) do begin
         masterS.score := masterS.score + detailS.score;
         readFile(detailFile, detailS);
      end;
      write(masterFile, masterS);
   end;
   close(detailFile);
   close(masterFile);
end;

procedure toPrint(var studentFile : scoreFile);
var
   s : student;
begin
   reset(studentFile);
   while (not eof(studentFile)) do begin
      read(studentFile, s);
      writeln('Codigo : ',s.code, ' Nombre : ', s.name, ' Puntuacion : ', s.score );
   end;
   close(studentFile);
end;

var
   detailFile : scoreFile;
   masterFile : scoreFile;
   option : integer;
begin
   assign(detailFile, 'detalleEstudiante');
   assign(masterFile, 'maestroEstudiante');
   writeln('0. Salir.');
   writeln('1. Crear el archivo detalle.');
   writeln('2. Crear el archivo maestro.');
   writeln('Ingrese la opcion');
   read(option);
   while (option <> 0) do begin
      case (option) of
         1 : begin
                createDetail(detailFile);
                toPrint(detailFile);
             end;
         2 : begin
                compactFile(masterFile, detailFile);
                toPrint(masterFile);
             end;
             else writeln('La opcion no es valida...');
      end;
      writeln('0. Salir.');
      writeln('1. Crear el archivo detalle.');
      writeln('2. Crear el archivo maestro.');
      writeln('Ingrese la opcion');
      read(option);
   while (option <> 0) do begin
      case (option) of
   end;
end.
