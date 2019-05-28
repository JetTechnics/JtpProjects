unit JTPStudio;

interface

uses
  Windows,
  TypesJTP, VideoSetsHeader, PluginJTP, Vector;


const  JTPStudioPath = 'C:\Program Files\JTPStudio\';
const  JTPStudioDLL = JTPStudioPath + 'JTPStudioNew.dll';



//     Video device types.
const  DECKLINK_VIDEO_DEVICE      : DWORD = $00000001;
const  BLUEFISH_VIDEO_DEVICE      : DWORD = $00000002;
const  MATROX_VIDEO_DEVICE        : DWORD = $00000004;
const  DIRECTSHOW_VIDEO_DEVICE    : DWORD = $00000008;
const  SIMULATOR_VIDEO_DEVICE     : DWORD = $00000010;



Type PHWnd = ^HWND;


const MaxErrorString = 4096;


Type TJtpFuncData = object
  Version : integer;
  pErrorsStr : PAnsiChar;
  //procedure Init;
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

function Get3DEngineVersion() : JtpRes;  stdcall;  external JTPStudioDLL;
//  Получить версию движка.


Type TEnumVideoDevices = object(TJtpFuncData)
  NumRequestSimulators : integer;  // Кол-во запрашиваемых симуляторов.

  constructor Create();
end;
PEnumVideoDevices = ^TEnumVideoDevices;

function EnumerateVideoDevices( DeviceType: DWORD;  DevicesNames: PStr256;  Params: DWORD;  pFuncData: PEnumVideoDevices ) : JtpRes;  stdcall;  external JTPStudioDLL;
//  Записывает имена видео плат. В случае успеха возвращает OK.
//  В последний DevicesNames записывает 0.
//  Params:
          const EnumVidDevsNoWarn : DWORD = 1;    //  Не показывать предупреждение, если не найдено видео плат.



Type TInitVideo = object(TJtpFuncData)
  NumRenderFrames : integer;  //  Кол-во запасённых отрисованных кадров.

  NumTimingFrames : integer;  //  Кол-во измерений времени.
  TimingItems : dword;        //  Какие участки движка измерять.

  constructor Create();
end;
PInitVideo = ^TInitVideo;

const TIMING_RENDER_WAIT      : dword = $00000001;  // время ожидания движком, когда видео девайсы заберут кадр.
const TIMING_RENDER           : dword = $00000002;  // время отрисовки кадра.
const TIMING_COPY_DEVICE      : dword = $00000004;  // время копирования кадра на видео девайс.
const TIMING_RNDR_FILLS       : dword = $00000008;  // сколько кадров рендера запасено.
const TIMING_OUT_SYNCS        : dword = $00000010;  // время синхронизации девайсов на выдачу.
const TIMING_WAIT_RNDR_FRAME  : dword = $00000020;  // сколько девайсы ждут отрисованного кадра.
const TIMING_INPUT_READIES    : dword = $00000040;  // сколько накоплено входных буферов.
const TIMING_INPUT_WAITS      : dword = $00000080;  // сколько ожидаем входной буфер.


function InitVideo( Params: DWORD;  VideoTrunks: PVideoTrunk;  VideoInputProperties: PVideoInputProperties;  pInitVideo: PInitVideo )
                  : JtpRes;  stdcall;  external JTPStudioDLL;
//  Устанавливает конфигурацию видео стволов и инициализирует устройства на вывод или ввод.
		//  Params - сейчас 0.
		//  VideoTrunks - стволы видео вывода/ввода.
		//  pInitVideoDesc - указатель на TInitVideo



Type TLoadProjectData = object(TJtpFuncData)
  NumScenes : integer;     // количество сцен в проекте.
  pSceneNames : PName;     // имена сцен.

  NumVariables : integer;  // количество переменных в проекте. Сейчас не используется.
  pProjVarNames : PName;   // имена переменных.

  constructor Create();
end;
PLoadProjectData = ^TLoadProjectData;

function LoadProject( ProjectPath: PPath;  TexturePathes: PPath;  Params: DWORD;  pLoadProjectData: PLoadProjectData ) : JtpRes;  stdcall;  external JTPStudioDLL;
//  Загружает проект трансляции.
		//  ProjectPath - файл проекта, где прописаны пути к сценам и переменные проекта.
		//  TexturePathes - пути к картинкам (фото, логотипы и т.д.). В последний TexturePathes записываем 0.
    //  pLoadProjectData - указатель на TLoadProjectData.



