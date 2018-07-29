object MainForm: TMainForm
  Left = 200
  Top = 60
  Caption = #1058#1072#1085#1082#1086#1074#1099#1081' '#1073#1080#1072#1090#1083#1086#1085
  ClientHeight = 890
  ClientWidth = 1584
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheel = FormMouseWheel
  OnShortCut = FormShortCut
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
    Top = 734
    Width = 1568
    Height = 148
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object Poligon2DGroupBox: TGroupBox
    Left = 8
    Top = 160
    Width = 265
    Height = 249
    Caption = ' '#1055#1086#1083#1080#1075#1086#1085' 2D '
    TabOrder = 3
    object Label1: TLabel
      Left = 10
      Top = 94
      Width = 81
      Height = 13
      Caption = #1050#1086#1083'-'#1074#1086' '#1090#1072#1085#1082#1086#1074': '
    end
    object ShowButton: TButton
      Left = 10
      Top = 24
      Width = 118
      Height = 25
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100
      Enabled = False
      TabOrder = 0
      OnClick = ShowButtonClick
    end
    object ClosePoligonButton: TButton
      Left = 144
      Top = 24
      Width = 112
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      Enabled = False
      TabOrder = 1
      OnClick = ClosePoligonButtonClick
    end
    object DirectCamButton1: TButton
      Left = 10
      Top = 203
      Width = 57
      Height = 35
      Caption = #1053#1072#1074#1077#1089#1090#1080' '#1082#1072#1084#1077#1088#1091' 1'
      TabOrder = 2
      WordWrap = True
      OnClick = DirectCamButton1Click
    end
    object DirectCamButton2: TButton
      Left = 73
      Top = 203
      Width = 57
      Height = 35
      Caption = #1053#1072#1074#1077#1089#1090#1080' '#1082#1072#1084#1077#1088#1091' 2'
      TabOrder = 3
      WordWrap = True
      OnClick = DirectCamButton2Click
    end
    object CommonViewButton: TButton
      Left = 136
      Top = 203
      Width = 57
      Height = 35
      Caption = #1054#1073#1097#1080#1081' '#1087#1083#1072#1085
      TabOrder = 4
      WordWrap = True
      OnClick = CommonViewButtonClick
    end
    object TankNumsEdit: TEdit
      Left = 98
      Top = 92
      Width = 33
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 5
      Text = '16'
    end
    object Tank1Panel: TPanel
      Left = 16
      Top = 125
      Width = 75
      Height = 33
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Color = clLime
      ParentBackground = False
      TabOrder = 6
    end
    object Tank2Panel: TPanel
      Left = 136
      Top = 125
      Width = 75
      Height = 33
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Color = clBlue
      ParentBackground = False
      TabOrder = 7
    end
    object Tank3Panel: TPanel
      Left = 16
      Top = 164
      Width = 75
      Height = 33
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Color = clRed
      ParentBackground = False
      TabOrder = 8
    end
    object Tank4Panel: TPanel
      Left = 136
      Top = 164
      Width = 75
      Height = 33
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Color = clYellow
      ParentBackground = False
      TabOrder = 9
    end
    object TankBox1: TCheckBox
      Left = 26
      Top = 132
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
      Left = 60
      Top = 131
      Width = 24
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 11
      Text = '5'
    end
    object TankBox2: TCheckBox
      Left = 146
      Top = 132
      Width = 27
      Height = 17
      Alignment = taLeftJustify
      Caption = '2.'
      TabOrder = 12
    end
    object Tank2Edit: TEdit
      Tag = 2
      Left = 179
      Top = 131
      Width = 24
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 13
      Text = '6'
    end
    object TankBox3: TCheckBox
      Left = 27
      Top = 171
      Width = 27
      Height = 17
      Alignment = taLeftJustify
      Caption = '3.'
      TabOrder = 14
    end
    object Tank3Edit: TEdit
      Tag = 3
      Left = 60
      Top = 170
      Width = 24
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 15
      Text = '7'
    end
    object TankBox4: TCheckBox
      Left = 146
      Top = 171
      Width = 27
      Height = 17
      Alignment = taLeftJustify
      Caption = '4.'
      TabOrder = 16
    end
    object Tank4Edit: TEdit
      Tag = 4
      Left = 179
      Top = 170
      Width = 24
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 17
      Text = '8'
    end
    object CancelFollowBtn: TButton
      Left = 199
      Top = 203
      Width = 57
      Height = 35
      Caption = #1054#1090#1084#1077#1085#1072' '#1089#1083#1077#1078#1077#1085#1080#1103
      TabOrder = 18
      WordWrap = True
      OnClick = CancelFollowBtnClick
    end
    object chbShowFlags: TCheckBox
      Left = 10
      Top = 63
      Width = 120
      Height = 17
      Alignment = taLeftJustify
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1092#1083#1072#1075#1080
      TabOrder = 19
      OnClick = chbShowFlagsClick
    end
    object btnZeroSpeeds: TButton
      Left = 144
      Top = 55
      Width = 112
      Height = 25
      Caption = #1054#1073#1085#1091#1083#1080#1090#1100' '#1089#1082#1086#1088#1086#1089#1090#1080
      TabOrder = 20
      OnClick = btnZeroSpeedsClick
    end
  end
  object CrewButton: TButton
    Left = 8
    Top = 672
    Width = 60
    Height = 25
    Caption = #1069#1082#1080#1087#1072#1078
    TabOrder = 4
    Visible = False
    OnClick = CrewButtonClick
  end
  object CloseCrewButton: TButton
    Left = 70
    Top = 672
    Width = 59
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 5
    Visible = False
    OnClick = CloseCrewButtonClick
  end
  object OtsechkaButton: TButton
    Left = 8
    Top = 703
    Width = 60
    Height = 25
    Caption = #1054#1090#1089#1077#1095#1082#1072
    TabOrder = 6
    Visible = False
    OnClick = OtsechkaButtonClick
  end
  object CloseOtsechkaButton: TButton
    Left = 70
    Top = 703
    Width = 59
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 7
    Visible = False
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
    Top = 67
    Width = 265
    Height = 87
    TabOrder = 9
    ExplicitLeft = 8
    ExplicitTop = 67
    ExplicitWidth = 265
    inherited GPSServerGroup: TGroupBox
      Left = 0
      Width = 265
      ExplicitLeft = 0
      ExplicitWidth = 265
      inherited lblGpsAddr: TLabel
        Top = 22
        ExplicitTop = 22
      end
      inherited lblGpsPort: TLabel
        Top = 22
        ExplicitTop = 22
      end
      inherited edGpsAddr: TEdit
        Top = 20
        Text = '94.228.243.168'
        ExplicitTop = 20
      end
      inherited edGpsPort: TEdit
        Top = 20
        ExplicitTop = 20
      end
      inherited btnConnect: TButton
        Top = 45
        OnClick = GPSServerConnectFrame1btnConnectClick
        ExplicitTop = 45
      end
    end
  end
  object chbSimulation: TCheckBox
    Left = 17
    Top = 39
    Width = 97
    Height = 17
    Caption = #1069#1084#1091#1083#1103#1090#1086#1088' GPS'
    TabOrder = 10
    OnClick = chbSimulationClick
  end
  object CaptionsGroupBox: TGroupBox
    Left = 8
    Top = 415
    Width = 265
    Height = 170
    Caption = ' '#1058#1080#1090#1088#1099' '
    TabOrder = 11
    object btnEditCaptions: TButton
      Left = 10
      Top = 118
      Width = 246
      Height = 35
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1090#1080#1090#1088#1086#1074
      TabOrder = 0
      OnClick = btnEditCaptionsClick
    end
    object Panel1: TPanel
      Left = 8
      Top = 24
      Width = 60
      Height = 88
      BevelOuter = bvNone
      Color = clLime
      ParentBackground = False
      TabOrder = 1
      object btnCaption1: TButton
        Tag = 1
        Left = 10
        Top = 4
        Width = 40
        Height = 35
        Caption = '1'
        Enabled = False
        TabOrder = 0
        OnClick = btnCaptionNClick
      end
      object btnCancelCaption1: TButton
        Tag = 1
        Left = 10
        Top = 45
        Width = 40
        Height = 35
        Caption = 'X1X'
        Enabled = False
        TabOrder = 1
        OnClick = btnCancelCaptionNClick
      end
    end
    object Panel2: TPanel
      Left = 71
      Top = 24
      Width = 60
      Height = 88
      BevelOuter = bvNone
      Color = clBlue
      ParentBackground = False
      TabOrder = 2
      object btnCaption2: TButton
        Tag = 2
        Left = 9
        Top = 7
        Width = 40
        Height = 35
        Caption = '2'
        Enabled = False
        TabOrder = 0
        OnClick = btnCaptionNClick
      end
      object btnCancelCaption2: TButton
        Tag = 2
        Left = 9
        Top = 48
        Width = 40
        Height = 35
        Caption = 'X2X'
        Enabled = False
        TabOrder = 1
        OnClick = btnCancelCaptionNClick
      end
    end
    object Panel3: TPanel
      Left = 133
      Top = 24
      Width = 60
      Height = 88
      BevelOuter = bvNone
      Color = clRed
      ParentBackground = False
      TabOrder = 3
      object btnCaption3: TButton
        Tag = 3
        Left = 10
        Top = 5
        Width = 40
        Height = 35
        Caption = '3'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = btnCaptionNClick
      end
      object btnCancelCaption3: TButton
        Tag = 3
        Left = 10
        Top = 46
        Width = 40
        Height = 35
        Caption = 'X3X'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnCancelCaptionNClick
      end
    end
    object Panel4: TPanel
      Left = 197
      Top = 24
      Width = 58
      Height = 88
      BevelOuter = bvNone
      Color = clYellow
      ParentBackground = False
      TabOrder = 4
      object btnCaption4: TButton
        Tag = 4
        Left = 8
        Top = 5
        Width = 40
        Height = 35
        Caption = '4'
        Enabled = False
        TabOrder = 0
        OnClick = btnCaptionNClick
      end
      object btnCancelCaption4: TButton
        Tag = 4
        Left = 8
        Top = 45
        Width = 40
        Height = 35
        Caption = 'X4X'
        Enabled = False
        TabOrder = 1
        OnClick = btnCancelCaptionNClick
      end
    end
  end
  object Button1: TButton
    Left = 144
    Top = 672
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 12
    Visible = False
    OnClick = Button1Click
  end
  object btnRefresh: TButton
    Left = 152
    Top = 36
    Width = 121
    Height = 25
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100' F1'
    TabOrder = 13
    OnClick = btnRefreshClick
  end
end
