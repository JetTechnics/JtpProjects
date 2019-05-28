unit VideoSetsHeader;

interface

uses Vcl.Forms, Windows,
     TypesJTP;


const  MAX_VIDEO_DEVICES = 32;    //  Макисмальное кол-во видео устройств.
const  LAST_VIDEO_DEVICE = MAX_VIDEO_DEVICES - 1;

const  MAX_VIDEO_TRUNKS = 32;    //  Макисмальное кол-во стволов.
const  LAST_VIDEO_TRUNK = MAX_VIDEO_TRUNKS - 1;

const  MAX_PREVIEW_WINDOWS = 32;



//   VideoTrunk. Ствол видео вывода.
Type TVideoTrunk = record

  Version            : integer;

  Enabled            : integer;    //  Ствол выбран на панели видео натроек.

  ScreensHorizontal  : integer;    //  Кол-во экранов по горизонтали.
  ScreensVertical    : integer;    //  Кол-во экранов по вертикали.

  ScreensRotate      : integer;    //  Повороты экрана. Например, TrunkVideo_90R и т.д.

  Flags              : integer;    //  Различные флаги. Например, TrunkVideo_SD_16_9 и т.д.

  OutputDisplayMode  : integer;    //  Режим видео вывода. Например, VideoModeHD1080i50, VideoModePAL и т.д.
  OutputPixelFormat  : integer;    //  Формат пикселя на выход. Например, bmdFormat8BitBGRA  и т.д.

  hOutWindow         : HWND;       //  Окно вывода видео картинки.

  pExtensions        : pointer;    //  Расширения для нестандарного применеНия. Например, симулятор VideoCapture (играем из видео файла)

  AlphaChannelTrunk  : integer;    //  Индекс ствола, используемого как альфа-канал. -1 - не используется.

  GpuIndex           : integer;    //  Какой GPU в системе использовать для рендера ствола.

  VerticalBlur       : single;     //  Блюр пикселей при interlaced видео режиме.
 	ScreenAlpha        : single;     //  Прозрачность всей картинки.
  ClearColor         : dword;      //  Цвет заливки перед отрисовкой.

  Simulator          : integer;    //  Все девайсы ствола - симуляторы на вывод.

  OutDevices   : array [0..LAST_VIDEO_DEVICE] of integer;

  Reserves     : array [0..255] of integer;   //  Резерв.

  procedure Clear();
end;
PVideoTrunk = ^TVideoTrunk;
const VideoTrunkSize : integer = sizeof( TVideoTrunk );  // В real-time другое значение.



//   Девайс на видео вход.
Type TVideoInputDevice = record
  Index : integer;          //  Индекс девайса.

  DisplayMode : integer;    //  Режим захвата видео. Например, VideoModeHD1080i50, VideoModePAL и т.д.
  PixelFormat : integer;    //  Формат пикселя на вход. Например, PixFormatBGRA8  и т.д.

  Simulator  : integer;     //  Симулятор девайса на ввод.
  StreamPath : TPath;       //  Файл секвенции для симулятора.

  procedure Clear();
end;
PVideoInputDevice = ^TVideoInputDevice;


//   Некие общие настройки видео входа.
Type TVideoInputProperties = record

  Version : integer;

  Present : integer;  // Показывать ли видео вход на панели видео настроек.

  InputDevices : array [0..LAST_VIDEO_DEVICE] of TVideoInputDevice;

  procedure Clear();
end;
PVideoInputProperties = ^TVideoInputProperties;



//    Повороты экранов в стволе (для TVideoTrunk.ScreensRotate).
const TrunkScreens_90R    : integer = $00000001;   //  Перевернуть вправо.
const TrunkScreens_90L    : integer = $00000002;   //  Перевернуть влево.
const TrunkScreens_180    : integer = $00000004;   //  Перевернуть на 180 градусов.

//    Флаги для TVideoTrunk.Flags
const TrunkVideo_SD_16_9      : integer = $00000001;   //  Режим SD (PAL 4/3) растягивается до 16/9.
const TrunkVideo_KeyPass      : integer = $00000002;   //  Кейер на проход.
const TrunkVideo_VertBlur     : integer = $00000004;   //  Только вертикальный блюр (для кадра без альфы).
const TrunkVideo_ProcessMouse : integer = $00000008;   //  Ловит событие от мыши в окне, к которому привязано это окно.



Type TVideoSets = record    //  Структура видео настроек.
    Version : integer;
    Flags : integer;                //  Флаги, сейчас 0.
    NumRequestTrunks : integer;     //  Кол-во запрашиваемых стволов. Такое кол-во TrunkBox-ов должно быть на панели видео настроек.
    NumRequestSimulators : integer;

    //SimulatorOutput : integer;    //  Запустим симулятор на вывод.
    //SimulatorInput : integer;     //  Запустим симулятор на ввод.

    Trunks : array [0..LAST_VIDEO_TRUNK] of TVideoTrunk;

    InputProperties : TVideoInputProperties;

    procedure Clear();
