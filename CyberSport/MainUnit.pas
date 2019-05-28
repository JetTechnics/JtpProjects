unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.AnsiStrings,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  TypesJTP, JTPStudio, Vector, VideoSetsHeader;

type
  TMainForm = class(TForm)
    StartButton: TButton;
    OutVideoPanel1: TPanel;
    LogListBox: TListBox;
    SimOutBox: TCheckBox;
    SimInputBox: TCheckBox;
    OutVideoPanel2: TPanel;
    procedure StartButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

  SoftVersion: integer = 1;

  VideoSets : TVideoSets;

  function VideoCloseSetsFunc( Flags: integer;  VideoSets: PVideoSets ) : integer;  stdcall;

  //  Функция-callback. Вызывается из графического движка, если есть какие-либо ошибки.
  function  ErrorsFunctionCB( pErrors : PAnsiChar;  pReserved : pointer ) : DWORD;  stdcall;

  procedure AddErrorStrings( pErrors : PAnsiChar );

implementation

{$R *.dfm}


procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseEngine(0, nil);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //  Для x64 нет FPU команд. Отключим FPU исключения.
  SetMXCSR($1F80);
end;



procedure TMainForm.StartButtonClick(Sender: TObject);
var
  EngineVersion : integer;
  hVideoSetsDll : HMODULE;

  pGetVersionFunc : TGetVersionVideoSetsFunc;
  pStartFunc : TVideoStartSetsFunc;

  Res, i, Version : integer;

begin
//i := sizeof( TVideoTrunk );

  StartButton.Enabled := false;

  VideoSets.Clear();
  VideoSets.NumRequestTrunks := 2;  // покажем 2 ствола на панели видео настроек.

  //  Симуляторы видео ввода/вывода
  if( SimOutBox.Checked ) then
    VideoSets.SimulatorOutput := 1;
  if( SimInputBox.Checked ) then
    VideoSets.SimulatorInput := 1;

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
  Panel : TPanel;
  str : string;
  CurrDir : AnsiString;
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

  {if Flags <> 0 then begin
    MessageDlg('Ошибка инициализации видео.', mtError, [mbOk], 0);
    VideoCloseSetsFunc := -1;
    Exit;
  end;}

  // Проект кибер спорт.
  CurrDir := GetCurrentDir() + '\Resources\CyberSport.txt';
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
    Exit;
  end;

  // Запустим движёк.
  Res := StartEngine( SoftVersion, 0, ErrorsFunctionCB, @StartEngineData );
  if( Res <> JTP_OK ) then begin
    AddErrorStrings( StartEngineData.pErrorsStr );
    MessageDlg('Ошибка запуска графического движка.', mtError, [mbOk], 0);
    Exit;
  end;

  OpenRecords( 0, nil );
  OutInputPictureToTrunk( 2, 2, 1, 0, nil );
  CloseRecords( 0, nil );

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

end.
