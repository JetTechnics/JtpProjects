object GPSServerConnectFrame: TGPSServerConnectFrame
  Left = 0
  Top = 0
  Width = 262
  Height = 87
  TabOrder = 0
  object GPSServerGroup: TGroupBox
    Left = 3
    Top = 3
    Width = 255
    Height = 78
    TabOrder = 0
    object lblGpsAddr: TLabel
      Left = 9
      Top = 22
      Width = 35
      Height = 13
      Caption = #1040#1076#1088#1077#1089':'
    end
    object lblGpsPort: TLabel
      Left = 156
      Top = 22
      Width = 29
      Height = 13
      Caption = #1055#1086#1088#1090':'
    end
    object edGpsAddr: TEdit
      Left = 50
      Top = 20
      Width = 92
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      Text = '172.30.34.137'
    end
    object edGpsPort: TEdit
      Left = 194
      Top = 20
      Width = 50
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      Text = '6543'
    end
    object btnConnect: TButton
      Left = 158
      Top = 45
      Width = 86
      Height = 25
      TabOrder = 2
      OnClick = btnConnectClick
    end
  end
end
