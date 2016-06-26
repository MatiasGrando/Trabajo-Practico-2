program Empresa_Multinacional;

Const
tamNombre = 30;
CantMeses=12;

Type
	tMes=(Ene, Feb, Mar, Abr, May, Jun, Jul, Ago, Sep, Oct, Nov, Dic);

	trVentas= record
		Fecha:string[8];
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

ArSuc:taSucursal;
ArVentas:taVentas;
ArVentasHistorico:taVentasHistorico;


{----------------------------------------Modulos----------------------------------------------------}


procedure LeerVentasHistorico (var ar:taVentasHistorico; var rec:trVentasHistorico; var fin:boolean);
	begin
	fin:=eof(ar);
	if not fin then
	read(ar,rec);
	end;

procedure LeerSuc(var Ar:taSucursal;var Suc:trSucursal;var fin:boolean);
	begin
	fin:=eof(Ar);
	if not fin then
	read(Ar,Suc);
	end;

procedure LeerVentas(var Ar:taVentas;var Ven:trVentas;var fin:boolean);
	begin
	fin:=eof(Ar);
	if not fin then
	read(Ar,Ven);
	end;


{---------------------PUNTO 1--------------------}


procedure MostrarTabla(var ArV:taVentas; var ArS:taSucursal);

var
i:byte;
j:tMes;
fin:boolean;
Suc:trSucursal;

	procedure corteControl(var Ar:taVentas;Suc:trSucursal);
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
	for i:=1 to (tamNombre  - length(Suc.Nombre)) do
	write(' ');
        repeat
          if (Ven.Sucursal = Suc.Num_Suc) then
                  begin
		        MesN:=copy(Ven.Fecha,5,2);
                        val(MesN,Mes,cod);
                        vMes[Mes]:=Ven.Cantidad;
                end;
          LeerVentas(ArV,Ven,fin);
        until fin;
	for i:=1 to 12 do
		begin
		str(vMes[i],aux);
		write(aux,'   ');
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
	Assign(arTransformarVentas,'C:\TP\TransformarVentas.dat');
	Assign(arHistoricoAux,'C:\TP\HistoricoAuxiliar.dat');
	TransformarVentas(arVentas,arTransformarVentas);
	Merge(arTransformarVentas,arVentasHistorico,ArHistoricoAux);
	ActualizoHistorico(arVentasHistorico,arHistoricoAux);
end;


{-----------------------------------------PUNTO 3-----------------------------------------------------------------------}


procedure Clientes;

Const
tamProvLoca = 50;

Type

TrClientes= record
		Num_Cli:Longint;
		Nombre:String[30];
		Provincia:String[50];
		Localidad:String[50];
		Direccion:String[50];
	end;

TaClientes = file of trClientes;

Var

ArCli:taClientes;
ArTotCli:Text;


procedure LeerClientes(var Ar:taClientes;var Cli:trClientes;var fin:boolean);
	begin
	fin:=eof(Ar);
	if not fin then
	read(Ar,Cli);
	end;


procedure GenerarTotCli (var ArCli:taClientes; var ArTotCli:text);

Type
Cad50=String[50];

Var
Clientes:TrClientes;
fin:boolean;
primero:boolean;
ContProv:longint;
ContLoca:longint;
ContClien:longint;
ProvAnt:Cad50;
LocaAnt:Cad50;

	Procedure GuardaProvincia(var ArTotCli:text; var ProvAnt:Cad50; var ContProv:longint; Clientes:TrClientes);

	Var
	i:byte;
	Begin
	Write(ArTotCli, ProvAnt);
	for i:=1 to (tamProvLoca-length(ProvAnt)) do
		write(ArTotCli,' ');
	Writeln(ArTotCli, ContProv);
	ContProv:=0;
	ProvAnt:=Clientes.Provincia;
	End;

	Procedure GuardaLocalidad(var ArTotCli:text; var LocaAnt:Cad50; var ContLoca:longint; Clientes:TrClientes);
	Var
	i:byte;

	Begin
	Write(ArTotCli, LocaAnt);
	for i:=1 to (tamProvLoca-length(LocaAnt)) do
		write(ArTotCli,' ');
	Writeln(ArTotCli, ContLoca);
	ContLoca:=0;
	LocaAnt:=Clientes.Localidad;
	End;

	Procedure GuardaClientes(var ArTotCli:text; var ContClien:longint);
	Begin
	Write(ArTotCli, 'Clientes totales:');
	Writeln(ArTotCli, ContClien);
	ContClien:=0;
	End;

	Procedure CargaTotCli(var ArTotCli:Text; var Clientes:TrClientes; var ContProv, ContLoca, ContClien:longint; var primero:boolean; var ProvAnt, LocaAnt:Cad50);
	Begin
	If Primero then
		Begin
		Primero:=False;
		ProvAnt:=Clientes.Provincia;
		LocaAnt:=Clientes.Localidad;
		End;
	If ProvAnt<>Clientes.Provincia then
		Begin
		GuardaLocalidad(ArTotCli, LocaAnt, ContLoca, Clientes);
		GuardaProvincia(ArTotCli, ProvAnt, ContProv, Clientes);
		End
	Else
	If LocaAnt<>Clientes.Localidad then
		GuardaLocalidad(ArTotCli, LocaAnt, ContLoca, Clientes);
	Inc(ContProv);
	Inc(ContLoca);
	Inc(ContClien);
	End;


