program asdasd;{Nota: Cambiar Nombre}

Const
tamNombre = 30;
CantMeses=12;

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

	TrVentasHistorico= record
		Anio:word;
		Mes:1..CantMeses;
		Num_Suc:word;
		Importe:real;
	end;

	taVentasHistorico= file of trVentasHistorico;

	taSucursal= file of trSucursal;

	taVentas= file of trVentas;

Var

ArSuc:taSucursal;{80 Ordenado por Num_Suc (ascendente), existe un reg para cada Num_Suc}
ArVentas:taVentas;{aprox 8000 Está ordenado en forma ascendente por Sucursal y Fecha}
ArVentasHistorico:taVentasHistorico;




{----------------------------------------Modulos----------------------------------------------------}

procedure LeerVentasHistorico (var ar:taVentasHistorico; var rec:trVentasHistorico; var fin:boolean);
	begin
	fin:=eof(ar);
	if not fin then
	read(ar,rec);
	end;

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

{---------------------PUNTO 1--------------------}

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

{------------PUNTO 2-------------------}


procedure TransformarVentas(var arVentas:taVentas; var arTransformarVentas:taVentasHistorico);

type
	tAuxFecha=string[4];
	tAuxFecha2=string[2];

Var
	rVentas:trVentas;
	rTransformarVentas:trVentasHistorico;
	rAux:trVentasHistorico;
        FinVentas:boolean;
        codigo:byte;
        AuxFecha:tAuxFecha;
        AuxFecha2:tAuxFecha2;
        AuxAnio:word;
        AuxMes:byte;

Begin
	reset(arVentas);
	rewrite(arTransformarVentas);
	LeerVentas(arVentas,rVentas,FinVentas);
	while not FinVentas do
	begin
		AuxFecha:=copy(rVentas.Fecha,1,4);
		val(AuxFecha,AuxAnio,codigo);
			if codigo=0 then
				rAux.Anio:=AuxAnio
			else writeln('Hubo un error al convertir año.');
		AuxFecha2:=copy(rVentas.Fecha,5,2);
		val(AuxFecha2,AuxMes,codigo);
			if codigo=0 then
				rAux.Mes:=AuxMes
			else writeln('Hubo un error al convertir mes.');
		rAux.Num_Suc:=rVentas.Sucursal;
		rAux.Importe:=rVentas.Importe;
		write(arTransformarVentas,rAux);
		LeerVentas(arVentas,rVentas,FinVentas);
	end;
	close(arVentas);
	close(arTransformarVentas);
end;




procedure Merge (var arTransformarVentas:taVentasHistorico; var arVentasHistorico:taVentasHistorico; var arHistoricoAux:taVentasHistorico);

var

rTransformarVentas,rVentasHistorico,rHistoricoAux: trVentasHistorico;
finTransformarVentas, finVentasHistorico: boolean;

begin
	reset(arTransformarVentas);
	reset(arVentasHistorico);
	rewrite(arHistoricoAux);
	LeerVentasHistorico(arTransformarVentas,rTransformarVentas,finTransformarVentas);
	LeerVentasHistorico(arVentasHistorico,rVentasHistorico,finVentasHistorico);
	while not finTransformarVentas and not finVentasHistorico do
		begin
		if (rTransformarVentas.Num_Suc<rVentasHistorico.Num_Suc) then
			begin
				write(arHistoricoAux,rTransformarVentas);
				LeerVentasHistorico(arTransformarVentas,rTransformarVentas,finTransformarVentas);
			end;
		if (rTransformarVentas.Num_Suc>rVentasHistorico.Num_Suc) then
			Begin
				write(arHistoricoAux,rVentasHistorico);
				LeerVentasHistorico(arVentasHistorico,rVentasHistorico,finVentasHistorico);
			end;
		if(rTransformarVentas.Num_Suc=rVentasHistorico.Num_Suc) then
			Begin
				if (rTransformarVentas.Anio<rVentasHistorico.Anio) then
					Begin
						write(arHistoricoAux,rTransformarVentas);
						LeerVentasHistorico(arTransformarVentas,rTransformarVentas,finTransformarVentas);
					end;
				if (rTransformarVentas.Anio>rVentasHistorico.Anio) then
					Begin
						write(arHistoricoAux,rVentasHistorico);
						LeerVentasHistorico(arVentasHistorico,rVentasHistorico,finVentasHistorico);
					end;
				if (rTransformarVentas.Anio=rVentasHistorico.Anio) then
					Begin
						if (rTransformarVentas.Mes<rVentasHistorico.Mes) then
						begin
							write(arHistoricoAux,rTransformarVentas);
							LeerVentasHistorico(arTransformarVentas,rTransformarVentas,finTransformarVentas);
						end;
						if (rTransformarVentas.Mes>rVentasHistorico.Mes) then
						Begin
							write(arHistoricoAux,rVentasHistorico);
							LeerVentasHistorico(arVentasHistorico,rVentasHistorico,finVentasHistorico);
						end;
						if (rTransformarVentas.Mes=rVentasHistorico.Mes) then
						begin
							write(arHistoricoAux,rTransformarVentas);
							LeerVentasHistorico(arTransformarVentas,rTransformarVentas,finTransformarVentas);
						end;
					end;
			end;
		end;
	while not finTransformarVentas do
		begin
			write(arHistoricoAux,rTransformarVentas);
			LeerVentasHistorico(arTransformarVentas,rTransformarVentas,finTransformarVentas);
		end;
	while not finVentasHistorico do
		begin
			write(arHistoricoAux,rVentasHistorico);
			LeerVentasHistorico(arVentasHistorico,rVentasHistorico,finVentasHistorico);
		end;
	close(arTransformarVentas);
	close(arVentasHistorico);
	close(arHistoricoAux);
	end;



