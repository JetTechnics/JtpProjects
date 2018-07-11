unit JTPStudio;

interface

uses
  Windows,
  TypesJTP, Decklink, PluginJTP, Vector;


const  JTPStudioPath = 'C:\Program Files\JTPStudio\';
const  JTPStudioDLL = JTPStudioPath + 'JTPStudioNew.dll';


const  MAX_VIDEO_DEVICES = 16;    //  Макисмальное кол-во видео устройств.
const  LAST_VIDEO_DEVICE = MAX_VIDEO_DEVICES - 1;

const  MAX_VIDEO_TRUNKS = 4;    //  Макисмальное кол-во стволов.
const  LAST_VIDEO_TRUNK = MAX_VIDEO_TRUNKS - 1;

const  MAX_PREVIEW_WINDOWS = 4;


//     Video device types.
const  DECKLINK_VIDEO_DEVICE      : DWORD = $00000001;
const  BLUEFISH_VIDEO_DEVICE      : DWORD = $00000002;
const  MATROX_VIDEO_DEVICE        : DWORD = $00000004;
const  DIRECTSHOW_VIDEO_DEVICE    : DWORD = $00000008;
const  SIMULATOR_VIDEO_DEVICE     : DWORD = $00000010;



//   VideoTrunk. Ствол видео вывода.
Type TVideoTrunk = record

  Size               : integer;    //  Размер стр-ры TVideoTrunk.

//  ScreensLayout      : integer;    //  Расположение экранов в стволе: 1х девайс (TrunkScreens_1x1), 2х1 девайсы (TrunkScreens_2x1) и т.д.
  ScreensHorizontal  : integer;    //  Кол-во экранов по горизонтали.
  ScreensVertical    : integer;    //  Кол-во экранов по вертикали.

  ScreensRotate      : integer;    //  Повороты экрана. Например, TrunkVideo_90R и т.д.

  Flags              : integer;    //  Различные флаги. Например, TrunkVideo_SD_16_9 и т.д.

  OutputDisplayMode  : integer;    //  Режим видео вывода. Например, bmdModeHD1080i50, bmdModePAL и т.д.
  OutputPixelFormat  : integer;    //  Формат пикселя на выход. Например, bmdFormat8BitBGRA  и т.д.
  hOutWindow         : HWND;       //  Окно вывода видео картинки.

  InputDisplayMode   : integer;    //  Режим захвата видео. Например, bmdModeHD1080i50, bmdModePAL и т.д.
  InputPixelFormat   : integer;    //  Формат пикселя на вход. Например, bmdFormat8BitBGRA  и т.д.

  AlphaChannelTrunk  : integer;    //  Индекс ствола, используемого как альфа-канал. -1 - не используется.

  GpuIndex           : integer;    //  Какой GPU в системе использовать для рендера ствола.

  pExtensions        : pointer;    //  Расширения для нестандарного применеия. Например, симулятор VideoCapture (играем из видео файла)

  OutDevices   : array [0..LAST_VIDEO_DEVICE] of integer;
  InputDevices : array [0..LAST_VIDEO_DEVICE] of integer;

  Reserves     : array [0..127] of integer;   //  Резерв.

  FrameWidthFactor   : integer;    //  Не используется.
  Rect               : TJTPRect;      //  Не используется.
  pWindowRender      : pointer;    //  Не используется.

  procedure ClearForDecklink();
end;

PVideoTrunk = ^TVideoTrunk;


//    Повороты экранов в стволе (для TVideoTrunk.ScreensRotate).
const TrunkScreens_90R    : integer = $00000001;   //  Перевернуть вправо.
const TrunkScreens_90L    : integer = $00000002;   //  Перевернуть влево.
const TrunkScreens_180    : integer = $00000004;   //  Перевернуть на 180 градусов.

