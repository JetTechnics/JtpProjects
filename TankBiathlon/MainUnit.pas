unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  JTPStudio, VideoSetsHeader, TypesJTP, PluginJTP, Vector,
  Poligon2D, GpsConnection, Vehicle;

type
  TMainForm = class(TForm)
    StartButton: TButton;
    OutVideoPanel: TPanel;
    LogListBox: TListBox;
    ZabegGroupBox: TGroupBox;
    ShowButton: TButton;
    GroupBox2: TGroupBox;
    GpsAddrLabel: TLabel;
    GpsPortLabel: TLabel;
    GpsAddrEdit: TEdit;
    GpsPortEdit: TEdit;
    GpsBox: TCheckBox;
    ClosePoligonButton: TButton;
    procedure StartButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ShowButtonClick(Sender: TObject);
    procedure ClosePoligonButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

  VideoTrunk : integer = -1;

  MyVersion : integer = 1;

implementation

{$R *.dfm}


procedure AddErrorStrings( pErrors : PAnsiChar );
var L : integer;
begin
	if( pErrors = nil ) then exit;

  while( pErrors[0] <> #0 ) do begin
	  MainForm.LogListBox.Items.Add( String(pErrors) );
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





procedure TMainForm.ClosePoligonButtonClick(Sender: TObject);
var i : integer;
begin
	OpenRecords( 0, nil );

  for i := 1 to MaxOneVehicles do begin
    Vehicles[i].Reset();
  end;

  CloseRecords( 0, nil );
end;



procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseEngine(0);
end;



procedure TMainForm.FormCreate(Sender: TObject);
begin
  //  Для x64 нет FPU команд. Отключим FPU исключения.
  SetMXCSR($1F80);
end;



procedure TMainForm.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  GWheelDelta := WheelDelta;
end;



procedure TMainForm.ShowButtonClick(Sender: TObject);
begin
  OpenRecords( 0, nil );

  //  Покажем полигон и все танки.
  ShowPoligon2D( 16, VideoTrunk );

  CloseRecords( 0, nil );
end;



//  Закрыли видео настройки.
//  Загрузим проект. Загрузим плагин для таскания танчиков по полю.

function VideoCloseSetsFunc( Flags: integer;  VideoSets: PVideoSets ) : integer;  stdcall;
var
  ProjectPath : array[0..1] of TPath;
  PluginPath : TPath;
  Textures : array[0..15] of TPath;
  Res: UInt64;
  LoadProjectData : TJtpLoadProjectData;
  PluginConfig : TPluginConfigTB;
  StartEngineData : TJtpFuncData;
begin

  VideoTrunk := VideoSets.Trunk1;

  //  Пути к картинкам.
  Textures[0].Text := '';

  //  Проект
  ProjectPath[0].text := 'C:/_TankBiathlon2018/Resources/TankBiathlon.prj';
  ProjectPath[1].text := '';

  Res := LoadProject( @ProjectPath, @Textures, 0, @LoadProjectData );
  if( Res <> JTP_OK ) then begin
  	AddErrorStrings( LoadProjectData.pErrorsStr );
  end;

  Res := StartEngine( MyVersion, 0, ErrorsFunctionCB, @StartEngineData );
  if( Res <> JTP_OK ) then begin
    AddErrorStrings( StartEngineData.pErrorsStr );
  end;
{
  OpenRecords( 0, nil );

  //  Загрузим плагин
  PluginConfig.Create();

  PluginPath.text := 'C:\Program Files\JTPStudio\Plugins\TankBiathlon\TankBiathlon.dll';
  Res := LoadPlugin( @PluginPath, @PluginConfig );

  CloseRecords( 0, nil );
}
end;



procedure TMainForm.StartButtonClick(Sender: TObject);
Var
  hVideoSetsDll : HMODULE;
  VideoSets : TVideoSets;
  pStartFunc : TVideoStartSetsFunc;
  Res, i : integer;
  OutWindows : array [0..LAST_VIDEO_TRUNK] of HWND;
  TrunkFlags : array [0..LAST_VIDEO_TRUNK] of integer;
  EngineVersion : integer;
  TrackPath : string;
  hCoordReaderDll : HMODULE;
  NumCoords, Ver : integer;
  DynArray, pf: ^single;
  Vec: TVector;
  pReadFunc : function ( pNumCoords, pVer, pCoords, pJumps : pointer; pFilePath: PAnsiChar ) : dword; stdcall;
begin
  StartButton.Enabled := false;

  //  Адрес GPS сервера
  StrCopy( GPSAddress, PAnsiChar( AnsiString(GpsAddrEdit.Text) ) );
  GPSPort := StrToInt( GPSPortEdit.Text );

  //  прочитаем трек для тестов.
  if( TEST <> 0 ) then begin
    TrackPath := GetCurrentDir() + '\' + 'Resources\FullTrack.txt';
    hCoordReaderDll := LoadLibrary( 'GpsCoordReader.dll' );
    if( hCoordReaderDll<>0 ) then begin

      @pReadFunc := GetProcAddress( hCoordReaderDll, 'ReadGpsCoords' );
      if( @pReadFunc <> nil )  then begin

          Res := pReadFunc( @NumCoords, @Ver, nil, nil, PAnsiChar(AnsiString(TrackPath)) );
          if( NumCoords > 1 )  then begin
            GetMem( DynArray, NumCoords*3*4 );
            Res := pReadFunc( @NumCoords, @Ver, DynArray, nil, PAnsiChar(AnsiString(TrackPath)) );
            pf := DynArray;
            for i:=0 to (NumCoords-1) do begin
              CopyMemory( @Vec, pf, 12 );
              if( Ver = 1 )  then begin
                Routes[i].GpsPos.x := Vec.x;
                Routes[i].GpsPos.z := Vec.y;
              end;
              if( Ver = 2 )  then begin
                Routes[i].GpsPos.x := Vec.y;
                Routes[i].GpsPos.z := Vec.x;
              end;
              Routes[i].GpsPos.y := Vec.z;

              Routes[i].Pos.x := Routes[i].GpsPos.z * lon_f1 - lon_f2;
              Routes[i].Pos.z := Routes[i].GpsPos.x * lat_f1 - lat_f2;
              //Routes[i].Pos.y := Height2d;

              Inc(pf,3);
            end;

            FreeMem( DynArray );

            MaxRoute := NumCoords;
          end;
      end;
    end;
  end;

  for i := 0 to LAST_VIDEO_TRUNK do begin
    OutWindows[i] := 0;
    TrunkFlags[i] := 0;
  end;

	EngineVersion := Get3DEngineVersion();

  hVideoSetsDll := LoadLibrary( JTPStudioPath + 'VideoSettings.dll' );
  if( hVideoSetsDll <> 0) then begin

    pStartFunc := GetProcAddress( hVideoSetsDll, 'VideoStartSets' );
    if( @pStartFunc <> nil ) then begin

      OutWindows[0] := OutVideoPanel.Handle;

      TrunkFlags[0] := TrunkVideo_ProcessMouse;

      Res := pStartFunc( 0, self, @OutWindows, @TrunkFlags, VideoCloseSetsFunc, nil );
    end;

  end;
end;

end.
