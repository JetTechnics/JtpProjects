unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.AnsiStrings,
  System.Types, System.IOUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  JTPStudio, VideoSetsHeader, TypesJTP, PluginJTP, Vector,
  Poligon2D, Vehicle, Titers,
  frGPSServerConnect, uGPSData, uConsts,
  uGPSPacketsQueue, uCaptionSettingsKeys, uCaptionSettings, uParamStorage,
  Vcl.Buttons;

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
    btnEditCaptions: TButton;
    Button1: TButton;
    chbShowFlags: TCheckBox;
    btnRefresh: TButton;
    btnZeroSpeeds: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    btnCaption1: TButton;
    btnCancelCaption1: TButton;
    btnCaption2: TButton;
    btnCancelCaption2: TButton;
    Panel3: TPanel;
    btnCaption3: TButton;
    btnCancelCaption3: TButton;
    Panel4: TPanel;
    btnCaption4: TButton;
    btnCancelCaption4: TButton;
    btnCountries: TButton;
    btnCloseCountries: TButton;
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
    procedure btnCancelCaptionNClick(Sender: TObject);
    procedure btnEditCaptionsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure chbShowFlagsClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure btnZeroSpeedsClick(Sender: TObject);
    procedure btnCountriesClick(Sender: TObject);
    procedure btnCloseCountriesClick(Sender: TObject);
  private
    FRunning: boolean;
    FSettings: TCaptionSettings;
    procedure CheckSimOption;
    procedure GPSCheckQueueEvent(Sender: TObject);
    {procedure OnParamValueChanged(Descr: TParamDescr; const OldValue, NewValue,
      OldValueFmt, NewValueFmt: string);}
  public
    procedure AddLogString(const AStr: string);
    {procedure AddLogGpsData(const GpsData: TGpsData; ticks: dword);}
    {procedure OnParamValueChanged(Descr: TParamDescr;
                const OldValue, NewValue, OldValueFmt, NewValueFmt: string);}
    procedure OnEndUpdateParamStorage(Sender: TObject);
  end;

var
  MainForm: TMainForm;

  VideoTrunk : integer = -1;

  MyVersion : integer = 2;

  VideoSets : TVideoSets;


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
//  Загрузим проект.

function VideoCloseSetsFunc( Flags: integer;  VideoSets: PVideoSets ) : integer;  stdcall;
var
  ProjectPath : array[0..1] of TPath;
  PluginPath : TPath;
  Textures : array of TPath;
  Res: JtpRes;

  LoadProjectData : TLoadProjectData;
  InitVideoData : TInitVideo;
  StartEngineData : TJtpFuncData;

  //PluginConfig : TPluginConfigTB;

  FlagsList: TStringDynArray;
  s: AnsiString;
  i, k: integer;
