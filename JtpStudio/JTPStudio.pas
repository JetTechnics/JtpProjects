unit JTPStudio;

interface

uses
  Windows,
  TypesJTP, Decklink, PluginJTP, Vector;


const  JTPStudioPath = 'C:\Program Files\JTPStudio\';
const  JTPStudioDLL = JTPStudioPath + 'JTPStudioNew.dll';


const  MAX_VIDEO_DEVICES = 16;    //  ������������ ���-�� ����� ���������.
const  LAST_VIDEO_DEVICE = MAX_VIDEO_DEVICES - 1;

const  MAX_VIDEO_TRUNKS = 4;    //  ������������ ���-�� �������.
const  LAST_VIDEO_TRUNK = MAX_VIDEO_TRUNKS - 1;

const  MAX_PREVIEW_WINDOWS = 4;


//     Video device types.
const  DECKLINK_VIDEO_DEVICE      : DWORD = $00000001;
const  BLUEFISH_VIDEO_DEVICE      : DWORD = $00000002;
const  MATROX_VIDEO_DEVICE        : DWORD = $00000004;
const  DIRECTSHOW_VIDEO_DEVICE    : DWORD = $00000008;
const  SIMULATOR_VIDEO_DEVICE     : DWORD = $00000010;



//   VideoTrunk. ����� ����� ������.
Type TVideoTrunk = record

  Size               : integer;    //  ������ ���-�� TVideoTrunk.

//  ScreensLayout      : integer;    //  ������������ ������� � ������: 1� ������ (TrunkScreens_1x1), 2�1 ������� (TrunkScreens_2x1) � �.�.
  ScreensHorizontal  : integer;    //  ���-�� ������� �� �����������.
  ScreensVertical    : integer;    //  ���-�� ������� �� ���������.

  ScreensRotate      : integer;    //  �������� ������. ��������, TrunkVideo_90R � �.�.

  Flags              : integer;    //  ��������� �����. ��������, TrunkVideo_SD_16_9 � �.�.

  OutputDisplayMode  : integer;    //  ����� ����� ������. ��������, bmdModeHD1080i50, bmdModePAL � �.�.
  OutputPixelFormat  : integer;    //  ������ ������� �� �����. ��������, bmdFormat8BitBGRA  � �.�.
  hOutWindow         : HWND;       //  ���� ������ ����� ��������.

  InputDisplayMode   : integer;    //  ����� ������� �����. ��������, bmdModeHD1080i50, bmdModePAL � �.�.
  InputPixelFormat   : integer;    //  ������ ������� �� ����. ��������, bmdFormat8BitBGRA  � �.�.

  AlphaChannelTrunk  : integer;    //  ������ ������, ������������� ��� �����-�����. -1 - �� ������������.

  GpuIndex           : integer;    //  ����� GPU � ������� ������������ ��� ������� ������.

  pExtensions        : pointer;    //  ���������� ��� ������������� ���������. ��������, ��������� VideoCapture (������ �� ����� �����)

  OutDevices   : array [0..LAST_VIDEO_DEVICE] of integer;
  InputDevices : array [0..LAST_VIDEO_DEVICE] of integer;

  Reserves     : array [0..127] of integer;   //  ������.

  FrameWidthFactor   : integer;    //  �� ������������.
  Rect               : TJTPRect;      //  �� ������������.
  pWindowRender      : pointer;    //  �� ������������.

  procedure ClearForDecklink();
end;

PVideoTrunk = ^TVideoTrunk;


//    �������� ������� � ������ (��� TVideoTrunk.ScreensRotate).
const TrunkScreens_90R    : integer = $00000001;   //  ����������� ������.
const TrunkScreens_90L    : integer = $00000002;   //  ����������� �����.
const TrunkScreens_180    : integer = $00000004;   //  ����������� �� 180 ��������.

//    ����� ��� TVideoTrunk.Flags
const TrunkVideo_SD_16_9      : integer = $00000001;   //  ����� SD (PAL 4/3) ������������� �� 16/9.
const TrunkVideo_KeyPass      : integer = $00000002;   //  ����� �� ������.
const TrunkVideo_VertBlur     : integer = $00000004;   //  ������ ������������ ���� (��� ����� ��� �����).
const TrunkVideo_ProcessMouse : integer = $00000008;   //  ����� ������� �� ���� � ����, � �������� ��������� ��� ����.

//    ����� GPU �� ��������� ��� �������.
const TrunkVideo_GpuDefault : integer = -1;


Type PHWnd = ^HWND;


const MaxErrorString = 4096;

Type TJtpFuncData = object
  pErrorsStr : PAnsiChar;
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

function Get3DEngineVersion() : UInt64;  stdcall;  external JTPStudioDLL;
//  �������� ������ ������.



