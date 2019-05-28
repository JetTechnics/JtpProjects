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




//  ������� �� ����� ��� callback-�� �� �����
type TJtpEvent = record
    EventType   : integer;
    Flags       : integer;
    SceneName   : PAnsiChar;
    ObjectName  : PAnsiChar;
    PointXY     : TJTPPoint;
end;
type PJtpEvent = ^TJtpEvent;

//  �������������� �������
const EVENT_CAPTURE    : integer = 1;   //  ������� callback-� ����� ��� ������������
const EVENT_MOUSE      : integer = 2;   //  ������� callback-� ����� �� ����

//  ����� ������� �� ����
const EM_LBUTTON_CLICK :  integer = $00000001;    //  �������� ����� ��������
const EM_LBUTTON_DOWN  :  integer = $00000002;    //  ���������� ����� �������
const EM_RBUTTON_CLICK :  integer = $00000004;    //  �������� ������ ��������
const EM_RBUTTON_DOWN  :  integer = $00000008;    //  ���������� ����� �������
const EM_MBUTTON_CLICK :  integer = $00000010;    //  �������� ����������� ��������
const EM_MBUTTON_DOWN  :  integer = $00000020;    //  ���������� ����������� �������
//const EM_MWHEEL        :  integer = $00000040;    //  ������ ����������� ������ (�������� � iValue[0])




//////////////   P R O X Y    E N G I N E    F U N C T I O N S     ///////////////

function Get3DEngineVersion() : JtpRes;  stdcall;  external JTPStudioDLL;
//  �������� ������ ������.


Type TEnumVideoDevices = object(TJtpFuncData)
  NumRequestSimulators : integer;  // ���-�� ������������� �����������.

  constructor Create();
end;
PEnumVideoDevices = ^TEnumVideoDevices;

function EnumerateVideoDevices( DeviceType: DWORD;  DevicesNames: PStr256;  Params: DWORD;  pFuncData: PEnumVideoDevices ) : JtpRes;  stdcall;  external JTPStudioDLL;
//  ���������� ����� ����� ����. � ������ ������ ���������� OK.
//  � ��������� DevicesNames ���������� 0.
//  Params:
          const EnumVidDevsNoWarn : DWORD = 1;    //  �� ���������� ��������������, ���� �� ������� ����� ����.



Type TInitVideo = object(TJtpFuncData)
  NumRenderFrames : integer;  //  ���-�� ��������� ������������ ������.

  NumTimingFrames : integer;  //  ���-�� ��������� �������.
  TimingItems : dword;        //  ����� ������� ������ ��������.

  constructor Create();
end;
PInitVideo = ^TInitVideo;

const TIMING_RENDER_WAIT      : dword = $00000001;  // ����� �������� �������, ����� ����� ������� ������� ����.
const TIMING_RENDER           : dword = $00000002;  // ����� ��������� �����.
const TIMING_COPY_DEVICE      : dword = $00000004;  // ����� ����������� ����� �� ����� ������.
const TIMING_RNDR_FILLS       : dword = $00000008;  // ������� ������ ������� ��������.
const TIMING_OUT_SYNCS        : dword = $00000010;  // ����� ������������� �������� �� ������.
const TIMING_WAIT_RNDR_FRAME  : dword = $00000020;  // ������� ������� ���� ������������� �����.
const TIMING_INPUT_READIES    : dword = $00000040;  // ������� ��������� ������� �������.
const TIMING_INPUT_WAITS      : dword = $00000080;  // ������� ������� ������� �����.


function InitVideo( Params: DWORD;  VideoTrunks: PVideoTrunk;  VideoInputProperties: PVideoInputProperties;  pInitVideo: PInitVideo )
                  : JtpRes;  stdcall;  external JTPStudioDLL;
//  ������������� ������������ ����� ������� � �������������� ���������� �� ����� ��� ����.
		//  Params - ������ 0.
		//  VideoTrunks - ������ ����� ������/�����.
		//  pInitVideoDesc - ��������� �� TInitVideo



Type TLoadProjectData = object(TJtpFuncData)
  NumScenes : integer;     // ���������� ���� � �������.
  pSceneNames : PName;     // ����� ����.

  NumVariables : integer;  // ���������� ���������� � �������. ������ �� ������������.
  pProjVarNames : PName;   // ����� ����������.

  constructor Create();
