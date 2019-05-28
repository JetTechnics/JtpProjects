unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.AnsiStrings,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  TypesJTP, JTPStudio, Vector, VideoSetsHeader, PluginJTP, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdFTP, Vcl.CheckLst, Vcl.Buttons;

type
  TMainForm = class(TForm)
    StartButton: TButton;
    SimOutBox: TCheckBox;
    LogListBox: TListBox;
    PlayerBox1: TGroupBox;
    VideoList1: TCheckListBox;
    OutVideoPanel1: TPanel;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);

    procedure AddPlaylist();

    procedure SendCmd(SendTo, Cmd : AnsiString);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

  SoftVersion : integer = 1;

  VideoSets : TVideoSets;

  NumPlayers : integer = 0;

  VPPlugin : TPluginVideoPlayers;

  function VideoCloseSetsFunc( Flags: integer;  VideoSets: PVideoSets ) : integer;  stdcall;

  procedure AddErrorStrings( pErrors : PAnsiChar );

  function  ErrorsFunctionCB( pErrors : PAnsiChar;  pReserved : pointer ) : DWORD;  stdcall;

  function  StartNewVideoFunction( VideoInfo : PPlayerVideoInfo ) : JtpRes;  stdcall;
  function  NewVideoPropsFunction( VideoInfo : PPlayerVideoInfo ) : JtpRes;  stdcall;


implementation

{$R *.dfm}

procedure TMainForm.StartButtonClick(Sender: TObject);
var
  EngineVersion : integer;
  hVideoSetsDll : HMODULE;

  pGetVersionFunc : TGetVersionVideoSetsFunc;
  pStartFunc : TVideoStartSetsFunc;
  Res, i, Version : integer;
begin
  StartButton.Enabled := false;

  VideoSets.Clear();
  VideoSets.NumRequestTrunks := 1;  // покажем 1 ствол на панели видео настроек. Все остальные стволы будут иметь идентичные настройки.

  //  Симуляторы видео ввода/вывода
  if( SimOutBox.Checked ) then
    VideoSets.SimulatorOutput := 1;

  EngineVersion := Get3DEngineVersion();

  // Загрузим dll, показывающую окно видео настроек.
  hVideoSetsDll := LoadLibrary( JTPStudioPath + 'VideoSettings.dll' );
  if( hVideoSetsDll <> 0 ) then begin

    // Получим версию окна видео настроек.
    pGetVersionFunc := GetProcAddress( hVideoSetsDll, 'GetVersionVideoSets' );
    if( @pGetVersionFunc <> nil ) then begin
      Version := pGetVersionFunc( 0, nil );
    end;

    // Функция, запускающая окно видео настроек.
    pStartFunc := GetProcAddress( hVideoSetsDll, 'VideoStartSets' );
    if( @pStartFunc <> nil ) then begin

      // VideoCloseSetsFunc вызвается при закрытии окна видео настроек.
      Res := pStartFunc( 0, Application, @VideoSets, VideoCloseSetsFunc, nil );
      if( Res <> 0 ) then begin
      end;
    end;
  end;

end;



function VideoCloseSetsFunc( Flags: integer;  VideoSets: PVideoSets ) : integer;  stdcall;
var
  Res : JtpRes;
  ProjectPath : array[0..1] of TPath;
  Textures : array [0..1023] of TPath;
  LoadProjectData : TLoadProjectData;
  StartEngineData : TStartEngineData;
  InitVideoData : TInitVideo;
  tex, i : integer;
  str : string;
  Panel : TPanel;
  CurrDir : AnsiString;
  PluginPath : TPath;
  SetPluginCB : TJtpFuncData;
begin

  LoadProjectData.Create();
  StartEngineData.Create();
  InitVideoData.Create();

  //  Пройдём по выбранным стволам. Назначим окна для видеовывода.
  for i := 0 to VideoSets.NumRequestTrunks do begin

    str := 'OutVideoPanel' + IntToStr(i+1);
    Panel := TPanel( MainForm.FindChildControl(str) );
    if( Panel <> nil ) then begin
      VideoSets.Trunks[i].hOutWindow := Panel.Handle;
    end;
  end;

  //  Измерение производительности движка.
  InitVideoData.NumTimingFrames := 300;
  InitVideoData.TimingItems := TIMING_RENDER_WAIT or TIMING_RENDER or TIMING_COPY_DEVICE or TIMING_RNDR_FILLS or
                               TIMING_OUT_SYNCS or TIMING_WAIT_RNDR_FRAME or TIMING_INPUT_READIES or TIMING_INPUT_WAITS;

  //  Инициализируем видео.
  Res := InitVideo( 0, @VideoSets.Trunks, @VideoSets.InputProperties, @InitVideoData );
  if( Res <> JTP_OK ) then begin

    if( InitVideoData.pErrorsStr <> nil ) then begin
      MessageDlg(InitVideoData.pErrorsStr, mtError, [mbOk], 0);
    end;

    Exit;
  end;

  // Проект ВидеоПлеер.
  CurrDir := GetCurrentDir() + '\Resources\VideoPlayer.txt';
  System.AnsiStrings.StrCopy( ProjectPath[0].text, PAnsiChar(CurrDir) );
  ProjectPath[1].text := '';

  // текстуры, загружаемые в проект.
  tex := 0;
  Textures[tex].text[0] := #0;

  // Загрузим проект со сценами, текстурами и т.д.
  Res := LoadProject( @ProjectPath, @Textures, 0, @LoadProjectData );
  if( Res <> JTP_OK ) then begin
  	AddErrorStrings( LoadProjectData.pErrorsStr );
    MessageDlg('Ошибка при загрузке проекта.', mtError, [mbOk], 0);
    VideoCloseSetsFunc := -1;
  end;

  // Запустим движёк.
  Res := StartEngine( SoftVersion, 0, ErrorsFunctionCB, @StartEngineData );
  if( Res <> JTP_OK ) then begin
    AddErrorStrings( StartEngineData.pErrorsStr );
    MessageDlg('Ошибка запуска графического движка.', mtError, [mbOk], 0);
    VideoCloseSetsFunc := -2;
  end;

  //  Настроим плагин.
  VPPlugin.Create();

  //  Callback-и
  VPPlugin.pStartVideoFunction := StartNewVideoFunction;
  VPPlugin.pNewVideoPropsFunction := NewVideoPropsFunction;

  VPPlugin.NumPlayers := 1;
  //  У каждого плеера свой ствол выдачи видео.
  VPPlugin.Trunks[0] := 1;
  //Plugin.Trunks[1] := 2;

  //  Загрузим плагин
  OpenRecords( 0, nil );

  PluginPath.text := 'C:\Program Files\JTPStudio\Plugins\VideoPlayers\VideoPlayers.dll';
  Res := LoadPlugin( @PluginPath, @VPPlugin );
  if( Res <> JTP_OK ) then begin
    AddErrorStrings( VPPlugin.pErrorsStr );
  end;

  CloseRecords( 0, nil );

  MainForm.AddPlaylist();
