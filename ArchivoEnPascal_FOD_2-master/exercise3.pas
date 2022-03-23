program exerciseThree;
uses
   sysutils;
const
   tallValue = 9999;
   dimF = 4;
type
   product = record
      code : integer;
      description : string;
      price : double;
      actualStock : integer;
      minimumStock : integer;
   end;

   orders = record
      code : integer;
      quantity : integer;
   end;

   masterFile = file of product;
   detailFile = file of orders;
   detailFileVector = array[1..dimF] of file of orders;
   detailRegisterVector = array[1..dimF] of orders;


procedure readOrders(var o : orders);
begin
   writeln('Ingrese el codigo del producto para su pedido :');
   readln(o.code);
   if (o.code <> 0) then begin
      writeln('Ingrese cantidad pedida :');
      readln(o.quantity);
   end;
end;

procedure createDetail(var ordersFile : detailFile);
var
   o : orders;
begin
   rewrite(ordersFile);
   readOrders(o);
   while(o.code <> 0) do begin
      write(ordersFile, o);
      readOrders(o);
   end;
end;

procedure readProduct(var p : product);
begin
   writeln('Ingrese el codigo del producto :');
   readln(p.code);
   if (p.code <> 0) then begin
      writeln('Ingrese un descripcion del producto :');
      readln(p.description);
      writeln('Ingrese el precio del producto :');
      readln(p.price);
      writeln('Ingrese el stock actual :');
      readln(p.actualStock);
      writeln('Ingrese el stock minimo :');
      readln(p.minimumStock);
   end;
end;

procedure createMaster(var productFile : masterFile);
var
   p : product;
begin
   rewrite(productFile);
   readProduct(p);
   while(p.code <> 0) do begin
      write(productFile, p);
      readProduct(p);
   end;
end;


//----------------------------------------------------------------------//
procedure readDetail(var detailFile : detailFile; var o : orders);
begin
   if (not eof(detailFile)) then read(detailFile, o)
   else o.code := tallValue;
end;

procedure minimum(var detailFilevector : detailFileVector; var detailRegisterVector : detailRegisterVector; var min : orders; var posMin : integer);
var
   i : integer;
   codMin : integer;
begin
   codMin := 99999;
   for i:= 1 to dimF do
      if (detailRegisterVector[i].code < codMin) then begin
         codMin := detailRegisterVector[i].code;
         posMin := i;
      end;
   min := detailRegisterVector[posMin];
   readDetail(detailFileVector[posMin], detailRegisterVector[posMin]);
end;

procedure updateMaster(var masterFile : masterFile; var detailFileVector : detailFileVector);
var
   min : orders;
   p : product;
   detailRegisterVector : detailRegisterVector;
   codeActual : integer;
   cantRequired : integer;
   branchOffice : integer;
   i : integer;
   difference : integer;
begin
   for i := 1 to dimF do begin
      reset(detailFileVector[i]);
      readDetail(detailFileVector[i], detailRegisterVector[i]);
   end;
   reset(masterFile);
   read(masterFile, p);
   minimum(detailFileVector, detailRegisterVector, min, branchOffice);
   while (min.code < tallValue) do begin
      codeActual := min.code;
      cantRequired := 0;
      while (codeActual = min.code) do begin
         cantRequired := cantRequired + min.quantity;
         minimum(detailFileVector, detailRegisterVector, min, branchOffice);
      end;
      while (p.code <> codeActual) do read(masterFile, p);
      difference := cantRequired - p.actualStock;
      if (difference > 0) then begin
         p.actualStock := 0;
         writeln('No se pudo satisfacer el pedido de la sucursal : ',branchOffice, ' codigo del producto : ', codeActual, ' La cantidad que no pudo ser enviada es : ', difference);
      end
      else begin
         p.actualStock := p.actualStock - cantRequired;
         if (p.actualStock < p.actualStock) then writeln('El pedido se envio. El stock dep producto quedo por debajo del minimo...')
         else writeln('El pedido se envio correctamente...');
      end;
      seek(masterFile, filepos(masterFile)-1);
      write(masterFile, p);
      if (not eof(masterFile)) then read(masterFile, p);
   end;
   close(masterFile);
   for i := 1 to dimF do close(detailFileVector[i]);
end;

var
   i : integer;
   detailFileVector_ : detailFileVector;
   masterFile_ : masterFile;
begin
   for i := 1 to dimF do assign (detailFileVector_[i], 'det'+IntToStr(i));
   assign(masterFile_, 'archivoMaestro');
   updateMaster(masterFile_, detailFileVector_);
   readln;
end.
