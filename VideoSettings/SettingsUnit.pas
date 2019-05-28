unit SettingsUnit;

interface


uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,

  JTPStudio, TypesJTP, VideoSetsHeader;

type
  TSettingsForm = class(TForm)

    VideoInputBox: TGroupBox;

    InputVideoModeBox: TComboBox;

    VideoSetsButtonOK: TButton;
    VideoModesBoxTemplate: TComboBox;
    MultiScreensBoxTemplate: TComboBox;

    procedure VideoSetsButtonOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    FErrorFlag: integer;
    //procedure CreateSimulators;
  public
    { Public declarations }
  end;

var
  SettingsForm: TSettingsForm;

  DllApp: TApplication = nil;

  FirstStart : boolean = true;

  gpCloseFunc: TVideoCloseSetsFunc;

  GVideoSets: PVideoSets;

  DevicesNames : array[0..MAX_VIDEO_DEVICES] of Str256;   // 16 devices [0..15] + 17th [16] for null char.

  //VideoTrunks : array[0..LAST_VIDEO_TRUNK] of TVideoTrunk;

  //OutWindows : array [0..LAST_VIDEO_TRUNK] of HWND;

  //TrunkFlags : array [0..LAST_VIDEO_TRUNK] of integer;


implementation

{$R *.dfm}


function GetVersionVideoSets( Flags: integer;  pReserve: pointer ) : integer; stdcall;
begin
  GetVersionVideoSets := 1;
end;



function VideoStartSets( Flags: integer;  MainApp: TApplication;  VideoSets : PVideoSets;{OutWins: PHwndArray;  pTrunkFlags: PTrunkFlagsArray;}
                         pCloseFunc: TVideoCloseSetsFunc;  pReserve: pointer ) : integer; stdcall;
//var trunk : integer;
begin
  GVideoSets := VideoSets;

  DllApp := Application;
  Application := MainApp;

  SettingsForm := TSettingsForm.Create(Application.MainForm);
  SettingsForm.Show();

  //  Надо создать TrunkBox-ы исходя из VideoSets.NumRequestTrunks.
  //  ...

  gpCloseFunc := pCloseFunc;

  VideoStartSets := 0;
end;


{procedure TSettingsForm.CreateSimulators;
var
  Res: JtpRes;
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
end;}


procedure TSettingsForm.FormActivate(Sender: TObject);
var Res: JtpRes;
    trunk, device, dvy, ind, i : integer;
    EnumParams : dword;
    DeviceTypes : dword;
    str : string;

    EnumDeviceData : TEnumVideoDevices;

    VideoForm : TForm;
    FormWidth : integer;

    TrunkBox : TGroupBox;
    TrunkBoxX, TrunkBoxW : integer;
    pTrunk : PVideoTrunk;

    DeviceBox, CheckBox : TCheckBox;
    ComboBox : TComboBox;
    MyLabel : TLabel;

    VideoModeStrings, ScreenConfigStrings : TStrings;

    sim_str : integer;
    HardwarePresent : boolean;