end;



procedure TMainForm.AddPlaylist();
var player, video : integer;
  PlayerBox : TGroupBox;
  VideoList : TCheckListBox;
  GuiStr, str : string;
  Command, PlayerStr, VideoPath  : AnsiString;
begin
  //  Загрузим видео файлы для каждого плеера.
  OpenRecords( 0, nil );

  //  Пройдём по GroupBox-ам плееров.
  for player := 1 to VPPlugin.NumPlayers do begin

    PlayerStr := 'player: ' + IntToStr(player);

    //  Внутри GroupBox-а плеера пройдём по строкам в TCheckListBox-е.
    GuiStr := 'PlayerBox' + IntToStr(player);
    PlayerBox := TGroupBox( MainForm.FindChildControl(GuiStr) );
    if( PlayerBox <> nil ) then begin

      GuiStr := 'VideoList' + IntToStr(player);
      VideoList := TCheckListBox( PlayerBox.FindChildControl(GuiStr) );
      if( VideoList <> nil ) then begin

        for video := 0 to  VideoList.Items.Count-1 do begin

          str := VideoList.Items[video];

VideoList.Checked[video] := true;
VideoPath := 'C:/videos/' + str;

          Command := 'cmd: {  ' + PlayerStr + '  add_video: "' + VideoPath + '"';
          if( VideoList.Checked[video] ) then
            Command := Command + '  enabled } '
          else
            Command := Command + '  disabled } ';

          SendCmd('VideoPlayers', Command);
        end;
      end;
    end;
  end;

  CloseRecords( 0, nil );
end;



procedure TMainForm.SendCmd(SendTo, Cmd : AnsiString);
var
  PluginName, Command : PAnsiChar;
  FuncData : TJtpFuncData;
  Res : integer;
begin
  FuncData.Create();

  //LogListBox.AddItem(SendTo  + ': ' + cmd, nil);
  //LogListBox.ItemIndex := LogListBox.Items.Count-1;

  PluginName := PAnsiChar(SendTo + #0);
  Command    := PAnsiChar(Cmd + #0);
  Res := SendPluginCommand(PluginName, Command, @FuncData);
  if( Res <> JTP_OK ) then begin
    AddErrorStrings( FuncData.pErrorsStr );
  end;
end;



procedure AddErrorStrings( pErrors : PAnsiChar );
var L : integer;
begin
	if( pErrors = nil ) then exit;

  while( pErrors[0] <> #0 ) do begin
	  MainForm.LogListBox.Items.Add( String(pErrors) );
    L := System.AnsiStrings.StrLen( pErrors );
    pErrors := pErrors + L + 1;
  end;
end;



//  Функция-callback. Вызывается из графического движка, если есть какие-либо ошибки.
function  ErrorsFunctionCB( pErrors : PAnsiChar;  pReserved : pointer ) : DWORD;  stdcall;
var L : integer;
Begin
	while( pErrors[0] <> #0 ) do begin
    L := System.AnsiStrings.StrLen( pErrors );
    pErrors := pErrors + L + 1;
  end;

  ErrorsFunctionCB := 0;
End;



function  StartNewVideoFunction( VideoInfo : PPlayerVideoInfo ) : JtpRes;  stdcall;
begin
  StartNewVideoFunction := 0;
end;



function  NewVideoPropsFunction( VideoInfo : PPlayerVideoInfo ) : JtpRes;  stdcall;
begin
  NewVideoPropsFunction := 0;
end;



procedure TMainForm.FormCreate(Sender: TObject);
begin
  //  Для x64 нет FPU команд. Отключим FPU исключения.
  SetMXCSR($1F80);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseEngine(0, nil);
end;



end.
