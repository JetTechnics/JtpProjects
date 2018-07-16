object Form1: TForm1
  Left = 263
  Top = 116
  Width = 290
  Height = 471
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 104
    Width = 66
    Height = 13
    Caption = 'Disconnected'
  end
  object Edit1: TEdit
    Left = 24
    Top = 16
    Width = 161
    Height = 21
    TabOrder = 0
    Text = '94.228.243.168'
  end
  object Edit2: TEdit
    Left = 24
    Top = 48
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '6543'
  end
  object Button1: TButton
    Left = 128
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object LogListBox: TListBox
    Left = 24
    Top = 136
    Width = 233
    Height = 281
    ItemHeight = 13
    TabOrder = 3
  end
end
