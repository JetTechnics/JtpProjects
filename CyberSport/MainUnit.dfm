object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 769
  ClientWidth = 1170
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
    Width = 97
    Height = 35
    Caption = 'Start'
    TabOrder = 0
    OnClick = StartButtonClick
  end
  object OutVideoPanel1: TPanel
    Left = 8
    Top = 72
    Width = 1152
    Height = 216
    Caption = 'OutVideoPanel1'
    TabOrder = 1
  end
  object LogListBox: TListBox
    Left = 8
    Top = 664
    Width = 1154
    Height = 97
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object SimOutBox: TCheckBox
    Left = 119
    Top = 8
    Width = 121
    Height = 17
    Caption = #1057#1080#1084#1091#1083#1103#1090#1086#1088' '#1074#1099#1074#1086#1076#1072
    TabOrder = 3
  end
  object SimInputBox: TCheckBox
    Left = 119
    Top = 26
    Width = 121
    Height = 17
    Caption = #1057#1080#1084#1091#1083#1103#1090#1086#1088' '#1079#1072#1093#1074#1072#1090#1072
    TabOrder = 4
  end
  object OutVideoPanel2: TPanel
    Left = 648
    Top = 294
    Width = 512
    Height = 288
    Caption = 'OutVideoPanel2'
    TabOrder = 5
  end
end
