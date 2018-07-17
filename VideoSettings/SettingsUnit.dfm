object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1074#1080#1076#1077#1086
  ClientHeight = 317
  ClientWidth = 882
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Out1TrunkBox: TGroupBox
    Left = 17
    Top = 24
    Width = 257
    Height = 161
    Caption = '    '
    TabOrder = 0
    object Out1VideoModeBox: TComboBox
      Left = 16
      Top = 32
      Width = 161
      Height = 21
      TabOrder = 0
      Text = 'HD1080i50'
      Items.Strings = (
        'HD1080i50'
        'PAL'
        '4K2160p25'
        '4K2160p50'
        ''
        'HD1080p24'
        'HD1080p25'
        'HD1080p30'
        'HD1080p50'
        'HD1080p60'
        ''
        'HD1080i60'
        ''
        '4K2160p24'
        '4K2160p30'
        '4K2160p60'
        ''
        'HD720p50'
        'HD720p60'
        ''
        'NTSC')
    end
    object Out1Device1Button: TRadioButton
      Left = 16
      Top = 72
      Width = 201
      Height = 17
      Caption = 'Device1'
      Checked = True
      TabOrder = 1
      TabStop = True
      Visible = False
    end
    object Out1Device2Button: TRadioButton
      Left = 16
      Top = 88
      Width = 201
      Height = 17
      Caption = 'Device2'
      TabOrder = 2
      Visible = False
    end
    object Out1PassCheckBox: TCheckBox
      Left = 16
      Top = 133
      Width = 81
      Height = 17
      Caption = #1053#1072' '#1087#1088#1086#1093#1086#1076
      TabOrder = 3
    end
    object Out1Device3Button: TRadioButton
      Left = 16
      Top = 104
      Width = 201
      Height = 17
      Caption = 'Device3'
      TabOrder = 4
      Visible = False
    end
    object Out1TrunkCheckBox: TCheckBox
      Left = 16
      Top = -2
      Width = 97
      Height = 17
      Caption = #1042#1080#1076#1077#1086' '#1074#1099#1074#1086#1076' 1'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
  end
  object VideoInputBox: TGroupBox
    Left = 617
    Top = 24
    Width = 257
    Height = 137
    Caption = ' '#1042#1080#1076#1077#1086' '#1047#1072#1093#1074#1072#1090' '
    TabOrder = 1
    object InputVideoModeBox: TComboBox
      Left = 16
      Top = 32
      Width = 161
      Height = 21
      TabOrder = 0
      Text = 'HD1080i50'
      Items.Strings = (
        'HD1080i50'
        'PAL'
        '4K2160p25'
        '4K2160p50'
        ''
        'HD1080p24'
        'HD1080p25'
        'HD1080p30'
        'HD1080p50'
        'HD1080p60'
        ''
        'HD1080i60'
        ''
        '4K2160p24'
        '4K2160p30'
        '4K2160p60'
        ''
        'NTSC'
        ''
        'HD720p50'
        'HD720p60')
    end
    object InputDevice1Button: TRadioButton
      Left = 16
      Top = 72
      Width = 201
      Height = 17
      Caption = 'Device1'
      TabOrder = 1
      Visible = False
    end
    object InputDevice2Button: TRadioButton
      Left = 16
      Top = 88
      Width = 201
      Height = 17
      Caption = 'Device2'
      TabOrder = 2
      Visible = False
    end
    object InputDevice3Button: TRadioButton
      Left = 16
      Top = 105
      Width = 201
      Height = 17
      Caption = 'Device3'
      TabOrder = 3
      Visible = False
    end
  end
  object VideoSetsButtonOK: TButton
    Left = 360
    Top = 280
    Width = 129
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = VideoSetsButtonOKClick
  end
  object SimOutBox: TCheckBox
    Left = 738
    Top = 264
    Width = 121
    Height = 17
    Caption = #1057#1080#1084#1091#1083#1103#1090#1086#1088' '#1074#1099#1074#1086#1076#1072
    TabOrder = 3
  end
  object SimInputBox: TCheckBox
    Left = 738
    Top = 287
    Width = 121
    Height = 17
    Caption = #1057#1080#1084#1091#1083#1103#1090#1086#1088' '#1079#1072#1093#1074#1072#1090#1072
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object Out2TrunkBox: TGroupBox
    Left = 296
    Top = 24
    Width = 257
    Height = 161
    Caption = '    '
    TabOrder = 5
    object Out2VideoModeBox: TComboBox
      Left = 16
      Top = 32
      Width = 161
      Height = 21
      TabOrder = 0
      Text = 'HD1080i50'
      Items.Strings = (
        'HD1080i50'
        'PAL'
        '4K2160p25'
        '4K2160p50'
        ''
        'HD1080p24'
        'HD1080p25'
        'HD1080p30'
        'HD1080p50'
        'HD1080p60'
        ''
        'HD1080i60'
        ''
        '4K2160p24'
        '4K2160p30'
        '4K2160p60'
        ''
        'HD720p50'
        'HD720p60'
        ''
        'NTSC')
    end
    object Out2Device1Button: TRadioButton
      Left = 16
      Top = 72
      Width = 201
      Height = 17
      Caption = 'Device1'
      TabOrder = 1
      Visible = False
    end
    object Out2Device2Button: TRadioButton
      Left = 16
      Top = 88
      Width = 201
      Height = 17
      Caption = 'Device2'
      Checked = True
      TabOrder = 2
      TabStop = True
      Visible = False
    end
    object Out2PassCheckBox: TCheckBox
      Left = 16
      Top = 133
      Width = 81
      Height = 17
      Caption = #1053#1072' '#1087#1088#1086#1093#1086#1076
      TabOrder = 3
    end
    object Out2Device3Button: TRadioButton
      Left = 16
      Top = 104
      Width = 201
      Height = 17
      Caption = 'Device3'
      TabOrder = 4
      Visible = False
    end
    object Out2TrunkCheckBox: TCheckBox
      Left = 16
      Top = -2
      Width = 97
      Height = 17
      Caption = #1042#1080#1076#1077#1086' '#1074#1099#1074#1086#1076' 2'
      TabOrder = 5
    end
  end
end
