unit TitlerUnit;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.AnsiStrings,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  JTPStudio, VideoSetsHeader, TypesJTP, Vector,
  PreviewUnit;

type
  TMainForm = class(TForm)
    StartButton: TButton;
    OutVideoPanel1: TPanel;
    OutVideoPanel2: TPanel;
    TableGroupBox: TGroupBox;
    TableButton: TButton;
    LogListBox: TListBox;
    TableClose: TButton;
    ChampionshipGroupBox: TGroupBox;
    ChampionshipShowButton: TButton;
    ChampionshipCloseButton: TButton;
    Button1: TButton;
    TimeGroupBox: TGroupBox;
    ShowTimeButton: TButton;
    CloseTimeButton: TButton;
    Timer1: TTimer;
    BeginButton: TButton;
    ScoresGroupBox: TGroupBox;
    ShowScoresButton: TButton;
    Scores1Button: TButton;
    Scores2Button: TButton;
    CityButton: TButton;
    CloseScoresButton: TButton;
    SimOutBox: TCheckBox;
    SimInputBox: TCheckBox;
    NumRequestTrunksBox: TGroupBox;
    NumRequestTrunksEdit: TEdit;
    PreviewCheckBox: TCheckBox;
    procedure StartButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TableButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TableCloseClick(Sender: TObject);
    procedure ChampionshipShowButtonClick(Sender: TObject);
    procedure ChampionshipCloseButtonClick(Sender: TObject);
    procedure ShowTimeButtonClick(Sender: TObject);
    procedure CloseTimeButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BeginButtonClick(Sender: TObject);
    procedure ShowScoresButtonClick(Sender: TObject);
    procedure Scores1ButtonClick(Sender: TObject);
    procedure Scores2ButtonClick(Sender: TObject);
    procedure CityButtonClick(Sender: TObject);
    procedure CloseScoresButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

  SoftVersion: integer = 1;

  VideoSets : TVideoSets;

  NumActiveTrunks: integer = 0;

  //VideoTrunk1 : integer = -1;
  //VideoTrunk2 : integer = -1;

  GPreviewWindows : array[0..MAX_PREVIEW_WINDOWS-1] of HWND;

  ProjectPath : array[0..1] of TPath;

  Textures : array[0..4095] of TPath;

  function VideoCloseSetsFunc( Flags: integer;  VideoSets: PVideoSets ) : integer;  stdcall;

  //  Функция-callback. Вызывается из графического движка, если есть какие-либо ошибки.
  function  ErrorsFunctionCB( pErrors : PAnsiChar;  pReserved : pointer ) : DWORD;  stdcall;

  procedure AddErrorStrings( pErrors : PAnsiChar );

implementation

{$R *.dfm}


procedure TMainForm.FormCreate(Sender: TObject);
begin
  //  Для x64 нет FPU команд. Отключим FPU исключения.
  SetMXCSR($1F80);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseEngine(0, nil);
end;




procedure TMainForm.StartButtonClick(Sender: TObject);      //  Покажем окно видео настроек.
Var
  hVideoSetsDll : HMODULE;

  pGetVersionFunc : TGetVersionVideoSetsFunc;
  pStartFunc : TVideoStartSetsFunc;

  Res : JtpRes;
  Version : integer;
  //OutWindows : array [0..LAST_VIDEO_TRUNK] of HWND;
  EngineVersion : integer;
begin
  StartButton.Enabled := false;

  VideoSets.Clear();

  // Кол-во запрашиваемых стволов на панели видео настроек.
  VideoSets.NumRequestTrunks := StrToInt( NumRequestTrunksEdit.Text );

  // Покажем видео входы.
  VideoSets.InputProperties.Present := 1;

  //  Симуляторы видео ввода/вывода
  //if( SimOutBox.Checked ) then
  //  VideoSets.SimulatorOutput := 1;
  //if( SimInputBox.Checked ) then
  //  VideoSets.SimulatorInput := 1;

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
  InitVideoData : TInitVideo;
  StartEngineData : TStartEngineData;

  tex, i, trunk : integer;
  Panel : TPanel;
  CurrDir : AnsiString;
  str : string;

  iscene, iobject, iscenario : integer;
  pSceneName : PName;
  pObjectName: PName;
  pScenarioName : PName;
  NumSurfElems : integer;
  SceneInfoData : TSceneInfo;
  ObjectInfoData : TObjectInfo;