function EnumerateVideoDevices( DeviceType: DWORD;  DevicesNames: PStr256;  Params: DWORD;  pFuncData: pointer ) : UInt64;  stdcall;  external JTPStudioDLL;
//  ���������� ����� ����� ����. � ������ ������ ���������� OK.
//  � ��������� DevicesNames ���������� 0.
//  Params:
          const EnumVidDevsNoWarn : DWORD = 1;    //  �� ���������� ��������������, ���� �� ������� ����� ����.



function InitVideo( VideoTrunks: PVideoTrunk;  Params: DWORD;  pInitVideoDesc: pointer) : UInt64;  stdcall;  external JTPStudioDLL;
//  ������������� ������������ ����� ������� � �������������� ���������� � ���.
		//  VideoTrunks - ������ ����� ������/�����.
		//  Params - �� ������������
		//  pInitVideoDesc - ��������� ��
  		  type TInitVideoDesc = record
	    		Version : integer;          //  ������.
	    		VerticalBlur : single;      //  ���� �������� ��� interlaced-����������.
		    	ScreenAlpha : single;       //  ������������ ���� ��������.
	  	    ClearColor : dword;
          pErrorsStr : PAnsiChar;     //  ����� ������, ���� ���������.
		    end;



function LoadProject( ProjectPath: PPath;  TexturePathes: PPath;  Params: DWORD;  pLoadProjectData: pointer ) : UInt64;  stdcall;  external JTPStudioDLL;
//  ��������� ������ ����������.
		//  ProjectPath - ���� �������, ��� ��������� ���� � ������ � ���������� �������.
		//  TexturePathes - ���� � ��������� (����, �������� � �.�.). � ��������� TexturePathes ���������� 0.
    //  pLoadProjectData - ��������� �� TJtpLoadProjectData.
        Type TJtpLoadProjectData = object(TJtpFuncData)
          NumScenes : integer;     // ���������� ���� � �������.
					pSceneNames : PName;     // ����� ����.
          NumVariables : integer;  // ���������� ���������� � �������. ������ �� ������������.
					pProjVarNames : PName;   // ����� ����������.
        end;



Type
  TErrorsCallbackPtr = function ( pErrors : PAnsiChar;  pReserved : pointer ) : dword;  stdcall;

function StartEngine( Version: integer;  Params: DWORD;  pErrorsCallback : TErrorsCallbackPtr;  pStartEngineData: pointer ) : UInt64;  stdcall;  external JTPStudioDLL;
//  �������� ������.
		//  Version = 1.


function CloseEngine( Params: DWORD ) : UInt64;  stdcall;  external JTPStudioDLL;
//  ��������� ������.
    //  Params - �� ������������.



function OpenRecords( Params: DWORD;  pReserve: pointer ) : UInt64;  stdcall;  external JTPStudioDLL;
//  ��������� ������ �������� ��� ������.

function CloseRecords( Params: DWORD;  pReserve: pointer ) : UInt64;  stdcall;  external JTPStudioDLL;
//  ��������� ������ �������� ��� ������.



function PlayScene( SceneName: PAnsiChar;  Delay: single;  Mode: dword;  TrunkIndex: integer;  pPlaySceneData: pointer ) : UInt64;  stdcall;  external JTPStudioDLL;
//  ��������� �����.
		//  SceneName  - ��� �����.
		//  Delay      - ��������, ����� ����� �������� �� ������.
    //  Mode       - ����� (�� ������������).
    //  TrunkIndex - ������ ������ (�� 1 �� MAX_VIDEO_TRUNKS).
    //  pPlaySceneData - ��������� �� TPlaySceneData.

		Type TPlaySceneData = object(TJtpFuncData)
		  SceneName: TName;   //  ��� ��������� �����. �������� ����� ���������� 'MyScene_Trunk1'.
		  hPreviewWnds : array[0..MAX_PREVIEW_WINDOWS-1] of HWND;  //  ���� ��� ������.
      Constructor Create;
		end;
    PPlaySceneData = ^TPlaySceneData;


function CloseScene( SceneName: PAnsiChar;  Delay: single;  pCloseSceneData : PJtpFuncData ) : UInt64;   stdcall; external JTPStudioDLL;
//  ��������� �����.
    //  SceneName  - ��� �����.
		//  Delay - �������� �� �������� �����. ���� FLT_UNDEF - �������� ������ �� ������ �����.
    //  pCloseSceneData - �������� �� TJtpFuncData.


type
  TSceneFrameFunc = function ( SceneName: PAnsiChar;  Flags: dword;  pEvents: PJtpEvent;  FrameTime: single;  pReserve: pointer ) : UInt64;  stdcall;