//    Флаги для TVideoTrunk.Flags
const TrunkVideo_SD_16_9      : integer = $00000001;   //  Режим SD (PAL 4/3) растягивается до 16/9.
const TrunkVideo_KeyPass      : integer = $00000002;   //  Кейер на проход.
const TrunkVideo_VertBlur     : integer = $00000004;   //  Только вертикальный блюр (для кадра без альфы).
const TrunkVideo_ProcessMouse : integer = $00000008;   //  Ловит событие от мыши в окне, к которому привязано это окно.

//    Выбор GPU по умолчанию для рендера.
const TrunkVideo_GpuDefault : integer = -1;


Type PHWnd = ^HWND;


const MaxErrorString = 4096;

Type TJtpFuncData = object
  pErrorsStr : PAnsiChar;
  Constructor Create;
end;
PJtpFuncData = ^TJtpFuncData;




//  События из двига для callback-ов из сцены
type TJtpEvent = record
    EventType   : integer;
    Flags       : integer;
    SceneName   : PAnsiChar;
    ObjectName  : PAnsiChar;
    PointXY     : TJTPPoint;
end;
type PJtpEvent = ^TJtpEvent;

//  Идентификаторы событий
const EVENT_CAPTURE    : integer = 1;   //  Событие callback-а сцены при видеозахвате
const EVENT_MOUSE      : integer = 2;   //  Событие callback-а сцены от мыши

//  Флаги событий от мыши
const EM_LBUTTON_CLICK :  integer = $00000001;    //  Кликнули левой клавишей
const EM_LBUTTON_DOWN  :  integer = $00000002;    //  Удерживаем левую клавишу
const EM_RBUTTON_CLICK :  integer = $00000004;    //  Кликнули правой клавишей
const EM_RBUTTON_DOWN  :  integer = $00000008;    //  Удерживаем левой клавишу
const EM_MBUTTON_CLICK :  integer = $00000010;    //  Кликнули центральной клавишей
const EM_MBUTTON_DOWN  :  integer = $00000020;    //  Удерживаем центральную клавишу
//const EM_MWHEEL        :  integer = $00000040;    //  крутим центральное колесо (значение в iValue[0])


//////////////   P R O X Y    E N G I N E    F U N C T I O N S     ///////////////

function Get3DEngineVersion() : UInt64;  stdcall;  external JTPStudioDLL;
//  Получить версию движка.



function EnumerateVideoDevices( DeviceType: DWORD;  DevicesNames: PStr256;  Params: DWORD;  pFuncData: pointer ) : UInt64;  stdcall;  external JTPStudioDLL;
//  Записывает имена видео плат. В случае успеха возвращает OK.
//  В последний DevicesNames записывает 0.
//  Params:
          const EnumVidDevsNoWarn : DWORD = 1;    //  Не показывать предупреждение, если не найдено видео плат.



function InitVideo( VideoTrunks: PVideoTrunk;  Params: DWORD;  pInitVideoDesc: pointer) : UInt64;  stdcall;  external JTPStudioDLL;
//  Устанавливает конфигурацию видео стволов и инициализирует устройства в них.
		//  VideoTrunks - стволы видео вывода/ввода.
		//  Params - не используется
		//  pInitVideoDesc - указатель на
  		  type TInitVideoDesc = record
	    		Version : integer;          //  версия.
	    		VerticalBlur : single;      //  блюр пикселей при interlaced-трансляции.
		    	ScreenAlpha : single;       //  прозрачность всей картинки.
	  	    ClearColor : dword;
          pErrorsStr : PAnsiChar;     //  Текст ошибки, если произошла.
		    end;



