unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.AnsiStrings,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  JTPStudio, VideoSetsHeader, TypesJTP, PluginJTP, Vector,
  Poligon2D, Vehicle, Titers,
  frGPSServerConnect, uGPSData, uConsts,
  uCaptionSettingsKeys, uCaptionSettings;

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
    CancelFollowBtn: TButton;
    chbSimulation: TCheckBox;
    CaptionsGroupBox: TGroupBox;
    btnCaption1: TButton;
    btnCaption2: TButton;
    btnCaption3: TButton;
    btnCaption4: TButton;
    btnCancelCaption: TButton;
    btnEditCaptions: TButton;
    procedure StartButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ShowButtonClick(Sender: TObject);
    procedure ClosePoligonButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    function  GetSelectedTanks() : integer;
    procedure CrewButtonClick(Sender: TObject);
    procedure CloseCrewButtonClick(Sender: TObject);
    procedure OtsechkaButtonClick(Sender: TObject);
    procedure CloseOtsechkaButtonClick(Sender: TObject);
    procedure DirectCamButton2Click(Sender: TObject);
    procedure CommonViewButtonClick(Sender: TObject);
    procedure btnTelemetryClick(Sender: TObject);
    procedure GPSServerConnectFrame1btnConnectClick(Sender: TObject);
    procedure CancelFollowBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chbSimulationClick(Sender: TObject);
    procedure DirectCamButton1Click(Sender: TObject);
    procedure btnCaptionNClick(Sender: TObject);
    procedure btnCancelCaptionClick(Sender: TObject);
    procedure btnEditCaptionsClick(Sender: TObject);
  private
    FRunning: boolean;
    FSettings: TCaptionSettings;
    procedure CheckSimOption;
    procedure CleanGPSUnitsEvent(Sender: TObject);
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



