unit PluginJTP;

interface

uses
  Windows, TypesJTP;


/////////////////////   � � � � � � �    � � � � � �  /////////////////////////

Type TPluginJTP = object               //  ������� ��������� ��� �������� � ������������� ��������
   Version  : integer;                 //  ������
   Kind     : integer;                 //  ��� �������
   Size     : integer;                 //  ������ � ������
   Constructor Create;
end;
type PPluginJTP = ^TPluginJTP;

/////////////////////////////////////////////////////////////////


//////////////   � � � �   � � � � � � � �   ///////////////
const JTP_PLUG_Empty = 0;
const JTP_PLUG_MultiScreens   = 100;
const JTP_PLUG_VideoTitler    = 101;
const JTP_PLUG_TankBiathlon   = 102;




/////////////  ������ ��� ��������� ��������  ////////////
Type TPluginConfigTB = object(TPluginJTP)
  Constructor Create;
end;



implementation


Constructor TPluginJTP.Create;
begin
  Version := 0;
  Kind := JTP_PLUG_Empty;
  Size := sizeof( TPluginJTP );
end;



/////////////  ������ ��� ��������� ��������  ////////////

Constructor TPluginConfigTB.Create;
begin
  TPluginJTP.Create();   // ��� ������� ����������� ������ ���������?
  Version := 1;
  Kind := JTP_PLUG_TankBiathlon;
  Size := sizeof( TPluginConfigTB );
end;

end.