function LoadProject( ProjectPath: PPath;  TexturePathes: PPath;  Params: DWORD;  pLoadProjectData: pointer ) : UInt64;  stdcall;  external JTPStudioDLL;
//  Загружает проект трансляции.
		//  ProjectPath - файл проекта, где прописаны пути к сценам и переменные проекта.
		//  TexturePathes - пути к картинкам (фото, логотипы и т.д.). В последний TexturePathes записываем 0.
    //  pLoadProjectData - указатель на TJtpLoadProjectData.
        Type TJtpLoadProjectData = object(TJtpFuncData)
          NumScenes : integer;     // количество сцен в проекте.
					pSceneNames : PName;     // имена сцен.
          NumVariables : integer;  // количество переменных в проекте. Сейчас не используется.
					pProjVarNames : PName;   // имена переменных.
        end;



Type
  TErrorsCallbackPtr = function ( pErrors : PAnsiChar;  pReserved : pointer ) : dword;  stdcall;

function StartEngine( Version: integer;  Params: DWORD;  pErrorsCallback : TErrorsCallbackPtr;  pStartEngineData: pointer ) : UInt64;  stdcall;  external JTPStudioDLL;
//  Стартуем движек.
		//  Version = 1.


function CloseEngine( Params: DWORD ) : UInt64;  stdcall;  external JTPStudioDLL;
//  Закрывает движек.
    //  Params - не используется.



function OpenRecords( Params: DWORD;  pReserve: pointer ) : UInt64;  stdcall;  external JTPStudioDLL;
//  Открывает запись действий для движка.

function CloseRecords( Params: DWORD;  pReserve: pointer ) : UInt64;  stdcall;  external JTPStudioDLL;
//  Закрывает запись действий для движка.



function PlayScene( SceneName: PAnsiChar;  Delay: single;  Mode: dword;  TrunkIndex: integer;  pPlaySceneData: pointer ) : UInt64;  stdcall;  external JTPStudioDLL;
//  Запускает сцену.
		//  SceneName  - имя сцены.
		//  Delay      - задержка, когда сцена появится на экране.
    //  Mode       - режим (не используется).
    //  TrunkIndex - индекс ствола (от 1 до MAX_VIDEO_TRUNKS).
    //  pPlaySceneData - указатель на TPlaySceneData.

		Type TPlaySceneData = object(TJtpFuncData)
		  SceneName: TName;   //  Имя созданной сцены. Например будет возвращено 'MyScene_Trunk1'.
		  hPreviewWnds : array[0..MAX_PREVIEW_WINDOWS-1] of HWND;  //  Окна для превью.
      Constructor Create;
		end;
    PPlaySceneData = ^TPlaySceneData;


function CloseScene( SceneName: PAnsiChar;  Delay: single;  pCloseSceneData : PJtpFuncData ) : UInt64;   stdcall; external JTPStudioDLL;
//  Закрывает сцену.
    //  SceneName  - имя сцены.
		//  Delay - задержка на закрытие сцены. Если FLT_UNDEF - задержка берётся из данных сцены.
    //  pCloseSceneData - укзатель на TJtpFuncData.


type
  TSceneFrameFunc = function ( SceneName: PAnsiChar;  Flags: dword;  pEvents: PJtpEvent;  FrameTime: single;  pReserve: pointer ) : UInt64;  stdcall;

function SetSceneProcessCallback( SceneName: PAnsiChar;  SceneFunc: TSceneFrameFunc;  Flags: dword;  pPlaySceneData : PJtpFuncData ) : UInt64;   stdcall; external JTPStudioDLL;
//  Задаёт пользовательскую функцию обработки сцены. Вызывается из движка.



function GetSceneInfo( SceneName: PAnsiChar;  pSceneInfoData: pointer ) : UInt64;   stdcall; external JTPStudioDLL;
//  Перечисляет объекты в сцене.
		//  SceneName  - имя сцены.
    //  pSceneInfoData - указатель на структуру TSceneInfoData. После вызова имена объектов надо скопировать куда-либо.
		//																													Т.к. pSceneInfoData будет не валиден после CloseRecords.

    Type TSceneInfoData = object(TJtpFuncData)
      NumObjects: integer;       //  количество объектов в сцене.
		  pObjectsNames: PName;      //  имена объектов.

      NumScenaries: integer;     //  количество сценариев в сцене.
      pScenariesNames: PName;    //  имена сценариев.
      Constructor Create;
		end;