begin

  LoadProjectData.Create();
  InitVideoData.Create();
  StartEngineData.Create();

  //  Пройдём по выбранным стволам. Назначим окна для видеовывода. Запомним окна превью.
  for trunk := 1 to VideoSets.NumRequestTrunks do begin

    if( VideoSets.Trunks[trunk-1].Enabled <> 0 ) then begin

      str := 'OutVideoPanel' + IntToStr(trunk);
      Panel := TPanel( MainForm.FindChildControl(str) );
      if( Panel <> nil ) then begin
        VideoSets.Trunks[trunk-1].hOutWindow := Panel.Handle;
      end;

      str := 'PreviewPanel' + IntToStr(trunk);
      Panel := TPanel( PreviewForm.FindChildControl(str) );
      if( Panel <> nil ) then begin
        GPreviewWindows[trunk-1] := Panel.Handle;
      end;

      inc(NumActiveTrunks);
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

  // Проект MyProject.
  CurrDir := GetCurrentDir() + '\Resources\MyProject.txt';
  System.AnsiStrings.StrCopy( ProjectPath[0].text, PAnsiChar(CurrDir) );
  ProjectPath[1].text := '';

  //  Пути к картинкам.
  Textures[0].Text := 'Resources/Fotos/Foto1.jpg';
  Textures[1].Text := 'Resources/Fotos/Foto2.jpg';
  Textures[2].Text := 'Resources/Fotos/Foto3.jpg';
  Textures[3].Text := '';

  // Загрузим проект со сценами, текстурами и т.д.
  Res := LoadProject( @ProjectPath, @Textures, 0, @LoadProjectData );
  if( Res <> JTP_OK ) then begin
  	AddErrorStrings( LoadProjectData.pErrorsStr );
    MessageDlg('Ошибка при загрузке проекта.', mtError, [mbOk], 0);
    VideoCloseSetsFunc := -1;
    Exit;
  end;

  //  Просмотрим данные проекта.
  //  Перечислим сцены..
  pSceneName := LoadProjectData.pSceneNames;
  for iscene := 0 to LoadProjectData.NumScenes-1 do begin

    //  Получаем инфо о сцене.
    SceneInfoData.Create();
    Res := GetSceneInfo( pSceneName.text, @SceneInfoData );
    if( Res = JTP_OK ) then begin

      //  Перечисляем объекты..
      pObjectName := SceneInfoData.pObjectsNames;
      for iobject := 0 to SceneInfoData.NumObjects-1 do begin

        //  Получаем инфо об объекте.
        ObjectInfoData.Create();
        Res := GetObjectInfo( pSceneName.text, pObjectName.text, @ObjectInfoData );
        if( Res = JTP_OK ) then begin

          //  Перечисляем surface элементы..
          NumSurfElems := ObjectInfoData.NumSurfElems;
        end;

        Inc( pObjectName );
      end;

      //  Перечислим сценарии в сцене..
      pScenarioName := SceneInfoData.pScenariesNames;
      for iscenario := 0 to SceneInfoData.NumScenaries-1 do begin
        Inc( pScenarioName );
      end;
  end;

    Inc( pSceneName );
  end;

  // Запустим движёк.
  Res := StartEngine( SoftVersion, 0, ErrorsFunctionCB, @StartEngineData );
  if( Res <> JTP_OK ) then begin
    AddErrorStrings( StartEngineData.pErrorsStr );
    MessageDlg('Ошибка запуска графического движка.', mtError, [mbOk], 0);
    Exit;
  end;
end;




procedure TMainForm.BeginButtonClick(Sender: TObject);   //  Запуск таймера матча.
begin
  Timer1.Enabled := true;
end;





///////////////////////    Т и т р    " Ч Е М П И О Н А Т "    /////////////////////////////

var
  ChampionshipScenes : array[1..4] of TName;  // Четыре имени сцены, 2 на превью, 2 в плейаут.
  ChampIndices : array[0..31] of integer;
  PreviewChamp : integer = 0;