function SetSceneProcessCallback( SceneName: PAnsiChar;  SceneFunc: TSceneFrameFunc;  Flags: dword;  pPlaySceneData : PJtpFuncData ) : UInt64;   stdcall; external JTPStudioDLL;
//  ����� ���������������� ������� ��������� �����. ���������� �� ������.



function GetSceneInfo( SceneName: PAnsiChar;  pSceneInfoData: pointer ) : UInt64;   stdcall; external JTPStudioDLL;
//  ����������� ������� � �����.
		//  SceneName  - ��� �����.
    //  pSceneInfoData - ��������� �� ��������� TSceneInfoData. ����� ������ ����� �������� ���� ����������� ����-����.
		//																													�.�. pSceneInfoData ����� �� ������� ����� CloseRecords.

    Type TSceneInfoData = object(TJtpFuncData)
      NumObjects: integer;       //  ���������� �������� � �����.
		  pObjectsNames: PName;      //  ����� ��������.

      NumScenaries: integer;     //  ���������� ��������� � �����.
      pScenariesNames: PName;    //  ����� ���������.
      Constructor Create;
		end;



function GetObjectInfo( SceneName, ObjectName: PAnsiChar;  pObjectInfoData: pointer ) : UInt64;   stdcall; external JTPStudioDLL;
//  �������� ���������� �� ������� �����.
    //  SceneName  - ��� �����.
    //  ObjectName - ��� �������.
    //  pObjectInfoData - ��������� �� ��������� TObjectInfoData. ����� �� ������� ����� CloseRecords.

    Type TObjectInfoData = object(TJtpFuncData)
      pObjName : PName;           //  ��� �������.
      ObjectType: integer;        //  ��� �������, ��. ���� �������� � TypesJTP.pas.

      NumAnimations: integer;     //  ���������� �������� � �������.
      pAnimationsNames : PName;   //  ����� �������� �������.

      NumSurfElems : integer;			//  ���������� ��������� �����������.
    end;



function CloneObject( SceneName, ObjectName: PAnsiChar;  pPos, pOrient, pSize, pColor : PVector;  Delay : single;  Flags: dword;  pCloneObjectData: pointer ) : UInt64;   stdcall; external JTPStudioDLL;
//  ��������� ������.  ����� �������� ������������ ������������, ���� nil, �� �� ���������.
		//  Delay - �������� ������������.
    //  pPos, pOrient, pSize, pColor - ��������� �� �������. ��������, ������� ������������ ��������� �������.
    //                               - pSize, pColor : ������ � ���� ������ �������.
    //  ���� �����-���� ��������� nil, �� �� �����������. ���� �����-���� ��������� ������� ����� FLT_UNDEF, �� ��������� �� �����������.

    Type TCloneObjectData = object(TJtpFuncData)
		  ObjectName: TName;   //  ��� ����������� �������.
      Constructor Create;
		end;
    PCloneObjectData = ^TCloneObjectData;



function UpdateSurfaceElement( SceneName, ObjectName: PAnsiChar;  Index, NumTex: integer;  PicturePath : PAnsiChar;  Text: PWideChar;  pColor : PJTPColor;
                               X,Y, W,H: integer;  Delay: single;  Flags: dword;   pUpdateSurfElemData : pointer ) : UInt64;   stdcall; external JTPStudioDLL;
//  �������� ������� �����������. ��� ����� ���� ����� ��� ������.
    //  SceneName, ObjectName - ����� ����� � �������.
    //  Index - ����� ���������, NumTex - ����� ��������. ������� �� 1-��.
		//  ���� PicturePath <> nil, ����������� ��������.  ���� Text <> nil, ����������� �����.
		//  ���� pColor = nil, �� ���� �� �����������. ���� ��������� ����� ����� FLT_UNDEF, �� �� �����������.
    //  ���� X,Y,W,H �� ����� INT_UNDEF - �������������� �����������.
		//  Delay = FLT_UNDEF - �������� ������ �� ������ �����.
    //  Flags = 0.
    //  pUpdateSurfElemData - ��������� �� TSurfElemData.

    Type TSurfElemData = object(TJtpFuncData)
      I : integer;    //  ������ ������ �������� (��� CloneSurfaceElement).
      W : integer;    //  ���������� ����� ������ � ��������. ���� W=1 - �������� ����� ������, 0 - �� ��������.
      Constructor Create;
    end;
    PSurfElemData = ^TSurfElemData;



function CloneSurfaceElement( SceneName, ObjectName: PAnsiChar;  Index, NumTex: integer;  PicturePath : PAnsiChar;  Text: PWideChar;  pColor : PVector;
															X,Y, W,H : integer;  Delay: single;  Flags: dword;  pCloneSurfElemData : pointer ) : UInt64;   stdcall; external JTPStudioDLL;