Type TErrorsCallbackPtr = function ( pErrors : PAnsiChar;  pReserved : pointer ) : dword;  stdcall;
//  Функция, куда сыпятся ошибки из движка.

Type TStartEngineData = object(TJtpFuncData)
  constructor Create();
end;
PStartEngineData = ^TStartEngineData;

function StartEngine( SoftVersion: integer;  Params: DWORD;  pErrorsCallback : TErrorsCallbackPtr;  pStartEngineData: PStartEngineData ) : JtpRes;  stdcall;  external JTPStudioDLL;
//  Стартуем движек.



function CloseEngine( Params: DWORD; pReserved : pointer ) : JtpRes;  stdcall;  external JTPStudioDLL;
//  Закрывает движек.
    //  Params - не используется.
    //  pReserved - не используется.



function OpenRecords( Params: DWORD;  pReserve: pointer ) : JtpRes;  stdcall;  external JTPStudioDLL;
//  Открывает запись действий для движка.

function CloseRecords( Params: DWORD;  pReserve: pointer ) : JtpRes;  stdcall;  external JTPStudioDLL;
//  Закрывает запись действий для движка.



Type TPlayScene = object(TJtpFuncData)
  SceneName: TName;   //  Имя созданной сцены. Например будет возвращено 'MyScene_Trunk1'.
  hPreviewWnds : array[0..MAX_PREVIEW_WINDOWS-1] of HWND;  //  Окна для превью.
  Constructor Create;
end;
PPlayScene = ^TPlayScene;

function PlayScene( SceneName: PAnsiChar;  Delay: single;  Mode: dword;  TrunkIndex: integer;  pPlayScene: PPlayScene ) : JtpRes;  stdcall;  external JTPStudioDLL;
//  Запускает сцену.
		//  SceneName  - имя сцены.
		//  Delay      - задержка, когда сцена появится на экране.
    //  Mode       - режим (не используется).
    //  TrunkIndex - индекс ствола (от 1 до MAX_VIDEO_TRUNKS).
    //  pPlayScene - указатель на TPlayScene.



function CloseScene( SceneName: PAnsiChar;  Delay: single;  Flags: dword;  pCloseScene : PJtpFuncData ) : JtpRes;   stdcall; external JTPStudioDLL;
//  Закрывает сцену.
    //  SceneName  - имя сцены.
		//  Delay - задержка на закрытие сцены. Если FLT_UNDEF - задержка берётся из данных сцены. Если Delay=0, сцена уничтожается моментально.
    //  Flags - флаги, сейчас ноль.
    //  pCloseScene - указатель на TCloseScene.


type
  TSceneFrameFunc = function ( SceneName: PAnsiChar;  Flags: dword;  pEvents: PJtpEvent;  FrameTime: single;  pReserve: pointer ) : JtpRes;  stdcall;

function SetSceneProcessCallback( SceneName: PAnsiChar;  SceneFunc: TSceneFrameFunc;  Flags: dword;  pPlayScene : PJtpFuncData ) : JtpRes;   stdcall; external JTPStudioDLL;
//  Задаёт пользовательскую функцию обработки сцены. Вызывается из движка.



Type TSceneInfo = object(TJtpFuncData)
  NumObjects: integer;       //  количество объектов в сцене.
  pObjectsNames: PName;      //  имена объектов.

  NumScenaries: integer;     //  количество сценариев в сцене.
  pScenariesNames: PName;    //  имена сценариев.

  Constructor Create;
end;
PSceneInfo = ^TSceneInfo;

function GetSceneInfo( SceneName: PAnsiChar;  pSceneInfo: PSceneInfo ) : JtpRes;   stdcall; external JTPStudioDLL;
//  Перечисляет объекты в сцене.
		//  SceneName  - имя сцены.
    //  pSceneInfo - указатель на структуру TSceneInfo. После вызова имена объектов, сценариев и т.д. надо скопировать куда-либо.
    //               Т.к. pSceneInfo будет валиден до следующего вызова GetSceneInfo или CloseRecords.