end;
PLoadProjectData = ^TLoadProjectData;

function LoadProject( ProjectPath: PPath;  TexturePathes: PPath;  Params: DWORD;  pLoadProjectData: PLoadProjectData ) : JtpRes;  stdcall;  external JTPStudioDLL;
//  ��������� ������ ����������.
		//  ProjectPath - ���� �������, ��� ��������� ���� � ������ � ���������� �������.
		//  TexturePathes - ���� � ��������� (����, �������� � �.�.). � ��������� TexturePathes ���������� 0.
    //  pLoadProjectData - ��������� �� TLoadProjectData.



Type TErrorsCallbackPtr = function ( pErrors : PAnsiChar;  pReserved : pointer ) : dword;  stdcall;
//  �������, ���� ������� ������ �� ������.

Type TStartEngineData = object(TJtpFuncData)
  constructor Create();
end;
PStartEngineData = ^TStartEngineData;

function StartEngine( SoftVersion: integer;  Params: DWORD;  pErrorsCallback : TErrorsCallbackPtr;  pStartEngineData: PStartEngineData ) : JtpRes;  stdcall;  external JTPStudioDLL;
//  �������� ������.



function CloseEngine( Params: DWORD; pReserved : pointer ) : JtpRes;  stdcall;  external JTPStudioDLL;
//  ��������� ������.
    //  Params - �� ������������.
    //  pReserved - �� ������������.



function OpenRecords( Params: DWORD;  pReserve: pointer ) : JtpRes;  stdcall;  external JTPStudioDLL;
//  ��������� ������ �������� ��� ������.

function CloseRecords( Params: DWORD;  pReserve: pointer ) : JtpRes;  stdcall;  external JTPStudioDLL;
//  ��������� ������ �������� ��� ������.



Type TPlayScene = object(TJtpFuncData)
  SceneName: TName;   //  ��� ��������� �����. �������� ����� ���������� 'MyScene_Trunk1'.
  hPreviewWnds : array[0..MAX_PREVIEW_WINDOWS-1] of HWND;  //  ���� ��� ������.
  Constructor Create;
end;
PPlayScene = ^TPlayScene;

function PlayScene( SceneName: PAnsiChar;  Delay: single;  Mode: dword;  TrunkIndex: integer;  pPlayScene: PPlayScene ) : JtpRes;  stdcall;  external JTPStudioDLL;
//  ��������� �����.
		//  SceneName  - ��� �����.
		//  Delay      - ��������, ����� ����� �������� �� ������.
    //  Mode       - ����� (�� ������������).
    //  TrunkIndex - ������ ������ (�� 1 �� MAX_VIDEO_TRUNKS).
    //  pPlayScene - ��������� �� TPlayScene.



function CloseScene( SceneName: PAnsiChar;  Delay: single;  Flags: dword;  pCloseScene : PJtpFuncData ) : JtpRes;   stdcall; external JTPStudioDLL;
//  ��������� �����.
    //  SceneName  - ��� �����.
		//  Delay - �������� �� �������� �����. ���� FLT_UNDEF - �������� ������ �� ������ �����. ���� Delay=0, ����� ������������ �����������.
    //  Flags - �����, ������ ����.
    //  pCloseScene - ��������� �� TCloseScene.


type
  TSceneFrameFunc = function ( SceneName: PAnsiChar;  Flags: dword;  pEvents: PJtpEvent;  FrameTime: single;  pReserve: pointer ) : JtpRes;  stdcall;

function SetSceneProcessCallback( SceneName: PAnsiChar;  SceneFunc: TSceneFrameFunc;  Flags: dword;  pPlayScene : PJtpFuncData ) : JtpRes;   stdcall; external JTPStudioDLL;
//  ����� ���������������� ������� ��������� �����. ���������� �� ������.



Type TSceneInfo = object(TJtpFuncData)
  NumObjects: integer;       //  ���������� �������� � �����.
  pObjectsNames: PName;      //  ����� ��������.

  NumScenaries: integer;     //  ���������� ��������� � �����.
  pScenariesNames: PName;    //  ����� ���������.

  Constructor Create;
