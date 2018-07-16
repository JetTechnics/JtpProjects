unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.AnsiStrings,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  JTPStudio, VideoSetsHeader, TypesJTP, PluginJTP, Vector,
  Poligon2D, Vehicle, Titers,
  frGPSServerConnect, uGPSData;

type
  TMainForm = class(TForm)
    StartButton: TButton;
    OutVideoPanel: TPanel;
    LogListBox: TListBox;
    Poligon2DGroupBox: TGroupBox;
    ShowButton: TButton;
    ClosePoligonButton: TButton;
    DirectCamButton1: TButton;
    CrewButton: TButton;
    CloseCrewButton: TButton;
    Label1: TLabel;
    OtsechkaButton: TButton;
    CloseOtsechkaButton: TButton;
    DirectCamButton2: TButton;
    CommonViewButton: TButton;
    TankNumsEdit: TEdit;
    Tank1Panel: TPanel;
    Tank2Panel: TPanel;
    Tank3Panel: TPanel;
    Tank4Panel: TPanel;
    btnTelemetry: TButton;
    TankBox1: TCheckBox;
    Tank1Edit: TEdit;
    TankBox2: TCheckBox;
    Tank2Edit: TEdit;
    TankBox3: TCheckBox;
    Tank3Edit: TEdit;
    TankBox4: TCheckBox;
    Tank4Edit: TEdit;
    GPSServerConnectFrame1: TGPSServerConnectFrame;
    procedure StartButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ShowButtonClick(Sender: TObject);
    procedure ClosePoligonButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    function  GetSelectedTanks() : integer;
    procedure DirectCamButton1Click(Sender: TObject);
    procedure CrewButtonClick(Sender: TObject);
    procedure CloseCrewButtonClick(Sender: TObject);
    procedure OtsechkaButtonClick(Sender: TObject);
    procedure CloseOtsechkaButtonClick(Sender: TObject);
    procedure DirectCamButton2Click(Sender: TObject);
    procedure CommonViewButtonClick(Sender: TObject);
    procedure btnTelemetryClick(Sender: TObject);
    procedure GPSServerConnectFrame1btnConnectClick(Sender: TObject);
  public
    procedure AddLogString(const AStr: string);
    procedure AddLogGpsData(TankId: integer; Lat, Lon: single; ticks: dword);
  end;

var
  MainForm: TMainForm;

  VideoTrunk : integer = -1;

  MyVersion : integer = 2;


implementation

uses
  GPSTelemetry, uGPSServerConnect;

{$R *.dfm}


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
  Textures[0].Text := 'Resources/Flags/AGO.tga';
  Textures[1].Text := 'Resources/Flags/ARM.tga';
  Textures[2].Text := 'Resources/Flags/BLR.tga';
  Textures[3].Text := 'Resources/Flags/CHN.tga';
  // ...
  Textures[4].Text := 'Resources/Color_Tank/Blue.tga';
  Textures[5].Text := 'Resources/Color_Tank/Green.tga';
  // ...
  Textures[6].Text[0] := #0;

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
  {
  System.AnsiStrings.StrCopy( GPSAddress, PAnsiChar( AnsiString(GpsAddrEdit.Text) ) );
  GPSPort := StrToInt( GPSPortEdit.Text );
  }

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



procedure TMainForm.ClosePoligonButtonClick(Sender: TObject);
var i : integer;
begin
	ShowButton.Enabled := true;
  ClosePoligonButton.Enabled := false;

	OpenRecords( 0, nil );

  for i := 1 to MaxOneVehicles do begin
    Vehicles[i].Reset();
  end;

  CloseScene( @PoligonSceneName, 0.0, nil );

  CloseRecords( 0, nil );
end;




////////////////   ЭКИПАЖ   ////////////////
procedure TMainForm.CrewButtonClick(Sender: TObject);
begin
  ShowCrew( VideoTrunk );
end;

procedure TMainForm.CloseCrewButtonClick(Sender: TObject);
begin
  CloseCrew();
end;
//////////////////////////////////////////////




////////////////   ОТСЕЧКА   ////////////////
procedure TMainForm.OtsechkaButtonClick(Sender: TObject);
begin
  ShowOtsechka( VideoTrunk );
end;

procedure TMainForm.CloseOtsechkaButtonClick(Sender: TObject);
begin
  CloseOtsechka();
end;
//////////////////////////////////////////////



function TMainForm.GetSelectedTanks() : integer;
var
  i, j : integer;
  Box : TCheckBox;
  str : string;
begin
  // Из CheckBox-ов определим, за какими танками будем вести камеру.
  j := 0;
  for i := 1 to MaxOneVehicles do begin
    str := 'TankBox' + IntToStr(i);
    Box := TCheckBox( Poligon2DGroupBox.FindChildControl( str ) );
    if( Box.Checked ) then begin
      ViewTanks[j] := i;
      inc(j);
    end;
  end;
  ViewTanks[j] := 0;
  GetSelectedTanks := j;