//  �������-callback. ���������� �� ������������ ������, ���� ���� �����-���� ������.
function  ErrorsFunctionCB( pErrors : PAnsiChar;  pReserved : pointer ) : DWORD;  stdcall;
var L : integer;
Begin
	while( pErrors[0] <> #0 ) do begin
    L := System.AnsiStrings.StrLen( pErrors );
    pErrors := pErrors + L + 1;
  end;

  ErrorsFunctionCB := 0;
End;




//  ������� ����� ���������.
//  �������� ������. �������� ������ ��� �������� �������� �� ����.

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

  if Flags <> 0 then
    begin
      MessageDlg('������ ������������� �����.', mtError, [mbOk], 0);
      Exit;
    end;

  VideoTrunk := VideoSets.Trunk1;

  //  ���� � ���������.
  Textures[0].Text := 'Resources/Flags/AGO.tga';
  Textures[1].Text := 'Resources/Flags/ARM.tga';
  Textures[2].Text := 'Resources/Flags/BLR.tga';
  Textures[3].Text := 'Resources/Flags/CHN.tga';
  // ...
  Textures[4].Text := 'Resources/Color_Tank/Blue.tga';
  Textures[5].Text := 'Resources/Color_Tank/Green.tga';
  // ...
  Textures[6].Text[0] := #0;

  //  ������
  ProjectPath[0].text := 'C:/_TankBiathlon2018/Resources/TankBiathlon.prj';
  ProjectPath[1].text := '';

  Res := LoadProject( @ProjectPath, @Textures, 0, @LoadProjectData );
  if( Res <> JTP_OK ) then begin
  	AddErrorStrings( LoadProjectData.pErrorsStr );
    MessageDlg('������ ��� �������� �������.', mtError, [mbOk], 0);
    Exit;
  end;

  Res := StartEngine( MyVersion, 0, ErrorsFunctionCB, @StartEngineData );
  if( Res <> JTP_OK ) then begin
    AddErrorStrings( StartEngineData.pErrorsStr );
    MessageDlg('������ ������� ������������ ������.', mtError, [mbOk], 0);
    Exit;
  end;

  MainForm.ShowButton.Enabled := true;
{
  OpenRecords( 0, nil );

  //  �������� ������
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
begin
  StartButton.Enabled := false;

  //  ����� GPS �������
  {
  System.AnsiStrings.StrCopy( GPSAddress, PAnsiChar( AnsiString(GpsAddrEdit.Text) ) );
  GPSPort := StrToInt( GPSPortEdit.Text );
  }

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

      Res := pStartFunc( 0, Application, @OutWindows, @TrunkFlags, VideoCloseSetsFunc, nil );
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

procedure TMainForm.CleanGPSUnitsEvent(Sender: TObject);
var
  i: integer;
  ticks: dword;
  tc0: dword;
begin
  ticks := Winapi.Windows.GetTickCount;
  LogListBox.Items.BeginUpdate;
  try
    try
      i := 0;
      while i < LogListBox.Items.Count do
        begin
          tc0 := dword(LogListBox.Items.Objects[i]);
          if ticks-tc0 > GPSUnitsCleanInterval
            then LogListBox.Items.Delete(i)
            else Inc(i);
        end;
    except
    end;
  finally
    LogListBox.Items.EndUpdate;
  end;
end;

//////////////// Captions //////////////////
procedure TMainForm.btnCancelCaptionClick(Sender: TObject);
begin
  CloseGlobalScene;
end;

procedure TMainForm.btnCaptionNClick(Sender: TObject);
var
  btn: TButton absolute Sender;
  lData: TStrings;
begin
  if ShowButton.Enabled or
     (not (Assigned(Sender) and (Sender is TButton) and
       (btn.Tag >= 1) and (btn.Tag <= iCaptionsNum)))
    then Exit;

  lData := TStringList.Create;
  try
    FSettings.GetCaptionData(btn.Tag, lData);
    ShowGlobalScene(VideoTrunk, lData);
  finally
    lData.Free;
  end;
end;


procedure TMainForm.btnEditCaptionsClick(Sender: TObject);
begin
  FSettings.Edit;
end;
///////////////////////////////////////////

////////////////   ������   ////////////////
procedure TMainForm.CrewButtonClick(Sender: TObject);
begin
  ShowCrew( VideoTrunk );
end;

procedure TMainForm.CloseCrewButtonClick(Sender: TObject);
begin
  CloseCrew();
end;
//////////////////////////////////////////////




////////////////   �������   ////////////////
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
  // �� CheckBox-�� ���������, �� ������ ������� ����� ����� ������.
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
  try
    FSettings.WriteString(sGPSServerSect, sGPSServerIP_key,
                          GPSServerConnectFrame1.edGpsAddr.Text);
    FSettings.WriteString(sGPSServerSect, sGPSServerPort_key,
                          GPSServerConnectFrame1.edGpsPort.Text);
    FSettings.UpdateFile;
  except
  end;
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

procedure TMainForm.CancelFollowBtnClick(Sender: TObject);
begin
  CancelCamera := true;
end;

procedure TMainForm.chbSimulationClick(Sender: TObject);
begin
  if FRunning then
    begin
      if chbSimulation.Checked
        then FSettings.WriteInteger(sGPSServerSect, sTestOpt_key, 1)
        else FSettings.WriteInteger(sGPSServerSect, sTestOpt_key, 0);

      if FSettings.Modified
        then FSettings.UpdateFile;
    end;
end;

procedure TMainForm.CheckSimOption;
Var
  Res, i : integer;
  TrackPath : string;
  hCoordReaderDll : HMODULE;
  NumCoords, Ver : integer;
  DynArray, pf: ^single;
  Vec: TVector;
  pReadFunc : function ( pNumCoords, pVer, pCoords, pJumps : pointer; pFilePath: PAnsiChar ) : dword; stdcall;

  procedure DisableSimOption;
  begin
    chbSimulation.Checked := false;
    chbSimulation.Enabled := false;
  end;

begin
  //  ��������� ���� ��� ������.
  try
    TrackPath := GetCurrentDir() + '\' + 'Resources\FullTrack.txt';
    if not FileExists(TrackPath) then System.SysUtils.Abort;
    hCoordReaderDll := LoadLibrary( 'GpsCoordReader.dll' );
    if hCoordReaderDll = 0 then System.SysUtils.Abort;

    @pReadFunc := GetProcAddress( hCoordReaderDll, 'ReadGpsCoords' );
    if @pReadFunc = nil then System.SysUtils.Abort;

    Res := pReadFunc( @NumCoords, @Ver, nil, nil, PAnsiChar(AnsiString(TrackPath)) );
    if NumCoords <= 1 then System.SysUtils.Abort;

    GetMem( DynArray, NumCoords*3*4 );
    try
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
    finally
      FreeMem( DynArray );
    end;
    MaxRoute := NumCoords;
  except
    on EAbort do DisableSimOption;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseEngine(0);
end;



procedure TMainForm.FormCreate(Sender: TObject);
begin
  //  ��� x64 ��� FPU ������. �������� FPU ����������.
  SetMXCSR($1F80);

  FRunning := false;
  try
    FSettings :=
        TCaptionSettings.Create(ChangeFileExt(Application.ExeName,'.cfg'),
                                TEncoding.UTF8, false);
    chbSimulation.Checked :=
      (FSettings.ReadInteger(sGPSServerSect, sTestOpt_key, iTestOpt_def) <> 0);
    GPSServerConnectFrame1.edGpsAddr.Text :=
        FSettings.ReadString(sGPSServerSect, sGPSServerIP_key, sGPSServerIP_def);
    GPSServerConnectFrame1.edGpsPort.Text :=
        FSettings.ReadString(sGPSServerSect, sGPSServerPort_key, sGPSServerPort_def);

    GPSServerConnectFrame1.GPSCleanEventTimer.Interval := GPSUnitsCleanInterval;
    GPSServerConnectFrame1.GPSCleanEventTimer.OnTimer := CleanGPSUnitsEvent;
    GPSServerConnectFrame1.UpdateUI(Self);

    CheckSimOption;
  finally
    FRunning := true;
  end;
end;


procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if FSettings.Modified
    then FSettings.UpdateFile;
  FSettings.Free;
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

  if chbSimulation.Checked
    then TEST := 1
    else TEST := 0;

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

  //  ������� ������� � ��� �����.
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

            i := 0;
            while i < LogListBox.Items.Count do
              begin
                tc0 := dword(LogListBox.Items.Objects[i]);
                if ticks-tc0 > GPSUnitsCleanInterval
                  then LogListBox.Items.Delete(i)
                  else Inc(i);
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
