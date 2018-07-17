unit SettingsUnit;

interface


uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,

  JTPStudio, TypesJTP, VideoSetsHeader, Decklink;

type
  TSettingsForm = class(TForm)
    Out1TrunkBox: TGroupBox;
    VideoInputBox: TGroupBox;
    Out1VideoModeBox: TComboBox;
    InputVideoModeBox: TComboBox;
    Out1Device1Button: TRadioButton;
    Out1Device2Button: TRadioButton;
    VideoSetsButtonOK: TButton;
    InputDevice1Button: TRadioButton;
    InputDevice2Button: TRadioButton;
    Out1PassCheckBox: TCheckBox;
    SimOutBox: TCheckBox;
    SimInputBox: TCheckBox;
    Out1Device3Button: TRadioButton;
    InputDevice3Button: TRadioButton;
    Out1TrunkCheckBox: TCheckBox;
    Out2TrunkBox: TGroupBox;
    Out2VideoModeBox: TComboBox;
    Out2Device1Button: TRadioButton;
    Out2Device2Button: TRadioButton;
    Out2PassCheckBox: TCheckBox;
    Out2Device3Button: TRadioButton;
    Out2TrunkCheckBox: TCheckBox;
    procedure VideoSetsButtonOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    FErrorFlag: integer;
    procedure CreateSimulators;
  public
    { Public declarations }
  end;

var
  SettingsForm: TSettingsForm;

  DllApp: TApplication = nil;

  FirstStart : boolean = true;

  gpCloseFunc: TVideoCloseSetsFunc;

  VideoSets: TVideoSets;

  DevicesNames : array[0..MAX_VIDEO_DEVICES] of Str256;   // 16 devices [0..15] + 17th [16] for null char.

  VideoTrunks : array[0..LAST_VIDEO_TRUNK] of TVideoTrunk;

  OutWindows : array [0..LAST_VIDEO_TRUNK] of HWND;

  TrunkFlags : array [0..LAST_VIDEO_TRUNK] of integer;


implementation

{$R *.dfm}


function VideoStartSets( Flags: integer;  MainApp: TApplication;  OutWins: PHwndArray;  pTrunkFlags: PTrunkFlagsArray;  pCloseFunc: TVideoCloseSetsFunc;  pReserve: pointer ) : integer; stdcall;
var trunk : integer;
begin
  DllApp := Application;
  Application := MainApp;

  SettingsForm := TSettingsForm.Create(Application.MainForm);
  SettingsForm.Show();

  if( OutWins <> nil ) then begin
	  for trunk := 0 to LAST_VIDEO_TRUNK do
  	  OutWindows[trunk] := OutWins^[trunk];
  end else begin
    for trunk := 0 to LAST_VIDEO_TRUNK do
  	  OutWindows[trunk] := 0;
  end;

  if( pTrunkFlags <> nil ) then begin
    for trunk := 0 to LAST_VIDEO_TRUNK do
      TrunkFlags[trunk] := pTrunkFlags^[trunk];
  end else begin
    for trunk := 0 to LAST_VIDEO_TRUNK do
      TrunkFlags[trunk] := 0;
  end;

  gpCloseFunc := pCloseFunc;

  VideoStartSets := 0;
end;


procedure TSettingsForm.CreateSimulators;
var
  Res: UInt64;
  EnumParams : dword;
  DeviceType : dword;
  EnumDeviceData : TJtpFuncData;