function GetObjectInfo( SceneName, ObjectName: PAnsiChar;  pObjectInfoData: pointer ) : UInt64;   stdcall; external JTPStudioDLL;
//  Получает информацию об объекте сцены.
    //  SceneName  - имя сцены.
    //  ObjectName - имя объекта.
    //  pObjectInfoData - указатель на структуру TObjectInfoData. Будет не валиден после CloseRecords.

    Type TObjectInfoData = object(TJtpFuncData)
      pObjName : PName;           //  имя объекта.
      ObjectType: integer;        //  тип объекта, см. типы объектов в TypesJTP.pas.

      NumAnimations: integer;     //  количество анимаций у объекта.
      pAnimationsNames : PName;   //  имена анимаций объекта.

      NumSurfElems : integer;			//  количество элементов поверхности.
    end;



function CloneObject( SceneName, ObjectName: PAnsiChar;  pPos, pOrient, pSize, pColor : PVector;  Delay : single;  Flags: dword;  pCloneObjectData: pointer ) : UInt64;   stdcall; external JTPStudioDLL;
//  Клонируем объект.  несут смещение относительно клонируемого, если nil, то не учитываем.
		//  Delay - задержка клонирования.
    //  pPos, pOrient, pSize, pColor - указатели на вектора. Смещение, поворот относительно исходного объекта.
    //                               - pSize, pColor : размер и цвет нового объекта.
    //  Если какой-либо указатель nil, то не учитывается. Если какой-либо компонент вектора равен FLT_UNDEF, то компонент не учитывается.

    Type TCloneObjectData = object(TJtpFuncData)
		  ObjectName: TName;   //  Имя полученного объекта.
      Constructor Create;
		end;
    PCloneObjectData = ^TCloneObjectData;



function UpdateSurfaceElement( SceneName, ObjectName: PAnsiChar;  Index, NumTex: integer;  PicturePath : PAnsiChar;  Text: PWideChar;  pColor : PJTPColor;
                               X,Y, W,H: integer;  Delay: single;  Flags: dword;   pUpdateSurfElemData : pointer ) : UInt64;   stdcall; external JTPStudioDLL;
//  Обновить элемент поверхности. Это может быть текст или иконка.
    //  SceneName, ObjectName - имена сцены и объекта.
    //  Index - номер эелемента, NumTex - номер текстуры. Начиная от 1-го.
		//  Если PicturePath <> nil, обновляется картинка.  Если Text <> nil, обновляется текст.
		//  Если pColor = nil, то цвет не обновляется. Если компонент цвета равен FLT_UNDEF, то не учитывается.
    //  Если X,Y,W,H не равны INT_UNDEF - соответственно обновляются.
		//  Delay = FLT_UNDEF - задержка берётся из данных сцены.
    //  Flags = 0.
    //  pUpdateSurfElemData - указатель на TSurfElemData.

    Type TSurfElemData = object(TJtpFuncData)
      I : integer;    //  Индекс нового элемента (для CloneSurfaceElement).
      W : integer;    //  Получаемая длина строки в пикселях. Если W=1 - получаем длину строки, 0 - не получаем.
      Constructor Create;
    end;
    PSurfElemData = ^TSurfElemData;



function CloneSurfaceElement( SceneName, ObjectName: PAnsiChar;  Index, NumTex: integer;  PicturePath : PAnsiChar;  Text: PWideChar;  pColor : PVector;
															X,Y, W,H : integer;  Delay: single;  Flags: dword;  pCloneSurfElemData : pointer ) : UInt64;   stdcall; external JTPStudioDLL;
