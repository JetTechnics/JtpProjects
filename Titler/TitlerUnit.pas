unit TitlerUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  JTPStudio, VideoSetsHeader, TypesJTP, Vector,
  PreviewUnit;

type
  TTitlerForm = class(TForm)
    StartButton: TButton;
    Out1VideoPanel: TPanel;
    Out2VideoPanel: TPanel;
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TitlerForm: TTitlerForm;

  MyVersion : integer = 1;

  VideoTrunk1 : integer = -1;
  VideoTrunk2 : integer = -1;

  ProjectPath : array[0..1] of TPath;

  Textures : array[0..4095] of TPath;

implementation

{$R *.dfm}

procedure AddErrorStrings( pErrors : PAnsiChar );
var L : integer;
begin
	if( pErrors = nil ) then exit;

  while( pErrors[0] <> #0 ) do begin
	  TitlerForm.LogListBox.Items.Add( String(pErrors) );
    L := StrLen( pErrors );
    pErrors := pErrors + L + 1;
  end;
end;



//  Функция-callback. Вызывается из графического движка, если есть какие-либо ошибки.
function  ErrorsFunctionCB( pErrors : PAnsiChar;  pReserved : pointer ) : DWORD;  stdcall;
var L : integer;
Begin
	while( pErrors[0] <> #0 ) do begin
    L := StrLen( pErrors );
    pErrors := pErrors + L + 1;
  end;

  ErrorsFunctionCB := 0;
End;



//  Закрыли видео настройки.
//  Загрузим проект. Перечислим сцены проекта. Перечислим объекты внутри сцен.

function VideoCloseSetsFunc( Flags: integer;  VideoSets: PVideoSets ) : integer;  stdcall;
var Res: UInt64;
		i : integer;
    ObjName, SceneName, ScenarioName : TName;
    pSceneNames : PName;
    LoadProjectData : TJtpLoadProjectData;
    StartEngineData : TJtpFuncData;
    SceneInfoData : TSceneInfoData;
    ObjectInfoData : TObjectInfoData;
    pObjectsNames : PName;
    pScenariesNames : PName;
    NumSurfElems : integer;
begin
  VideoTrunk1 := VideoSets.Trunk1;
  VideoTrunk2 := VideoSets.Trunk2;

  ProjectPath[0].text := 'C:/ALEXBASE/Development/JTPProjects/Titler/Resources/MyProject.prj';
  ProjectPath[1].text := '';

  //  Пути к картинкам.
  Textures[0].Text := 'Resources/Fotos/Foto1.jpg';
  Textures[1].Text := 'Resources/Fotos/Foto2.jpg';
  Textures[2].Text := 'Resources/Fotos/Foto3.jpg';
  Textures[3].Text := '';

  Res := LoadProject( @ProjectPath, @Textures, 0, @LoadProjectData );
  if( Res <> JTP_OK ) then begin
  	AddErrorStrings( LoadProjectData.pErrorsStr );
  end;

  //  Пример перечисления сцен проекта.
  pSceneNames := LoadProjectData.pSceneNames;
  for i := 0 to LoadProjectData.NumScenes-1 do begin

    StrCopy( SceneName.text, pSceneNames.text );

    Inc( pSceneNames );
  end;

  Res := StartEngine( MyVersion, 0, ErrorsFunctionCB, @StartEngineData );
  if( Res <> JTP_OK ) then begin
    AddErrorStrings( StartEngineData.pErrorsStr );
  end;

  //  Пример перечисления объектов в сцене.
  OpenRecords( 0, nil );

  //  Получаем инфо о сцене.
  SceneInfoData.Create;
  Res := GetSceneInfo( 'Scores', @SceneInfoData );
  pObjectsNames := SceneInfoData.pObjectsNames;

  //  Перечисление объектов.
  for i := 0 to SceneInfoData.NumObjects-1 do begin
    StrCopy( ObjName.text, pObjectsNames.text );

    //  Пример получения данных об объекте.
    if( ObjName.text = 'RightBlack' ) then begin
      GetObjectInfo( 'Scores', 'RightBlack', @ObjectInfoData );

      NumSurfElems := ObjectInfoData.NumSurfElems;
    end;

    Inc( pObjectsNames );
  end;

  //  Перечисление сценариев в сцене
  pScenariesNames := SceneInfoData.pScenariesNames;
  for i := 0 to SceneInfoData.NumScenaries-1 do begin
    StrCopy( ScenarioName.text, pScenariesNames.text );
    Inc( pScenariesNames );
  end;

  CloseRecords( 0, nil );
end;



procedure TTitlerForm.FormCreate(Sender: TObject);
begin
  //  Для x64 нет FPU команд. Отключим FPU исключения.
  SetMXCSR($1F80);
end;


procedure TTitlerForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseEngine(0);
end;




procedure TTitlerForm.StartButtonClick(Sender: TObject);      //  Покажем окно видео настроек.
Var
  hVideoSetsDll : HMODULE;
  VideoSets : TVideoSets;
  pStartFunc : TVideoStartSetsFunc;
  Res : integer;
  OutWindows : array [0..LAST_VIDEO_TRUNK] of HWND;
  EngineVersion : integer;
begin
  StartButton.Enabled := false;

	EngineVersion := Get3DEngineVersion();

  hVideoSetsDll := LoadLibrary( JTPStudioPath + 'VideoSettings.dll' );
  if( hVideoSetsDll <> 0) then begin

    pStartFunc := GetProcAddress( hVideoSetsDll, 'VideoStartSets' );
    if( @pStartFunc <> nil ) then begin
      OutWindows[0] := Out1VideoPanel.Handle;
      OutWindows[1] := Out2VideoPanel.Handle;
      OutWindows[2] := 0;
      OutWindows[3] := 0;
      Res := pStartFunc( 0, Application, @OutWindows, nil, VideoCloseSetsFunc, nil );
    end;

  end;
end;




procedure TTitlerForm.BeginButtonClick(Sender: TObject);   //  Запуск таймера матча.
begin
  Timer1.Enabled := true;
end;





///////////////////////    Т и т р    " Ч Е М П И О Н А Т "    /////////////////////////////

var
  ChampionshipScene : TName;
  ChampIndices : array[0..31] of integer;
  PreviewChamp : integer = 0;

procedure TTitlerForm.ChampionshipShowButtonClick(Sender: TObject);
Var Res : UInt64;
    PlaySceneData : TPlaySceneData;
    i, y : integer;
    SurfElemData : TSurfElemData;
begin

	PlaySceneData.Create();
  SurfElemData.Create();

  OpenRecords( 0, nil );

    if( VideoTrunk1 > 0 ) then begin

      if( PreviewChamp = 0 ) then begin
        PreviewChamp := 1;
        PlaySceneData.hPreviewWnds[0] := PreviewForm.Handle;
        PreviewForm.Show();
      end
      else begin
        PreviewChamp := 0;
      end;

	    Res := PlayScene( 'Championship', 0.0, 0, VideoTrunk1, @PlaySceneData );
  	  if( Res = JTP_OK ) then begin

      //  Сцена на preview автоматически удаляется. Не будем запоминать её имя.
      if( PlaySceneData.hPreviewWnds[0] = 0 ) then
    		StrCopy( ChampionshipScene.text, PlaySceneData.SceneName.text );

        y := 20;

        //  Создадим новые копии строк команд.
        for i := 1 to 8 do begin

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

  CloseRecords( 0, nil );
end;



procedure TTitlerForm.ChampionshipCloseButtonClick(Sender: TObject);
var CloseSceneData : TJtpFuncData;
    Res : UInt64;
begin
	OpenRecords( 0, nil );

  	if( ChampionshipScene.text[0] <> #0 ) then begin
	  	Res := CloseScene( ChampionshipScene.text, FLT_UNDEF, @CloseSceneData );
		  if( Res <> JTP_OK ) then
			  AddErrorStrings( CloseSceneData.pErrorsStr );
      ChampionshipScene.text[0] := #0;
    end;

  CloseRecords( 0, nil );
end;

///////////////////////    К о н е ц   т и т р а   " Ч Е М П И О Н А Т "    /////////////////////////////








//////////////////    Т и т р   " Т А Б Л И Ц А  И Г Р О К О В "    //////////////////////

var
	TableScene1 : TName;
  TableScene2 : TName;
  PreviewTable : integer = 0;

procedure TTitlerForm.TableButtonClick(Sender: TObject);
Var Res : UInt64;
    PlaySceneData : TPlaySceneData;
    CloneObjectData : TCloneObjectData;
    Delay : single;
    VPos : TVector;
    i : integer;
    SurfElemData : TSurfElemData;
    Text, TextIter : string;
    StringObjects : array[0..31] of TName;
begin

	PlaySceneData.Create;
  SurfElemData.Create;

  OpenRecords( 0, nil );

    if( VideoTrunk1 > 0 ) then begin

      if( PreviewTable = 0 ) then begin
        PreviewTable := 1;
        PlaySceneData.hPreviewWnds[0] := PreviewForm.Handle;
        PreviewForm.Show();
      end
      else begin
        PreviewTable := 0;
      end;

	    Res := PlayScene( 'Table', 0.0, 0, VideoTrunk1, @PlaySceneData );
  	  if( Res = JTP_OK ) then begin

      //  Сцена на preview автоматически удаляется. Не будем запоминать её имя.
      if( PlaySceneData.hPreviewWnds[0] = 0 ) then
    		StrCopy( TableScene1.text, PlaySceneData.SceneName.text );

        Delay := 0.2;

        VPos.VSet( 0.0, -12.0, 0.0 );

        StringObjects[0].text := 'String1';

        //  Создадим новые копии строк.
        for i := 1 to 4 do begin

          Res := CloneObject( PlaySceneData.SceneName.text, 'String1', @VPos, nil, nil, nil, Delay, JTP_RELATIVE, @CloneObjectData );

          if( Res = JTP_OK ) then begin
            StringObjects[i].text := CloneObjectData.ObjectName.text;
	        end else begin
            AddErrorStrings( CloneObjectData.pErrorsStr );
          end;

          VPos.y := VPos.y - 12.0;
          Delay := Delay + 0.2;

        end;

        //  Обновим текст на строках.
        Text := 'Der Bestätigungstext ';

        for i := 0 to 4 do begin

        	TextIter := Text + IntToStr(i+1);

          Res := UpdateSurfaceElement( PlaySceneData.SceneName.text, StringObjects[i].text, 1, 1, nil, PWideChar(TextIter), nil,
											            INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, FLT_UNDEF, 0, @SurfElemData );

          if( Res <> JTP_OK ) then begin
            AddErrorStrings( SurfElemData.pErrorsStr );
          end;

        end;

	    end else begin
  	  	AddErrorStrings( PlaySceneData.pErrorsStr );
    	end;
    end;

{
    if( VideoTrunk2 > 0 ) then begin

	    Res := PlayScene( 'Table', 0.0, 0, VideoTrunk2, @PlaySceneData );
  	  if( Res = JTP_OK ) then begin

	    end else begin
  	  	AddErrorStrings( PlaySceneData.pErrorsStr );
    	end;
    end;
}

  CloseRecords( 0, nil );
end;


procedure TTitlerForm.TableCloseClick(Sender: TObject);
var CloseSceneData : TJtpFuncData;
    Res : UInt64;
begin
	OpenRecords( 0, nil );

  	if( TableScene1.text[0] <> #0 ) then begin
	  	Res := CloseScene( TableScene1.text, FLT_UNDEF, @CloseSceneData );
		  if( Res <> JTP_OK ) then
			  AddErrorStrings( CloseSceneData.pErrorsStr );
      TableScene1.text[0] := #0;
    end;

    if( TableScene2.text[0] <> #0 ) then begin
		  Res := CloseScene( TableScene2.text, FLT_UNDEF, @CloseSceneData );
  		if( Res <> JTP_OK ) then
	  		AddErrorStrings( CloseSceneData.pErrorsStr );
      TableScene2.text[0] := #0;
    end;

  CloseRecords( 0, nil );
end;

//////////////////    К о н е ц   т и т р а   " Т А Б Л И Ц А  И Г Р О К О В "    /////////////////////////







///////////////////////    Т и т р   " В Р Е М Я "    ///////////////////////////////

var
	TimeScene1 : TName;
  TimeScene2 : TName;
  TimeSceneEnabled : boolean = false;
  TimeSceneCity : boolean = false;


procedure TTitlerForm.ShowTimeButtonClick(Sender: TObject);
Var Res : UInt64;
    PlaySceneData : TPlaySceneData;
begin
  PlaySceneData.Create();

  TimeSceneCity := false;

  OpenRecords( 0, nil );

  Res := PlayScene( 'Time', 0.0, 0, VideoTrunk1, @PlaySceneData );
  if( Res = JTP_OK ) then begin
    StrCopy( TimeScene1.text, PlaySceneData.SceneName.text );
  end;

  CloseRecords( 0, nil );

  TimeSceneEnabled := true;
end;


var
  TimeMin, TimeSec, TimeSec100 : integer;

procedure TTitlerForm.Timer1Timer(Sender: TObject);
Var Res : UInt64;
    TimeText : string;
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

  	Res := UpdateSurfaceElement( TimeScene1.text, 'TimePlane', 1, 1, nil, PWideChar(TimeText), nil,
											            INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, FLT_UNDEF, 0, nil {@SurfElemData} );
	  //  Ошибку можно не смотреть. Таймер тикает весь матч (или приходит по com порту). Но сцена с таймером висит на экране не всегда.
  	{if( Res <> JTP_OK ) then begin
	    AddErrorStrings( SurfElemData.pErrorsStr );
  	end;}

	  CloseRecords( 0, nil );
  end;
end;


procedure TTitlerForm.CityButtonClick(Sender: TObject);
var PlayScenarioData : TJtpFuncData;
    SurfElemData : TSurfElemData;
    Res : UInt64;
begin
  PlayScenarioData.Create;
  SurfElemData.Create;

  TimeSceneCity := true;

  OpenRecords( 0, nil );

  Res := UpdateSurfaceElement( TimeScene1.text, 'CityPlane', 1, 1, nil, PWideChar('Санкт-Петербург'), nil,
											            INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, @SurfElemData );
  if( Res <> JTP_OK ) then
    AddErrorStrings( SurfElemData.pErrorsStr );

  Res := PlayScenario( TimeScene1.text, 'CityAndTemperature', FLT_UNDEF, 0, @PlayScenarioData );
  if( Res <> JTP_OK ) then
    AddErrorStrings( PlayScenarioData.pErrorsStr );

  CloseRecords( 0, nil );
end;


procedure TTitlerForm.CloseTimeButtonClick(Sender: TObject);
var CloseSceneData : TJtpFuncData;
    PlayAnimationData : TJtpFuncData;
    Res : UInt64;
begin
  TimeSceneEnabled := false;

  OpenRecords( 0, nil );

  if( TimeSceneCity ) then begin
    Res := PlayAnimation( TimeScene1.text, 'CityPlane', 'MoveUp', FLT_UNDEF, 0, @PlayAnimationData );
    if( Res <> JTP_OK ) then
			  AddErrorStrings( PlayAnimationData.pErrorsStr );
  end;

  if( TimeScene1.text[0] <> #0 ) then begin
	  	Res := CloseScene( TimeScene1.text, FLT_UNDEF, @CloseSceneData );
		  if( Res <> JTP_OK ) then
			  AddErrorStrings( CloseSceneData.pErrorsStr );
      TimeScene1.text[0] := #0;
    end;

    if( TimeScene2.text[0] <> #0 ) then begin
		  Res := CloseScene( TimeScene2.text, FLT_UNDEF, @CloseSceneData );
  		if( Res <> JTP_OK ) then
	  		AddErrorStrings( CloseSceneData.pErrorsStr );
      TimeScene2.text[0] := #0;
    end;

  CloseRecords( 0, nil );
end;

///////////////////////    К о н е ц   т и т р а   " В Р Е М Я "    /////////////////////////////







////////////////////////////    Т и т р   " С Ч Ё Т "    ///////////////////////////////

var
	ScoresScene : TName;
  Scores1 : integer = 0;
  Scores2 : integer = 0;

procedure TTitlerForm.ShowScoresButtonClick(Sender: TObject);
Var Res : UInt64;
    PlaySceneData : TPlaySceneData;
begin
  PlaySceneData.Create();

  OpenRecords( 0, nil );

  Res := PlayScene( 'Scores', 0.0, 0, VideoTrunk1, @PlaySceneData );
  if( Res = JTP_OK ) then begin
    StrCopy( ScoresScene.text, PlaySceneData.SceneName.text );

   	Res := UpdateSurfaceElement( ScoresScene.text, 'CenterBlue', 1, 1, nil, PWideChar('ЦСКА'), nil,
											            INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil {@SurfElemData} );

    Res := UpdateSurfaceElement( ScoresScene.text, 'CenterBlue', 2, 1, nil, PWideChar('СПАРТАК'), nil,
											            INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil {@SurfElemData} );
  end;

  CloseRecords( 0, nil );
end;


procedure TTitlerForm.Scores1ButtonClick(Sender: TObject);
Var Res : UInt64;
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


procedure TTitlerForm.Scores2ButtonClick(Sender: TObject);
Var Res : UInt64;
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


procedure TTitlerForm.CloseScoresButtonClick(Sender: TObject);
Var Res : integer;
    CloseSceneData : TJtpFuncData;
begin
    OpenRecords( 0, nil );

  	if( ScoresScene.text[0] <> #0 ) then begin
	  	Res := CloseScene( ScoresScene.text, FLT_UNDEF, @CloseSceneData );
		  if( Res <> JTP_OK ) then
			  AddErrorStrings( CloseSceneData.pErrorsStr );
      ScoresScene.text[0] := #0;
    end;
end;

///////////////////////    К о н е ц   т и т р а   " С Ч Ё Т "    /////////////////////////////

end.