end;
PSceneInfo = ^TSceneInfo;

function GetSceneInfo( SceneName: PAnsiChar;  pSceneInfo: PSceneInfo ) : JtpRes;   stdcall; external JTPStudioDLL;
//  ����������� ������� � �����.
		//  SceneName  - ��� �����.
    //  pSceneInfo - ��������� �� ��������� TSceneInfo. ����� ������ ����� ��������, ��������� � �.�. ���� ����������� ����-����.
    //               �.�. pSceneInfo ����� ������� �� ���������� ������ GetSceneInfo ��� CloseRecords.



Type TObjectInfo = object(TJtpFuncData)
  pObjName : PName;           //  ��� �������.
  ObjectType: integer;        //  ��� �������, ��. ���� �������� � TypesJTP.pas.

  NumAnimations: integer;     //  ���������� �������� � �������.
  pAnimationsNames : PName;   //  ����� �������� �������.

  NumSurfElems : integer;			//  ���������� ��������� �����������.

  Constructor Create;
end;
PObjectInfo = ^TObjectInfo;

function GetObjectInfo( SceneName, ObjectName: PAnsiChar;  pObjectInfo: PObjectInfo ) : JtpRes;   stdcall; external JTPStudioDLL;
//  �������� ���������� �� ������� �����.
    //  SceneName  - ��� �����.
    //  ObjectName - ��� �������.
    //  pObjectInfo - ��������� �� ��������� TObjectInfo. ����� ������� �� ���������� ������ GetObjectInfo ��� CloseRecords.



Type TCloneObject = object(TJtpFuncData)
  ObjectName: TName;   //  ��� ����������� �������.
  Constructor Create;
end;
PCloneObject = ^TCloneObject;

function CloneObject( SceneName, ObjectName: PAnsiChar;  pPos, pOrient, pSize, pColor : PVector;  Delay : single;  Flags: dword;  pCloneObject: PCloneObject )
                     : JtpRes;   stdcall; external JTPStudioDLL;
//  ��������� ������.  ����� �������� ������������ ������������, ���� nil, �� �� ���������.
		//  Delay - �������� ������������.
    //  pPos, pOrient, pSize, pColor - ��������� �� �������. ��������, ������� ������������ ��������� �������.
    //                               - pSize, pColor : ������ � ���� ������ �������.
    //  ���� �����-���� ��������� nil, �� �� �����������. ���� �����-���� ��������� ������� ����� FLT_UNDEF, �� ��������� �� �����������.




Type TSurfElemData = object(TJtpFuncData)
  I : integer;    //  ������ ������ �������� (��� CloneSurfaceElement).
  W : integer;    //  ���������� ����� ������ � ��������. ���� W=1 - �������� ����� ������, 0 - �� ��������.
  H : integer;    //  ���������� ������ ������ � ��������. ���� H=1 - �������� ����� ������, 0 - �� ��������.
  Constructor Create;
end;
PSurfElemData = ^TSurfElemData;

function UpdateSurfaceElement( SceneName, ObjectName: PAnsiChar;  Index, NumTex: integer;  PicturePath : PAnsiChar;  Text: PWideChar;  pColor : PJTPColor;
                               X,Y, W,H: integer;  Delay: single;  Flags: dword;   pUpdateSurfElemData : PSurfElemData ) : JtpRes;   stdcall; external JTPStudioDLL;
//  �������� ������� �����������. ��� ����� ���� ����� ��� ������.
    //  SceneName, ObjectName - ����� ����� � �������.
    //  Index - ����� ���������, NumTex - ����� �������� ������ ������� (����). ������� �� 1-��.
		//  ���� PicturePath <> nil, ����������� ��������.  ���� Text <> nil, ����������� �����.
		//  ���� pColor = nil, �� ���� �� �����������. ���� ��������� ����� ����� FLT_UNDEF, �� �� �����������.
    //  ���� X,Y,W,H �� ����� INT_UNDEF - �������������� �����������.
		//  Delay = FLT_UNDEF - �������� ������ �� ������ �����.
    //  Flags = 0.
    //  pUpdateSurfElemData - ��������� �� TSurfElemData.




