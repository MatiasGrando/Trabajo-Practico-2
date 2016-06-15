program asdasd;{Nota: Cambiar Nombre}

Const
tamNombre = 30;

Type
	tMes=(Ene, Feb, Mar, Abr, May, Jun, Jul, Ago, Sep, Oct, Nov, Dic);
	trVentas= record
		Fecha:string[8];{AAAAMMDD}
		Num_Cliente:word;
		Sucursal:word;
		Articulo:longword;
		Cantidad:word;
		importe:real;
	end;
	trSucursal= record
		Num_Suc:word;
		Nombre:string[tamNombre];
		Pais:string[50];
		Direccion:string[50];
		Telefono:string[20];
	end;
taSucursal= file of trSucursal;
taVentas= file of trVentas;

Var
ArSuc:taSucursal;{80 Ordenado por Num_Suc (ascendente), existe un reg para cada Num_Suc}
ArVentas:taVentas;{aprox 8000 Está ordenado en forma ascendente por Sucursal y Fecha}

{----------------------------------------Modulos----------------------------------------------------}
procedure LeerSuc(var Ar:taSucursal;var Suc:trSucursal;var fin:boolean);{Lectura adelantada de sucursal}
	begin
	fin:=eof(Ar);
	if not fin then
	read(Ar,Suc);
	end;

procedure LeerVentas(var Ar:taVentas;var Ven:trVentas;var fin:boolean);{Lectura adelantada de ventas}
	begin
	fin:=eof(Ar);
	if not fin then
	read(Ar,Ven);
	end;


procedure MostrarTabla(var ArV:taVentas; var ArS:taSucursal);{Arma la tabla}

var
i:byte;
j:tMes;
fin:boolean;
Suc:trSucursal;

	procedure corteControl(var Ar:taVentas;Suc:trSucursal);{Corte de control local}
	Type
	tvVentasMes= array[1..12] of word;
	var
	i:byte;
	fin:boolean;
	Ven:trVentas;
	MesN:string[2];
	aux:string;
	Mes:byte;
	vMes:tvVentasMes;
	cod:integer;

	begin
	Mes:=0;
	for i:=1 to 12 do
		vMes[i]:= 0;
	LeerVentas(ArV,Ven,fin);
	write(Suc.Nombre);
	for i:=1 to (length(Suc.Nombre)-tamNombre) do
	write(' ');
	while not fin and (Ven.Sucursal = Suc.Num_Suc) do
	begin
		MesN:=copy(Ven.Fecha,5,2); {Busco la fecha en el registro de venta y la convierte a numero}
		val(MesN,Mes,cod);
		vMes[Mes]:= vMes[Mes] + Ven.Cantidad;
		LeerVentas(ArV,Ven,fin)
	end;
	for i:=1 to 12 do
		begin
		str(vMes[i],aux);
		write(aux+' ');
		end;
	writeln();
	end;

begin
	reset(ArV);
	reset(ArS);
	for i:=1 to tamNombre do
		write(' ');
	for j:=Ene to Dic do
	 case j of
	 Ene:write('Ene ');
	 Feb:write('Feb ');
	 Mar:write('Mar ');
	 Abr:write('Abr ');
	 May:write('May ');
	 Jun:write('Jun ');
	 Jul:write('Jul ');
	 Ago:write('Ago ');
	 Sep:write('Sep ');
	 Oct:write('Oct ');
	 Nov:write('Nov ');
	 else
	 	write('Dic ')
	 end;
	 writeln();
	 LeerSuc(ArS,Suc,fin);
	 while not fin do
	 begin
	 	corteControl(ArV,Suc);
	 	LeerSuc(ArS,Suc,fin);
	 end;
	 close(ArS);
	 close(ArV);
end;


{-----------------------------------Programa Principal----------------------------------------------}
begin
	Assign(ArSuc,'C:/SucursalesArg.dat');
	Assign(ArVentas,'C:/VentasArg2015.dat');
	MostrarTabla(ArVentas,ArSuc);
	readln();
end.