Type TObjectInfo = object(TJtpFuncData)
  pObjName : PName;           //  имя объекта.
  ObjectType: integer;        //  тип объекта, см. типы объектов в TypesJTP.pas.

  NumAnimations: integer;     //  количество анимаций у объекта.
  pAnimationsNames : PName;   //  имена анимаций объекта.

  NumSurfElems : integer;			//  количество элементов поверхности.

  Constructor Create;
end;
PObjectInfo = ^TObjectInfo;

function GetObjectInfo( SceneName, ObjectName: PAnsiChar;  pObjectInfo: PObjectInfo ) : JtpRes;   stdcall; external JTPStudioDLL;
//  Получает информацию об объекте сцены.
    //  SceneName  - имя сцены.
    //  ObjectName - имя объекта.
    //  pObjectInfo - указатель на структуру TObjectInfo. Будет валиден до следующего вызова GetObjectInfo или CloseRecords.



Type TCloneObject = object(TJtpFuncData)
  ObjectName: TName;   //  Имя полученного объекта.
  Constructor Create;
end;
PCloneObject = ^TCloneObject;

function CloneObject( SceneName, ObjectName: PAnsiChar;  pPos, pOrient, pSize, pColor : PVector;  Delay : single;  Flags: dword;  pCloneObject: PCloneObject )
                     : JtpRes;   stdcall; external JTPStudioDLL;
//  Клонируем объект.  несут смещение относительно клонируемого, если nil, то не учитываем.
		//  Delay - задержка клонирования.
    //  pPos, pOrient, pSize, pColor - указатели на вектора. Смещение, поворот относительно исходного объекта.
    //                               - pSize, pColor : размер и цвет нового объекта.
    //  Если какой-либо указатель nil, то не учитывается. Если какой-либо компонент вектора равен FLT_UNDEF, то компонент не учитывается.




Type TSurfElemData = object(TJtpFuncData)
  I : integer;    //  Индекс нового элемента (для CloneSurfaceElement).
  W : integer;    //  Получаемая длина строки в пикселях. Если W=1 - получаем длину строки, 0 - не получаем.
  H : integer;    //  Получаемая высота строки в пикселях. Если H=1 - получаем длину строки, 0 - не получаем.
  Constructor Create;
end;
PSurfElemData = ^TSurfElemData;

function UpdateSurfaceElement( SceneName, ObjectName: PAnsiChar;  Index, NumTex: integer;  PicturePath : PAnsiChar;  Text: PWideChar;  pColor : PJTPColor;
                               X,Y, W,H: integer;  Delay: single;  Flags: dword;   pUpdateSurfElemData : PSurfElemData ) : JtpRes;   stdcall; external JTPStudioDLL;
//  Обновить элемент поверхности. Это может быть текст или иконка.
    //  SceneName, ObjectName - имена сцены и объекта.
    //  Index - номер эелемента, NumTex - номер текстуры внутри объекта (слой). Начиная от 1-го.
		//  Если PicturePath <> nil, обновляется картинка.  Если Text <> nil, обновляется текст.
		//  Если pColor = nil, то цвет не обновляется. Если компонент цвета равен FLT_UNDEF, то не учитывается.
    //  Если X,Y,W,H не равны INT_UNDEF - соответственно обновляются.
		//  Delay = FLT_UNDEF - задержка берётся из данных сцены.
    //  Flags = 0.
    //  pUpdateSurfElemData - указатель на TSurfElemData.




function CloneSurfaceElement( SceneName, ObjectName: PAnsiChar;  Index, NumTex: integer;  PicturePath : PAnsiChar;  Text: PWideChar;  pColor : PVector;
															X,Y, W,H : integer;  Delay: single;  Flags: dword;  pCloneSurfElemData : PSurfElemData ) : JtpRes;   stdcall; external JTPStudioDLL;