function CloneSurfaceElement( SceneName, ObjectName: PAnsiChar;  Index, NumTex: integer;  PicturePath : PAnsiChar;  Text: PWideChar;  pColor : PVector;
															X,Y, W,H : integer;  Delay: single;  Flags: dword;  pCloneSurfElemData : PSurfElemData ) : JtpRes;   stdcall; external JTPStudioDLL;
//  ����������� ������� �����������. ��� ����� ���� ����� ��� ������.
		//  SceneName, ObjectName - ����� ����� � �������.
    //  Index - ����� ��������, �� �������� ���������, NumTex - ����� �������� ������ ������� (����). ������� �� 1-��.
		//  PicturePath - ���� � ��������. ���� nil, ������ �� ������.
    //  Text - ����� �����. ���� nil, ������ �� ������.
    //  ���� pColor = nil, �� ���� ������ �� ������. ���� ��������� ����� ����� FLT_UNDEF, �� ������ �� ������.
    //  X,Y - ���������� ������ �������� (��� ����������, ��� ������������ ������). ���� INT_UNDEF, �� ������� �� ������.
    //  W,H - �������������� ������. ���� INT_UNDEF, �� ������� �� ������.
    //  Delay - �������� �� ������������. (������ �� ������������, ������ 0.0).
    //  Flags - JTP_RELATIVE ��� JTP_ABSOLUTE (����-�� ������������ ������ ��� ����������).
    //  pCloneSurfElemData - ��������� �� TSurfElemData.



function PlayAnimation( SceneName, ObjectName, AnimationName : PAnsiChar;  Delay: single;  AnimFlags: dword;  pPlayAnimation: PJtpFuncData ) : JtpRes;
										    stdcall; external JTPStudioDLL;
//  ��������� �������� � ������� �����. �������� ������� ������� � ���������.
		//  SceneName, ObjectName, AnimationName - ����� �����, ������� � ��������.
    //  Delay - �������� �� ������ ��������. ��� ��������� � ������� ������ �������� � ���������.
    //  pPlayAnimation - ��������� �� TJtpFuncData.



function PlayAnimationSmooth( SceneName, UnitName : PAnsiChar;  Delay: single;  AnimFlags: dword;  pFrom, pTo: PVector;  SmoothType: dword;
											        SmoothFactor: single;  Duration: single;  pPlayAnimation: PJtpFuncData ) : JtpRes;    stdcall; external JTPStudioDLL;
//  ������� � ��������� �������� � ������� �����. �������� ����� ���� � ������� ������� (������� �������� � ����������).
		//  SceneName, ObjectName - ����� ����� � �������.
    //  Delay - �������� �� ������ ��������.
    //  AnimFlags - ����� ��������. ��. ���� �������� � TypesJTP.pas.
    //  pFrom � pTo - ����������� ��������. ���� pFrom=nil, �� ������ �������� ������ �� �������.
    //  SmoothType - ��� ������� �����. ��. ���� ������ ������ � TypesJTP.pas.
    //  SmoothFactor - ������� ��������.
    //  Duration - ������������ ��������.
    //  pPlayAnimation - ��������� �� TJtpFuncData.



function PlayScenario( SceneName, ScenarioName : PAnsiChar;  Delay: single;  Flags: dword;  pPlayScenario: PJtpFuncData ) : JtpRes;   stdcall; external JTPStudioDLL;
//  ��������� �������� �����.
		//  SceneName - ����� �����.
    //  ScenarioName - ��� ��������.
    //  Delay - �������� �� ������������. ���� FLT_UNDEF, �������� ������ �� �����.
    //  Flags - �� ������������.
    //  pPlayScenario - ��������� �� TJtpFuncData.



Type TSetObjectSpace = object(TJtpFuncData)
  BillboardRingShift : single;  // ����� ��������� �� ������ (� JtpDesigner-� billboarding -> ViewOffset). FLT_UNDEF - �� ������������.
  Constructor Create;
end;
PSetObjectSpace = ^TSetObjectSpace;


function SetObjectSpace( SceneName, ObjectName: PAnsiChar;  pPos, pOrient, pSize, pDir, pTarget : PVector;  pColor : PJTPColor;  Delay: single;
												 Flags: dword;  pSetObjectSpace: PSetObjectSpace ) : JtpRes;   stdcall; external JTPStudioDLL;
