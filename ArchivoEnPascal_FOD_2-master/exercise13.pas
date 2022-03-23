program exerciseThirteen;
const
   tallValue = 999999;
type
   rango = 1..500;
   str6 = string[6];
   str20 = string[20];

   detailReg = record //Rapipago
      dni : integer;
      code : str6;
      feeAmount : integer;
   end;

   masterReg = record  //Archivo existente en la facultad
      dni : integer;
      code : str6;
      totalAmount : integer;
   end;

   masterFile = file of masterReg;  //es el archivo con los registrso de la facultad
   detailFile = file of detailReg;  //sera el archivo con los registros de cada sucursal de RapiPago

   detailRegisterVector = array[rango] of detailReg;  //es el vector de registros de rapipago
   detailFileVector = array[rango] of detailFile;    //es el vector de archivos de RapiPago

//////////////////Procedimientos////////////////////////
procedure leer(var detailFile : detailFile; var d : detailReg);
begin
   if(not eof(detailFile)) then read(detailFile, d)
   else d.dni := tallValue;
end;

procedure minimo(var detailFileVector : detailFileVector; var detailRegisterVector : detailRegisterVector; var min : detailReg; N : integer);
var
   i : integer;
   aux : detailReg;
   posMin : integer;
begin
   aux.dni := tallValue;
   posMin :=  -1;

   for i := 1 to N do begin
      if (detailRegisterVector[i].dni < aux.dni) then begin
         aux := detailRegisterVector[i];
         posMin := i;
      end;
   end;
   if (posMin <> -1) then begin
      min := aux;
      leer(detailFileVector[posMin], detailRegisterVector[posMin]);
   end
   else  min.dni := tallValue;
end;

procedure actualize(var masterFile : masterFile; var detailFileVector : detailFileVector; var detailRegisterVector : detailRegisterVector; N : integer);
var
   m : masterReg;
   min : detailReg;
   i : integer;
   dniAct : integer; codeAct : str6; feeAct : integer;
begin
   reset(masterFile);
   for i:= 1 to N do begin
      reset(detailFileVector[i]);
      leer(detailFileVector[i], detailRegisterVector[i]);
   end;
   minimo(detailFileVector, detailRegisterVector, min, N);
   read(masterFile, m);
   while (min.dni <> tallValue) do begin
      while (m.dni <> min.dni) do begin
         if(not eof(masterFile)) then read(masterFile, m);
      end;
      dniAct := min.dni;
      while (dniAct = min.dni) do begin
         codeAct := min.code;
         feeAct := 0;
         while (dniAct = min.dni) and (codeAct = min.code) do begin
            feeAct := feeAct + min.feeAmount;
            minimo(detailFileVector, detailRegisterVector, min, N);
         end;
         m.totalAmount := m.totalAmount + feeAct;
         seek(masterFile, filePos(masterFile) - 1);
         write(masterFile, m);
         read(masterFile, m);
      end;
   end;
   close(masterFile);
   for i := 1 to N do begin
      close(detailFileVector[i]);
   end;
end;

procedure morosos(var masterFile : masterFile; var texto : text);
var
   m : masterReg;
begin
   reset(masterFile);
   rewrite(texto);
   while (not eof(masterFile)) do begin
      read(masterFile, m);
      if (m.totalAmount = 0) then writeln(texto, ' ', m.dni, ' ', m.code, ' ', ' Alumno moroso');
   end;
   close(texto);
   close(masterFile);
end;

procedure detailToPrint(m : masterReg);
begin
   with m do begin
      writeln('Dni del alumno : ', dni);
      writeln('Codigo de baucher de carrera : ', code);
      writeln('Monto total pagado : ', totalAmount);
   end;
   writeln();
end;

procedure masterToPrint(var masterFile : masterFile);
var
   m : masterReg;
begin
   reset(masterFile);
   while(not eof(masterFile)) do begin
      read(masterFile, m);
      detailToPrint(m);
   end;
   close(masterFile);
end;

var

   masterFile_ : masterFile;
   detailFileVector_ : detailFileVector;
   detailRegistervector_ : detailRegisterVector;
   textFile : text;
   name_, num : str20;
   i, n, opcion : integer;
begin
   writeln('Nombre del archivo maestro a procesar : ');
   readln(name_);
   assign(masterFile_, name_);
   writeln('Ingrese la cantidad de archivos detalle : ');
   readln(n);
   for i:= 1 to n do begin
      Str(i, num);
      assign(detailFileVector_[i], 'detalles-'+num);
   end;
   writeln('1. Actualizar datos del alumno.');
   writeln('2. Listar en un archivo texto los alumnos que no pagaron.');
   writeln('3. Mostrar archivo maestro.');
   writeln('4. Salir.');
   writeln('Opcion');
   readln(opcion);
   case opcion of
      1: actualize(masterFile_, detailFileVector_, detailRegisterVector_, n);
      2: begin
            writeln('Nombre del archivo de texto que almacenara los datos');
            readln(name_);
            assign(textFile, name_);
            morosos(masterFile_, textFile);
         end;
      3: masterToPrint(masterFile_);
   end;
   writeln('FIN DEL PROGRAMA');
   readln();
end.
