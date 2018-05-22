object TitlerForm: TTitlerForm
  Left = 0
  Top = 0
  Caption = 'TitlerForm'
  ClientHeight = 672
  ClientWidth = 1248
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
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
  object Out1VideoPanel: TPanel
    Left = 200
    Top = 8
    Width = 512
    Height = 288
    Caption = 'Out1VideoPanel'
    TabOrder = 1
  end
  object Out2VideoPanel: TPanel
    Left = 728
    Top = 8
    Width = 512
    Height = 288
    Caption = 'Out2VideoPanel'
    TabOrder = 2
  end
  object TableGroupBox: TGroupBox
    Left = 9
    Top = 208
    Width = 185
    Height = 105
    Caption = ' '#1058#1072#1073#1083#1080#1094#1072' '#1048#1075#1088#1086#1082#1086#1074' '
    TabOrder = 3
    object TableButton: TButton
      Left = 3
      Top = 24
      Width = 89
      Height = 25
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100
      TabOrder = 0
      OnClick = TableButtonClick
    end
    object TableClose: TButton
      Left = 3
      Top = 55
      Width = 89
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 1
      OnClick = TableCloseClick
    end
  end
  object LogListBox: TListBox
    Left = 8
    Top = 568
    Width = 1096
    Height = 96
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 4
  end
  object ChampionshipGroupBox: TGroupBox
    Left = 9
    Top = 96
    Width = 185
    Height = 97
    Caption = ' '#1063#1077#1084#1087#1080#1086#1085#1072#1090' '
    TabOrder = 5
    object ChampionshipShowButton: TButton
      Left = 3
      Top = 24
      Width = 88
      Height = 25
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100
      TabOrder = 0
      OnClick = ChampionshipShowButtonClick
    end
    object ChampionshipCloseButton: TButton
      Left = 3
      Top = 55
      Width = 88
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 1
      OnClick = ChampionshipCloseButtonClick
    end
    object Button1: TButton
      Left = 97
      Top = 24
      Width = 85
      Height = 25
      Caption = '2-'#1103' '#1095#1072#1089#1090#1100
      TabOrder = 2
    end
  end
  object TimeGroupBox: TGroupBox
    Left = 8
    Top = 328
    Width = 186
    Height = 89
    Caption = ' '#1042#1088#1077#1084#1103' '
    TabOrder = 6
    object ShowTimeButton: TButton
      Left = 3
      Top = 24
      Width = 85
      Height = 25
      Caption = ' '#1055#1086#1082#1072#1079#1072#1090#1100' '
      TabOrder = 0
      OnClick = ShowTimeButtonClick
    end
    object CloseTimeButton: TButton
      Left = 3
      Top = 55
      Width = 85
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 1
      OnClick = CloseTimeButtonClick
    end
    object CityButton: TButton
      Left = 94
      Top = 24
      Width = 75
      Height = 25
      Caption = #1043#1086#1088#1086#1076
      TabOrder = 2
      OnClick = CityButtonClick
    end
  end
  object BeginButton: TButton
    Left = 8
    Top = 65
    Width = 121
    Height = 25
    Caption = #1053#1072#1095#1072#1083#1086' '#1084#1072#1090#1095#1072
    TabOrder = 7
    OnClick = BeginButtonClick
  end
  object ScoresGroupBox: TGroupBox
    Left = 8
    Top = 423
    Width = 178
    Height = 81
    Caption = ' '#1057#1095#1105#1090' '
    TabOrder = 8
    object ShowScoresButton: TButton
      Left = 3
      Top = 16
      Width = 81
      Height = 25
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100
      TabOrder = 0
      OnClick = ShowScoresButtonClick
    end
    object Scores1Button: TButton
      Left = 112
      Top = 16
      Width = 49
      Height = 25
      Caption = #1057#1095#1105#1090'1'
      TabOrder = 1
      OnClick = Scores1ButtonClick
    end
    object Scores2Button: TButton
      Left = 112
      Top = 47
      Width = 49
      Height = 25
      Caption = #1057#1095#1105#1090'2'
      TabOrder = 2
      OnClick = Scores2ButtonClick
    end
    object CloseScoresButton: TButton
      Left = 3
      Top = 47
      Width = 81
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 3
      OnClick = CloseScoresButtonClick
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 156
    Top = 384
  end
end
