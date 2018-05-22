unit PluginJTP;

interface

uses
  Windows, TypesJTP;


/////////////////////   Б А З О В Ы Й    П Л А Г И Н  /////////////////////////

Type TPluginJTP = object               //  Базовая структура для загрузки и инициализации плагинов
   Version  : integer;                 //  версия
   Kind     : integer;                 //  тип плагина
   Size     : integer;                 //  размер в байтах
   Constructor Create;
end;
type PPluginJTP = ^TPluginJTP;

/////////////////////////////////////////////////////////////////


//////////////   В И Д Ы   П Л А Г И Н О В   ///////////////
const JTP_PLUG_Empty = 0;
const JTP_PLUG_MultiScreens   = 100;
const JTP_PLUG_VideoTitler    = 101;
const JTP_PLUG_TankBiathlon   = 102;




/////////////  Плагин для танкового биатлона  ////////////
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



/////////////  Плагин для танкового биатлона  ////////////

Constructor TPluginConfigTB.Create;
begin
  TPluginJTP.Create();   // Как вызвать конструктор предка автоматом?
  Version := 1;
  Kind := JTP_PLUG_TankBiathlon;
  Size := sizeof( TPluginConfigTB );
end;

end.
