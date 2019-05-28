object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1042#1080#1076#1077#1086' '#1087#1083#1077#1077#1088
  ClientHeight = 582
  ClientWidth = 1189
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
  object SimOutBox: TCheckBox
    Left = 119
    Top = 8
    Width = 121
    Height = 17
    Caption = #1057#1080#1084#1091#1083#1103#1090#1086#1088' '#1074#1099#1074#1086#1076#1072
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object LogListBox: TListBox
    Left = 8
    Top = 511
    Width = 1165
    Height = 63
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object PlayerBox1: TGroupBox
    Left = 32
    Top = 80
    Width = 577
    Height = 313
    Caption = #1055#1083#1077#1077#1088'1'
    TabOrder = 3
    object VideoList1: TCheckListBox
      Left = 3
      Top = 24
      Width = 173
      Height = 216
      ItemHeight = 13
      Items.Strings = (
        'Video1.mpg'
        'Video2.mpg')
      TabOrder = 0
    end
    object OutVideoPanel1: TPanel
      Left = 182
      Top = 24
      Width = 384
      Height = 216
      Caption = 'OutVideoPanel1'
      TabOrder = 1
    end
  end
end
