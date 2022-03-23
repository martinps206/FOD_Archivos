program exerciseOne;
const
   tallValue = 9999;
type
   str = string[30];

   employee = record
      code : integer;
      name : str;
      commissionAmount : double;
   end;

   archivo = file of employee;

procedure readEmployee(var e : employee);
begin
   write('Ingrese codigo de empleado : ');
   readln(e.code);
   if(e.code <> 0) then begin
      write('Ingrese el nombe del empleado : ');
      readln(e.name);
      writeln('Ingrese el de comision : ');
      readln(e.commissionAmount);
   end;
end;

procedure createDetail(var employeeFile : archivo);
var
   e : employee;
begin
   rewrite(employeeFile);   //Creamos el archivo detalle empleado
   readEmployee(e);
   while (e.code <> 0) do begin
      write(employeeFile, e);
      readEmployee(e);
   end;
end;

procedure readFile(var employeeFile : archivo; var e : employee);
begin
   if (not eof(employeeFile))  then read(employeeFile, e)
   else e.code := tallValue;
end;

procedure compactFile(var masterFile : archivo; var detailFile : archivo);
var
   employeeMaster : employee;
   employeeDetail : employee;
begin
   reset(detailFile);
   rewrite(masterFile);
   readFile(detailFile, employeeDetail);
   while (employeeDetail.code < tallValue)  do begin
      employeeMaster.code := employeeDetail.code;
      employeeMaster.name := employeeDetail.name;
      employeeMaster.commissionAmount := 0;
      while (employeeMaster.code = employeeDetail.code) do begin
         employeeMaster.commissionAmount := employeeMaster.commissionAmount + employeeDetail.commissionAmount;
         readFile(detailFile, employeeDetail);
      end;
      write(masterFile, employeeMaster);
   end;
   close(masterFile);
   close(detailFile);
end;

procedure toPrint(var employeeFile : archivo);
var
   e : employee;
begin
   reset(employeeFile);
   while (not eof(employeeFile)) do begin
      read(employeeFile, e);
      writeln('codigo : ',e.code,' nombre : ',e.name,' comision : ',e.commissionAmount);
   end;
   close(employeeFile);
end;

var
   detailFile : archivo;
   masterFile : archivo;
   opcion : integer;
begin
   assign(detailFile, 'detalleEmplado');
   assign(masterFile, 'maestroEmpleado');
   writeln('1. Crear el archivo detalle.');
   writeln('2. Crear archivo maeestro.');
   writeln('0. Salir.');
   writeln('Ingrese una opcion:');
   read(opcion);
   while (opcion <> 0) do begin
      case (opcion) of
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
      writeln('1. Crear el archivo detalle.');
      writeln('2. Crear archivo maeestro.');
      writeln('0. Salir.');
      writeln('Ingrese una opcion:');
      read(opcion);
   end;
end.
