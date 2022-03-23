program actualizar;
   type emp = record
      nombre: string[30];
      direccion: string[30];
      cht: integer;
   end;

   e_diario = record
      nombre: string[30];
      cht: integer;
   end;

   detalle = file of e_diario;
   maestro = file of emp;

var
   regm: emp;
   regd: e_diario;
   mae1: maestro;
   det1: detalle;

begin
   assign (mae1, 'maestro');
   assign (det1, 'detalle');
   reset (mae1);
   reset (det1);

   while (not eof(det1)) do begin
      read(mae1, regm);
      read(det1,regd);
        
      while (regm.nombre <> regd.nombre) do read(mae1,regm);

      regm.cht := regm.cht + regd.cht;
      seek (mae1, filepos(mae1)-1);
      write(mae1,regm);

   end;
   close(mae1);
   close(det1);
end.

