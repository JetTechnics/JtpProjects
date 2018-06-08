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
    Top = 128
    Width = 265
    Height = 257
    Caption = #1047#1072#1073#1077#1075
    TabOrder = 3
    object Label1: TLabel
      Left = 13
      Top = 69
      Width = 45
      Height = 13
      Caption = #1058#1072#1085#1082#1080' ...'
    end
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
      Enabled = False
      TabOrder = 1
      OnClick = ClosePoligonButtonClick
    end
    object DirectCamButton1: TButton
      Left = 3
      Top = 213
      Width = 57
      Height = 35
      Caption = #1053#1072#1074#1077#1089#1090#1080' '#1082#1072#1084#1077#1088#1091' 1'
      TabOrder = 2
      WordWrap = True
      OnClick = DirectCamButton1Click
    end
    object TankBox1: TCheckBox
      Left = 9
      Top = 89
      Width = 14
      Height = 17
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 3
    end
    object TankBox2: TCheckBox
      Left = 9
      Top = 115
      Width = 14
      Height = 17
      TabOrder = 4
    end
    object TankBox3: TCheckBox
      Left = 9
      Top = 141
      Width = 14
      Height = 17
      TabOrder = 5
    end
    object TankBox4: TCheckBox
      Left = 9
      Top = 168
      Width = 14
      Height = 17
      Color = clHighlight
      ParentColor = False
      TabOrder = 6
    end
    object Tank1Edit: TEdit
      Tag = 1
      Left = 26
      Top = 90
      Width = 24
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 7
      Text = '5'
    end
    object Tank2Edit: TEdit
      Tag = 2
      Left = 26
      Top = 116
      Width = 24
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 8
      Text = '6'
    end
    object Tank3Edit: TEdit
      Tag = 3
      Left = 26
      Top = 142
      Width = 24
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 9
      Text = '7'
    end
    object Tank4Edit: TEdit
      Tag = 4
      Left = 26
      Top = 167
      Width = 24
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 10
      Text = '8'
    end
    object DirectCamButton2: TButton
      Left = 73
      Top = 213
      Width = 57
      Height = 35
      Caption = #1053#1072#1074#1077#1089#1090#1080' '#1082#1072#1084#1077#1088#1091' 2'
      TabOrder = 11
      WordWrap = True
      OnClick = DirectCamButton2Click
    end
    object CommonViewButton: TButton
      Left = 142
      Top = 213
      Width = 75
      Height = 35
      Caption = #1054#1073#1097#1080#1081' '#1087#1083#1072#1085
      TabOrder = 12
      OnClick = CommonViewButtonClick
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
  object CrewButton: TButton
    Left = 8
    Top = 441
    Width = 60
    Height = 25
    Caption = #1069#1082#1080#1087#1072#1078
    TabOrder = 5
    OnClick = CrewButtonClick
  end
  object CloseCrewButton: TButton
    Left = 70
    Top = 441
    Width = 59
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 6
    OnClick = CloseCrewButtonClick
  end
  object OtsechkaButton: TButton
    Left = 8
    Top = 496
    Width = 60
    Height = 25
    Caption = #1054#1090#1089#1077#1095#1082#1072
    TabOrder = 7
    OnClick = OtsechkaButtonClick
  end
  object CloseOtsechkaButton: TButton
    Left = 70
    Top = 496
    Width = 59
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 8
    OnClick = CloseOtsechkaButtonClick
  end
end
