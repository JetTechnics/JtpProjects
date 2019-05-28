object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1074#1080#1076#1077#1086
  ClientHeight = 416
  ClientWidth = 577
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
  object VideoInputBox: TGroupBox
    Left = 265
    Top = 23
    Width = 232
    Height = 161
    Caption = '   '#1042#1080#1076#1077#1086' '#1047#1072#1093#1074#1072#1090' '
    TabOrder = 0
    Visible = False
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
  end
  object VideoSetsButtonOK: TButton
    Left = 265
    Top = 356
    Width = 129
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = VideoSetsButtonOKClick
  end
  object VideoModesBoxTemplate: TComboBox
    Left = 265
    Top = 217
    Width = 161
    Height = 21
    Enabled = False
    TabOrder = 2
    Text = 'HD1080i50'
    Visible = False
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
  object MultiScreensBoxTemplate: TComboBox
    Left = 432
    Top = 217
    Width = 49
    Height = 21
    Enabled = False
    TabOrder = 3
    Text = '1x1'
    Visible = False
    Items.Strings = (
      '1x1'
      '2x1'
      '3x1'
      '4x1')
  end
end
