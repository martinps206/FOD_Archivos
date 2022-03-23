program exerciseSix;
const
   tallValue = 9999;
type
   years = 2000..2020;
   months = 1..12;
   days = 1..31;
   str = string[20];

   monthAmount = array[month] of integer;

   clienteRegister = record
      code : integer;
      name : str;
   end;

   sales = record
      client : clientRegister;
      monthAmount : monthAmount;
      yearTotal : integer;
   end;

   registerMaster = record
      client : clientRegister;
      year : years;
      month : months;
      day : days;
      amount : amount;
   end;

   masterFile = file of registerMaster;

procedure inicializeMonth(var s : sales);
var
   i : integer;
begin
   for i := 1 to 12 do v.month[i] := 0;
end;

procedure readMaster(var masterFile : masterFile; var r : registerMaster);
begin
   if (not eof(masterFile)) then read(masterFile, r)
   else r.clienteRegister.code := tallValue;
end;

procedure toString(v : sales; year : years);
var
   i : integer;
begin
   with v do begin
      writeln('Codigo cliente : ', client.code);
      writeln('Nombre : ', client.name);
      for i := 1 to 12 do begin
         if(monthAmount[i] = 0) then writeln('El cliente no compro nada en el mes ', i);
         else writeln('Monto gastado en el mes ', i, ' : ', monthAmount[i]);
      end;
      writeln('Total comprado en el anio ',year,': ',yearTotal);
   end;
   writeln();
end;

procedure llenarCliente(var v : sales ; r : registerMaster);
begin
   v.clienteRegister.code := r.clienteRegister.code;
   v.clienteRegister.name := r.clienteRegister.name;
end;

var
   masterFile : masterFile;
   r : registerMaster;
   name : str;
   sale : sales;
   codeAct : integer; yearAct : years; monthAct : months; total : integer;
begin

end.