//  ����������� ������� �����������. ��� ����� ���� ����� ��� ������.
		//  SceneName, ObjectName - ����� ����� � �������.
    //  Index - ����� ��������, �� �������� ���������, NumTex - ����� ��������. ������� �� 1-��.
		//  PicturePath - ���� � ��������. ���� nil, ������ �� ������.
    //  Text - ����� �����. ���� nil, ������ �� ������.
    //  ���� pColor = nil, �� ���� ������ �� ������. ���� ��������� ����� ����� FLT_UNDEF, �� ������ �� ������.
    //  X,Y - ���������� ������ �������� (��� ����������, ��� ������������ ������). ���� INT_UNDEF, �� ������� �� ������.
    //  W,H - �������������� ������. ���� INT_UNDEF, �� ������� �� ������.
    //  Delay - �������� �� ������������. (������ �� ������������, ������ 0.0).
    //  Flags - JTP_RELATIVE ��� JTP_ABSOLUTE (����-�� ������������ ������ ��� ����������).
    //  pCloneSurfElemData - ��������� �� TSurfElemData.



function PlayAnimation( SceneName, ObjectName, AnimationName : PAnsiChar;  Delay: single;  AnimFlags: dword;  pPlayAnimationData: pointer ) : UInt64;
										    stdcall; external JTPStudioDLL;
//  ��������� �������� � ������� �����. �������� ������� ������� � ���������.
		//  SceneName, ObjectName, AnimationName - ����� �����, ������� � ��������.
    //  Delay - �������� �� ������ ��������. ��� ��������� � ������� ������ �������� � ���������.
    //  pPlayAnimationData - ��������� �� TJtpFuncData.



function PlayAnimationSmooth( SceneName, UnitName : PAnsiChar;  Delay: single;  AnimFlags: dword;  pFrom, pTo: PVector;  SmoothType: dword;
											        SmoothFactor: single;  Duration: single;  pPlayAnimationData: pointer ) : UInt64;    stdcall; external JTPStudioDLL;
//  ������� � ��������� �������� � ������� �����. �������� ����� ���� � ������� ������� (������� �������� � ����������).
		//  SceneName, ObjectName - ����� ����� � �������.
    //  Delay - �������� �� ������ ��������.
    //  AnimFlags - ����� ��������. ��. ���� �������� � TypesJTP.pas.
    //  pFrom � pTo - ����������� ��������. ���� pFrom=nil, �� ������ �������� ������ �� �������.
    //  SmoothType - ��� ������� �����. ��. ���� ������ ������ � TypesJTP.pas.
    //  SmoothFactor - ������� ��������.
    //  Duration - ������������ ��������.
    //  pPlayAnimationData - ��������� �� TJtpFuncData.



function PlayScenario( SceneName, ScenarioName : PAnsiChar;  Delay: single;  Flags: dword;  pPlayScenario: PJtpFuncData ) : UInt64;   stdcall; external JTPStudioDLL;
//  ��������� �������� �����.
		//  SceneName - ����� �����.
    //  ScenarioName - ��� ��������.
    //  Delay - �������� �� ������������. ���� FLT_UNDEF, �������� ������ �� �����.
    //  Flags - �� ������������.
    //  pPlayScenario - ��������� �� TJtpFuncData.



function SetObjectSpace( SceneName, ObjectName: PAnsiChar;  pPos, pOrient, pSize, pDir, pTarget : PVector;  pColor : PJTPColor;  Delay: single;
												 Flags: dword;  pSetObjectSpace: PJtpFuncData ) : UInt64;   stdcall; external JTPStudioDLL;
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
    //  pSetObjectSpace - ��������� �� TJtpFuncData.


function GetObjectSpace( SceneName, ObjectName: PAnsiChar;  pPos, pOrient, pSize, pDir, pTarget : PVector;  pColor : PJTPColor;
												 Flags: dword;  pGetObjectSpaceData: PJtpFuncData ) : UInt64;   stdcall; external JTPStudioDLL;
//  �������� ���������������� ����-�� �������.
    //  ��������� ��� � SetObjectSpace.



function SetObjectTexture( SceneName, ObjectName: PAnsiChar;  TexturePath: PPath;  TexIndex : integer;  Delay: single;
                           Flags: dword;  pSetObjectTexture: PJtpFuncData ) : UInt64;   stdcall; external JTPStudioDLL;
//  ���������� ������� ����� ��������.
    //  SceneName, ObjectName - ����� ����� � �������.
    //  TexturePath - ���� � ��������. ���� �������� �� ���������, ��� ���������� � �����.
    //  TexIndex - ����� �������� ������ �������. ������������� ������ 1.
    //  Delay - �������� �� ��������� ��������.
    //  Flags - �� ������������.
    //  pSetObjectTexture - ��������� �� TJtpFuncData.





/////////////    � � � � � �   �   � � � � � � � � �   /////////////////////////

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
