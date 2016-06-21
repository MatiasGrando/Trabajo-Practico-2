program CargarArchivos;

Type
	cantArch= (VentasHistorico,SucursalesArg,Clientes,Ventas);
	trVentasHistorico= record
		Anio:byte;
		Mes:byte;
		Num_Sucursal:word;
		Importe:real;
	end;
	trSucursalesArg= record 
		Num_Sucursal:word;
		Nombre:string[30];
		Pais:string[50];
		Direccion:string[50];
		Telefono:string[20];
	end;
	trClientes= record
		Num_Cliente:word;
		Nombre:string[30];
		Provincia:string[50];
		Localidad:string[50];
		Direccion:string[50];
	end;
	trVentas= record
		Num_Cliente:word;
		Sucursal:word;
		Articulo:longword;
		Cantidad:word;
		Importe:real;
	end;
	taVentasHist= file of trVentasHistorico;
	taSucursalesArg= file of trSucursalesArg;
	taClientes= file of trClientes;
	taVentas= file of trVentas;
	tvCargados= array [cantArch] of boolean;
Var
	avHist:taVentasHist;
	aVen:taVentas;
	asArg:taSucursalesArg;
	aClie:taClientes;
	opcion:integer;
	vCargados:tvCargados;
{---------Modulos-------}

procedure CargarVentas(var arch:taVentas; var vec:tvCargados);
	var
	auxreg:trVentas;
	opcion:byte;
	{variables dentro del registro (auxiliares)}
		aNum_Cliente:word;
		aSucursal:word;
		aArticulo:longword;
		aCantidad:word;
		aImporte:real;
	begin
	rewrite(arch);
	writeln('Ingrese 1 para agregar nuevos registros, 0 para salir');
	readln(opcion);
	while (opcion <> 0) do
	begin
		vec[Ventas]:= true;
		writeln('Ingrese Numero de Cliente');
		readln(aNum_Cliente);
		writeln('Ingrese Sucursal');
		readln(aSucursal);
		writeln('Ingrese Articulo');
		readln(aArticulo);
		writeln('Ingrese Cantidad');
		readln(aCantidad);
		writeln('Ingrese Importe');
		readln(aImporte);
		with auxreg do
		begin
			Num_Cliente:= aNum_Cliente;
			Sucursal:=aSucursal;
			Articulo:=aArticulo;
			Cantidad:=aCantidad;
			Importe:=aImporte;
		end;
		write(arch,auxreg);
		writeln('Ingrese 1 para agregar nuevos registros, 0 para salir');
	end;
	close(arch);
	end;

procedure CargarClientes(var arch:taClientes; var vec:tvCargados);
	var
	auxreg:trClientes;
	opcion:byte;
	{variables dentro del registro (auxiliares)}
		aNum_Cliente:word;
		aNombre:string[30];
		aProvincia:string[50];
		aLocalidad:string[50];
		aDireccion:string[50];
	begin
	rewrite(arch);
	writeln('Ingrese 1 para agregar nuevos registros, 0 para salir');
	readln(opcion);
	while (opcion <> 0) do
	begin
		vec[Clientes]:= true;
		writeln('Ingrese Numero de Cliente');
		readln(aNum_Cliente);
		writeln('Ingrese Nombre');
		readln(aNombre);
		writeln('Ingrese Provincia');
		readln(aProvincia);
		writeln('Ingrese Localidad');
		readln(aLocalidad);
		writeln('Ingrese Direccion');
		readln(aDireccion);
		with auxreg do
		begin
			Num_Cliente:= aNum_Cliente;
			Nombre:=aNombre;
			Provincia:=aProvincia;
			Direccion:=aDireccion;
			Localidad:=aLocalidad;
		end;
		write(arch,auxreg);
		writeln('Ingrese 1 para agregar nuevos registros, 0 para salir');
	end;
	close(arch);
	end;