begin
  if( not FirstStart ) then
    exit;

  VideoForm := TForm(Sender);
  FormWidth := 200;

  VideoSetsButtonOK.SetFocus();

  FirstStart := false;
  FErrorFlag := 0;//-1;

  EnumParams := 0;

  InputVideoModeBox.ItemIndex := 0;

  EnumDeviceData.Create();
  EnumDeviceData.NumRequestSimulators := GVideoSets.NumRequestSimulators;

  DeviceTypes := DECKLINK_VIDEO_DEVICE;
  if( EnumDeviceData.NumRequestSimulators <> 0 ) then
    DeviceTypes := DeviceTypes or SIMULATOR_VIDEO_DEVICE;

  //  Найдём видео девайсы.
  Res := EnumerateVideoDevices( DeviceTypes, @DevicesNames, EnumParams, @EnumDeviceData );

  if( Res = JTP_OK ) then begin

    //  Есть ли аппаратные девайсы в системе?
    HardwarePresent := false;
    for device := 0 to LAST_VIDEO_DEVICE do begin
      if( DevicesNames[device].text[0] <> #0 )  then begin
        i := pos( 'DeckLink', DevicesNames[device].text );
        if( i <> 0 ) then begin
          HardwarePresent := true;
          break;
        end;
      end;
    end;

    //  Список видео-режимов.
    ComboBox := TComboBox( VideoForm.FindChildControl('VideoModesBoxTemplate') );
    if( ComboBox <> nil ) then
      VideoModeStrings := ComboBox.Items;

    //  Список конфигураций ствола (1x1, 2x1, ...).
    ComboBox := TComboBox( VideoForm.FindChildControl('MultiScreensBoxTemplate') );
    if( ComboBox <> nil ) then
      ScreenConfigStrings := ComboBox.Items;

    TrunkBoxX := 15;  TrunkBoxW := 230;

    //  Запишем имена девайсов в контролы на форме

    //  Проходим по GroupBox-ам стволов.
    for trunk := 0 to GVideoSets.NumRequestTrunks-1 do begin

      pTrunk := @GVideoSets.Trunks[trunk-1];

      //str := 'Trunk' + IntToStr(trunk+1) + 'Box';
      //TrunkBox := TGroupBox( VideoForm.FindChildControl( str ) );
      //if( TrunkBox <> nil ) then begin

      //  Создадим GroupBox для ствола.
      TrunkBox := TGroupBox.Create(VideoForm);
      TrunkBox.Parent := VideoForm;
      TrunkBox.Name := 'Trunk' + IntToStr(trunk+1) + 'Box';
      TrunkBox.Caption := '';
      TrunkBox.Visible := true;
      TrunkBox.Left := TrunkBoxX;    inc(TrunkBoxX, 260);
      TrunkBox.Top := 30;
      TrunkBox.Width := TrunkBoxW;
      TrunkBox.Height := 280;

      //  Галоча "Вкл ствол"
      CheckBox := TCheckBox.Create(VideoForm);
      CheckBox.Parent := VideoForm;
      CheckBox.Name := 'Trunk' + IntToStr(trunk+1) + 'EnableBox';
      CheckBox.Caption := 'Видео - ствол ' + IntToStr(trunk+1);
      CheckBox.Visible := true;
      CheckBox.Left := TrunkBox.Left + 16;
      CheckBox.Top := TrunkBox.Top - 7;
      CheckBox.Width := 100;
      CheckBox.Height := 17;
if( trunk = 0 ) then CheckBox.Checked := true;

      //  Список видео-режимов.
      ComboBox := TComboBox.Create(TrunkBox);
      ComboBox.Parent := TForm(TrunkBox);
      ComboBox.Name := 'Trunk' + IntToStr(trunk+1) + 'VideoModeBox';
      ComboBox.Visible := true;
      ComboBox.Items := VideoModeStrings;
      ComboBox.ItemIndex := 0;
      ComboBox.Left := 16;
      ComboBox.Top := 16;
      ComboBox.Width := 170;
      ComboBox.Height := 21;

      //  Проходим по девайсам, создаём CheckBox для девайса, записываем его имя.
      dvy := 50;    ind := 0;

      for device := 0 to LAST_VIDEO_DEVICE do begin
        if( DevicesNames[device].text[0] <> #0 )  then begin

          //sim_str := pos( 'Simulator', DevicesNames[device].text );
          //if( (sim_str <> 0) and (HardwarePresent) ) then
          //  continue;

          //  Выбраны симуляторы или аппаратные девайсы.
          //if( (GVideoSets.SimulatorOutput = 0) and (sim_str <> 0) ) then
          //  continue;
          //if( (GVideoSets.SimulatorOutput <> 0) and (sim_str = 0) ) then
          //  continue;

          DeviceBox := TCheckBox.Create(TrunkBox);
          DeviceBox.Parent := TrunkBox;
          DeviceBox.Name := 'Device' + IntToStr(device+1);
          DeviceBox.Caption := DevicesNames[device].text;
          DeviceBox.Visible := true;
          DeviceBox.Left := 16;
          DeviceBox.Top := dvy;    inc(dvy,19);
          DeviceBox.Width := 200;
          DeviceBox.Height := 17;

//if( ( trunk = 0 ) and ( ind >= 0 ) and ( ind <= 2 ) ) then  DeviceBox.Checked := true;
//if( ( trunk = 1 ) and ( ind = 3 ) ) then  DeviceBox.Checked := true;

if( ( trunk = 0 ) and ( ind = 0 ) ) then DeviceBox.Checked := true;
if( ( trunk = 1 ) and ( ind = 1 ) ) then DeviceBox.Checked := true;

          inc(ind);
        end;
      end;

      //  Конфигурация ствола (1х1, 2х1, ...)
      dvy := dvy + 15;
      MyLabel := TLabel.Create(TrunkBox);
      MyLabel.Parent := TrunkBox;
      MyLabel.Name := 'Trunk' + IntToStr(trunk+1) + 'MultiScreenText';
      MyLabel.Caption := 'Мульти экраны: ';
      MyLabel.Visible := true;
      MyLabel.Left := 16;
      MyLabel.Top := dvy;
      MyLabel.Width := 82;
      MyLabel.Height := 17;

      //  Список конфигураций ствола.
      ComboBox := TComboBox.Create(TrunkBox);
      ComboBox.Parent := TForm(TrunkBox);
      ComboBox.Name := 'Trunk' + IntToStr(trunk+1) + 'MultiScreensBox';
      ComboBox.Visible := true;
      ComboBox.Items := ScreenConfigStrings;
      ComboBox.Text := '1x1';
      ComboBox.Left := MyLabel.Left + MyLabel.Width + 5;
      ComboBox.Top := MyLabel.Top - 3;
      ComboBox.Width := 49;
      ComboBox.Height := 21;

      // Галочка "На проход"
      dvy := dvy + 30;
      CheckBox := TCheckBox.Create(TrunkBox);
      CheckBox.Parent := TrunkBox;
      CheckBox.Name := 'Trunk' + IntToStr(trunk+1) + 'PassCheckBox';
      CheckBox.Caption := 'На проход';
      CheckBox.Visible := true;
      CheckBox.Left := 16;
      CheckBox.Top := dvy;
      CheckBox.Width := 73;
      CheckBox.Height := 17;
      if( (pTrunk.Flags and TrunkVideo_KeyPass) <> 0 ) then
        CheckBox.Checked := true
      else
        CheckBox.Checked := false;

      // Галочка "Симулятор"
      CheckBox := TCheckBox.Create(TrunkBox);
      CheckBox.Parent := TrunkBox;
      CheckBox.Name := 'Device' + IntToStr(device+1);
      CheckBox.Caption := 'Симулятор';
      CheckBox.Visible := true;
      CheckBox.Left := 110;
      CheckBox.Top := dvy;
      CheckBox.Width := 70;
      CheckBox.Height := 17;
      if( (DeviceTypes and SIMULATOR_VIDEO_DEVICE) <> 0 ) then
        CheckBox.Checked := true;

      TrunkBox.Height := dvy + 30;

      FormWidth := TrunkBox.Left + TrunkBoxW + 30;
      //end;
    end;

    //  Видео вход.
    if( GVideoSets.InputProperties.Present <> 0 ) then begin

      VideoInputBox.Left := TrunkBoxX + 20;
      VideoInputBox.Visible := true;

      // Запишем имена девайсов для видео входа.
      dvy := 65;    ind := 0;
      for device := 0 to LAST_VIDEO_DEVICE do begin
        if( DevicesNames[device].text[0] <> #0 )  then begin

          sim_str := ansipos( 'Simulator', DevicesNames[device].text );

          //  Выбраны симуляторы или аппаратные девайсы.
          //if( (GVideoSets.SimulatorInput = 0) and (sim_str <> 0) ) then
          //  continue;
          //if( (GVideoSets.SimulatorInput <> 0) and (sim_str = 0) ) then
          //  continue;

          DeviceBox := TCheckBox.Create(VideoInputBox);
          DeviceBox.Parent := VideoInputBox;
          DeviceBox.Name := 'Device' + IntToStr(device+1);
          DeviceBox.Caption := DevicesNames[device].text;
          DeviceBox.Visible := true;
          DeviceBox.Left := 16;
          DeviceBox.Top := dvy;    inc(dvy,19);
          DeviceBox.Width := 200;
          DeviceBox.Height := 17;

  //if( ind = 3 ) then DeviceBox.Checked := true;

          inc(ind);

        end;
      end;

      VideoInputBox.Height := dvy + 15;

      FormWidth := VideoInputBox.Left + VideoInputBox.Width + 50;
    end;

    VideoSetsButtonOK.Top := TrunkBox.Top + TrunkBox.Height + 30;

    VideoForm.Width := FormWidth;
    VideoForm.Height := VideoSetsButtonOK.Top + VideoSetsButtonOK.Height + 60;

    VideoSetsButtonOK.Left := Round( (VideoForm.Width - VideoSetsButtonOK.Width) / 2 );

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
      gpCloseFunc( FErrorFlag, GVideoSets );
  except
  end;
end;


procedure TSettingsForm.FormDestroy(Sender: TObject);
begin
  if Assigned(DllApp) then Application := DllApp;
  SettingsForm := nil;
end;



function GetDisplayModeByIndex( Index: integer ) : integer;
begin
  GetDisplayModeByIndex := VideoModeNull;

  if( Index = 0 )  then  GetDisplayModeByIndex := VideoModeHD1080i50;
  if( Index = 1 )  then  GetDisplayModeByIndex := VideoModePAL;
  if( Index = 2 )  then  GetDisplayModeByIndex := VideoMode4K2160p25;
  if( Index = 3 )  then  GetDisplayModeByIndex := VideoMode4K2160p50;

  if( Index = 5 )  then  GetDisplayModeByIndex := VideoModeHD1080p24;
  if( Index = 6 )  then  GetDisplayModeByIndex := VideoModeHD1080p25;
  if( Index = 7 )  then  GetDisplayModeByIndex := VideoModeHD1080p30;
  if( Index = 8 )  then  GetDisplayModeByIndex := VideoModeHD1080p50;
  if( Index = 9 )  then  GetDisplayModeByIndex := VideoModeHD1080p60;

  if( Index = 11 ) then  GetDisplayModeByIndex := VideoModeHD1080i60;

  if( Index = 13 ) then  GetDisplayModeByIndex := VideoMode4K2160p24;
  if( Index = 14 ) then  GetDisplayModeByIndex := VideoMode4K2160p30;
  if( Index = 15 ) then  GetDisplayModeByIndex := VideoMode4K2160p60;

  if( Index = 17 ) then  GetDisplayModeByIndex := VideoModeHD720p50;
  if( Index = 18 ) then  GetDisplayModeByIndex := VideoModeHD720p60;

  if( Index = 20 ) then  GetDisplayModeByIndex := VideoModeNTSC;
end;



procedure TSettingsForm.VideoSetsButtonOKClick(Sender: TObject);
var Res: JtpRes;
    trunk : integer;
    str : string;
    VideoForm : TForm;
    TrunkBox : TGroupBox;
    TrunkCheckBox : TCheckBox;
    pTrunk : PVideoTrunk;
    pInputDevice : PVideoInputDevice;
    device : integer;
    DeviceButton : TCheckBox;
    ComboBox : TComboBox;
    //VideoModeIndex : integer;
    KeyPassButton : TCheckBox;
    ind : integer;
    sim_str : integer;
begin

  //if SimOutBox.Checked then CreateSimulators;

  VideoForm := TForm(TButton(Sender).Parent);

  //  Проходим по стволам. Находим выбранные девайсы из контролов на форме.
  for trunk := 1 to GVideoSets.NumRequestTrunks do begin // to MAX_VIDEO_TRUNKS

  		pTrunk := @GVideoSets.Trunks[trunk-1];

      //  GroupBox ствола.
      str := 'Trunk' + IntToStr(trunk) + 'Box';
      TrunkBox := TGroupBox( SettingsForm.FindChildControl(str) );
      if( TrunkBox <> nil ) then begin
        //  EnableBox ствола.
        str := 'Trunk' + IntToStr(trunk) + 'EnableBox';
        TrunkCheckBox := TCheckBox( VideoForm.FindChildControl(str) );
        if( TrunkCheckBox.Checked ) then begin

          pTrunk.Enabled := 1;

          pTrunk.ScreensHorizontal := 1;
          pTrunk.ScreensVertical := 1;

          //  Видео режим.
          str := 'Trunk' + IntToStr(trunk) + 'VideoModeBox';
          ComboBox := TComboBox( TrunkBox.FindChildControl(str) );
          //VideoModeIndex := ComboBox.ItemIndex;

          pTrunk.OutputDisplayMode := GetDisplayModeByIndex( ComboBox.ItemIndex );

          // Вкл/Выкл кейер на проход.
          str := 'Trunk' + IntToStr(trunk) + 'PassCheckBox';
          KeyPassButton := TCheckBox( TrunkBox.FindChildControl(str) );
          if( KeyPassButton.Checked ) then
            pTrunk.Flags := pTrunk.Flags or TrunkVideo_KeyPass
          else
            pTrunk.Flags := pTrunk.Flags and not TrunkVideo_KeyPass;

          //  Проходим по девайсам в стволе, если девайс отмечен галочкой, помещаем его индекс в ствол.
          ind := 0;
          for device := 1 to MAX_VIDEO_DEVICES do begin
            if( DevicesNames[device-1].text[0] <> #0 )  then begin

              str := 'Device' + IntToStr(device);

              DeviceButton := TCheckBox( TrunkBox.FindChildControl(str) );
              if( (DeviceButton <> nil) and (DeviceButton.Checked) ) then begin

                pTrunk.OutDevices[ind] := device;
                Inc(ind);
              end;
            end;
          end;

          //  ComboBox с конфигурацией нескольких экранов.
          str := 'Trunk' + IntToStr(trunk) + 'MultiScreensBox';
          ComboBox := TComboBox( TrunkBox.FindChildControl(str) );
          if( ComboBox <> nil ) then begin

            str := ComboBox.Text;

            // первая цифра поля ComboBox
            pTrunk.ScreensHorizontal := StrToInt(str[1]);
            // вторая цифра поля ComboBox
            pTrunk.ScreensVertical := StrToInt(str[3]);
          end;

        end else begin
          pTrunk.Enabled := 0;
        end;
      end;
  end;

  // Найдём выбранные девайсы для видео входа.
  ind := 0;
  for device := 1 to MAX_VIDEO_DEVICES do begin
    if( DevicesNames[device-1].text[0] <> #0 )  then begin

      str := 'Device' + IntToStr(device);

      DeviceButton := TCheckBox( VideoInputBox.FindChildControl(str) );
      if( (DeviceButton <> nil) and (DeviceButton.Checked) ) then begin

        pInputDevice := @GVideoSets.InputProperties.InputDevices[ind];

        pInputDevice.DisplayMode := GetDisplayModeByIndex( InputVideoModeBox.ItemIndex );

//sim_str := pos( 'Simulator', DevicesNames[device-1].text );
//if( sim_str <> 0 ) then begin
//  pInputDevice.PixelFormat := PixelFormat8BitBGRA; // для тестов
//  pInputDevice.StreamPath.text := 'C:/ALEXBASE/seqs/image001.tga';
//end;

        GVideoSets.InputProperties.InputDevices[ind].Index := device;
        Inc(ind);
      end;

    end;
  end;

  SettingsForm.Close();
  // SettingsForm.Destroy();
  // SettingsForm := nil;
end;


exports GetVersionVideoSets;
exports VideoStartSets;



end.