//  Клонировать элемент поверхности. Это может быть текст или иконка.
		//  SceneName, ObjectName - имена сцены и объекта.
    //  Index - номер элемента, от которого клонируем, NumTex - номер текстуры. Начиная от 1-го.
		//  PicturePath - путь к картинке. Если nil, берётся от предка.
    //  Text - новый текст. Если nil, берётся от предка.
    //  Если pColor = nil, то цвет берётся от предка. Если компонент цвета равен FLT_UNDEF, то берётся от предка.
    //  X,Y - координаты нового элемента (или абсолютные, или относительно предка). Если INT_UNDEF, то берутся от предка.
    //  W,H - ограничивающий размер. Если INT_UNDEF, то берутся от предка.
    //  Delay - задержка на клонирование. (Сейчас не используется, всегда 0.0).
    //  Flags - JTP_RELATIVE или JTP_ABSOLUTE (коор-ты относительно предка или абсолютные).
    //  pCloneSurfElemData - указатель на TSurfElemData.



function PlayAnimation( SceneName, ObjectName, AnimationName : PAnsiChar;  Delay: single;  AnimFlags: dword;  pPlayAnimationData: pointer ) : UInt64;
										    stdcall; external JTPStudioDLL;
//  Проиграть анимацию у объекта сцены. Анимация создана заранее в редакторе.
		//  SceneName, ObjectName, AnimationName - имена сцены, объекта и анимации.
    //  Delay - задержка на запуск анимации. Она плюсуется к времени старта анимации в редакторе.
    //  pPlayAnimationData - указатель на TJtpFuncData.



function PlayAnimationSmooth( SceneName, UnitName : PAnsiChar;  Delay: single;  AnimFlags: dword;  pFrom, pTo: PVector;  SmoothType: dword;
											        SmoothFactor: single;  Duration: single;  pPlayAnimationData: pointer ) : UInt64;    stdcall; external JTPStudioDLL;
//  Создать и прогирать анимацию у объекта сцены. Анимация может быть с мягкими ключами (плавное ускорене и торможение).
		//  SceneName, ObjectName - имена сцены и объекта.
    //  Delay - задержка на запуск анимации.
    //  AnimFlags - флаги анимации. См. коды анимаций в TypesJTP.pas.
    //  pFrom и pTo - анимируемые значения. Если pFrom=nil, то первое значение берётся из объекта.
    //  SmoothType - тип мягкого ключа. См. коды мягких ключей в TypesJTP.pas.
    //  SmoothFactor - степень мягкости.
    //  Duration - длительность анимации.
    //  pPlayAnimationData - указатель на TJtpFuncData.



function PlayScenario( SceneName, ScenarioName : PAnsiChar;  Delay: single;  Flags: dword;  pPlayScenario: PJtpFuncData ) : UInt64;   stdcall; external JTPStudioDLL;
//  Проиграть сценарий сцены.
		//  SceneName - именя сцены.
    //  ScenarioName - имя сценария.
    //  Delay - задержка на проигрывание. Если FLT_UNDEF, задержка берётся из сцены.
    //  Flags - не используется.
    //  pPlayScenario - указатель на TJtpFuncData.



function SetObjectSpace( SceneName, ObjectName: PAnsiChar;  pPos, pOrient, pSize, pDir, pTarget : PVector;  pColor : PJTPColor;  Delay: single;
												 Flags: dword;  pSetObjectSpace: PJtpFuncData ) : UInt64;   stdcall; external JTPStudioDLL;