//  Клонировать элемент поверхности. Это может быть текст или иконка.
		//  SceneName, ObjectName - имена сцены и объекта.
    //  Index - номер элемента, от которого клонируем, NumTex - номер текстуры внутри объекта (слой). Начиная от 1-го.
		//  PicturePath - путь к картинке. Если nil, берётся от предка.
    //  Text - новый текст. Если nil, берётся от предка.
    //  Если pColor = nil, то цвет берётся от предка. Если компонент цвета равен FLT_UNDEF, то берётся от предка.
    //  X,Y - координаты нового элемента (или абсолютные, или относительно предка). Если INT_UNDEF, то берутся от предка.
    //  W,H - ограничивающий размер. Если INT_UNDEF, то берутся от предка.
    //  Delay - задержка на клонирование. (Сейчас не используется, всегда 0.0).
    //  Flags - JTP_RELATIVE или JTP_ABSOLUTE (коор-ты относительно предка или абсолютные).
    //  pCloneSurfElemData - указатель на TSurfElemData.



function PlayAnimation( SceneName, ObjectName, AnimationName : PAnsiChar;  Delay: single;  AnimFlags: dword;  pPlayAnimation: PJtpFuncData ) : JtpRes;
										    stdcall; external JTPStudioDLL;
//  Проиграть анимацию у объекта сцены. Анимация создана заранее в редакторе.
		//  SceneName, ObjectName, AnimationName - имена сцены, объекта и анимации.
    //  Delay - задержка на запуск анимации. Она плюсуется к времени старта анимации в редакторе.
    //  pPlayAnimation - указатель на TJtpFuncData.



function PlayAnimationSmooth( SceneName, UnitName : PAnsiChar;  Delay: single;  AnimFlags: dword;  pFrom, pTo: PVector;  SmoothType: dword;
											        SmoothFactor: single;  Duration: single;  pPlayAnimation: PJtpFuncData ) : JtpRes;    stdcall; external JTPStudioDLL;
//  Создать и прогирать анимацию у объекта сцены. Анимация может быть с мягкими ключами (плавное ускорене и торможение).
		//  SceneName, ObjectName - имена сцены и объекта.
    //  Delay - задержка на запуск анимации.
    //  AnimFlags - флаги анимации. См. коды анимаций в TypesJTP.pas.
    //  pFrom и pTo - анимируемые значения. Если pFrom=nil, то первое значение берётся из объекта.
    //  SmoothType - тип мягкого ключа. См. коды мягких ключей в TypesJTP.pas.
    //  SmoothFactor - степень мягкости.
    //  Duration - длительность анимации.
    //  pPlayAnimation - указатель на TJtpFuncData.



function PlayScenario( SceneName, ScenarioName : PAnsiChar;  Delay: single;  Flags: dword;  pPlayScenario: PJtpFuncData ) : JtpRes;   stdcall; external JTPStudioDLL;
//  Проиграть сценарий сцены.
		//  SceneName - именя сцены.
    //  ScenarioName - имя сценария.
    //  Delay - задержка на проигрывание. Если FLT_UNDEF, задержка берётся из сцены.
    //  Flags - не используется.
    //  pPlayScenario - указатель на TJtpFuncData.



Type TSetObjectSpace = object(TJtpFuncData)
  BillboardRingShift : single;  // Сдвиг биллборда по кольцу (В JtpDesigner-е billboarding -> ViewOffset). FLT_UNDEF - не используется.
  Constructor Create;
end;
PSetObjectSpace = ^TSetObjectSpace;


function SetObjectSpace( SceneName, ObjectName: PAnsiChar;  pPos, pOrient, pSize, pDir, pTarget : PVector;  pColor : PJTPColor;  Delay: single;
												 Flags: dword;  pSetObjectSpace: PSetObjectSpace ) : JtpRes;   stdcall; external JTPStudioDLL;
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
    //  pSetObjectSpace - указатель на TSetObjectSpace.



function GetObjectSpace( SceneName, ObjectName: PAnsiChar;  pPos, pOrient, pSize, pDir, pTarget : PVector;  pColor : PJTPColor;
												 Flags: dword;  pGetObjectSpace: PJtpFuncData ) : JtpRes;   stdcall; external JTPStudioDLL;
//  Получить пространственные коор-ты объекта.
    //  Параметры как в SetObjectSpace.



function SetObjectTexture( SceneName, ObjectName: PAnsiChar;  TexturePath: PPath;  NumTex : integer;  Delay: single;
                           Flags: dword;  pSetObjectTexture: PJtpFuncData ) : JtpRes;   stdcall; external JTPStudioDLL;
