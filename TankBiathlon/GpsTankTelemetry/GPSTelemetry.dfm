object _GPSTelemetry: T_GPSTelemetry
  Left = 0
  Top = 0
  Caption = '_GPSTelemetry'
  ClientHeight = 858
  ClientWidth = 581
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 21
    Width = 581
    Height = 837
    ActivePage = tsBaseConnect
    Align = alClient
    TabOrder = 0
    object tsShow: TTabSheet
      Caption = #1058#1088#1072#1085#1089#1083#1103#1094#1080#1103
      ImageIndex = 4
      object Panel23: TPanel
        Left = 3
        Top = 6
        Width = 562
        Height = 800
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object shapeTeam44: TShape
          Left = 341
          Top = 455
          Width = 115
          Height = 205
          Pen.Style = psClear
        end
        object shapeTeam11: TShape
          Left = 0
          Top = 455
          Width = 115
          Height = 205
          Pen.Style = psClear
        end
        object shapeTeam33: TShape
          Left = 227
          Top = 455
          Width = 115
          Height = 205
          Pen.Style = psClear
        end
        object shapeTeam22: TShape
          Left = 114
          Top = 455
          Width = 115
          Height = 205
          Pen.Style = psClear
        end
        object ShapeTeam4: TShape
          Left = 341
          Top = 0
          Width = 115
          Height = 400
          Pen.Style = psClear
        end
        object ShapeTeam3: TShape
          Left = 227
          Top = 0
          Width = 115
          Height = 400
          Pen.Style = psClear
        end
        object ShapeTeam2: TShape
          Left = 114
          Top = 0
          Width = 115
          Height = 400
          Pen.Style = psClear
        end
        object shapeTeam1: TShape
          Left = 0
          Top = 0
          Width = 115
          Height = 400
          Pen.Style = psClear
        end
        object btnEkipag1: TSpeedButton
          Left = 17
          Top = 38
          Width = 75
          Height = 40
          AllowAllUp = True
          GroupIndex = 1
          Caption = #1101#1082#1080#1087#1072#1078
          OnClick = btnEkipag1Click
        end
        object btnEkipag2: TSpeedButton
          Left = 132
          Top = 38
          Width = 75
          Height = 40
          AllowAllUp = True
          GroupIndex = 1
          Caption = #1101#1082#1080#1087#1072#1078
          OnClick = btnEkipag1Click
        end
        object btnEkipag3: TSpeedButton
          Left = 249
          Top = 38
          Width = 75
          Height = 40
          AllowAllUp = True
          GroupIndex = 1
          Caption = #1101#1082#1080#1087#1072#1078
          OnClick = btnEkipag1Click
        end
        object btnEkipag4: TSpeedButton
          Left = 361
          Top = 38
          Width = 75
          Height = 40
          AllowAllUp = True
          GroupIndex = 1
          Caption = #1101#1082#1080#1087#1072#1078
          OnClick = btnEkipag1Click
        end
        object btnShooting1: TSpeedButton
          Left = 17
          Top = 149
          Width = 75
          Height = 40
          AllowAllUp = True
          GroupIndex = 1
          Caption = #1089#1090#1088#1077#1083#1100#1073#1072
          OnClick = btnShooting1Click
        end
        object btnShooting2: TSpeedButton
          Left = 132
          Top = 149
          Width = 75
          Height = 40
          AllowAllUp = True
          GroupIndex = 1
          Caption = #1089#1090#1088#1077#1083#1100#1073#1072
          OnClick = btnShooting1Click
        end
        object btnShooting3: TSpeedButton
          Left = 249
          Top = 149
          Width = 75
          Height = 40
          AllowAllUp = True
          GroupIndex = 1
          Caption = #1089#1090#1088#1077#1083#1100#1073#1072
          OnClick = btnShooting1Click
        end
        object btnShooting4: TSpeedButton
          Left = 361
          Top = 149
          Width = 75
          Height = 40
          AllowAllUp = True
          GroupIndex = 1
          Caption = #1089#1090#1088#1077#1083#1100#1073#1072
          OnClick = btnShooting1Click
        end
        object btnOtsechka1: TSpeedButton
          Left = 17
          Top = 261
          Width = 75
          Height = 40
          AllowAllUp = True
          GroupIndex = 1
          Caption = #1086#1090#1089#1077#1095#1082#1080
          OnClick = btnOtsechka1Click
        end
        object btnOtsechka2: TSpeedButton
          Left = 132
          Top = 261
          Width = 75
          Height = 40
          AllowAllUp = True
          GroupIndex = 1
          Caption = #1086#1090#1089#1077#1095#1082#1080
          OnClick = btnOtsechka1Click
        end
        object btnOtsechka3: TSpeedButton
          Left = 249
          Top = 261
          Width = 75
          Height = 40
          AllowAllUp = True
          GroupIndex = 1
          Caption = #1086#1090#1089#1077#1095#1082#1080
          OnClick = btnOtsechka1Click
        end
        object btnOtsechka4: TSpeedButton
          Left = 361
          Top = 261
          Width = 75
          Height = 40
          AllowAllUp = True
          GroupIndex = 1
          Caption = #1086#1090#1089#1077#1095#1082#1080
          OnClick = btnOtsechka1Click
        end
        object SpeedButton1: TSpeedButton
          Left = 17
          Top = 756
          Width = 75
          Height = 44
          Caption = #1054#1073#1085#1086#1074#1080#1090#1100' F1'
          OnClick = btnRefreshClick
        end
        object btnCamera11: TSpeedButton
          Left = 17
          Top = 464
          Width = 75
          Height = 50
          AllowAllUp = True
          GroupIndex = 2
          Caption = #1082#1072#1084#1077#1088#1072' 1'
        end
        object btnCamera12: TSpeedButton
          Left = 132
          Top = 464
          Width = 75
          Height = 50
          AllowAllUp = True
          GroupIndex = 3
          Caption = #1082#1072#1084#1077#1088#1072' 1'
        end
        object btnCamera13: TSpeedButton
          Left = 249
          Top = 464
          Width = 75
          Height = 50
          AllowAllUp = True
          GroupIndex = 4
          Caption = #1082#1072#1084#1077#1088#1072' 1'
        end
        object btnCamera14: TSpeedButton
          Left = 361
          Top = 464
          Width = 75
          Height = 50
          AllowAllUp = True
          GroupIndex = 5
          Caption = #1082#1072#1084#1077#1088#1072' 1'
        end
        object btnCamera21: TSpeedButton
          Left = 17
          Top = 534
          Width = 75
          Height = 50
          AllowAllUp = True
          GroupIndex = 6
          Caption = #1082#1072#1084#1077#1088#1072' 2'
        end
        object btnCamera22: TSpeedButton
          Left = 132
          Top = 534
          Width = 75
          Height = 50
          AllowAllUp = True
          GroupIndex = 7
          Caption = #1082#1072#1084#1077#1088#1072' 2'
        end
        object btnCamera23: TSpeedButton
          Left = 249
          Top = 534
          Width = 75
          Height = 50
          AllowAllUp = True
          GroupIndex = 8
          Caption = #1082#1072#1084#1077#1088#1072' 2'
        end
        object btnCamera24: TSpeedButton
          Left = 361
          Top = 534
          Width = 75
          Height = 50
          AllowAllUp = True
          GroupIndex = 9
          Caption = #1082#1072#1084#1077#1088#1072' 2'
        end
        object btnUnSetCameras: TSpeedButton
          Left = 17
          Top = 676
          Width = 190
          Height = 50
          AllowAllUp = True
          Caption = #1086#1090#1082#1083#1102#1095#1080#1090#1100' '#1082#1072#1084#1077#1088#1099
        end
        object btnMainView: TSpeedButton
          Left = 249
          Top = 676
          Width = 190
          Height = 50
          AllowAllUp = True
          Caption = #1086#1073#1097#1080#1081' '#1087#1083#1072#1085
        end
        object btnDist1: TSpeedButton
          Left = 17
          Top = 602
          Width = 75
          Height = 50
          AllowAllUp = True
          GroupIndex = 10
          Caption = #1076#1080#1089#1090#1072#1085#1094#1080#1103
        end
        object btnDist2: TSpeedButton
          Left = 132
          Top = 602
          Width = 75
          Height = 50
          AllowAllUp = True
          GroupIndex = 11
          Caption = #1076#1080#1089#1090#1072#1085#1094#1080#1103
        end
        object btnDist3: TSpeedButton
          Left = 249
          Top = 602
          Width = 75
          Height = 50
          AllowAllUp = True
          GroupIndex = 12
          Caption = #1076#1080#1089#1090#1072#1085#1094#1080#1103
        end
        object btnDist4: TSpeedButton
          Left = 361
          Top = 602
          Width = 75
          Height = 50
          AllowAllUp = True
          GroupIndex = 13
          Caption = #1076#1080#1089#1090#1072#1085#1094#1080#1103
        end
        object btnRefreshTankColor: TSpeedButton
          Left = 150
          Top = 756
          Width = 155
          Height = 44
          Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1094#1074#1077#1090#1072'  '#1090#1072#1085#1082#1086#1074'  F2'
          OnClick = btnRefreshTankColorClick
        end
        object Label13: TLabel
          Left = 19
          Top = 376
          Width = 19
          Height = 13
          Caption = 'GPS'
        end
        object Label14: TLabel
          Left = 133
          Top = 374
          Width = 19
          Height = 13
          Caption = 'GPS'
        end
        object Label15: TLabel
          Left = 248
          Top = 374
          Width = 19
          Height = 13
          Caption = 'GPS'
        end
        object Label16: TLabel
          Left = 361
          Top = 374
          Width = 19
          Height = 13
          Caption = 'GPS'
        end
        object Panel18: TPanel
          Left = 348
          Top = 756
          Width = 91
          Height = 42
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 0
          object btnOpenScenes: TSpeedButton
            Left = 42
            Top = 0
            Width = 49
            Height = 22
            AllowAllUp = True
            GroupIndex = 10
            Caption = #1042#1050#1051
          end
          object btnCloseScenes: TSpeedButton
            Left = 42
            Top = 20
            Width = 49
            Height = 22
            AllowAllUp = True
            GroupIndex = 10
            Down = True
            Caption = #1042#1067#1050#1051
          end
          object Label11: TLabel
            Left = 0
            Top = 9
            Width = 36
            Height = 13
            Caption = #1057#1062#1045#1053#1067
          end
        end
        object ePlayer11: TEdit
          Left = 7
          Top = 84
          Width = 99
          Height = 21
          TabOrder = 1
        end
        object ePlayer12: TEdit
          Left = 7
          Top = 105
          Width = 99
          Height = 21
          TabOrder = 2
        end
        object ePlayer13: TEdit
          Left = 7
          Top = 124
          Width = 99
          Height = 21
          TabOrder = 3
        end
        object ePlayer21: TEdit
          Left = 121
          Top = 84
          Width = 99
          Height = 21
          TabOrder = 4
        end
        object ePlayer22: TEdit
          Left = 121
          Top = 105
          Width = 99
          Height = 21
          TabOrder = 5
        end
        object ePlayer23: TEdit
          Left = 121
          Top = 124
          Width = 99
          Height = 21
          TabOrder = 6
        end
        object ePlayer31: TEdit
          Left = 234
          Top = 84
          Width = 99
          Height = 21
          TabOrder = 7
        end
        object ePlayer32: TEdit
          Left = 234
          Top = 105
          Width = 99
          Height = 21
          TabOrder = 8
        end
        object ePlayer33: TEdit
          Left = 234
          Top = 124
          Width = 99
          Height = 21
          TabOrder = 9
        end
        object ePlayer41: TEdit
          Left = 346
          Top = 84
          Width = 99
          Height = 21
          TabOrder = 10
        end
        object ePlayer42: TEdit
          Left = 346
          Top = 105
          Width = 99
          Height = 21
          TabOrder = 11
        end
        object ePlayer43: TEdit
          Left = 346
          Top = 124
          Width = 99
          Height = 21
          TabOrder = 12
        end
        object eTeam1: TEdit
          Left = 7
          Top = 11
          Width = 99
          Height = 21
          TabOrder = 13
        end
        object eTeam2: TEdit
          Left = 121
          Top = 11
          Width = 99
          Height = 21
          TabOrder = 14
        end
        object eTeam3: TEdit
          Left = 234
          Top = 11
          Width = 99
          Height = 21
          TabOrder = 15
        end
        object eTeam4: TEdit
          Left = 346
          Top = 11
          Width = 99
          Height = 21
          TabOrder = 16
        end
        object eShooting11: TEdit
          Left = 9
          Top = 195
          Width = 99
          Height = 21
          TabOrder = 17
        end
        object eShooting12: TEdit
          Left = 9
          Top = 216
          Width = 99
          Height = 21
          TabOrder = 18
        end
        object eShooting13: TEdit
          Left = 9
          Top = 235
          Width = 99
          Height = 21
          TabOrder = 19
        end
        object eShooting21: TEdit
          Left = 123
          Top = 195
          Width = 99
          Height = 21
          TabOrder = 20
        end
        object eShooting22: TEdit
          Left = 123
          Top = 216
          Width = 99
          Height = 21
          TabOrder = 21
        end
        object eShooting23: TEdit
          Left = 123
          Top = 235
          Width = 99
          Height = 21
          TabOrder = 22
        end
        object eShooting31: TEdit
          Left = 236
          Top = 195
          Width = 99
          Height = 21
          TabOrder = 23
        end
        object eShooting32: TEdit
          Left = 236
          Top = 216
          Width = 99
          Height = 21
          TabOrder = 24
        end
        object eShooting33: TEdit
          Left = 236
          Top = 235
          Width = 99
          Height = 21
          TabOrder = 25
        end
        object eShooting41: TEdit
          Left = 348
          Top = 195
          Width = 99
          Height = 21
          TabOrder = 26
        end
        object eShooting42: TEdit
          Left = 348
          Top = 216
          Width = 99
          Height = 21
          TabOrder = 27
        end
        object eShooting43: TEdit
          Left = 348
          Top = 235
          Width = 99
          Height = 21
          TabOrder = 28
        end
        object eOtsechka11: TEdit
          Left = 8
          Top = 307
          Width = 99
          Height = 21
          TabOrder = 29
        end
        object eOtsechka12: TEdit
          Left = 8
          Top = 328
          Width = 99
          Height = 21
          TabOrder = 30
        end
        object eOtsechka13: TEdit
          Left = 8
          Top = 347
          Width = 99
          Height = 21
          TabOrder = 31
        end
        object eOtsechka21: TEdit
          Left = 122
          Top = 307
          Width = 99
          Height = 21
          TabOrder = 32
        end
        object eOtsechka22: TEdit
          Left = 122
          Top = 328
          Width = 99
          Height = 21
          TabOrder = 33
        end
        object eOtsechka23: TEdit
          Left = 122
          Top = 347
          Width = 99
          Height = 21
          TabOrder = 34
        end
        object eOtsechka31: TEdit
          Left = 236
          Top = 307
          Width = 99
          Height = 21
          TabOrder = 35
        end
        object eOtsechka32: TEdit
          Left = 236
          Top = 328
          Width = 99
          Height = 21
          TabOrder = 36
        end
        object eOtsechka33: TEdit
          Left = 236
          Top = 347
          Width = 99
          Height = 21
          TabOrder = 37
        end
        object eOtsechka41: TEdit
          Left = 348
          Top = 307
          Width = 99
          Height = 21
          TabOrder = 38
        end
        object eOtsechka42: TEdit
          Left = 348
          Top = 328
          Width = 99
          Height = 21
          TabOrder = 39
        end
        object eOtsechka43: TEdit
          Left = 348
          Top = 347
          Width = 99
          Height = 21
          TabOrder = 40
        end
        object chbShowDistance: TCheckBox
          Left = 0
          Top = 426
          Width = 73
          Height = 17
          Caption = #1044#1080#1089#1090#1072#1085#1094#1080#1103
          TabOrder = 41
        end
        object eSpeed1: TEdit
          Left = 87
          Top = 406
          Width = 60
          Height = 21
          TabOrder = 42
        end
        object eDist1: TEdit
          Left = 87
          Top = 426
          Width = 60
          Height = 21
          TabOrder = 43
        end
        object eSpeed2: TEdit
          Left = 161
          Top = 406
          Width = 60
          Height = 21
          TabOrder = 44
        end
        object eDist2: TEdit
          Left = 161
          Top = 426
          Width = 60
          Height = 21
          TabOrder = 45
        end
        object eSpeed3: TEdit
          Left = 236
          Top = 406
          Width = 60
          Height = 21
          TabOrder = 46
        end
        object eDist3: TEdit
          Left = 236
          Top = 426
          Width = 60
          Height = 21
          TabOrder = 47
        end
        object eSpeed4: TEdit
          Left = 310
          Top = 406
          Width = 60
          Height = 21
          TabOrder = 48
        end
        object eDist4: TEdit
          Left = 310
          Top = 426
          Width = 60
          Height = 21
          TabOrder = 49
        end
        object chbShowSpeed: TCheckBox
          Left = 0
          Top = 406
          Width = 68
          Height = 17
          Caption = #1057#1082#1086#1088#1086#1089#1090#1100
          TabOrder = 50
        end
        object Panel2: TPanel
          Left = 478
          Top = 455
          Width = 84
          Height = 234
          AutoSize = True
          BevelOuter = bvLowered
          TabOrder = 51
          object btnShowUnShowTitle2Tanks: TSpeedButton
            Left = 1
            Top = 20
            Width = 75
            Height = 50
            AllowAllUp = True
            GroupIndex = 14
            Caption = #1055#1086#1082#1072#1079#1072#1090#1100
          end
          object Label12: TLabel
            Left = 16
            Top = 1
            Width = 48
            Height = 13
            Caption = #1090#1072#1073#1083#1080#1095#1082#1080
          end
          object rbShowEkipag2Tanks: TRadioButton
            Left = 5
            Top = 90
            Width = 57
            Height = 17
            Caption = #1069#1082#1080#1087#1072#1078
            Checked = True
            TabOrder = 0
            TabStop = True
          end
          object rbShowOtsechki2Tanks: TRadioButton
            Left = 5
            Top = 154
            Width = 65
            Height = 17
            Caption = #1054#1090#1089#1077#1095#1082#1080
            TabOrder = 1
          end
          object rbShowShooting2Tanks: TRadioButton
            Left = 5
            Top = 123
            Width = 73
            Height = 17
            Caption = #1057#1090#1088#1077#1083#1100#1073#1072
            TabOrder = 2
          end
          object chbChangePositionTablesOnTitle2Tanks: TCheckBox
            Left = 8
            Top = 193
            Width = 75
            Height = 40
            Caption = #1087#1086#1084#1077#1085#1103#1090#1100' '#1084#1077#1089#1090#1072#1084#1080' '#1090#1072#1073#1083#1080#1095#1082#1080
            TabOrder = 3
            WordWrap = True
          end
        end
      end
      object eGPS2: TEdit
        Left = 161
        Top = 377
        Width = 40
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object eGPS1: TEdit
        Left = 47
        Top = 377
        Width = 40
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object eGPS3: TEdit
        Left = 276
        Top = 377
        Width = 40
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object eGPS4: TEdit
        Left = 389
        Top = 377
        Width = 40
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
    end
    object tsExtendedData: TTabSheet
      Caption = #1069#1082#1080#1087#1072#1078#1080', '#1054#1090#1089#1077#1095#1082#1080', '#1057#1090#1088#1077#1083#1100#1073#1072
      object Panel17: TPanel
        Left = 0
        Top = 0
        Width = 573
        Height = 23
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object btnRefresh: TSpeedButton
          Left = 1
          Top = 1
          Width = 69
          Height = 22
          Caption = #1054#1073#1085#1086#1074#1080#1090#1100
          OnClick = btnRefreshClick
        end
        object btnEditGPS: TSpeedButton
          Left = 353
          Top = 1
          Width = 57
          Height = 22
          Caption = 'Edit GPS'
          OnClick = btnEditGPSClick
        end
        object pnlEditGPS: TPanel
          Left = 416
          Top = 1
          Width = 78
          Height = 22
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 0
          Visible = False
          object btnSetNewGPS: TSpeedButton
            Left = 55
            Top = 0
            Width = 23
            Height = 22
            Caption = 'Set'
            OnClick = btnSetNewGPSClick
          end
          object cbEditGPS: TComboBox
            Left = 0
            Top = 0
            Width = 49
            Height = 21
            TabOrder = 0
          end
        end
        object rbEkipag: TRadioButton
          Left = 104
          Top = 0
          Width = 58
          Height = 17
          Caption = #1101#1082#1080#1087#1072#1078
          Checked = True
          TabOrder = 1
          TabStop = True
          Visible = False
          OnClick = rbEkipagClick
        end
        object rbOtsechki: TRadioButton
          Left = 168
          Top = 0
          Width = 58
          Height = 17
          Caption = #1086#1090#1089#1077#1095#1082#1080
          TabOrder = 2
          Visible = False
          OnClick = rbOtsechkiClick
        end
        object rbShooting: TRadioButton
          Left = 248
          Top = 0
          Width = 65
          Height = 17
          Caption = #1089#1090#1088#1077#1083#1100#1073#1072
          TabOrder = 3
          Visible = False
          OnClick = rbShootingClick
        end
      end
      object Panel25: TPanel
        Left = 0
        Top = 23
        Width = 573
        Height = 786
        Align = alClient
        TabOrder = 1
        object Splitter4: TSplitter
          AlignWithMargins = True
          Left = 4
          Top = 347
          Width = 565
          Height = 3
          Cursor = crVSplit
          Align = alBottom
          AutoSnap = False
          ExplicitLeft = 1
          ExplicitTop = 1
          ExplicitWidth = 162
        end
        object Splitter5: TSplitter
          Left = 1
          Top = 237
          Width = 571
          Height = 3
          Cursor = crVSplit
          Align = alBottom
          AutoSnap = False
          Beveled = True
          ExplicitLeft = 5
          ExplicitTop = 243
          ExplicitWidth = 573
        end
        object DBGrid1: TDBGrid
          Left = 1
          Top = 1
          Width = 571
          Height = 236
          Align = alClient
          BorderStyle = bsNone
          DataSource = dsTanksData
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDrawColumnCell = DBGrid1DrawColumnCell
          Columns = <
            item
              Expanded = False
              FieldName = 'TeamColorID'
              Title.Alignment = taCenter
              Title.Caption = #1062#1074#1077#1090
              Width = 28
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TeamName'
              Title.Alignment = taCenter
              Title.Caption = #1050#1086#1084#1072#1085#1076#1072
              Width = 150
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'PlayerName'
              Title.Alignment = taCenter
              Title.Caption = #1059#1095#1072#1089#1090#1085#1080#1082
              Width = 130
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'AmplyaName'
              Title.Alignment = taCenter
              Title.Caption = #1040#1084#1087#1083#1091#1072
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'GPSID'
              Title.Caption = 'GPS'
              Width = 25
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CountryName'
              Title.Alignment = taCenter
              Title.Caption = #1057#1090#1088#1072#1085#1072
              Width = 100
              Visible = True
            end>
        end
        object DBGrid2: TDBGrid
          Left = 1
          Top = 353
          Width = 571
          Height = 286
          Align = alBottom
          BorderStyle = bsNone
          DataSource = dsOtsechki
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDrawColumnCell = DBGrid1DrawColumnCell
          Columns = <
            item
              Expanded = False
              FieldName = 'o.TeamColorID'
              Title.Alignment = taCenter
              Title.Caption = #1062#1074#1077#1090
              Width = 28
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TeamName'
              Title.Alignment = taCenter
              Title.Caption = #1050#1086#1084#1072#1085#1076#1072
              Width = 150
              Visible = True
            end
            item
              Alignment = taRightJustify
              Expanded = False
              FieldName = 'NumOtsec'
              Title.Caption = #1086#1090#1089#1077#1095#1082#1080
              Width = 43
              Visible = True
            end
            item
              Alignment = taRightJustify
              Expanded = False
              FieldName = 'cTimeMS'
              Title.Alignment = taCenter
              Title.Caption = #1042#1088#1077#1084#1103
              Width = 65
              Visible = True
            end>
        end
        object DBGrid3: TDBGrid
          Left = 1
          Top = 240
          Width = 571
          Height = 104
          Align = alBottom
          BorderStyle = bsNone
          DataSource = dsInfo
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          ReadOnly = True
          TabOrder = 2
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDrawColumnCell = DBGrid1DrawColumnCell
          Columns = <
            item
              Expanded = False
              FieldName = 'TeamColorID'
              Title.Alignment = taCenter
              Title.Caption = #1062#1074#1077#1090
              Width = 28
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TeamName'
              Title.Alignment = taCenter
              Title.Caption = #1050#1086#1084#1072#1085#1076#1072
              Width = 50
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'cMish1'
              Title.Alignment = taCenter
              Title.Caption = #1052#1080#1096#1077#1085#1100'1'
              Width = 85
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'p1'
              Title.Alignment = taCenter
              Title.Caption = #1087'1'
              Width = 35
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'a1'
              Title.Alignment = taCenter
              Title.Caption = #1076'1'
              Width = 35
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'cMish2'
              Title.Alignment = taCenter
              Title.Caption = #1052#1080#1096#1077#1085#1100'2'
              Width = 85
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'p2'
              Title.Alignment = taCenter
              Title.Caption = #1087'2'
              Width = 35
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'a2'
              Title.Alignment = taCenter
              Title.Caption = #1076'2'
              Width = 35
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'cMish3'
              Title.Alignment = taCenter
              Title.Caption = #1052#1080#1096#1077#1085#1100'3'
              Width = 85
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'p3'
              Title.Alignment = taCenter
              Title.Caption = #1087'3'
              Width = 35
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'a3'
              Title.Alignment = taCenter
              Title.Caption = #1076'3'
              Width = 35
              Visible = True
            end>
        end
        object Panel5: TPanel
          Left = 1
          Top = 689
          Width = 571
          Height = 23
          Align = alBottom
          AutoSize = True
          BevelOuter = bvNone
          Color = clSilver
          ParentBackground = False
          TabOrder = 3
          object btnGangeColorTanks: TSpeedButton
            Left = 187
            Top = 1
            Width = 95
            Height = 22
            Caption = #1087#1086#1084#1077#1085#1103#1090#1100' '#1094#1074#1077#1090#1072
            OnClick = btnGangeColorTanksClick
          end
          object Label3: TLabel
            Left = 139
            Top = 6
            Width = 30
            Height = 13
            Caption = #1058#1072#1085#1082'1'
          end
          object Label4: TLabel
            Left = 296
            Top = 6
            Width = 30
            Height = 13
            Caption = #1058#1072#1085#1082'2'
          end
          object cbTank2: TComboBox
            Left = 332
            Top = 0
            Width = 132
            Height = 21
            Style = csDropDownList
            TabOrder = 0
            OnChange = cbTank1Change
            OnDropDown = cbTank1DropDown
          end
          object cbTank1: TComboBox
            Left = 2
            Top = 0
            Width = 131
            Height = 21
            Style = csDropDownList
            TabOrder = 1
            OnChange = cbTank1Change
            OnDropDown = cbTank1DropDown
          end
        end
        object pnlColors: TPanel
          Left = 1
          Top = 712
          Width = 571
          Height = 73
          Align = alBottom
          Caption = 'pnlColors'
          TabOrder = 4
          object sgColorTank: TStringGrid
            Left = 1
            Top = 1
            Width = 432
            Height = 71
            Align = alLeft
            ColCount = 2
            DefaultColWidth = 85
            DefaultRowHeight = 20
            RowCount = 2
            TabOrder = 0
            OnDrawCell = sgColorTankDrawCell
            ColWidths = (
              85
              85)
            RowHeights = (
              20
              20)
          end
        end
        object sgSpeed: TStringGrid
          Left = 1
          Top = 639
          Width = 571
          Height = 50
          Align = alBottom
          ColCount = 2
          DefaultColWidth = 85
          DefaultRowHeight = 20
          RowCount = 2
          TabOrder = 5
          ColWidths = (
            85
            85)
          RowHeights = (
            20
            20)
        end
      end
    end
    object tsTankGraphics: TTabSheet
      Caption = #1060#1083#1072#1075#1080' , '#1052#1080#1096#1077#1085#1080
      ImageIndex = 1
      object Splitter2: TSplitter
        Left = 0
        Top = 155
        Width = 573
        Height = 3
        Cursor = crVSplit
        Align = alTop
        AutoSnap = False
        Beveled = True
        ExplicitTop = 168
        ExplicitWidth = 795
      end
      object Splitter3: TSplitter
        Left = 0
        Top = 291
        Width = 573
        Height = 3
        Cursor = crVSplit
        Align = alTop
        AutoSnap = False
        Beveled = True
        ExplicitTop = 313
        ExplicitWidth = 217
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 573
        Height = 22
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Color = clGray
        ParentBackground = False
        TabOrder = 0
        object btnRefreshLocal: TSpeedButton
          Left = 1
          Top = 0
          Width = 67
          Height = 22
          Caption = #1054#1073#1085#1086#1074#1080#1090#1100
          OnClick = btnRefreshLocalClick
        end
        object btnReloadGraphics: TSpeedButton
          Left = 222
          Top = 0
          Width = 105
          Height = 22
          Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1075#1088#1072#1092#1080#1082#1091
          OnClick = btnReloadGraphicsClick
        end
        object btnLoadGraphics: TSpeedButton
          Left = 94
          Top = 0
          Width = 105
          Height = 22
          Caption = #1057#1086#1079#1076#1072#1090#1100' '#1075#1088#1072#1092#1080#1082#1091
          OnClick = btnLoadGraphicsClick
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 294
        Width = 573
        Height = 515
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel6'
        TabOrder = 1
        object Panel7: TPanel
          Left = 0
          Top = 0
          Width = 573
          Height = 18
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = #1057#1090#1088#1072#1085#1099' '#1080' '#1092#1083#1072#1075#1080
          TabOrder = 0
          object btnImportCountry: TSpeedButton
            Left = 112
            Top = 0
            Width = 65
            Height = 18
            Caption = #1048#1084#1087#1086#1088#1090
            OnClick = btnImportCountryClick
          end
          object DBNavigator1: TDBNavigator
            Left = 0
            Top = 0
            Width = 88
            Height = 18
            DataSource = dsCountryLoc
            VisibleButtons = [nbInsert, nbDelete, nbPost, nbCancel]
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = DBNavigator1Click
          end
        end
        object DBGrid5: TDBGrid
          Left = 0
          Top = 18
          Width = 573
          Height = 497
          Align = alClient
          DataSource = dsCountryLoc
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDblClick = DBGrid5DblClick
          Columns = <
            item
              Expanded = False
              FieldName = 'CountryName'
              Title.Alignment = taCenter
              Title.Caption = #1057#1090#1088#1072#1085#1072
              Width = 208
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FlagImg'
              Title.Alignment = taCenter
              Title.Caption = #1060#1083#1072#1075
              Width = 455
              Visible = True
            end>
        end
      end
      object Panel8: TPanel
        Left = 0
        Top = 158
        Width = 573
        Height = 133
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel8'
        TabOrder = 2
        object Panel9: TPanel
          Left = 0
          Top = 0
          Width = 573
          Height = 21
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = #1062#1074#1077#1090#1072' '#1090#1072#1085#1082#1086#1074
          TabOrder = 0
          object btnImportColor: TSpeedButton
            Left = 112
            Top = 0
            Width = 65
            Height = 18
            Caption = #1048#1084#1087#1086#1088#1090
            OnClick = btnImportColorClick
          end
          object R: TLabel
            Left = 343
            Top = 4
            Width = 15
            Height = 13
            Caption = 'R+'
          end
          object Label17: TLabel
            Left = 394
            Top = 4
            Width = 15
            Height = 13
            Caption = 'G+'
          end
          object Label18: TLabel
            Left = 445
            Top = 4
            Width = 14
            Height = 13
            Caption = 'B+'
          end
          object Label19: TLabel
            Left = 494
            Top = 4
            Width = 14
            Height = 13
            Caption = 'Y+'
          end
          object DBNavigator2: TDBNavigator
            Left = 0
            Top = 0
            Width = 88
            Height = 18
            DataSource = dsColorLoc
            VisibleButtons = [nbInsert, nbDelete, nbPost, nbCancel]
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = DBNavigator2Click
          end
          object eAddR: TEdit
            Left = 360
            Top = 0
            Width = 28
            Height = 21
            TabOrder = 1
            Text = '0'
          end
          object eAddG: TEdit
            Left = 410
            Top = 0
            Width = 28
            Height = 21
            TabOrder = 2
            Text = '0'
          end
          object eAddB: TEdit
            Left = 461
            Top = 0
            Width = 28
            Height = 21
            TabOrder = 3
            Text = '0'
          end
          object eAddYR: TEdit
            Left = 509
            Top = 0
            Width = 28
            Height = 21
            TabOrder = 4
            Text = '0'
          end
          object eAddYG: TEdit
            Left = 543
            Top = 0
            Width = 28
            Height = 21
            TabOrder = 5
            Text = '0'
          end
        end
        object DBGrid4: TDBGrid
          Left = 0
          Top = 21
          Width = 573
          Height = 112
          Align = alClient
          DataSource = dsColorLoc
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDrawColumnCell = DBGrid4DrawColumnCell
          OnDblClick = DBGrid4DblClick
          Columns = <
            item
              Expanded = False
              FieldName = 'RankColor'
              Title.Alignment = taCenter
              Title.Caption = 'N'
              Width = 23
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ColorImg'
              Title.Alignment = taCenter
              Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
              Width = 68
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ColorID'
              PickList.Strings = (
                'r'
                'g'
                'b'
                'y')
              Title.Alignment = taCenter
              Title.Caption = 'ID'
              Width = 39
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ColorValue'
              Title.Alignment = taCenter
              Title.Caption = #1062#1074#1077#1090
              Width = 30
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TexturePath'
              Title.Alignment = taCenter
              Title.Caption = #1058#1077#1082#1089#1090#1091#1088#1072
              Width = 250
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'PicturePath'
              Title.Alignment = taCenter
              Title.Caption = #1050#1072#1088#1090#1080#1085#1082#1072
              Width = 250
              Visible = True
            end>
        end
      end
      object Panel11: TPanel
        Left = 0
        Top = 22
        Width = 573
        Height = 133
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel8'
        TabOrder = 3
        object Panel12: TPanel
          Left = 0
          Top = 0
          Width = 573
          Height = 18
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = #1052#1080#1096#1077#1085#1080
          TabOrder = 0
          object btnImportMesheny: TSpeedButton
            Left = 112
            Top = 0
            Width = 65
            Height = 18
            Caption = #1048#1084#1087#1086#1088#1090
            OnClick = btnImportMeshenyClick
          end
          object DBNavigator3: TDBNavigator
            Left = 0
            Top = 0
            Width = 88
            Height = 18
            DataSource = dsMeshenyLoc
            VisibleButtons = [nbInsert, nbDelete, nbPost, nbCancel]
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = DBNavigator3Click
          end
        end
        object DBGrid6: TDBGrid
          Left = 0
          Top = 18
          Width = 573
          Height = 115
          Align = alClient
          DataSource = dsMeshenyLoc
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDrawColumnCell = DBGrid4DrawColumnCell
          OnDblClick = DBGrid6DblClick
          Columns = <
            item
              Expanded = False
              FieldName = 'MeshenyName'
              Title.Alignment = taCenter
              Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Width = 132
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'MeshenyID'
              PickList.Strings = (
                'TTT'
                'T'
                'G'
                'H')
              Title.Alignment = taCenter
              Title.Caption = 'ID'
              Width = 61
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'MeshenyCount'
              Title.Alignment = taCenter
              Title.Caption = #1050#1086#1083'-'#1074#1086
              Width = 52
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'PicturePath'
              Title.Alignment = taCenter
              Title.Caption = #1050#1072#1088#1090#1080#1085#1082#1072
              Width = 417
              Visible = True
            end>
        end
      end
    end
    object tsBaseConnect: TTabSheet
      Caption = #1041#1072#1079#1099', '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1077
      ImageIndex = 3
      object Panel16: TPanel
        Left = 0
        Top = 0
        Width = 573
        Height = 82
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Color = clSilver
        ParentBackground = False
        TabOrder = 0
        object Label2: TLabel
          Left = 12
          Top = 0
          Width = 158
          Height = 13
          Caption = #1042#1085#1077#1096#1085#1103#1103' '#1041#1072#1079#1072' (Tank_2013.mdb)'
          WordWrap = True
        end
        object btnConnect: TSpeedButton
          Left = 423
          Top = 14
          Width = 85
          Height = 22
          Cursor = crHandPoint
          Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100#1089#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          OnClick = btnConnectClick
        end
        object btnUnConnect: TSpeedButton
          Left = 514
          Top = 15
          Width = 50
          Height = 22
          Cursor = crHandPoint
          Caption = #1054#1090#1082#1083'.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          OnClick = btnUnConnectClick
        end
        object Label5: TLabel
          Left = 12
          Top = 42
          Width = 217
          Height = 13
          Caption = #1051#1086#1082#1072#1083#1100#1085#1072#1103' '#1041#1072#1079#1072' (Tank_GPS_LocalData.mdb)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object btnConnectLocal: TSpeedButton
          Left = 423
          Top = 60
          Width = 85
          Height = 22
          Cursor = crHandPoint
          Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100#1089#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          OnClick = btnConnectLocalClick
        end
        object btnUnConnectLocal: TSpeedButton
          Left = 514
          Top = 60
          Width = 50
          Height = 22
          Cursor = crHandPoint
          Caption = #1054#1090#1082#1083'.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          OnClick = btnUnConnectLocalClick
        end
        object eBaseFile: TEdit
          Left = 5
          Top = 15
          Width = 389
          Height = 21
          Cursor = crHandPoint
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object btnBaseFile: TButton
          Left = 392
          Top = 15
          Width = 25
          Height = 22
          Cursor = crHandPoint
          Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1092#1072#1081#1083' '#1073#1072#1079#1099
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = btnBaseFileClick
        end
        object eBaseFileLocal: TEdit
          Left = 5
          Top = 60
          Width = 389
          Height = 21
          Cursor = crHandPoint
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object btnBaseFileLocal: TButton
          Left = 392
          Top = 60
          Width = 25
          Height = 22
          Cursor = crHandPoint
          Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1092#1072#1081#1083' '#1073#1072#1079#1099
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = btnBaseFileLocalClick
        end
      end
      object Panel15: TPanel
        Left = 0
        Top = 82
        Width = 573
        Height = 118
        Align = alTop
        ParentBackground = False
        TabOrder = 1
        object Label6: TLabel
          Left = 11
          Top = 6
          Width = 71
          Height = 13
          Caption = #1089#1082#1086#1088#1086#1089#1090#1100' '#1082#1084'\'#1095
        end
        object Label7: TLabel
          Left = 7
          Top = 41
          Width = 69
          Height = 13
          Caption = #1088#1072#1089#1089#1090#1086#1103#1085#1080#1084' '#1052
        end
        object Label8: TLabel
          Left = 170
          Top = 13
          Width = 184
          Height = 13
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1089#1090#1088#1086#1082' '#1086#1090#1089#1077#1095#1077#1082' '#1085#1072' '#1090#1080#1090#1088#1077
        end
        object Label9: TLabel
          Left = 158
          Top = 69
          Width = 196
          Height = 13
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1089#1090#1088#1086#1082' '#1090#1072#1085#1082#1080#1089#1090#1086#1074' '#1085#1072' '#1090#1080#1090#1088#1077
        end
        object Label10: TLabel
          Left = 167
          Top = 41
          Width = 187
          Height = 13
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1089#1090#1088#1086#1082' '#1084#1080#1096#1077#1085#1077#1081' '#1085#1072' '#1090#1080#1090#1088#1077
        end
        object btnMeshenTexture_Clear: TSpeedButton
          Left = 3
          Top = 95
          Width = 149
          Height = 22
          Caption = #1055#1091#1089#1090#1072#1103' '#1084#1080#1096#1077#1085#1100' ('#1090#1077#1082#1089#1090#1091#1088#1072')'
          OnClick = btnMeshenTexture_ClearClick
        end
        object eSpeedKMH: TEdit
          Left = 88
          Top = 9
          Width = 58
          Height = 21
          TabOrder = 0
          Text = ' '#1050#1052'/'#1063
        end
        object eMoveDistanceM: TEdit
          Left = 87
          Top = 37
          Width = 58
          Height = 21
          TabOrder = 1
          Text = ' '#1052
        end
        object speQuantityOtsechekOnTitle: TSpinEdit
          Left = 360
          Top = 8
          Width = 65
          Height = 22
          MaxValue = 10
          MinValue = 1
          TabOrder = 2
          Value = 3
        end
        object speQuantityPlayersOnTitle: TSpinEdit
          Left = 360
          Top = 64
          Width = 65
          Height = 22
          MaxValue = 10
          MinValue = 1
          TabOrder = 3
          Value = 3
        end
        object speQuantityMisheniOnTitle: TSpinEdit
          Left = 360
          Top = 36
          Width = 65
          Height = 22
          MaxValue = 10
          MinValue = 1
          TabOrder = 4
          Value = 3
        end
        object eMeshenTexture_Clear: TEdit
          Left = 158
          Top = 92
          Width = 406
          Height = 21
          TabOrder = 5
        end
      end
    end
    object tsTitle3DGraphics: TTabSheet
      Caption = #1057#1094#1077#1085#1099' 3D'
      ImageIndex = 2
      object Panel10: TPanel
        Left = 0
        Top = 0
        Width = 573
        Height = 133
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel8'
        TabOrder = 0
        object Panel13: TPanel
          Left = 0
          Top = 0
          Width = 573
          Height = 18
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = #1057#1094#1077#1085#1099
          TabOrder = 0
          object DBNavigator4: TDBNavigator
            Left = 0
            Top = 0
            Width = 88
            Height = 18
            VisibleButtons = [nbInsert, nbDelete, nbPost, nbCancel]
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = DBNavigator3Click
          end
        end
        object DBGrid7: TDBGrid
          Left = 0
          Top = 18
          Width = 573
          Height = 115
          Align = alClient
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDrawColumnCell = DBGrid4DrawColumnCell
          OnDblClick = DBGrid6DblClick
          Columns = <
            item
              Expanded = False
              FieldName = 'MeshenyName'
              Title.Alignment = taCenter
              Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Width = 132
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'MeshenyID'
              PickList.Strings = (
                'TTT'
                'T'
                'G'
                'H')
              Title.Alignment = taCenter
              Title.Caption = 'ID'
              Width = 61
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'MeshenyCount'
              Title.Alignment = taCenter
              Title.Caption = #1050#1086#1083'-'#1074#1086
              Width = 52
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'PicturePath'
              Title.Alignment = taCenter
              Title.Caption = #1050#1072#1088#1090#1080#1085#1082#1072
              Width = 512
              Visible = True
            end>
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 581
    Height = 21
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Color = clSilver
    ParentBackground = False
    TabOrder = 1
    object Label1: TLabel
      Left = 9
      Top = 2
      Width = 30
      Height = 13
      Caption = #1047#1072#1077#1079#1076
    end
    object DBEdit1: TDBEdit
      Left = 45
      Top = 0
      Width = 286
      Height = 21
      DataField = 'StateName'
      DataSource = dsTanksData
      TabOrder = 0
    end
    object DBEdit2: TDBEdit
      Left = 337
      Top = 0
      Width = 105
      Height = 21
      DataField = 'ZaezdName'
      DataSource = dsTanksData
      TabOrder = 1
    end
  end
  object TimerTelemetry: TTimer
    Enabled = False
    OnTimer = TimerTelemetryTimer
    Left = 32
    Top = 552
  end
  object OpenDialog1: TOpenDialog
    Filter = 'mdb|*.mdb'
    Left = 40
    Top = 600
  end
  object dsTanksData: TDataSource
    DataSet = qTanksData
    OnDataChange = dsTanksDataDataChange
    Left = 120
    Top = 616
  end
  object qTanksData: TADOQuery
    Connection = _GPS_dm.DBTanks
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select *  from  tblAmplya a'
      'RIGHT JOIN'
      '('
      
        'select * from ( select *  from  tblTeamPlayers tp, tblPlayers p ' +
        'where tp.TeamPlayer = p.PlayerID ) s2'
      'RIGHT JOIN'
      '('
      'select *  from  tblCountry c'
      'RIGHT JOIN'
      '('
      'select  t.GroupID as CID , t.TeamID  as TID, *'
      'from tblState s, tblZaezd z, tblZaezdMap zm, tblTeams t'
      'where trim(s.ActiveState) = '#39'true'#39
      'and s.StateID = z.GroupID'
      'and trim(z.ActiveZaezd) = '#39'true'#39
      'and z.ZaezdID = zm.ZaezdID'
      'and t.TeamID = zm.TeamID'
      ') s1'
      'ON c.CountryName = s1.CID'
      ') s21'
      'ON s21.TID = s2.TeamID'
      ') s3'
      'ON s3.AmplyaID = a.AmplyaID'
      ''
      'order by s3.NumTank, s3.TeamName, a.DisplayPos'
      ''
      '')
    Left = 120
    Top = 568
  end
  object qOtsechki: TADOQuery
    Connection = _GPS_dm.DBTanks
    CursorType = ctStatic
    OnCalcFields = qOtsechkiCalcFields
    Parameters = <>
    SQL.Strings = (
      'select *'
      'from tblState s, tblZaezd z, tblTeams t, tblOtsech o'
      'where trim(s.ActiveState) = '#39'true'#39
      'and s.StateID = z.GroupID'
      'and trim(z.ActiveZaezd) = '#39'true'#39
      'and z.ZaezdID = o.GroupID'
      'and t.TeamID = o.TeamID'
      'order by t.TeamName, o.NumOtsec'
      ''
      ''
      ''
      '')
    Left = 200
    Top = 568
    object qOtsechkitblStateID: TAutoIncField
      FieldName = 'tblStateID'
      ReadOnly = True
    end
    object qOtsechkisGroupID: TWideStringField
      FieldName = 's.GroupID'
      Size = 30
    end
    object qOtsechkiStateName: TWideStringField
      FieldName = 'StateName'
      Size = 100
    end
    object qOtsechkiStateID: TWideStringField
      FieldName = 'StateID'
      Size = 100
    end
    object qOtsechkiActiveState: TWideStringField
      FieldName = 'ActiveState'
      Size = 100
    end
    object qOtsechkitblZaezdID: TAutoIncField
      FieldName = 'tblZaezdID'
      ReadOnly = True
    end
    object qOtsechkizGroupID: TWideStringField
      FieldName = 'z.GroupID'
      Size = 30
    end
    object qOtsechkiZaezdName: TWideStringField
      FieldName = 'ZaezdName'
      Size = 100
    end
    object qOtsechkiZaezdID: TWideStringField
      FieldName = 'ZaezdID'
      Size = 100
    end
    object qOtsechkiActiveZaezd: TWideStringField
      FieldName = 'ActiveZaezd'
      Size = 200
    end
    object qOtsechkitblTeamsID: TAutoIncField
      FieldName = 'tblTeamsID'
      ReadOnly = True
    end
    object qOtsechkitGroupID: TWideStringField
      FieldName = 't.GroupID'
      Size = 30
    end
    object qOtsechkiTeamName: TWideStringField
      FieldName = 'TeamName'
      Size = 100
    end
    object qOtsechkiEkipag: TWideStringField
      FieldName = 'Ekipag'
      Size = 100
    end
    object qOtsechkitTeamColorID: TWideStringField
      FieldName = 't.TeamColorID'
      Size = 100
    end
    object qOtsechkitTeamID: TWideStringField
      FieldName = 't.TeamID'
      Size = 100
    end
    object qOtsechkitblOtsechID: TAutoIncField
      FieldName = 'tblOtsechID'
      ReadOnly = True
    end
    object qOtsechkioGroupID: TWideStringField
      FieldName = 'o.GroupID'
      Size = 30
    end
    object qOtsechkioTeamID: TWideStringField
      FieldName = 'o.TeamID'
      Size = 100
    end
    object qOtsechkiNumOtsec: TWideStringField
      FieldName = 'NumOtsec'
      Size = 100
    end
    object qOtsechkiTimeOtsec: TWideStringField
      FieldName = 'TimeOtsec'
      Size = 100
    end
    object qOtsechkiDisplayPos: TWideStringField
      FieldName = 'DisplayPos'
      Size = 200
    end
    object qOtsechkitmsec: TWideStringField
      FieldName = 'tmsec'
      Size = 200
    end
    object qOtsechkioTeamColorID: TWideStringField
      FieldName = 'o.TeamColorID'
      Size = 200
    end
    object qOtsechkiZaezd: TWideStringField
      FieldName = 'Zaezd'
      Size = 200
    end
    object qOtsechkicTimeMS: TStringField
      FieldKind = fkCalculated
      FieldName = 'cTimeMS'
      Calculated = True
    end
  end
  object dsOtsechki: TDataSource
    DataSet = qOtsechki
    Left = 200
    Top = 616
  end
  object qInfo: TADOQuery
    Connection = _GPS_dm.DBTanks
    CursorType = ctStatic
    OnCalcFields = qInfoCalcFields
    Parameters = <>
    SQL.Strings = (
      'select *'
      
        'from tblState s, tblZaezd z, tblZaezdMap zm, tblTeams t, tblInfo' +
        '1  i'
      'where trim(s.ActiveState) = '#39'true'#39
      'and s.StateID = z.GroupID'
      'and trim(z.ActiveZaezd) = '#39'true'#39
      'and z.ZaezdID = zm.ZaezdID'
      'and t.TeamID = zm.TeamID'
      'and t.TeamID = i.TeamID'
      'order by zm.NumTank, t.TeamName')
    Left = 264
    Top = 568
    object qInfotblTeamsID: TAutoIncField
      FieldName = 'tblTeamsID'
      ReadOnly = True
    end
    object qInfotGroupID: TWideStringField
      FieldName = 't.GroupID'
      Size = 30
    end
    object qInfoTeamName: TWideStringField
      FieldName = 'TeamName'
      Size = 100
    end
    object qInfotEkipag: TWideStringField
      FieldName = 't.Ekipag'
      Size = 100
    end
    object qInfoTeamColorID: TWideStringField
      FieldName = 'TeamColorID'
      Size = 100
    end
    object qInfotTeamID: TWideStringField
      FieldName = 't.TeamID'
      Size = 100
    end
    object qInfoiGroupID: TWideStringField
      FieldName = 'i.GroupID'
      Size = 30
    end
    object qInfoiTeamID: TWideStringField
      FieldName = 'i.TeamID'
      Size = 100
    end
    object qInfoiEkipag: TWideStringField
      FieldName = 'i.Ekipag'
      Size = 100
    end
    object qInfoDisplayPos: TWideStringField
      FieldName = 'DisplayPos'
      Size = 100
    end
    object qInfofirenum: TWideStringField
      FieldName = 'firenum'
      Size = 100
    end
    object qInfoIRM: TWideStringField
      FieldName = 'IRM'
      Size = 100
    end
    object qInfoZaezd: TWideStringField
      FieldName = 'Zaezd'
      Size = 100
    end
    object qInfoRubeg: TWideStringField
      FieldName = 'Rubeg'
      Size = 200
    end
    object qInfoTime1: TWideStringField
      FieldName = 'Time1'
      Size = 200
    end
    object qInfoS1: TWideStringField
      FieldName = 'S1'
      Size = 200
    end
    object qInfoMish1: TWideStringField
      FieldName = 'Mish1'
      Size = 200
    end
    object qInfop1: TWideStringField
      FieldName = 'p1'
      Size = 200
    end
    object qInfoa1: TWideStringField
      FieldName = 'a1'
      Size = 200
    end
    object qInfoMish2: TWideStringField
      FieldName = 'Mish2'
      Size = 200
    end
    object qInfoTime2: TWideStringField
      FieldName = 'Time2'
      Size = 200
    end
    object qInfoS2: TWideStringField
      FieldName = 'S2'
      Size = 200
    end
    object qInfop2: TWideStringField
      FieldName = 'p2'
      Size = 200
    end
    object qInfoa2: TWideStringField
      FieldName = 'a2'
      Size = 200
    end
    object qInfoMish3: TWideStringField
      FieldName = 'Mish3'
      Size = 200
    end
    object qInfoTime3: TWideStringField
      FieldName = 'Time3'
      Size = 200
    end
    object qInfoS3: TWideStringField
      FieldName = 'S3'
      Size = 200
    end
    object qInfop3: TWideStringField
      FieldName = 'p3'
      Size = 200
    end
    object qInfoa3: TWideStringField
      FieldName = 'a3'
      Size = 200
    end
    object qInfoTotalTime: TWideStringField
      FieldName = 'TotalTime'
      Size = 200
    end
    object qInfotmsec: TWideStringField
      FieldName = 'tmsec'
      Size = 200
    end
    object qInfocMish1: TStringField
      FieldKind = fkCalculated
      FieldName = 'cMish1'
      Calculated = True
    end
    object qInfocMish2: TStringField
      FieldKind = fkCalculated
      FieldName = 'cMish2'
      Calculated = True
    end
    object qInfocMish3: TStringField
      FieldKind = fkCalculated
      FieldName = 'cMish3'
      Calculated = True
    end
    object qInfoGPSID: TWideStringField
      FieldName = 'GPSID'
      Size = 200
    end
  end
  object dsInfo: TDataSource
    DataSet = qInfo
    Left = 264
    Top = 616
  end
  object qCountryLoc: TADOQuery
    Connection = _GPS_dm.DBLocal
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select *  from  tblCountry '
      'order by CountryName'
      '')
    Left = 408
    Top = 568
  end
  object dsCountryLoc: TDataSource
    DataSet = qCountryLoc
    Left = 408
    Top = 616
  end
  object qColorLoc: TADOQuery
    Connection = _GPS_dm.DBLocal
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select *  from  tblColor '
      'order by RankColor'
      ''
      '')
    Left = 344
    Top = 568
    object qColorLoctblColorID: TAutoIncField
      FieldName = 'tblColorID'
      ReadOnly = True
    end
    object qColorLocGroupID: TWideStringField
      FieldName = 'GroupID'
      Size = 30
    end
    object qColorLocColorImg: TWideStringField
      FieldName = 'ColorImg'
      Size = 100
    end
    object qColorLocColorID: TWideStringField
      FieldName = 'ColorID'
      Size = 100
    end
    object qColorLocTexturePath: TWideStringField
      FieldName = 'TexturePath'
      Size = 255
    end
    object qColorLocPicturePath: TWideStringField
      FieldName = 'PicturePath'
      Size = 255
    end
    object qColorLocColorValue: TIntegerField
      FieldName = 'ColorValue'
    end
    object qColorLocRankColor: TIntegerField
      FieldName = 'RankColor'
    end
  end
  object dsColorLoc: TDataSource
    DataSet = qColorLoc
    Left = 344
    Top = 616
  end
  object ColorDialog1: TColorDialog
    Left = 40
    Top = 648
  end
  object OpenDialogTanks: TOpenDialog
    Left = 344
    Top = 520
  end
  object qMeshenyLoc: TADOQuery
    Connection = _GPS_dm.DBLocal
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select *  from  tblMesheny'
      'order by MeshenyName'
      '')
    Left = 344
    Top = 664
    object qMeshenyLoctblMeshenyID: TAutoIncField
      FieldName = 'tblMeshenyID'
      ReadOnly = True
    end
    object qMeshenyLocGroupID: TWideStringField
      FieldName = 'GroupID'
      Size = 30
    end
    object qMeshenyLocMeshenyName: TWideStringField
      FieldName = 'MeshenyName'
      Size = 100
    end
    object qMeshenyLocMeshenyObject: TWideStringField
      FieldName = 'MeshenyObject'
      Size = 100
    end
    object qMeshenyLocMeshenyCount: TWideStringField
      FieldName = 'MeshenyCount'
      Size = 100
    end
    object qMeshenyLocMeshenyTryMain: TWideStringField
      FieldName = 'MeshenyTryMain'
      Size = 100
    end
    object qMeshenyLocMeshenyCountMain: TWideStringField
      FieldName = 'MeshenyCountMain'
      Size = 100
    end
    object qMeshenyLocMeshenyTryOther: TWideStringField
      FieldName = 'MeshenyTryOther'
      Size = 100
    end
    object qMeshenyLocMeshenyCountOther: TWideStringField
      FieldName = 'MeshenyCountOther'
      Size = 100
    end
    object qMeshenyLocMeshenyID: TWideStringField
      FieldName = 'MeshenyID'
      Size = 100
    end
    object qMeshenyLocPicturePath: TWideStringField
      FieldName = 'PicturePath'
      Size = 255
    end
  end
  object dsMeshenyLoc: TDataSource
    DataSet = qMeshenyLoc
    Left = 408
    Top = 664
  end
end