Begin
Reset(ArCli);
Rewrite(ArTotCli);
LeerClientes(ArCli, Clientes, fin);
Primero:=True;
While not fin do
begin
	CargaTotCli(ArTotCli, Clientes, ContProv, ContLoca, ContClien, primero, ProvAnt, LocaAnt);
	LeerClientes(ArCli, Clientes, fin);
end;
GuardaLocalidad(ArTotCli, LocaAnt, ContLoca, Clientes);
GuardaProvincia(ArTotCli, ProvAnt, ContProv, Clientes);
GuardaClientes(ArTotCli, ContClien);
close(ArCli);
close(ArTotCli);
End;


Begin
Assign(ArCli,'C:\TP\Clientes.dat');
Assign(ArTotCli,'C:\TP\TotCli.txt');
GenerarTotCli(ArCli, ArTotCli);
End;

{-----------------------------------------------Punto 4--------------------------------------------------------------------------------}


Procedure ActualizarArchSucMun(var ArchSucArg:taSucursal);

	 Var
	 	RegSucMun,RegSucArg,RegSucAux:trSucursal;
	 	FinMun,FinArg:boolean;
	 	ArchSucMun,ArchSucAux: taSucursal;

	 Procedure PasarAuxASucMun(var ArchSucAux:taSucursal;var ArchSucMun:taSucursal;var RegSucAux:trSucursal;var RegSucMun:trSucursal);

	 begin
	 	reset(ArchSucAux);
	 	rewrite(ArchSucMun);
	 	read(ArchSucAux,RegSucAux);
	 	while not eof(ArchSucAux) do
	 		begin
	 		write (ArchSucMun,RegSucAux);
	 		read(ArchSucAux,RegSucAux);
	 		end;
	 	close(ArchSucAux);
	 	close(ArchSucMun);
	 end;


Begin
 	assign(archSucMun,'C:\TP\ArchSucMun.dat');
 	assign(ArchSucAux,'C:\TP\SucMunAuxiliar');
	reset(ArchSucArg);
	reset(archSucMun);
	rewrite(ArchSucAux);
	LeerSuc(ArchSucMun,RegSucMun,FinMun);
	LeerSuc(ArchSucArg,RegSucArg,FinArg);
	while not FinArg and not FinMun do
		if (RegSucMun.Num_Suc<RegSucArg.Num_Suc) then
			begin
				write(ArchSucAux,RegSucMun);
				LeerSuc(ArchSucMun,RegSucMun,FinMun);
			end
		else begin
				write(ArchSucAux,RegSucArg);
				LeerSuc(ArchSucArg,RegSucArg,FinArg);
			end;
	while not FinArg do
		begin
			write(ArchSucAux,RegSucArg);
			LeerSuc(ArchSucArg,RegSucArg,FinArg);
		end;
	while not FinMun do
		begin
			write(ArchSucAux,RegSucMun);
			LeerSuc(ArchSucMun,RegSucMun,FinMun);
		end;
	close(archSucMun);
	close(archSucArg);
	PasarAuxASucMun(ArchSucAux,ArchSucMun,RegSucAux,RegSucMun);
   end;

{-----------------------------------Programa Principal----------------------------------------------}

begin
	Assign(ArSuc,'C:\TP\SucursalesArg.dat');
	Assign(ArVentas,'C:\TP\VentasArg2015.dat');
	Assign(ArVentasHistorico,'C:\TP\VentasHistoricas.dat');
	MostrarTabla(ArVentas,ArSuc);
	Actualizar(ArVentasHistorico,ArVentas);
	Clientes;
        ActualizarArchSucMun(ArSuc);
	readln();
end.


