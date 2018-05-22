object MainForm: TMainForm
  Left = 200
  Top = 60
  Caption = 'TankBiathlon'
  ClientHeight = 862
  ClientWidth = 1584
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseWheel = FormMouseWheel
  PixelsPerInch = 96
  TextHeight = 13
  object StartButton: TButton
    Left = 8
    Top = 8
    Width = 121
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = StartButtonClick
  end
  object OutVideoPanel: TPanel
    Left = 279
    Top = 8
    Width = 1280
    Height = 720
    Caption = 'OutVideoPanel'
    TabOrder = 1
  end
  object LogListBox: TListBox
    Left = 8
    Top = 744
    Width = 1096
    Height = 96
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 2
  end
  object ZabegGroupBox: TGroupBox
    Left = 8
    Top = 120
    Width = 265
    Height = 353
    Caption = #1047#1072#1073#1077#1075
    TabOrder = 3
    object ShowButton: TButton
      Left = 3
      Top = 24
      Width = 118
      Height = 25
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100
      TabOrder = 0
      OnClick = ShowButtonClick
    end
    object ClosePoligonButton: TButton
      Left = 136
      Top = 24
      Width = 75
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 1
      OnClick = ClosePoligonButtonClick
    end
    object DirectCamButton1: TButton
      Left = 3
      Top = 301
      Width = 57
      Height = 35
      Caption = #1053#1072#1074#1077#1089#1090#1080' '#1082#1072#1084#1077#1088#1091' 1'
      TabOrder = 2
      WordWrap = True
      OnClick = DirectCamButton1Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 56
    Width = 265
    Height = 48
    TabOrder = 4
    object GpsAddrLabel: TLabel
      Left = 9
      Top = 25
      Width = 35
      Height = 13
      Caption = #1040#1076#1088#1077#1089':'
      Enabled = False
    end
    object GpsPortLabel: TLabel
      Left = 164
      Top = 25
      Width = 29
      Height = 13
      Caption = #1055#1086#1088#1090':'
      Enabled = False
    end
    object GpsAddrEdit: TEdit
      Left = 50
      Top = 23
      Width = 92
      Height = 19
      Ctl3D = False
      Enabled = False
      ParentCtl3D = False
      TabOrder = 1
      Text = '172.30.34.137'
    end
    object GpsPortEdit: TEdit
      Left = 199
      Top = 23
      Width = 50
      Height = 19
      Ctl3D = False
      Enabled = False
      ParentCtl3D = False
      TabOrder = 2
      Text = '6543'
    end
    object GpsBox: TCheckBox
      Left = 7
      Top = 1
      Width = 138
      Height = 17
      Caption = 'Broadcast GPS address'
      TabOrder = 0
    end
  end
end