end;
PVideoSets = ^TVideoSets;

  //  Функция получения версии видео окна.
  TGetVersionVideoSetsFunc = function ( Flags: integer;  pReserve: pointer ) : integer; stdcall;

  //  Callback функция, когда закрыли форму видео настроек.
  TVideoCloseSetsFunc = function ( Flags: integer;  VideoSets: PVideoSets ) : integer;  stdcall;

  //  Функция показа формы видео настроек.
  TVideoStartSetsFunc = function ( Flags: integer;  MainApp: TApplication;  VideoSets : PVideoSets; //OutWindows: PHwndArray;  pTrunkFlags: PTrunkFlagsArray;
                                   pCloseFunc: TVideoCloseSetsFunc;  pReserve: pointer ) : integer; stdcall;



//     Видео режимы:

const  VideoModeNull	       : integer = 0;
const  VideoModeNTSC	       : integer = 1;
const  VideoModeNTSC2398	   : integer = 2;
const  VideoModePAL	         : integer = 3;
const  VideoModeNTSCp	       : integer = 4;
const  VideoModePALp	       : integer = 5;
//  HD...
const  VideoModeHD1080p2398	 : integer = 6;
const  VideoModeHD1080p24	   : integer = 7;
const  VideoModeHD1080p25	   : integer = 8;
const  VideoModeHD1080p2997	 : integer = 9;
const  VideoModeHD1080p30	   : integer = 10;
const  VideoModeHD1080i50	   : integer = 11;
const  VideoModeHD1080i5994	 : integer = 12;
const  VideoModeHD1080i60  	 : integer = 13;
const  VideoModeHD1080p50	   : integer = 14;
const  VideoModeHD1080p5994	 : integer = 15;
const  VideoModeHD1080p60 	 : integer = 16;
//  720p..
const  VideoModeHD720p50	   : integer = 17;
const  VideoModeHD720p5994	 : integer = 18;
const  VideoModeHD720p60	   : integer = 19;
//  2K..
const  VideoMode2k2398	     : integer = 20;
const  VideoMode2k24	       : integer = 21;
const  VideoMode2k25	       : integer = 22;
const  VideoMode2kDCI2398	   : integer = 23;
const  VideoMode2kDCI24	     : integer = 24;
const  VideoMode2kDCI25	     : integer = 25;
//  4K..
const  VideoMode4K2160p2398  : integer = 26;
const  VideoMode4K2160p24	   : integer = 27;
const  VideoMode4K2160p25	   : integer = 28;
const  VideoMode4K2160p2997  : integer = 29;
const  VideoMode4K2160p30	   : integer = 30;
const  VideoMode4K2160p50	   : integer = 31;
const  VideoMode4K2160p5994  : integer = 32;
const  VideoMode4K2160p60	   : integer = 33;
const  VideoMode4kDCI2398	   : integer = 34;
const  VideoMode4kDCI24	     : integer = 35;
const  VideoMode4kDCI25	     : integer = 36;



//     Форматы пикселя:

const  PixelFormatNull        : integer = 0;
const  PixelFormat8BitYUV	    : integer = 1;
const  PixelFormat10BitYUV   	: integer = 2;
const  PixelFormat8BitARGB   	: integer = 3;
const  PixelFormat8BitBGRA   	: integer = 4;
const  PixelFormat10BitRGB   	: integer = 5;
const  PixelFormat12BitRGB	  : integer = 6;
const  PixelFormat12BitRGBLE	: integer = 7;
const  PixelFormat10BitRGBXLE	: integer = 8;
const  PixelFormat10BitRGBX	  : integer = 9;
const  PixelFormatH265	      : integer = 10;
const  PixelFormatDNxHR	      : integer = 11;



//    Выбор GPU по умолчанию для рендера.
const TrunkVideo_GpuDefault : integer = -1;



implementation



procedure TVideoInputDevice.Clear();
begin
  Index := -1;

  DisplayMode := 0;
  PixelFormat := PixelFormat8BitYUV;

  Simulator := 0;
  StreamPath.text[0] := #0;
end;



procedure TVideoInputProperties.Clear();
var i : integer;
begin
  Version := 1;

  Present := 0;

  for i := 0 to LAST_VIDEO_DEVICE do begin
    InputDevices[i].Clear();
  end;
end;



procedure TVideoTrunk.Clear();
var device : integer;
    i : integer;
begin
  Version := 1;

  Enabled := 0;

  ScreensHorizontal := 0;
  ScreensVertical := 0;
  ScreensRotate := 0;
  Flags := 0;

  OutputDisplayMode := VideoModeNull;
  OutputPixelFormat := PixelFormat8BitBGRA;
  hOutWindow := 0;

  AlphaChannelTrunk := -1;

  GpuIndex := TrunkVideo_GpuDefault;

  pExtensions := nil;

  Simulator := 0;

  VerticalBlur := 0.15;
  ScreenAlpha := 1.0;
  ClearColor := $00999999;

  for device := 0 to LAST_VIDEO_DEVICE do begin
    OutDevices[device] := -1;
  end;

  for i := 0 to 255 do
    Reserves[i] := 0;
end;



procedure TVideoSets.Clear();
var
  i : integer;
begin
  Version := 1;

  Flags := 0;

  //SimulatorOutput := 0;
  //SimulatorInput := 0;

  NumRequestSimulators := 0;

  NumRequestTrunks := 0;
  for i := 0 to LAST_VIDEO_TRUNK do begin
    Trunks[i].Clear();
  end;

  InputProperties.Clear();
end;

end.
