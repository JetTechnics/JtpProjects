unit PluginJTP;

interface

uses
  Windows, TypesJTP, VideoSetsHeader;


/////////////////////   Б А З О В Ы Й    П Л А Г И Н  /////////////////////////

Type TPluginJTP = object           //  Базовая структура для загрузки и инициализации плагинов
   Version : integer;              //  Версия
   Kind    : integer;              //  Тип плагина
   Size    : integer;              //  Размер в байтах.
   ipack1  : integer;
   pErrorsStr : PAnsiChar;         //  Строка с ошибкой.
   Constructor Create;
end;
type PPluginJTP = ^TPluginJTP;

/////////////////////////////////////////////////////////////////


//////////////   В И Д Ы   П Л А Г И Н О В   ///////////////
const JTP_PLUG_Empty = 0;
const JTP_PLUG_MultiScreens   = 100;
const JTP_PLUG_VideoPlayer    = 101;
const JTP_PLUG_TankBiathlon   = 102;



/////////////  Плагин для видео плеера  ////////////
///

Type TPlayerVideoInfo = record
   Version        : integer;                      //  Версия TVideoInfo.
   Size           : integer;                      //  Размер в байтах TVideoInfo.

   PlayerIndex    : integer;                      //  Номер плеера.
   VideoIndex     : integer;                      //  Номер видео файла в плеере.

   VideoCodecName : Str256;                       //  Имя видео кодека.
   VideoW, VideoH : integer;                      //  Размер видео кадра.
   FPS            : single;                       //  FPS.
   Bitrate        : single;                       //  Битрейт в мбит/с.
   Duration       : integer;                      //  Длительность в мили секундах.

   PreviewPixels  : pbyte;                        //  Превью битмап, размер массива = PreviewW * PreviewH * 4. RGBA.
   PreviewW, PreviewH : integer;                  //  Размер превью.

   AudioCodecName : Str256;                       //  Имя аудио кодека.
   Channels       : integer;                      //  Каналов звука.
   Frequency      : integer;                      //  Частота дискретизации.
   SampleBits     : integer;                      //  Бит на один сэмпл.

   procedure Init();
end;
   type PPlayerVideoInfo = ^TPlayerVideoInfo;


Type TVideoPlayerCallbackFunc = function ( VideoInfo : PPlayerVideoInfo ) : JtpRes;  stdcall;


Type TPluginVideoPlayers = object(TPluginJTP)

  NumPlayers : integer;
  Trunks : array [0..MAX_VIDEO_TRUNKS-1] of integer;    //  Номер ствола, куда выводится видео с каждого плеера.

  pStartVideoFunction : TVideoPlayerCallbackFunc;       //  Callback когда запускается видео.
  pNewVideoPropsFunction : TVideoPlayerCallbackFunc;    //  Callback когда добавляется новое видео.
  Constructor Create;
end;
////////////////////////////////////////////////////




/////////////  Плагин для танкового биатлона  ////////////
Type TPluginTankBiathlon = object(TPluginJTP)
  Constructor Create;
end;
//////////////////////////////////////////////////////////


implementation


Constructor TPluginJTP.Create();
begin
  Version := 1;
  Kind := JTP_PLUG_Empty;
  Size := sizeof( TPluginJTP );
  ipack1 := 0;
  pErrorsStr := nil;
end;



////////////////  Плагин для видео плеера  ///////////////

Constructor TPluginVideoPlayers.Create();
var i : integer;
begin
  TPluginJTP.Create();   // Как вызвать конструктор предка автоматом?

  Kind := JTP_PLUG_VideoPlayer;
  Size := sizeof( TPluginVideoPlayers );

  NumPlayers := 0;

  for i := 0 to LAST_VIDEO_TRUNK do
    Trunks[i] := -1;

  pStartVideoFunction := nil;
  pNewVideoPropsFunction := nil;
end;


procedure TPlayerVideoInfo.Init();
begin
    Version := 1;
    Size := sizeof( TPlayerVideoInfo );

    PlayerIndex := -1;
    VideoIndex := -1;

    VideoCodecName.text := '';
    VideoW := 0;   VideoH := 0;
    FPS := 0;
    Bitrate := 0;
    Duration := 0;

    PreviewPixels := nil;
    PreviewW := 0;    PreviewH := 0;

    AudioCodecName.text := '';
    Channels := 0;
    Frequency := 0;
    SampleBits := 0;
end;

//////////////////////////////////////////////////////////





/////////////  Плагин для танкового биатлона  ////////////

Constructor TPluginTankBiathlon.Create();
begin
  TPluginJTP.Create();

  Kind := JTP_PLUG_TankBiathlon;
  Size := sizeof( TPluginTankBiathlon );
end;

//////////////////////////////////////////////////////////

end.
