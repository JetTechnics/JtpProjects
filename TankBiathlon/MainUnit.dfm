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
    Width = 1297
    Height = 720
    Caption = 'OutVideoPanel'
    TabOrder = 1
  end
  object LogListBox: TListBox
    Left = 8
    Top = 744
    Width = 1568
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
  object Poligon2DGroupBox: TGroupBox
    Left = 8
    Top = 160
    Width = 265
    Height = 225
    Caption = ' '#1055#1086#1083#1080#1075#1086#1085' 2D '
    TabOrder = 3
    object Label1: TLabel
      Left = 10
      Top = 64
      Width = 81
      Height = 13
      Caption = #1050#1086#1083'-'#1074#1086' '#1090#1072#1085#1082#1086#1074': '
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
      Left = 13
      Top = 173
      Width = 57
      Height = 35
      Caption = #1053#1072#1074#1077#1089#1090#1080' '#1082#1072#1084#1077#1088#1091' 1'
      TabOrder = 2
      WordWrap = True
      OnClick = DirectCamButton1Click
    end
    object DirectCamButton2: TButton
      Left = 76
      Top = 173
      Width = 57
      Height = 35
      Caption = #1053#1072#1074#1077#1089#1090#1080' '#1082#1072#1084#1077#1088#1091' 2'
      TabOrder = 3
      WordWrap = True
      OnClick = DirectCamButton2Click
    end
    object CommonViewButton: TButton
      Left = 139
      Top = 173
      Width = 75
      Height = 35
      Caption = #1054#1073#1097#1080#1081' '#1087#1083#1072#1085
      TabOrder = 4
      OnClick = CommonViewButtonClick
    end
    object TankNumsEdit: TEdit
      Left = 98
      Top = 62
      Width = 33
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 5
      Text = '16'
    end
    object Tank1Panel: TPanel
      Left = 16
      Top = 95
      Width = 75
      Height = 33
      BevelInner = bvRaised
      BevelOuter = bvLowered
      ParentBackground = False
      TabOrder = 6
    end
    object Tank2Panel: TPanel
      Left = 136
      Top = 95
      Width = 75
      Height = 33
      BevelInner = bvRaised
      BevelOuter = bvLowered
      ParentBackground = False
      TabOrder = 7
    end
    object Tank3Panel: TPanel
      Left = 16
      Top = 134
      Width = 75
      Height = 33
      BevelInner = bvRaised
      BevelOuter = bvLowered
      ParentBackground = False
      TabOrder = 8
    end
    object Tank4Panel: TPanel
      Left = 136
      Top = 134
      Width = 75
      Height = 33
      BevelInner = bvRaised
      BevelOuter = bvLowered
      ParentBackground = False
      TabOrder = 9
    end
    object TankBox1: TCheckBox
      Left = 25
      Top = 103
      Width = 27
      Height = 17
      Alignment = taLeftJustify
      Caption = '1.'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 10
    end
    object Tank1Edit: TEdit
      Tag = 1
      Left = 59
      Top = 102
      Width = 24
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 11
      Text = '5'
    end
    object TankBox2: TCheckBox
      Left = 145
      Top = 103
      Width = 27
      Height = 17
      Alignment = taLeftJustify
      Caption = '2.'
      TabOrder = 12
    end
    object Tank2Edit: TEdit
      Tag = 2
      Left = 178
      Top = 102
      Width = 24
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 13
      Text = '6'
    end
    object TankBox3: TCheckBox
      Left = 26
      Top = 142
      Width = 27
      Height = 17
      Alignment = taLeftJustify
      Caption = '3.'
      TabOrder = 14
    end
    object Tank3Edit: TEdit
      Tag = 3
      Left = 59
      Top = 141
      Width = 24
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 15
      Text = '7'
    end
    object TankBox4: TCheckBox
      Left = 145
      Top = 142
      Width = 27
      Height = 17
      Alignment = taLeftJustify
      Caption = '4.'
      TabOrder = 16
    end
    object Tank4Edit: TEdit
      Tag = 4
      Left = 178
      Top = 141
      Width = 24
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 17
      Text = '8'
    end
  end
  object CrewButton: TButton
    Left = 8
    Top = 672
    Width = 60
    Height = 25
    Caption = #1069#1082#1080#1087#1072#1078
    TabOrder = 4
    OnClick = CrewButtonClick
  end
  object CloseCrewButton: TButton
    Left = 70
    Top = 672
    Width = 59
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 5
    OnClick = CloseCrewButtonClick
  end
  object OtsechkaButton: TButton
    Left = 8
    Top = 703
    Width = 60
    Height = 25
    Caption = #1054#1090#1089#1077#1095#1082#1072
    TabOrder = 6
    OnClick = OtsechkaButtonClick
  end
  object CloseOtsechkaButton: TButton
    Left = 70
    Top = 703
    Width = 59
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 7
    OnClick = CloseOtsechkaButtonClick
  end
  object btnTelemetry: TButton
    Left = 152
    Top = 8
    Width = 121
    Height = 25
    Caption = #1058#1077#1083#1077#1084#1077#1090#1088#1080#1103
    TabOrder = 8
    OnClick = btnTelemetryClick
  end
  inline GPSServerConnectFrame1: TGPSServerConnectFrame
    Left = 8
    Top = 39
    Width = 265
    Height = 87
    TabOrder = 9
    ExplicitLeft = 8
    ExplicitTop = 39
    ExplicitWidth = 265
    inherited GPSServerGroup: TGroupBox
      Left = 0
      Width = 265
      ExplicitLeft = 0
      ExplicitWidth = 265
    end
  end
end
