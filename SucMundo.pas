program CargarSucArg;
	
	type
	
	trSucursalesArg= record
		Num_Sucursal:word;
		Nombre:string[30];
		Pais:string[50];
		Direccion:string[50];
		Telefono:string[20];
                end;
        tasucursalesarg  = file of trsucursalesarg;
	
	var
	
	ArchSucMundo:taSucursalesArg;
	RegSucMundo:trSucursalesArg;
		aNum_Sucursal:word;
		aNombre:string[30];
		aPais:string[50];
		aDireccion:string[50];
		aTelefono:string[20];
		opcion:byte;
	
	begin
	
	assign(ArchSucMundo,'C:\TP\sucmundo.dat');
	rewrite(archSucMundo);
	writeln('Ingrese 1 para agregar nuevos registros, 0 para salir');
	readln(opcion);
	while (opcion <> 0) do
	begin
		writeln('ingrese num de suc');
        readln(anum_sucursal);
		writeln('Ingrese Nombre');
		readln(aNombre);
		writeln('Ingrese Pais');
		readln(aPais);
		writeln('Ingrese Direccion');
		readln(aDireccion);
		writeln('Ingrese Telefono');
		readln(aTelefono);
		with regsucmundo do
		begin
			Num_Sucursal:= aNum_Sucursal;
			Nombre:=aNombre;
			Pais:=aPais;
			Direccion:=aDireccion;
			Telefono:=aTelefono
		end;
		write(archsucmundo,regsucmundo);
		writeln('Ingrese 1 para agregar nuevos registros, 0 para salir');
                readln(opcion);

	end;
	close(archsucmundo);
	end.