//  Установить объекту новую текстуру.
    //  SceneName, ObjectName - имена сцены и объекта.
    //  TexturePath - путь к текстуре. Если текстура не загружена, она загрузится с диска.
    //  NumTex - номер текстуры внутри объекта (слой). Используектся только 1.
    //  Delay - задержка на установку текстуры.
    //  Flags - не используется.
    //  pSetObjectTexture - указатель на TJtpFuncData.



function OutInputPictureToTrunk( InputDeviceIndex: integer;  TrunkIndex: integer;  Enable: integer;  Flags: dword;  pOutIPtoTrunk: PJtpFuncData ) :
                                 JtpRes;   stdcall; external JTPStudioDLL;
//  Выдать входную картинку на ствол выдачи.
//  DeviceIndex - номер входного устройства.
//  TrunkIndex - номер выходного ствола.
//  Enable - 1/0 вкл/выкл выдачу.
//  Flags:
           const OIP_SHOW_ONLY_WINDOW : DWORD = $00000001;  //  Входная картинка подаётся только в окне play out ствола.
           const OIP_HIDE_ALPHA : DWORD       = $00000002;  //  Альфа входной картинки очищается, попадает только цвет.
//  pOutIPtoTrunk - указатель.




/////////////    Р А Б О Т А   С   П Л А Г И Н А М И   /////////////////////////

function  LoadPlugin( Path : PPath;  PluginJTP : PPluginJTP ) : JtpRes;   stdcall; external JTPStudioDLL;
//  Загружает плагин из dll библиотеки.
//  Path - путь к библиотеке.
//  PluginJTP - конфигурация плагина: тип, версия и т.д.


function  SendPluginCommand( PluginName : PAnsiChar;  Command : PAnsiChar;  pSendPluginCommand: PJtpFuncData ) : JtpRes;   stdcall; external JTPStudioDLL;
//  Послать команду плагину.
//  PluginName - имя плагина.
//  Command - строковая команда (длина не ограничена).



//function  SetPluginCallBack( PluginName, CallbackName : PAnsiChar;  pFunc: pointer;  SetPluginCallBackPtr : PJtpFuncData ) :
//                             JtpRes;   stdcall; external JTPStudioDLL;
//  Назначить callback плагину. Указывается имя плагина, имя callback-а и указатель на него.


//////////////////////////////////////////////////////////////////////////////////



implementation

//procedure TJtpFuncData.Init();
Constructor TJtpFuncData.Create();
begin
  Version := 1;
  pErrorsStr := nil;
end;



Constructor TPlayScene.Create;
var i : integer;
begin
  TJtpFuncData.Create();

	SceneName.text[0] := #0;

  for i := 0 to (MAX_PREVIEW_WINDOWS-1) do
    hPreviewWnds[i] := 0;
end;



Constructor TSceneInfo.Create;
begin
  TJtpFuncData.Create();

	NumObjects := 0;
  pObjectsNames := nil;

  NumScenaries := 0;
  pScenariesNames := nil;
end;



Constructor TObjectInfo.Create;
begin
  TJtpFuncData.Create();

  pObjName := nil;
  ObjectType := 0;

  NumAnimations := 0;
  pAnimationsNames := nil;

  NumSurfElems := 0;
end;




Constructor TCloneObject.Create;
begin
	TJtpFuncData.Create();

  ObjectName.text[0] := #0;
end;


Constructor TSurfElemData.Create;
begin
  TJtpFuncData.Create();

  I := 0;
  W := 0;
  H := 0;
end;



Constructor TSetObjectSpace.Create();
begin
  TJtpFuncData.Create();

  BillboardRingShift := FLT_UNDEF;
end;



Constructor TEnumVideoDevices.Create();
begin
  TJtpFuncData.Create();

  NumRequestSimulators := 0;
end;



Constructor TInitVideo.Create();
begin
  TJtpFuncData.Create();

  NumRenderFrames := 4;

  NumTimingFrames := 0;
  TimingItems := 0;
end;



Constructor TLoadProjectData.Create();
begin
  TJtpFuncData.Create();

  NumScenes := 0;
	pSceneNames := nil;
  NumVariables := 0;
  pProjVarNames := nil;
end;



Constructor TStartEngineData.Create();
begin
  TJtpFuncData.Create();
end;

end.
