program ejercicio5;
type
   electrodomestico = record
      codigo : integer;
      nombre : string[10];
      descripcion : string[15];
      precio : double;
      stockMinimo : integer;
      stockDisponible : integer;
   end;

   archivo = file of electrodomestico;

procedure leerElectrodomestico(var e : electrodomestico);
begin
   writeln('Ingrese codigo de producto : ');
   readln(e.codigo);
   if(e.codigo <>0) then begin
      writeln('Ingrese el nombre del producto : ');
      readln(e.nombre);
      writeln('Ingrese la descripcion del producto : ');
      readln(e.descripcion);
      writeln('Ingrese el precio del producto : ');
      readln(e.precio);
      writeln('Ingrese el stock minimo : ');
      readln(e.stockMinimo);
      writeln('Ingrese el stock disponible : ');
      readln(e.stockDisponible);
   end;
end;

procedure CargarArchivoElectrodomestico(var archElectrodomestico : archivo);
var
   e : electrodomestico;
begin
   leerElectrodomestico(e);
   while(e.codigo <> 0) do begin
      write(archElectrodomestico, e);
      leerElectrodomestico(e);
   end;
end;

procedure exportarElectrodomestico(var archElectrodomestico : archivo; var archExporta : text);
var
   e : electrodomestico;
begin
   while (not eof(archElectrodomestico)) do begin
      read(archElectrodomestico, e);
      with e do begin
         writeln(archExporta,nombre);
         writeln(archExporta, 'CODIGO : ', codigo, ' NOMBRE : ', nombre, ' PRECIO : ', precio:5:4, ' STOCK MINIMO : ', stockDisponible);
      end;
   end;
end;

procedure exportarDiferenciaDeStock(var archElectrodomestico : archivo; var archExporta : text);
var
   e : electrodomestico;
begin
   while (not eof(archElectrodomestico)) do begin
      read(archElectrodomestico, e);
      with e do begin
         if (e.stockMinimo > e.stockDisponible) then begin
            writeln(archExporta,nombre);
            writeln(archExporta, 'CODIGO : ', codigo, ' NOMBRE : ', nombre, ' PRECIO : ', precio:5:4, ' STOCK MINIMO : ', stockDisponible);
         end;
      end;
   end;
end;

procedure agregarElectrodomestico(var archElectrodomestico : archivo);
var
   e : electrodomestico;
begin
   seek(archElectrodomestico, filesize(archElectrodomestico));
   leerElectrodomestico(e);
   while(e.codigo <> 0) do begin
      write(archElectrodomestico, e);
      leerElectrodomestico(e);
   end;
end;

procedure modificarStock(var archElectrodomestico : archivo);
var
   e : electrodomestico;
   nro, newnro : integer;
   ok : boolean;
begin
   ok := true;
   writeln('Ingrese el codigo del electrodomestico a modificar stock');
   readln(nro);
   while (nro <> 0) do begin
      while (not eof(archElectrodomestico) and ok) do read(archElectrodomestico, e);
      if(e.codigo = nro) then begin
         writeln('Ingrese el nuevo stock :');
         readln(newnro);
         e.codigo := newnro;
         seek(archElectrodomestico, filepos(archElectrodomestico) - 1);
         write(archElectrodomestico, e);
      end;
      writeln('Ingrese otro codigo de electrodomestico si desea modificar el stock. Presione 0 si desea salir :');
      readln(nro);
      seek(archElectrodomestico, 0);
   end;
end;

procedure exportarElectrodomesticoSinStock(var archElectrodomestico : archivo; var archExporta : text);
var
   e : electrodomestico;
begin
   while(not eof(archElectrodomestico)) do begin
      read(archElectrodomestico, e);
      if (e.stockDisponible = 0) then begin
         with e do begin
            writeln(archExporta, 'CODIGO : ', codigo,'NOMBRE : ', NOMBRE, ' PRECIO : ', precio:3:4, ' STOCK DISPONIBLE : ', stockDisponible);
            writeln();
         end;
      end;
   end;
end;

///////////PROGRAMA PRINCIPAL/////////////
var
   nombre, nombreaux : String;
   archElectrodomestico : archivo;
   opcion : integer;
   archExporta : text;
begin
   writeln('Ingrese el nombre del achivo : ');
   readln(nombre);
   assign(archElectrodomestico, nombre);
   rewrite(archElectrodomestico);
   writeln('Empezamos a cargar los datos de los electrodomesticos');
   CargarArchivoElectrodomestico(archElectrodomestico);
   close(archElectrodomestico);
   writeln('Finalizamos la carga al archivo electrodomesticos');

   writeln();
   writeln('ELECTRODOMESTICO');
   writeln('----------------');
   writeln('1. Exportar a un archivo de texto.');
   writeln('2. Exportar a un archivo de texto los de stock minimo.');
   writeln('3. Agregar un electrodomestico al archivo.');
   writeln('4. Modificar el stock de un producto.');
   writeln('5. Exportar un archivo sin stock de productos.');
   writeln('Ingrese una opcion a realizar : ');
   readln(opcion);

   while( opcion <> 0) do begin

      case (opcion) of
         1 : begin
                reset(archElectrodomestico);

                writeln('Ingrese el nombre del archivo para exportar : ');
                readln(nombreaux);
                assign(archExporta, nombreaux);
                rewrite(archExporta);

                writeln('Exportando el archivo');
                exportarElectrodomestico(archElectrodomestico, archExporta);
                writeln('Fin de la exportacion...');
                close(archExporta);
                close(archElectrodomestico);
             end;
         2 : begin
                reset(archElectrodomestico);

                writeln('Ingrese el nombre del archivo para exportar : ');
                readln(nombreaux);
                assign(archExporta, nombreaux);
                rewrite(archExporta);

                writeln('Exportando el archivo de Stockc');
                exportarDiferenciaDeStock(archElectrodomestico, archExporta);
                writeln('Fin de la exportacion...');
                close(archExporta);
                close(archElectrodomestico);
             end;
         3 : begin
                reset(archElectrodomestico);
                reset(archExporta);
                writeln('Ingrese el electrodomestico que desea agregar.');
                agregarElectrodomestico(archElectrodomestico);
                exportarElectrodomestico(archElectrodomestico, archExporta);
                close(archExporta);
                close(archElectrodomestico);
             end;
         4 : begin
                reset(archElectrodomestico);
                reset(archExporta);
                writeln('Ingrese los datos para modificar el stock.');
                modificarStock(archElectrodomestico);
                exportarElectrodomestico(archElectrodomestico, archExporta);
                close(archExporta);
                close(archElectrodomestico);
             end;
         5 : begin
                reset(archElectrodomestico);
                writeln('Ingrese el nombre del archivo para exportar : ');
                readln(nombreaux);
                assign(archExporta, nombreaux);
                rewrite(archExporta);
                exportarElectrodomesticoSinStock(archElectrodomestico, archExporta);
                close(archExporta);
                close(archElectrodomestico);
             end;
         else
         writeln('Opcion no valida.Ingrese 0 si desea Salir');
         readln(opcion);
      end;
      writeln('ELECTRODOMESTICO');
      writeln('----------------');
      writeln('1. Exportar a un archivo de texto.');
      writeln('2. Exportar a un archivo de texto los de stock minimo.');
      writeln('3. Agregar un electrodomestico al archivo .');
      writeln('4. Modificar el stock de un producto.');
      writeln('Desea realizar otra operacion. Presione 0 para salir...');
      readln(opcion);
   end;
   readln();
end.
