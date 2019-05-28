unit PluginJTP;

interface

uses
  Windows, TypesJTP, VideoSetsHeader;


/////////////////////   � � � � � � �    � � � � � �  /////////////////////////

Type TPluginJTP = object           //  ������� ��������� ��� �������� � ������������� ��������
   Version : integer;              //  ������
   Kind    : integer;              //  ��� �������
   Size    : integer;              //  ������ � ������.
   ipack1  : integer;
   pErrorsStr : PAnsiChar;         //  ������ � �������.
   Constructor Create;
end;
type PPluginJTP = ^TPluginJTP;

/////////////////////////////////////////////////////////////////


//////////////   � � � �   � � � � � � � �   ///////////////
const JTP_PLUG_Empty = 0;
const JTP_PLUG_MultiScreens   = 100;
const JTP_PLUG_VideoPlayer    = 101;
const JTP_PLUG_TankBiathlon   = 102;



/////////////  ������ ��� ����� ������  ////////////
///

Type TPlayerVideoInfo = record
   Version        : integer;                      //  ������ TVideoInfo.
   Size           : integer;                      //  ������ � ������ TVideoInfo.

   PlayerIndex    : integer;                      //  ����� ������.
   VideoIndex     : integer;                      //  ����� ����� ����� � ������.

   VideoCodecName : Str256;                       //  ��� ����� ������.
   VideoW, VideoH : integer;                      //  ������ ����� �����.
   FPS            : single;                       //  FPS.
   Bitrate        : single;                       //  ������� � ����/�.
   Duration       : integer;                      //  ������������ � ���� ��������.

   PreviewPixels  : pbyte;                        //  ������ ������, ������ ������� = PreviewW * PreviewH * 4. RGBA.
   PreviewW, PreviewH : integer;                  //  ������ ������.

   AudioCodecName : Str256;                       //  ��� ����� ������.
   Channels       : integer;                      //  ������� �����.
   Frequency      : integer;                      //  ������� �������������.
   SampleBits     : integer;                      //  ��� �� ���� �����.

   procedure Init();
end;
   type PPlayerVideoInfo = ^TPlayerVideoInfo;


Type TVideoPlayerCallbackFunc = function ( VideoInfo : PPlayerVideoInfo ) : JtpRes;  stdcall;


Type TPluginVideoPlayers = object(TPluginJTP)

  NumPlayers : integer;
  Trunks : array [0..MAX_VIDEO_TRUNKS-1] of integer;    //  ����� ������, ���� ��������� ����� � ������� ������.

  pStartVideoFunction : TVideoPlayerCallbackFunc;       //  Callback ����� ����������� �����.
  pNewVideoPropsFunction : TVideoPlayerCallbackFunc;    //  Callback ����� ����������� ����� �����.
  Constructor Create;
end;
////////////////////////////////////////////////////




/////////////  ������ ��� ��������� ��������  ////////////
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



////////////////  ������ ��� ����� ������  ///////////////

Constructor TPluginVideoPlayers.Create();
var i : integer;
begin
  TPluginJTP.Create();   // ��� ������� ����������� ������ ���������?

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





/////////////  ������ ��� ��������� ��������  ////////////

Constructor TPluginTankBiathlon.Create();
begin
  TPluginJTP.Create();

  Kind := JTP_PLUG_TankBiathlon;
  Size := sizeof( TPluginTankBiathlon );
end;

//////////////////////////////////////////////////////////

end.