procedure TMainForm.ChampionshipShowButtonClick(Sender: TObject);
Var Res : JtpRes;
    PlaySceneData : TPlayScene;
    i, trunk, y, sc_offset : integer;
    SurfElemData : TSurfElemData;
begin

  if( PreviewCheckBox.Checked ) then begin
    sc_offset := 0;
    PreviewForm.Show();
  end else begin
    sc_offset := NumActiveTrunks;       // на превью уже есть сцены
  end;

  OpenRecords( 0, nil );

  for trunk := 1 to VideoSets.NumRequestTrunks do begin
    if( VideoSets.Trunks[trunk-1].Enabled <> 0 ) then begin

      PlaySceneData.Create();

      if( PreviewCheckBox.Checked ) then
        PlaySceneData.hPreviewWnds[0] := GPreviewWindows[trunk-1];

      Res := PlayScene( 'Championship', 0.0, 0, trunk, @PlaySceneData );
  	  if( Res = JTP_OK ) then begin

        System.AnsiStrings.StrCopy( ChampionshipScenes[trunk+sc_offset].text, PlaySceneData.SceneName.text );

        //  Создадим новые копии строк команд.
        y := 20;
        for i := 1 to 8 do begin

          SurfElemData.Create();

          Res := CloneSurfaceElement( PlaySceneData.SceneName.text, 'Table', 2, 1, nil, 'Текст', nil, 0, y, INT_UNDEF, INT_UNDEF, 0.0, JTP_RELATIVE, @SurfElemData );

          if( Res = JTP_OK ) then begin
	          ChampIndices[i] := SurfElemData.I;
          end
          else begin
            AddErrorStrings( SurfElemData.pErrorsStr );
          end;

          y := y + 20;
        end;
      end else begin
  	  	AddErrorStrings( PlaySceneData.pErrorsStr );
    	end;
    end;
  end;

  CloseRecords( 0, nil );
end;



procedure TMainForm.Button1Click(Sender: TObject);
var
  Res : JtpRes;
  trunk, sc_offset : integer;
  SurfElemData : TSurfElemData;
begin
  if( PreviewCheckBox.Checked ) then begin
    sc_offset := 0;
    PreviewForm.Show();
  end else begin
    sc_offset := NumActiveTrunks;
  end;

  OpenRecords( 0, nil );

  for trunk := 1 to VideoSets.NumRequestTrunks do begin
    if( VideoSets.Trunks[trunk-1].Enabled <> 0 ) then begin

      SurfElemData.Create();

      Res := UpdateSurfaceElement( ChampionshipScenes[trunk+sc_offset].text, 'Table', 1, 1, nil, 'Češi. Sluneční soustava obsahuje centrální hvězdu a několik planet', nil,
											            INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, FLT_UNDEF, 0, @SurfElemData );

    end;
  end;

  CloseRecords( 0, nil );
end;



procedure TMainForm.ChampionshipCloseButtonClick(Sender: TObject);
var CloseSceneData : TJtpFuncData;
    Res : JtpRes;
    i : integer;