end;

procedure TMainForm.GPSServerConnectFrame1btnConnectClick(Sender: TObject);
begin
  GPSServerConnectFrame1.btnConnectClick(Sender);

end;

procedure TMainForm.DirectCamButton1Click(Sender: TObject);
var
  Count : integer;
begin

  Count := GetSelectedTanks();
  if( Count <> 0 ) then
    NewCameraMoving := CAM_MOVE_TO_TANKS or CAM_MOVE_TARGET_MED_POINT or CAM_MOVE_POS_OVER_TARGET;

end;



procedure TMainForm.DirectCamButton2Click(Sender: TObject);
var
  Count : integer;
begin

  Count := GetSelectedTanks();
	if( Count <> 0 ) then
	 NewCameraMoving := CAM_MOVE_TO_TANKS or CAM_MOVE_TARGET_MED_POINT or CAM_MOVE_POS_INCLINE;
end;



procedure TMainForm.CommonViewButtonClick(Sender: TObject);
begin
  NewCameraMoving := CAM_MOVE_COMMON or CAM_MOVE_TARGET_MED_POINT or CAM_MOVE_POS_OVER_TARGET;
end;



procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseEngine(0);
end;



procedure TMainForm.FormCreate(Sender: TObject);
begin
  //  Для x64 нет FPU команд. Отключим FPU исключения.
  SetMXCSR($1F80);

  GPSServerConnectFrame1.UpdateUI(Self);
end;


procedure TMainForm.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  GWheelDelta := WheelDelta;
end;


procedure TMainForm.ShowButtonClick(Sender: TObject);
var
  Ids : TIdArray;
  i : integer;
  str : string;
  Panel : TPanel;
  Edit : TEdit;
begin
	ShowButton.Enabled := false;
  ClosePoligonButton.Enabled := true;
  if not ((TEST <> 0) or (GPSServerConnectFrame1.ConnectState <> csDisconnected))
    then GPSServerConnectFrame1.btnConnectClick(nil);

  LogListBox.Items.Clear;

  OpenRecords( 0, nil );

  for i := 1 to MaxOneVehicles do begin
    str := 'Tank' + IntToStr(i) + 'Edit';
    Edit := TEdit( Poligon2DGroupBox.FindChildControl( str ) );
    if not Assigned(Edit) then Continue;
    Ids[i] := StrToInt( Edit.Text );
  end;

  //  Покажем полигон и все танки.
  ShowPoligon2D( 16, VideoTrunk, @Ids );

  CloseRecords( 0, nil );
end;

procedure TMainForm.AddLogGpsData(TankId: integer; Lat, Lon: single; ticks: dword);
begin
  TThread.Queue(nil,
      procedure
      var
        i: integer;
        id: integer;
        s: string;
        pkts: string;
        tc0: dword;
        fnd: boolean;
        fmt: string;
      begin
        fnd := false;
        LogListBox.Items.BeginUpdate;
          try
            fmt := '%5d%20.5f%20.5f%15d | %10d';
            try
              for i:=0 to LogListBox.Items.Count-1 do
                begin
                  s := LogListBox.Items[i];
                  Delete(s, Pos('|',s)+2, 100);
                  id := StrToInt(Trim(System.Copy(s, 1, 6)));
                  tc0 := dword(LogListBox.Items.Objects[i]);
                  if id = TankId then
                    begin
                      pkts := Format(fmt, [TankId, Lat, Lon, ticks-tc0, 0]);
                      LogListBox.Items[i] := pkts;
                      LogListBox.Items.Objects[i] := TObject(ticks);
                      fnd := true;
                    end
                                 else
                    begin
                      pkts := s + Format('%10d', [ticks-tc0]);
                      LogListBox.Items[i] := pkts;
                    end;
                end;

              if fnd then Exit;
              pkts := Format(fmt, [TankId, Lat, Lon, 0, 0]);
              LogListBox.Items.Add(pkts);
              LogListBox.Items.Objects[LogListBox.Items.Count-1] := TObject(ticks);
            except
              pkts := Format(fmt, [TankId, Lat, Lon, 0, 0]);
              LogListBox.Items.Add(pkts);
              LogListBox.Items.Objects[LogListBox.Items.Count-1] := TObject(ticks);
            end;
        finally
          LogListBox.Items.EndUpdate;
        end;
      end
    );
end;

procedure TMainForm.AddLogString(const AStr: string);
begin
  TThread.Queue(nil,
      procedure
      begin
        LogListBox.Items.Add(AStr);
      end
    );
end;

procedure TMainForm.btnTelemetryClick(Sender: TObject);
begin
  // _GPSTelemetry.Show;
end;

end.