procedure ActualizoHistorico(var arVentasHistorico:taVentasHistorico;var arHistoricoAux:taVentasHistorico);

var
	rHistoricoAux:trVentasHistorico;
	finHistoricoAux:boolean;

begin
	reset(arHistoricoAux);
	rewrite(arVentasHistorico);
	LeerVentasHistorico(arHistoricoAux,rHistoricoAux,finHistoricoAux);
	while not finHistoricoAux do
	begin
		write(arVentasHistorico,rHistoricoAux);
		LeerVentasHistorico(arHistoricoAux,rHistoricoAux,finHistoricoAux);
	end;
	close(arHistoricoAux);
	close(arVentasHistorico);
end;




procedure Actualizar (var ArVentasHistorico:taVentasHistorico; var ArVentas:taVentas);

Var

	ArTransformarVentas:taVentasHistorico;
	ArHistoricoAux:taVentasHistorico;

Begin
	Assign(arTransformarVentas,'C:/TransformarVentas.dat');
	Assign(arHistoricoAux,'C:/HistoricoAuxiliar.dat');
	TransformarVentas(arVentas,arTransformarVentas);
	Merge(arTransformarVentas,arVentasHistorico,ArHistoricoAux);
	ActualizoHistorico(arVentasHistorico,arHistoricoAux);
end;
{-----------------------------------------------4--------------------------------------------------------------------------------) 
actualizar el archivo SucMundo.dat
 insertando las sucursales argentinas. El archivo tiene el mismo formato de registro que el archivo SucursalesArg.
 El archivo actualizado debe quedar con el mismo orden que sucmundo

Asimo que archsucarg esta ordenado por num de suc, y que el arch suc mundo tmb, al hacer la carga de sucursales argentinas, el nº seria N+1 donde
N es el num de suc del ultimo registro del arch suc mun}
Procedure LecturaAdelantada(var Archivo:taSucursal;var Registro:trSucursal ;var Fin:boolean);
	
	Begin
		Fin:=(EOF(Archivo));
		if not fin then  read (Archivo,Registro);
	End;
	
Procedure ActualizarArchSucMun;

	 Var 
	 	RegSucMun,RegSucArg:trSucursal;
	 	Fin:boolean;
	 	ArchSucMun,ArchSucArg: taSucursal;

	 Begin
	 	assing(archSucMun,'c:\SucMun.dat');
	 	assing(ArchSucArg,'c\SucursalesArg.dat');
		reset(ArchSucArg);
		rewrite(archSucMun);

		while not (eof(archSucMun)) do
			Begin
				read(archSucMun,RegSucMun)
			end;
		leer(ArchSucArg,RegSucArg,Fin);
		while not fin do 
			Begin
				write(archSucMun,RegSucArg);
				leer(ArchSucArg,RegSucArg,Fin)
			end;
		close(archSucMun);
		close(archSucArg);

{-----------------------------------Programa Principal----------------------------------------------}
begin
	Assign(ArSuc,'C:\SucursalesArg.dat');
	Assign(ArVentas,'C:\VentasArg2015.dat');
	Assign(ArVentasHistorico,'C:\VentasHistoricas.dat');
	assing(archSucMun,'c:\SucMun.dat');
	MostrarTabla(ArVentas,ArSuc);
	Actualizar(ArVentasHistorico,ArVentas);
	ActualizarArchSucMun;
	readln();
end.