//  ���������� ���������������� ����-�� �������. ��� �������, ����������, ������, �����������, ����.
		//  SceneName, ObjectName - ����� ����� � �������.
    //  pPos, pOrient, pSize - �������, ���������� � ������ ��������������. ���� nil, �� ������ �� �����������.
    //                         ���� ��������� ������� ����� FLT_UNDEF, �� �� �����������.
    //  pDir - �����������. ���� nil, �� ������ �� �����������. ���� ��������� ������� ����� FLT_UNDEF, �� �� �����������.
    //			   (������ �� ������������).
    //  pTarget - �����, ���� ������� ������. ���� nil, �� ������ �� �����������. ���� ��������� ������� ����� FLT_UNDEF, �� �� �����������.
    //         (������ �� ������������).
    //  pColor - ���� �������. ���� nil, �� ���� �� �����������. ���� ��������� ����� ����� FLT_UNDEF, �� �� �����������.
    //  Delay - �������� �� ��������� ��������� ��� �����.
    //  Flags - JTP_RELATIVE ��� JTP_ABSOLUTE - ����-�� ������������� ��� ����������.
    //  pSetObjectSpace - ��������� �� TSetObjectSpace.



function GetObjectSpace( SceneName, ObjectName: PAnsiChar;  pPos, pOrient, pSize, pDir, pTarget : PVector;  pColor : PJTPColor;
												 Flags: dword;  pGetObjectSpace: PJtpFuncData ) : JtpRes;   stdcall; external JTPStudioDLL;
//  �������� ���������������� ����-�� �������.
    //  ��������� ��� � SetObjectSpace.



function SetObjectTexture( SceneName, ObjectName: PAnsiChar;  TexturePath: PPath;  NumTex : integer;  Delay: single;
                           Flags: dword;  pSetObjectTexture: PJtpFuncData ) : JtpRes;   stdcall; external JTPStudioDLL;
//  ���������� ������� ����� ��������.
    //  SceneName, ObjectName - ����� ����� � �������.
    //  TexturePath - ���� � ��������. ���� �������� �� ���������, ��� ���������� � �����.
    //  NumTex - ����� �������� ������ ������� (����). ������������� ������ 1.
    //  Delay - �������� �� ��������� ��������.
    //  Flags - �� ������������.
    //  pSetObjectTexture - ��������� �� TJtpFuncData.



function OutInputPictureToTrunk( InputDeviceIndex: integer;  TrunkIndex: integer;  Enable: integer;  Flags: dword;  pOutIPtoTrunk: PJtpFuncData ) :
                                 JtpRes;   stdcall; external JTPStudioDLL;
//  ������ ������� �������� �� ����� ������.
//  DeviceIndex - ����� �������� ����������.
//  TrunkIndex - ����� ��������� ������.
//  Enable - 1/0 ���/���� ������.
//  Flags:
           const OIP_SHOW_ONLY_WINDOW : DWORD = $00000001;  //  ������� �������� ������� ������ � ���� play out ������.
           const OIP_HIDE_ALPHA : DWORD       = $00000002;  //  ����� ������� �������� ���������, �������� ������ ����.
//  pOutIPtoTrunk - ���������.




/////////////    � � � � � �   �   � � � � � � � � �   /////////////////////////

function  LoadPlugin( Path : PPath;  PluginJTP : PPluginJTP ) : JtpRes;   stdcall; external JTPStudioDLL;
//  ��������� ������ �� dll ����������.
//  Path - ���� � ����������.
//  PluginJTP - ������������ �������: ���, ������ � �.�.


function  SendPluginCommand( PluginName : PAnsiChar;  Command : PAnsiChar;  pSendPluginCommand: PJtpFuncData ) : JtpRes;   stdcall; external JTPStudioDLL;
//  ������� ������� �������.
//  PluginName - ��� �������.
//  Command - ��������� ������� (����� �� ����������).



//function  SetPluginCallBack( PluginName, CallbackName : PAnsiChar;  pFunc: pointer;  SetPluginCallBackPtr : PJtpFuncData ) :
//                             JtpRes;   stdcall; external JTPStudioDLL;
//  ��������� callback �������. ����������� ��� �������, ��� callback-� � ��������� �� ����.


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
