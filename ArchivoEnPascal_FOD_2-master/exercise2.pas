program exerciseTwo;
const
   tallValue = 99999999;
type
   str = string[30];

   student = record
      code : integer;
      name : str;
      approved : integer;
      notApproved : integer;
   end;

   studentDetail = record
      code : integer;
      approved : integer;
   end;

   archivo = file of student;
   archivoDetail = file of studentDetail;

///////// Crear archivo maestro //////////////////

procedure readFileMaster(var textStudent : text; var a : student);
begin
   if (not eof(textStudent))  then read(textStudent, a.code, a.name, a.approved, a.notApproved)
   else e.code := tallValue;
end;

procedure masterCreate(var masterFile : archivo);
var
   textStudent : text;
   a : student;
   auxName : string;
begin
   writeln('Ingrese nombre para el archivo : ');
   readln(auxName);
   assign(masterfile, auxName);
   rewrite(masterFile);

   assign(textStudent, 'student.txt');
   reset(textStudent);
   readFileMaster(textStudent, a);
   while (a.code < tallValue) do begin
      write(masterFile, a);
      readFileMaster(textStudent, a);
   end;
   writeln('El archivo fue creado...');
   close(textStudent);
   close(masteFile);
end;

procedure toPrintMaster(var masterFile : archivo);
var
   s : student;
   textMasterFile : text;
begin
   assign(textMasterFile, 'reporteAlumnos.txt');
   reset(masterFile);
   rewrite(textMasterFile);
   while (not eof(masterFile)) do begin
      read(masterFile, s);
      writeln(textMasterFile, 'Codigo de alumno : ', s.code, ' Nombre del alumno : ', s.name);
      writeln(textMasterFile, 'Cantidad de cursos aprobados : ', s.approved, ' Cantidad de curso sin final : ', s.notApproved);
   end;
   close(textMasterFile);
   close(masterFile);
end;

////////////  crear archivo detalle ///////////

procedure readFileDetail(var textStudentDetail : text; var a : studentDetail);
begin
   if (not eof(textStudentDetail))  then read(textStudentDetail, a.code, a.approved)
   else a.code := tallValue;
end;

procedure detailCreate(var detailFile : archivoDetail);
var
   textStudentDetail : text;
   a : student;
   auxName : string;
begin
   writeln('Ingrese nombre para el archivo : ');
   readln(auxName);
   assign(detailFile, auxName);
   rewrite(detailFile);

   assign(textStudentDetail, 'detail.txt');
   reset(textStudentDetail);
   readFileDetail(textStudentDetail, a);
   while (a.code < tallValue) do begin
      write(detailFile, a);
      readFileDetail(textStudentDetail, a);
   end;
   writeln('El archivo fue creado...');
   close(detailFile);
   close(textStudentDetail);
end;

procedure toPrintDetail(var detailFile : archivoDetail);
var
   s : student;
   textDetailFile : text;
begin
   assign(textDetailFile, 'reporteAlumnos.txt');
   reset(masterFile);
   rewrite(textDetailrFile);
   while (not eof(masterFile)) do begin
      read(masterFile, s);
      writeln(textDetailFile, 'Codigo de alumno : ', s.code, ' Aprobo el final', s.approved);
   end;
   close(textDetailFile);
   close(masterFile);
end;

///////////////// Actualizar el archivo maestro //////////////////7

procedure readFile(var detailFile : archivoDetail; var a : studentDetail);
begin
   if (not eof(detailFile)) then read(detailFile, a)
   else a.code := tallValue;
end;

procedure actualizeMaster(var masterFile : archivo; var detailFile : archivoDetail);
var
   s : student;
   a : studentDetail;
   aux : integer;
begin
   reset(masterFile);
   reset(detailFile);
   readFile(detailFile, a);
   read(masterFile, s);
   while (a.code <> tallValue) do begin
      while (s.code <> a.code) do read(masterFile, s);
      aux := a.code;
      writeln(aux);
      while (a.code = aux and g.code <> tallValue) do begin
         if (a.approved = 1) then s.approved := s.approved + 1;
         else  s.approved := s.approved +1;
      end;
      seek(masterfile, filepos(masterFile)-1);
      write(masterFile, s);
   end;
   close(masterFile);
   close(detailFile);
end;