begin
	OpenRecords( 0, nil );

  for i := 1 to 4 do begin
    if( ChampionshipScenes[i].text[0] <> #0 ) then begin
      CloseSceneData.Create();
	  	Res := CloseScene( @ChampionshipScenes[i], FLT_UNDEF, 0, @CloseSceneData );
		  if( Res <> JTP_OK ) then
			  AddErrorStrings( CloseSceneData.pErrorsStr );
      ChampionshipScenes[i].text[0] := #0;
    end;
  end;

  CloseRecords( 0, nil );
end;

///////////////////////    К о н е ц   т и т р а   " Ч Е М П И О Н А Т "    /////////////////////////////








//////////////////    Т и т р   " Т А Б Л И Ц А  И Г Р О К О В "    //////////////////////

var
	PlayersTableScenes : array[1..4] of TName; // Два ствола, два превью.

procedure TMainForm.TableButtonClick(Sender: TObject);
Var Res : JtpRes;
    PlaySceneData : TPlayScene;
    CloneObjectData : TCloneObject;
    Delay : single;
    VPos : TVector;
    i, sc_offset, trunk : integer;
    SurfElemData : TSurfElemData;
    Text, TextIter : string;
    StringObjects : array[0..31] of TName;
begin

  if( PreviewCheckBox.Checked ) then begin
    sc_offset := 0;
    PreviewForm.Show();
  end else begin
    sc_offset := NumActiveTrunks;       // на превью уже есть сцены
  end;

  OpenRecords( 0, nil );

  for trunk := 1 to VideoSets.NumRequestTrunks do begin
    if( VideoSets.Trunks[trunk-1].Enabled <> 0 ) then begin

      PlaySceneData.Create();

      if( PreviewCheckBox.Checked ) then
        PlaySceneData.hPreviewWnds[0] := GPreviewWindows[trunk-1];

      Res := PlayScene( 'Table', 0.0, 0, trunk, @PlaySceneData );
  	  if( Res = JTP_OK ) then begin

        System.AnsiStrings.StrCopy( PlayersTableScenes[trunk+sc_offset].text, PlaySceneData.SceneName.text );

        Delay := 0.2;

        VPos.VSet( 0.0, -12.0, 0.0 );

        StringObjects[0].text := 'String1';

        //  Создадим новые копии строк.
        for i := 1 to 4 do begin

          CloneObjectData.Create();

          Res := CloneObject( PlaySceneData.SceneName.text, 'String1', @VPos, nil, nil, nil, Delay, JTP_RELATIVE, @CloneObjectData );

          if( Res = JTP_OK ) then begin
            StringObjects[i].text := CloneObjectData.ObjectName.text;

            //  Обновим текст.
            Text := 'Der Bestätigungstext ';
      	    TextIter := Text + IntToStr(i+1);

            SurfElemData.Create();

            Res := UpdateSurfaceElement( PlaySceneData.SceneName.text, StringObjects[i].text, 1, 1, nil, PWideChar(TextIter), nil,
											            INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, FLT_UNDEF, 0, @SurfElemData );

            if( Res <> JTP_OK ) then
              AddErrorStrings( SurfElemData.pErrorsStr );
	        end else begin
            AddErrorStrings( CloneObjectData.pErrorsStr );
          end;

          VPos.y := VPos.y - 12.0;
          Delay := Delay + 0.2;

        end;
      end;
    end;
  end;

  CloseRecords( 0, nil );
end;


procedure TMainForm.TableCloseClick(Sender: TObject);
var CloseSceneData : TJtpFuncData;
    Res : JtpRes;
    i : integer;
begin
	OpenRecords( 0, nil );

  for i := 1 to 4 do begin
    if( PlayersTableScenes[i].text[0] <> #0 ) then begin
      CloseSceneData.Create();
	  	Res := CloseScene( @PlayersTableScenes[i], FLT_UNDEF, 0, @CloseSceneData );
		  if( Res <> JTP_OK ) then
			  AddErrorStrings( CloseSceneData.pErrorsStr );
      PlayersTableScenes[i].text[0] := #0;
    end;
  end;

  CloseRecords( 0, nil );
end;

//////////////////    К о н е ц   т и т р а   " Т А Б Л И Ц А  И Г Р О К О В "    /////////////////////////







///////////////////////    Т и т р   " В Р Е М Я "    ///////////////////////////////

var
  TimeScenes : array[1..2] of TName; // Два ствола, превью нет.
  TimeSceneEnabled : boolean = false;
  TimeSceneCity : boolean = false;


procedure TMainForm.ShowTimeButtonClick(Sender: TObject);
Var Res : JtpRes;
    PlaySceneData : TPlayScene;
    trunk : integer;
begin
  TimeSceneCity := false;

  OpenRecords( 0, nil );

  for trunk := 1 to VideoSets.NumRequestTrunks do begin
    if( VideoSets.Trunks[trunk-1].Enabled <> 0 ) then begin

      PlaySceneData.Create();

      if( PreviewCheckBox.Checked ) then
        PlaySceneData.hPreviewWnds[0] := GPreviewWindows[trunk-1];

      Res := PlayScene( 'Time', 0.0, 0, trunk, @PlaySceneData );
      if( Res = JTP_OK ) then begin

        System.AnsiStrings.StrCopy( TimeScenes[trunk].text, PlaySceneData.SceneName.text );
        end;
    end;
  end;

  CloseRecords( 0, nil );

  TimeSceneEnabled := true;
end;


var
  TimeMin, TimeSec, TimeSec100 : integer;

procedure TMainForm.Timer1Timer(Sender: TObject);
Var Res : JtpRes;
    TimeText : string;
    i : integer;
    SurfElemData : TSurfElemData;
begin
  //  Таймер. Сотые, секунды, минуты.
  Inc(TimeSec100);
  if( TimeSec100 >= 100 ) then begin
    TimeSec100 := 0;

    Inc(TimeSec);
    if( TimeSec >= 60 ) then begin
      TimeSec := 0;

      Inc(TimeMin);
      if( TimeMin >= 60 ) then begin
        TimeMin := 0;
      end;
    end;
  end;

  if( TimeSceneEnabled ) then begin

    if( TimeMin < 10) then TimeText := '0'
    else TimeText := '';
    TimeText := TimeText + IntToStr(TimeMin) + ':';

    if( TimeSec < 10) then TimeText := TimeText + '0';
    TimeText := TimeText + IntToStr(TimeSec) + ':';

    if( TimeSec100 < 10) then TimeText := TimeText + '0';
    TimeText := TimeText + IntToStr(TimeSec100);

    OpenRecords( 0, nil );

    for i := 1 to 2 do begin

      if( TimeScenes[i].text[0] <> #0 ) then begin

        SurfElemData.Create();

        Res := UpdateSurfaceElement( TimeScenes[i].text, 'TimePlane', 1, 1, nil, PWideChar(TimeText), nil,
                                    INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, FLT_UNDEF, 0, @SurfElemData );
        if( Res <> JTP_OK ) then
          AddErrorStrings( SurfElemData.pErrorsStr );
      end;
    end;

	  CloseRecords( 0, nil );
  end;
end;


procedure TMainForm.CityButtonClick(Sender: TObject);
var PlayScenarioData : TJtpFuncData;
    SurfElemData : TSurfElemData;
    Res : JtpRes;
    i : integer;
begin
  TimeSceneCity := true;

  OpenRecords( 0, nil );

  for i := 1 to 2 do begin

    if( TimeScenes[i].text[0] <> #0 ) then begin

      PlayScenarioData.Create();
      SurfElemData.Create();

      Res := UpdateSurfaceElement( TimeScenes[i].text, 'CityPlane', 1, 1, nil, PWideChar('Санкт-Петербург'), nil,
                                    INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, @SurfElemData );
      if( Res <> JTP_OK ) then
        AddErrorStrings( SurfElemData.pErrorsStr );

      Res := PlayScenario( TimeScenes[i].text, 'CityAndTemperature', FLT_UNDEF, 0, @PlayScenarioData );
      if( Res <> JTP_OK ) then
        AddErrorStrings( PlayScenarioData.pErrorsStr );
    end;
  end;

  CloseRecords( 0, nil );
end;


procedure TMainForm.CloseTimeButtonClick(Sender: TObject);
var CloseSceneData : TJtpFuncData;
    PlayAnimationData : TJtpFuncData;
    Res : JtpRes;
    i :integer;
begin
  TimeSceneEnabled := false;

  OpenRecords( 0, nil );

  for i := 1 to 2 do begin

    if( TimeScenes[i].text[0] <> #0 ) then begin

    if( TimeSceneCity ) then begin
      PlayAnimationData.Create();
      Res := PlayAnimation( TimeScenes[i].text, 'CityPlane', 'MoveUp', FLT_UNDEF, 0, @PlayAnimationData );
      if( Res <> JTP_OK ) then
          AddErrorStrings( PlayAnimationData.pErrorsStr );
    end;

    CloseSceneData.Create();
    Res := CloseScene( @TimeScenes[i], FLT_UNDEF, 0, @CloseSceneData );
    if( Res <> JTP_OK ) then
      AddErrorStrings( CloseSceneData.pErrorsStr );

    TimeScenes[i].text[0] := #0;
    end;
  end;

  CloseRecords( 0, nil );
end;

///////////////////////    К о н е ц   т и т р а   " В Р Е М Я "    /////////////////////////////







////////////////////////////    Т и т р   " С Ч Ё Т "    ///////////////////////////////

var
	ScoresScene : TName;
  Scores1 : integer = 0;
  Scores2 : integer = 0;

procedure TMainForm.ShowScoresButtonClick(Sender: TObject);
Var Res : JtpRes;
    PlaySceneData : TPlayScene;
    SurfElemData : TSurfElemData;
begin
  PlaySceneData.Create();

  {OpenRecords( 0, nil );

  Res := PlayScene( 'Scores', 0.0, 0, VideoTrunk1, @PlaySceneData );
  if( Res = JTP_OK ) then begin
    StrCopy( ScoresScene.text, PlaySceneData.SceneName.text );

    SurfElemData.Create();
   	Res := UpdateSurfaceElement( ScoresScene.text, 'CenterBlue', 1, 1, nil, PWideChar('ЦСКА'), nil,
											            INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, @SurfElemData );

    SurfElemData.Create();
    Res := UpdateSurfaceElement( ScoresScene.text, 'CenterBlue', 2, 1, nil, PWideChar('СПАРТАК'), nil,
											            INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, @SurfElemData );
  end;

  CloseRecords( 0, nil );}
end;


procedure TMainForm.Scores1ButtonClick(Sender: TObject);
Var Res : JtpRes;
	  PlayAnimationData : TJtpFuncData;
    ScoresText : string;
begin

  Inc( Scores1 );
  ScoresText := IntToStr( Scores1 );

  OpenRecords( 0, nil );

    Res := PlayAnimation( ScoresScene.text, 'RightBlack', 'Rotate', 0.0, 0, @PlayAnimationData );
    if( Res = JTP_OK ) then begin

    	Res := UpdateSurfaceElement( ScoresScene.text, 'RightBlack', 1, 1, nil, PWideChar(ScoresText), nil,
											            INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.25, 0, nil {@SurfElemData} );

    end;
  CloseRecords( 0, nil );
end;


procedure TMainForm.Scores2ButtonClick(Sender: TObject);
Var Res : JtpRes;
	  PlayAnimationData : TJtpFuncData;
    ScoresText : string;
    Pos : TVector;
    SetObjectSpaceData : TJtpFuncData;
begin

  Inc( Scores2 );
  ScoresText := IntToStr( Scores2 );

  OpenRecords( 0, nil );

    Res := PlayAnimation( ScoresScene.text, 'RightBlack', 'Rotate', 0.0, 0, @PlayAnimationData );
    if( Res = JTP_OK ) then begin

    	Res := UpdateSurfaceElement( ScoresScene.text, 'RightBlack', 2, 1, nil, PWideChar(ScoresText), nil,
											            INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.25, 0, nil {@SurfElemData} );

      //  Пример перемещения объекта по осям XYZ в точку (100,200,x).  x - z-координата не менятеся.
      {SetObjectSpaceData.Create;

      Pos.VSet( 100, 200.0, FLT_UNDEF );

			SetObjectSpace( ScoresScene.text, 'CenterBlue', @Pos, nil, nil, nil, nil, nil, 0.0, JTP_ABSOLUTE, @SetObjectSpaceData );}

      //  Пример смещения объекта по оси X на 300 единиц влево.
      SetObjectSpaceData.Create;

      Pos.VSet( -300, 0.0, 0.0 );

			SetObjectSpace( ScoresScene.text, 'CenterBlue', @Pos, nil, nil, nil, nil, nil, 0.0, JTP_RELATIVE, @SetObjectSpaceData );

    end;
  CloseRecords( 0, nil );
end;


procedure TMainForm.CloseScoresButtonClick(Sender: TObject);
Var Res : integer;
    CloseSceneData : TJtpFuncData;
begin
    OpenRecords( 0, nil );

    CloseSceneData.Create();

  	if( ScoresScene.text[0] <> #0 ) then begin
	  	Res := CloseScene( @ScoresScene, FLT_UNDEF, 0, @CloseSceneData );
		  if( Res <> JTP_OK ) then
			  AddErrorStrings( CloseSceneData.pErrorsStr );
      ScoresScene.text[0] := #0;
    end;
end;

///////////////////////    К о н е ц   т и т р а   " С Ч Ё Т "    /////////////////////////////





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
begin
	while( pErrors[0] <> #0 ) do begin
    L := System.AnsiStrings.StrLen( pErrors );
    pErrors := pErrors + L + 1;
  end;

  ErrorsFunctionCB := 0;
end;


End.