//  Установить пространственные коор-ты объекта. Это позиция, ориентация, размер, направление, цвет.
		//  SceneName, ObjectName - имена сцены и объекта.
    //  pPos, pOrient, pSize - позиция, ориентация и размер соответственно. Если nil, то вектор не учитывается.
    //                         Если компонент вектора равен FLT_UNDEF, то не учитывается.
    //  pDir - направление. Если nil, то вектор не учитывается. Если компонент вектора равен FLT_UNDEF, то не учитывается.
    //			   (Сейчас не используется).
    //  pTarget - точка, куда смотрит камера. Если nil, то вектор не учитывается. Если компонент вектора равен FLT_UNDEF, то не учитывается.
    //         (Сейчас не используется).
    //  pColor - цвет объекта. Если nil, то цвет не учитывается. Если компонент цвета равен FLT_UNDEF, то не учитывается.
    //  Delay - задержка на установку координат или цвета.
    //  Flags - JTP_RELATIVE или JTP_ABSOLUTE - коор-ты относительные или абсолютные.
    //  pSetObjectSpace - указатель на TJtpFuncData.


function GetObjectSpace( SceneName, ObjectName: PAnsiChar;  pPos, pOrient, pSize, pDir, pTarget : PVector;  pColor : PJTPColor;
												 Flags: dword;  pGetObjectSpaceData: PJtpFuncData ) : UInt64;   stdcall; external JTPStudioDLL;
//  Получить пространственные коор-ты объекта.
    //  Параметры как в SetObjectSpace.



function SetObjectTexture( SceneName, ObjectName: PAnsiChar;  TexturePath: PPath;  TexIndex : integer;  Delay: single;
                           Flags: dword;  pSetObjectTexture: PJtpFuncData ) : UInt64;   stdcall; external JTPStudioDLL;
//  Установить объекту новую текстуру.
    //  SceneName, ObjectName - имена сцены и объекта.
    //  TexturePath - путь к текстуре. Если текстура не загружена, она загрузится с диска.
    //  TexIndex - номер текстуры внутри объекта. Используектся только 1.
    //  Delay - задержка на установку текстуры.
    //  Flags - не используется.
    //  pSetObjectTexture - указатель на TJtpFuncData.





/////////////    Р А Б О Т А   С   П Л А Г И Н А М И   /////////////////////////

function  LoadPlugin( pPath : PPath;  PluginJTP : PPluginJTP ) : UInt64;   stdcall; external JTPStudioDLL;




//////////////////////////////////////////////////////////////////////////////////



implementation

Constructor TJtpFuncData.Create;
begin
  pErrorsStr := nil;
end;


Constructor TPlaySceneData.Create;
var i : integer;
begin
	SceneName.text[0] := #0;
  for i := 0 to (MAX_PREVIEW_WINDOWS-1) do
    hPreviewWnds[i] := 0;
end;


Constructor TSceneInfoData.Create;
begin
	NumObjects := 0;
  pObjectsNames := nil;

  NumScenaries := 0;
  pScenariesNames := nil;
end;


Constructor TCloneObjectData.Create;
begin
	ObjectName.text[0] := #0;
end;


Constructor TSurfElemData.Create;
begin
  I := 0;
  W := 0;
end;




procedure TVideoTrunk.ClearForDecklink();
var device : integer;
    i : integer;
begin
  Size := sizeof( TVideoTrunk );

//  ScreensLayout := 0;
  ScreensHorizontal := 0;
  ScreensVertical := 0;
  ScreensRotate := 0;
  Flags := 0;

  OutputDisplayMode := 0; //bmdModeUnknown;
  OutputPixelFormat := bmdFormat8BitBGRA;
  hOutWindow := 0;

  InputDisplayMode := 0;  //bmdModeUnknown;
  InputPixelFormat := bmdFormat8BitBGRA;

  AlphaChannelTrunk := -1;

  GpuIndex := TrunkVideo_GpuDefault;

  pExtensions := nil;

  FrameWidthFactor := 0;

  with Rect do begin
    x1 := 0;  x2 := 0;  y1 := 0;  y2 := 0;
  end;

  for device := 0 to LAST_VIDEO_DEVICE do begin
    OutDevices[device] := -1;
    InputDevices[device] := -1;
  end;

  for i := 0 to 127 do
    Reserves[i] := 0;
end;

end.
