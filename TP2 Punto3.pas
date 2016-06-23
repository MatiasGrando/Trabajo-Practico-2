Program Punto3;

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
Assign(ArCli,'C:\Clientes.dat');
Assign(ArTotCli,'C:\TotCli.txt');		
GenerarTotCli(ArCli, ArTotCli);
End.