procedure CargarSucArg(var arch:taSucursalesArg; var vec:tvCargados);
	var
	ArchSucMundo:taSucursalesArg;
	RegSucMundo:trSucursalesArg;
	auxreg:trSucursalesArg;
	opcion:byte;
	{variables dentro del registro (auxiliares)}
		aNum_Sucursal:word;
		aNombre:string[30];
		aPais:string[50];
		aDireccion:string[50];
		aTelefono:string[20];
	begin
	assign(ArchSucMundo,'c:\SucMundo.dat');
	reset(SucMundo);
	while not eof do
		begin
			readln(ArchSucMundo,RegSucMundo)
		end;
	NumeroUltimaSuc:= RegSucMundo.Num_Sucursal ;
	close(ArchSucMundo);
	rewrite(arch);
	writeln('Ingrese 1 para agregar nuevos registros, 0 para salir');
	readln(opcion);
	while (opcion <> 0) do
	begin
		vec[SucursalesArg]:= true;
		
		aNum_Sucursal:=(NumeroUltimaSuc+1);
		NumeroUltimaSuc:=(NumeroUltimaSuc+1);


		writeln('Ingrese Nombre');
		readln(aNombre);
		writeln('Ingrese Pais');
		readln(aPais);
		writeln('Ingrese Direccion');
		readln(aDireccion);
		writeln('Ingrese Telefono');
		readln(aTelefono);
		with auxreg do
		begin
			Num_Sucursal:= aNum_Sucursal;
			Nombre:=aNombre;
			Pais:=aPais;
			Direccion:=aDireccion;
			Telefono:=aTelefono
		end;
		write(arch,auxreg);
		writeln('Ingrese 1 para agregar nuevos registros, 0 para salir');
	end;
	close(arch);
	end;

procedure CargarVentasHist(var arch:taVentasHist; var vec:tvCargados);
	var
	auxreg:trVentasHistorico;
	opcion:byte;
	{variables dentro del registro (auxiliares)}
		aAnio:byte;
		aMes:byte;
		aNum_Sucursal:word;
		aImporte:real;
	begin
	rewrite(arch);
	writeln('Ingrese 1 para agregar nuevos registros, 0 para salir');
	readln(opcion);
	while (opcion <> 0) do
	begin
		vec[VentasHistorico]:= true;
		writeln('Ingrese Año');
		readln(aAnio);
		writeln('Ingrese Mes');
		readln(aMes);
		writeln('Ingrese Numero de Sucursal');
		readln(aNum_Sucursal);
		writeln('Ingrese Importe');
		readln(aImporte);
		with auxreg do
		begin
			Anio:= aAnio;
			Mes:=aMes;
			Num_Sucursal:=aNum_Sucursal;
			Importe:=aImporte;
		end;
		write(arch,auxreg);
		writeln('Ingrese 1 para agregar nuevos registros, 0 para salir');
	end;
	close(arch);
	end;
procedure MostrarCargados(vec:tvCargados);
	var
	i:cantArch;
	cargado:boolean;

	begin
	cargado:= false;
	write('Usted ha cargado:');
	for i:=VentasHistorico to Ventas do
		if vec[i] then
			case i of
			VentasHistorico:
			begin
			write(' Ventas Historico');
			cargado:= true;
			end;
			SucursalesArg:
			begin
			write(' Sucursales Argentina');
			cargado:= true;
			end;
			Clientes:
			begin
			write(' Clientes');
			cargado:= true;
			end;
			Ventas:
			begin
			write(' Ventas');
			cargado:= true;
			end;
		end;
	if not cargado then
	write(' ningun archivo');
	end;

procedure inivec(vec:tvCargados);
var
i:cantArch;	

	begin
	for i:=VentasHistorico to Ventas do
	vec[i]:=false;
	end;

{-------Programa---------}
begin
	Assign(avHist,'C:\VentasHist.dat');
	Assign(aVen,'C:\Ventas.dat');
	Assign(aClie,'C:\Clientes.dat');
	Assign(asArg,'C:\SucursalesArg.dat');
	inivec(vCargados);
	repeat
		begin
		write('A continuacion ingrese 1 para cargar el archivo de Ventas Historico,');
		write('2 para cargar Sucursales de Argentina, 3 para cargar Clientes, 4 para');
		write('cargar Ventas, 5 para ver cuales ya fueron cargados y 0 para salir');
		writeln();
		readln(opcion);
		case opcion of
			1:CargarVentasHist(avHist,vCargados);
			2:CargarSucArg(asArg,vCargados);
			3:CargarClientes(aClie,vCargados);
			4:CargarVentas(aVen,vCargados);
			5:MostrarCargados(vCargados);
		end;
		end;
		until opcion = 0;
end.