begin

  LoadProjectData.Create();
  InitVideoData.Create();
  StartEngineData.Create();

  if Flags <> 0 then begin
    MessageDlg('Ошибка инициализации видео.', mtError, [mbOk], 0);
    Exit;
  end;

  VideoTrunk := 1;

  VideoSets.Trunks[VideoTrunk-1].hOutWindow := MainForm.OutVideoPanel.Handle;


  //  Инициализируем видео.
  Res := InitVideo( 0, @VideoSets.Trunks, @VideoSets.InputProperties, @InitVideoData );
  if( Res <> JTP_OK ) then begin

    if( InitVideoData.pErrorsStr <> nil ) then begin
      MessageDlg(InitVideoData.pErrorsStr, mtError, [mbOk], 0);
    end;

    AddErrorStrings( InitVideoData.pErrorsStr );

    Exit;
  end;

  //  Пути к картинкам.
  // All flags
  SetLength(Textures, Length(FlagsList)+3);
  k := Low(Textures);
  FlagsList := TDirectory.GetFiles('C:/_TankBiathlon2018/Resources/Flags', '*.tga');
  for i:=Low(FlagsList) to High(FlagsList) do
    begin
      s := AnsiString('Resources\Flags\' + ExtractFileName(FlagsList[i]));
      CopyMemory(@Textures[k].Text, PAnsiChar(s), Length(s)+1);
      Inc(k);
    end;
  // Other textures
  Textures[k].Text := 'Resources/Color_Tank/Blue.tga';
  Textures[k+1].Text := 'Resources/Color_Tank/Green.tga';
  Textures[k+2].Text[0] := #0;

  //  Проект
  ProjectPath[0].text := 'C:/_TankBiathlon2018/Resources/TankBiathlon.txt';
  ProjectPath[1].text := '';

  // Загрузим проект со сценами, текстурами и т.д.
  Res := LoadProject( @ProjectPath, @Textures[Low(Textures)], 0, @LoadProjectData );
  if( Res <> JTP_OK ) then begin
  	AddErrorStrings( LoadProjectData.pErrorsStr );
    MessageDlg('Ошибка при загрузке проекта.', mtError, [mbOk], 0);
    Exit;
  end;

  // Запустим движёк.
  Res := StartEngine( MyVersion, 0, ErrorsFunctionCB, @StartEngineData );
  if( Res <> JTP_OK ) then begin
    AddErrorStrings( StartEngineData.pErrorsStr );
    MessageDlg('Ошибка запуска графического движка.', mtError, [mbOk], 0);
    Exit;
  end;

  MainForm.ShowButton.Enabled := true;

  // CaptionParamStorage.OnParamChanged := MainForm.OnParamValueChanged;
  CaptionParamStorage.OnEndUpdate := MainForm.OnEndUpdateParamStorage;
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

  pStartFunc : TVideoStartSetsFunc;
  pGetVersionFunc : TGetVersionVideoSetsFunc;

  i : integer;

  Res : JtpRes;

  Version : integer;
  EngineVersion : integer;
  //OutWindows : array [0..LAST_VIDEO_TRUNK] of HWND;
  //TrunkFlags : array [0..LAST_VIDEO_TRUNK] of integer;

begin
  StartButton.Enabled := false;

  VideoSets.Clear();

  VideoSets.NumRequestTrunks := 1;

  VideoSets.NumRequestSimulators := 2;

  //  Симуляторы видео ввода/вывода
  //if( SimOutBox.Checked ) then
  //  VideoSets.SimulatorOutput := 1;

  //  Адрес GPS сервера
  {
  System.AnsiStrings.StrCopy( GPSAddress, PAnsiChar( AnsiString(GpsAddrEdit.Text) ) );
  GPSPort := StrToInt( GPSPortEdit.Text );
  }

  {for i := 0 to LAST_VIDEO_TRUNK do begin
    OutWindows[i] := 0;
    TrunkFlags[i] := 0;
  end;}

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



procedure TMainForm.ClosePoligonButtonClick(Sender: TObject);
var i : integer;
begin
	ShowButton.Enabled := true;
  ClosePoligonButton.Enabled := false;

  btnCountries.Enabled := false;
  btnCloseCountries.Enabled := false;
  btnCaption1.Enabled := false;
  btnCaption2.Enabled := false;
  btnCaption3.Enabled := false;
  btnCaption4.Enabled := false;
  btnCancelCaption1.Enabled := false;
  btnCancelCaption2.Enabled := false;
  btnCancelCaption3.Enabled := false;
  btnCancelCaption4.Enabled := false;

  CloseCountries;
  for i:=1 to iCaptionsNum do
    CloseGlobalScene(i);

	OpenRecords( 0, nil );

  for i := 1 to MaxOneVehicles do begin
    Vehicles[i].Reset();
  end;

  CloseScene( @PoligonSceneName, 0.0, 0, nil );

  CloseRecords( 0, nil );
end;

procedure TMainForm.GPSCheckQueueEvent(Sender: TObject);
var
  i: integer;
  ticks: dword;
  tc0: dword;
  Pkt: TGPSPacket;
  // Descr: TParamDescr;

  procedure DoLogGpsData;
  var
    k: integer;
    id: integer;
    s: string;
    pkts: string;
    tc0: dword;
    fnd: boolean;
    fmt: string;
    v: single;
  begin
    fnd := false;
    for k:=1 to iTanksNum do
      if Vehicles[k].Id = Pkt.DevId then
        begin
          fnd := true;
          break;
        end;

    if fnd then
      begin
        v := (Pkt.Speed / 1000) * 3600; // convert to kmh
        Vehicles[k].Vcur := v;
        CaptionParamStorage.SetParamDataV(cpiSpeed, k, Round(v));
        if v > Vehicles[k].Vmax then
          begin
            Vehicles[k].Vmax := v;
            CaptionParamStorage.SetParamDataV(cpiSpeed_max, k, Round(v));
          end;
      end;

    fnd := false;
    fmt := '%5d%20.5f%20.5f%15d | %10d';
    try
      for k:=0 to LogListBox.Items.Count-1 do
        begin
          s := LogListBox.Items[k];
          Delete(s, Pos('|',s)+2, 100);
          id := StrToInt(Trim(System.Copy(s, 1, 6)));
          tc0 := dword(LogListBox.Items.Objects[k]);
          if id = Pkt.DevId then
            begin
              pkts := Format(fmt, [Pkt.DevId, Pkt.Lat, Pkt.Lon, ticks-tc0, 0]);
              LogListBox.Items[k] := pkts;
              LogListBox.Items.Objects[k] := TObject(ticks);
              fnd := true;
            end
                         else
            begin
              pkts := s + Format('%10d', [ticks-tc0]);
              LogListBox.Items[k] := pkts;
            end;
        end;

      k := 0;
      while k < LogListBox.Items.Count do
        begin
          tc0 := dword(LogListBox.Items.Objects[k]);
          if ticks-tc0 > GPSUnitsCleanInterval
            then LogListBox.Items.Delete(k)
            else Inc(k);
        end;

      if fnd then Exit;
      pkts := Format(fmt, [Pkt.DevId, Pkt.Lat, Pkt.Lon, 0, 0]);
      LogListBox.Items.Add(pkts);
      LogListBox.Items.Objects[LogListBox.Items.Count-1] := TObject(ticks);
    except
      pkts := Format(fmt, [Pkt.DevId, Pkt.Lat, Pkt.Lon, 0, 0]);
      LogListBox.Items.Add(pkts);
      LogListBox.Items.Objects[LogListBox.Items.Count-1] := TObject(ticks);
    end;
  end;

begin
  //*** Random speed for debug ***************
  (* Descr := TParamDescr.Create('N');
  try
    for i:=1 to iTanksNum do
      begin
        Descr.SetTankIdAndName(i, asCaptionParams[cpiSpeed]);
        CaptionParamStorage.SetParamDataV(Descr, Random(100));
      end;
  finally
    Descr.Free;
  end; *)
  //******************************************
  LogListBox.Items.BeginUpdate;
  try
    CaptionParamStorage.BeginUpdate;
    try
      ticks := Winapi.Windows.GetTickCount;
      repeat
        Pkt := PopPacket(false);
        if not Assigned(Pkt) then break;
          try
            DoLogGPSData;
          finally
            Pkt.Free;
          end;
      until false;

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
      CaptionParamStorage.EndUpdate;
    end;
  finally
    LogListBox.Items.EndUpdate;
  end;
end;

//////////////// Captions //////////////////
procedure TMainForm.btnCancelCaptionNClick(Sender: TObject);
var
  btn: TButton absolute Sender;
begin
  if StartButton.Enabled or
     (not (Assigned(Sender) and (Sender is TButton) and
       (btn.Tag >= 1) and (btn.Tag <= iCaptionsNum)))
    then Exit;

  CloseGlobalScene(btn.Tag);
end;

procedure TMainForm.btnCaptionNClick(Sender: TObject);
var
  btn: TButton absolute Sender;
  lData: TStrings;
begin
  if StartButton.Enabled or
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

procedure TMainForm.OnEndUpdateParamStorage(Sender: TObject);
var
  i: integer;
  lData: TStrings;
begin
  OpenRecords(0, nil);
  try
    lData := TStringList.Create;
    try
      for i:=1 to iCaptionsNum do
        begin
          FSettings.GetCaptionData(i, lData);
          UpdateGlobalScene(lData);
        end;
    finally
      lData.Free;
    end;
  finally
    CloseRecords(0, nil);
  end;
end;

{procedure TMainForm.OnParamValueChanged(Descr: TParamDescr;
  const OldValue, NewValue, OldValueFmt, NewValueFmt: string);
var
  lData: TStrings;
  CaptionIdx: integer;
begin
  lData := TStringList.Create;
  try
    CaptionIdx := Titers.GetCaptionIndex;
    if CaptionIdx = -1 then Exit;
    FSettings.GetCaption1DescrData(Descr, NewValueFmt, CaptionIdx, lData);
    UpdateGlobalScene(lData);
  finally
    lData.Free;
  end;
end;}

procedure TMainForm.btnEditCaptionsClick(Sender: TObject);
begin
  FSettings.Edit;
end;

procedure TMainForm.btnCountriesClick(Sender: TObject);
begin
  if not StartButton.Enabled
    then ShowCountries(VideoTrunk);
end;

procedure TMainForm.btnCloseCountriesClick(Sender: TObject);
begin
  if not StartButton.Enabled
    then CloseCountries;
end;

///////////////////////////////////////////

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
  Ids: TIdArray;
  i, j : integer;
  GPSId: integer;
  Idx : integer;
  Box : TCheckBox;
  str : string;

  procedure GetSelectedTankIdx;
  var
    k: integer;
  begin
    Idx := 0;
    for k:=1 to MaxOneVehicles do
      if Vehicles[k].Id = GPSId then
        begin
          Idx := k;
          Exit;
        end;
  end;

begin
  Ids[1] := StrToIntDef(Tank1Edit.Text, -1);
  Ids[2] := StrToIntDef(Tank2Edit.Text, -1);
  Ids[3] := StrToIntDef(Tank3Edit.Text, -1);
  Ids[4] := StrToIntDef(Tank4Edit.Text, -1);

  // Из CheckBox-ов определим, за какими танками будем вести камеру.
  j := 0;
  for i := 1 to MaxOneVehicles do begin
    GPSId := Ids[i];
    if GPSId = -1 then Continue;
    str := 'TankBox' + IntToStr(i);
    Box := TCheckBox( Poligon2DGroupBox.FindChildControl( str ) );
    if Box.Checked then
    begin
      GetSelectedTankIdx;
      if Idx > 0 then
        begin
          ViewTanks[j] := Idx;
          inc(j);
        end;
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

procedure TMainForm.chbShowFlagsClick(Sender: TObject);
var
  v: integer;
begin
  if FRunning then
    begin
      if chbShowFlags.Checked
        then v := 1
        else v := 0;
      ShowFlags := v;
      FSettings.WriteInteger(sUISect, sShowFlags_key, v);

      if FSettings.Modified
        then FSettings.UpdateFile;
    end;
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
  //  прочитаем трек для тестов.
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
  CloseEngine(0, nil);
end;



procedure TMainForm.FormCreate(Sender: TObject);
begin
  //  Для x64 нет FPU команд. Отключим FPU исключения.
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

    ShowFlags := FSettings.ReadInteger(sUISect, sShowFlags_key, iShowFlags_def);
    chbShowFlags.Checked := (ShowFlags > 0);

    GPSServerConnectFrame1.GPSCheckQueueTimer.Interval := GPSQueueCheckInterval;
    GPSServerConnectFrame1.GPSCheckQueueTimer.OnTimer := GPSCheckQueueEvent;
    GPSServerConnectFrame1.UpdateUI(Self);

    CheckSimOption;
  finally
    FRunning := true;
  end;
end;


procedure TMainForm.FormDestroy(Sender: TObject);
begin
  // CaptionParamStorage.OnParamChanged := nil;
  CaptionParamStorage.OnEndUpdate := nil;
  if FSettings.Modified
    then FSettings.UpdateFile;
  FSettings.Free;
end;

procedure TMainForm.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  GWheelDelta := WheelDelta;
end;

procedure TMainForm.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  case Msg.CharCode of
    VK_F1: _GPSTelemetry.pRefresh(nil);
  end;
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

  btnCountries.Enabled := true;
  btnCloseCountries.Enabled := true;
  btnCaption1.Enabled := true;
  btnCaption2.Enabled := true;
  btnCaption3.Enabled := true;
  btnCaption4.Enabled := true;
  btnCancelCaption1.Enabled := true;
  btnCancelCaption2.Enabled := true;
  btnCancelCaption3.Enabled := true;
  btnCancelCaption4.Enabled := true;

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

  //  Покажем полигон и все танки.
  ShowPoligon2D( 16, VideoTrunk, @Ids );

  CloseRecords( 0, nil );
end;

(*
procedure TMainForm.AddLogGpsData(const GpsData: TGpsData; ticks: dword);
var
  TankId: integer;
  Lat, Lon, Dist: single;
  TimeMilli: JtpRes;
  PacketNum: integer;
  Batt: integer;
  Speed: single;
begin
  TankId := GpsData.VehicleId;
  Lat  := GpsData.Latitude;
  Lon  := GpsData.Longitude;
  Dist := GpsData.Distance;
  TimeMilli := GpsData.TimeMilli;
  PacketNum := GpsData.PacketNum;
  Batt  := GpsData.Battery;
  Speed := GpsData.Speed;

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
        v: single;
      begin
        for i:=1 to iTanksNum do
          if Vehicles[i].Id = TankId then break;

        v := (Speed / 1000) * 3600; // convert to kmh
        Vehicles[i].Vcur := v;
        CaptionParamStorage.SetParamDataV(cpiSpeed, i, Round(v));
        if v > Vehicles[i].Vmax then
          begin
            Vehicles[i].Vmax := v;
            CaptionParamStorage.SetParamDataV(cpiSpeed_max, i, Round(v));
          end;

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
*)

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
  _GPSTelemetry.Show;
end;

procedure TMainForm.btnZeroSpeedsClick(Sender: TObject);
begin
  CaptionParamStorage.BeginUpdate;
  try
    CaptionParamStorage.ZeroSpeeds;
  finally
    CaptionParamStorage.EndUpdate;
  end;
end;

procedure TMainForm.btnRefreshClick(Sender: TObject);
begin
  _GPSTelemetry.pRefresh(nil);
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  Orient : TVector;
begin
  OpenRecords( 0, nil );

  CameraInclination := -90.0;
  Orient.VSet( 0.0, 0.0, CameraInclination );
  SetObjectSpace( @PoligonSceneName, 'Camera', nil, @Orient, nil, nil, nil, nil, 0.0, JTP_ABSOLUTE, nil );

  CloseRecords( 0, nil );
end;

end.