begin
  EnumParams := EnumVidDevsNoWarn;
  DeviceType := SIMULATOR_VIDEO_DEVICE;
  FillChar(DevicesNames, SizeOf(DevicesNames), #0);
  Res := EnumerateVideoDevices(DeviceType, @DevicesNames, EnumParams, @EnumDeviceData);
  if Res <> JTP_OK then
    begin
      FErrorFlag := 2;
      //  Show error.
      if EnumDeviceData.pErrorsStr <> nil then
        begin
        end;
    end;
end;

procedure TSettingsForm.FormActivate(Sender: TObject);
var Res: UInt64;
    trunk, device : integer;
    EnumParams : dword;
    DeviceType : dword;
    str : string;
    TrunkBox : TGroupBox;
    DeviceButton : TRadioButton;
    EnumDeviceData : TJtpFuncData;
begin
  if( not FirstStart ) then
    exit;

  FirstStart := false;
  FErrorFlag := -1;

  EnumParams := 0;

  Out1VideoModeBox.ItemIndex := 0;
  Out2VideoModeBox.ItemIndex := 0;

  DeviceType := DECKLINK_VIDEO_DEVICE;

  //  Очистим стволы в значения по умолчанию. Назначим окна вывода видео.
  for trunk := 0 to LAST_VIDEO_TRUNK do
    VideoTrunks[trunk].ClearForDecklink();

  // if( SimOutBox.Checked ) then begin
  //   EnumParams := EnumParams or EnumVidDevsNoWarn;
  //   DeviceType := SIMULATOR_VIDEO_DEVICE;
  // end;

  //  Найдём видео девайсы.
  Res := EnumerateVideoDevices( DeviceType, @DevicesNames, EnumParams, @EnumDeviceData );
  if( Res = JTP_OK ) then begin

    //  Запишем имена девайсов в контролы на форме

    //  Проходим по GroupBox-ам стволов.
    for trunk := 0 to LAST_VIDEO_TRUNK do begin

      str := 'Out' + IntToStr(trunk+1) + 'TrunkBox';
      TrunkBox := TGroupBox( TForm(Sender).FindChildControl( str ) );
      if( TrunkBox <> nil ) then begin

        //  Проходим по девайсам в стволе.
        for device := 0 to LAST_VIDEO_DEVICE do begin
          if( DevicesNames[device].text[0] <> #0 )  then begin
            str := 'Out' + IntToStr(trunk+1) + 'Device' + IntToStr(device+1) + 'Button';
            DeviceButton := TRadioButton( TrunkBox.FindChildControl( str ) );
            if( DeviceButton <> nil ) then begin
              //  Запишем имя девайса в контрол.
              DeviceButton.Visible := true;
              DeviceButton.Caption := String( DevicesNames[device].text );
            end;
          end;
        end;
      end;
    end;
  end else begin
    FErrorFlag := 1;
    //  Show error.
    if( EnumDeviceData.pErrorsStr <> nil ) then begin

    end;
  end;
end;


procedure TSettingsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  try
    if( Pointer(@gpCloseFunc) <> nil ) then
      gpCloseFunc( FErrorFlag, @VideoSets );
  except
  end;
end;

procedure TSettingsForm.FormDestroy(Sender: TObject);
begin
  if Assigned(DllApp) then Application := DllApp;
  SettingsForm := nil;
end;

procedure TSettingsForm.VideoSetsButtonOKClick(Sender: TObject);
var Res: UInt64;
    trunk : integer;
    str : string;
    TrunkGrBox : TGroupBox;
    TrunkCheckBox : TCheckBox;
    pTrunk : PVideoTrunk;
    device : integer;
    DeviceButton : TRadioButton;
    ComboBox : TComboBox;
    VideoModeIndex : integer;
    KeyPassButton : TRadioButton;
    ind : integer;
    InitVideoDesc : TInitVideoDesc;
begin

  if SimOutBox.Checked then CreateSimulators;

  //  Проходим по стволам.
  for trunk := 1 to MAX_VIDEO_TRUNKS do begin

  		pTrunk := @VideoTrunks[trunk-1];

      pTrunk.hOutWindow := OutWindows[trunk-1];

      //  GroupBox ствола.
      str := 'Out' + IntToStr(trunk) + 'TrunkBox';
      TrunkGrBox := TGroupBox( SettingsForm.FindChildControl(str) );
      if( TrunkGrBox <> nil ) then begin
        //  CheckBox ствола.
        str := 'Out' + IntToStr(trunk) + 'TrunkCheckBox';
        TrunkCheckBox := TCheckBox( TrunkGrBox.FindChildControl(str) );
        if( TrunkCheckBox.Checked ) then begin

          pTrunk.ScreensHorizontal := 1;
          pTrunk.ScreensVertical := 1;

          //  Видео режим.
          str := 'Out' + IntToStr(trunk) + 'VideoModeBox';
          ComboBox := TComboBox( TrunkGrBox.FindChildControl(str) );
          VideoModeIndex := ComboBox.ItemIndex;

          if( VideoModeIndex = 0 )  then  pTrunk.OutputDisplayMode := bmdModeHD1080i50;
          if( VideoModeIndex = 1 )  then  pTrunk.OutputDisplayMode := bmdModePAL;
          if( VideoModeIndex = 2 )  then  pTrunk.OutputDisplayMode := bmdMode4K2160p25;
          if( VideoModeIndex = 3 )  then  pTrunk.OutputDisplayMode := bmdMode4K2160p50;

          if( VideoModeIndex = 5 )  then  pTrunk.OutputDisplayMode := bmdModeHD1080p24;
          if( VideoModeIndex = 6 )  then  pTrunk.OutputDisplayMode := bmdModeHD1080p25;
          if( VideoModeIndex = 7 )  then  pTrunk.OutputDisplayMode := bmdModeHD1080p30;
          if( VideoModeIndex = 8 )  then  pTrunk.OutputDisplayMode := bmdModeHD1080p50;
          if( VideoModeIndex = 9 )  then  pTrunk.OutputDisplayMode := bmdModeHD1080p6000;

          if( VideoModeIndex = 11 ) then  pTrunk.OutputDisplayMode := bmdModeHD1080i6000;

          if( VideoModeIndex = 13 ) then  pTrunk.OutputDisplayMode := bmdMode4K2160p24;
          if( VideoModeIndex = 14 ) then  pTrunk.OutputDisplayMode := bmdMode4K2160p30;
          if( VideoModeIndex = 15 ) then  pTrunk.OutputDisplayMode := bmdMode4K2160p60;

          if( VideoModeIndex = 17 ) then  pTrunk.OutputDisplayMode := bmdModeHD720p50;
          if( VideoModeIndex = 18 ) then  pTrunk.OutputDisplayMode := bmdModeHD720p60;

          if( VideoModeIndex = 20 ) then  pTrunk.OutputDisplayMode := bmdModeNTSC;

          // Вкл/Выкл кейер на проход.
          str := 'Out' + IntToStr(trunk) + 'PassCheckBox';
          KeyPassButton := TRadioButton( TrunkGrBox.FindChildControl(str) );
          if( KeyPassButton.Checked ) then
            pTrunk.Flags := pTrunk.Flags or TrunkVideo_KeyPass;

          pTrunk.Flags := pTrunk.Flags or TrunkFlags[trunk-1];

        end else begin
          pTrunk.ScreensHorizontal := 0;
          pTrunk.ScreensVertical := 0;
        end;

        if SimOutBox.Checked then
          begin
            if (trunk = 1) or (trunk = 2)
              then pTrunk.OutDevices[0] := trunk;
          end
                             else
          begin
            //  Проходим по девайсам в стволе.
            ind := 0;
            for device := 1 to MAX_VIDEO_DEVICES do begin
              if( DevicesNames[device-1].text[0] <> #0 )  then begin
                str := 'Out' + IntToStr(trunk) + 'Device' + IntToStr(device) + 'Button';
                DeviceButton := TRadioButton( TrunkGrBox.FindChildControl(str) );
                if( (DeviceButton <> nil) and (DeviceButton.Checked) ) then begin
                  pTrunk.OutDevices[ind] := device;
                  Inc(ind);
                end;
              end;
            end;
          end;
      end;
  end;

  with InitVideoDesc do begin
    Version := 1;
    VerticalBlur := 0.15;
 	  ScreenAlpha := 1.0;
    ClearColor := $00999999;
  end;

  Res := InitVideo( @VideoTrunks, 0, @InitVideoDesc );
  if( Res = JTP_OK ) then begin
    VideoSets.Clear();

    if( Out1TrunkCheckBox.Checked ) then
      VideoSets.Trunk1 := 1;
    if( Out2TrunkCheckBox.Checked ) then
      VideoSets.Trunk2 := 2;

    FErrorFlag := 0;
    // if( gpCloseFunc <> nil ) then
      // gpCloseFunc( 0, @VideoSets );
    // end;
  end else begin
    FErrorFlag := 3;
    //  Show error.
    if( InitVideoDesc.pErrorsStr <> nil ) then begin
    end;
  end;

  SettingsForm.Close();
  // SettingsForm.Destroy();
  // SettingsForm := nil;
end;


exports VideoStartSets;



end.
