object frmCaptionSettings: TfrmCaptionSettings
  Left = 0
  Top = 0
  Caption = 'Caption settings'
  ClientHeight = 343
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    635
    343)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 471
    Top = 305
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 552
    Top = 305
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object pgcPages: TPageControl
    Left = 0
    Top = 0
    Width = 635
    Height = 299
    ActivePage = pgStrings
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object pgStrings: TTabSheet
      Caption = 'Strings'
      object vleCaptionStrings: TValueListEditor
        Left = 0
        Top = 0
        Width = 627
        Height = 271
        Align = alClient
        KeyOptions = [keyUnique]
        TabOrder = 0
        TitleCaptions.Strings = (
          'String'
          'Name')
        OnValidate = vleCaptionStringsValidate
        ColWidths = (
          150
          471)
        RowHeights = (
          18
          18)
      end
    end
    object pgCaptions1: TTabSheet
      Caption = 'Captions 1'
      ImageIndex = 1
      object vleCaptions1: TValueListEditor
        Left = 0
        Top = 0
        Width = 627
        Height = 271
        Align = alClient
        DropDownRows = 20
        KeyOptions = [keyUnique]
        TabOrder = 0
        TitleCaptions.Strings = (
          'String name'
          'Parameter')
        OnGetPickList = CaptionsGetPickList
        OnValidate = vleCaptionsValidate
        ColWidths = (
          150
          471)
        RowHeights = (
          18
          18)
      end
    end
    object pgCaptions2: TTabSheet
      Caption = 'Captions 2'
      ImageIndex = 2
      object vleCaptions2: TValueListEditor
        Left = 0
        Top = 0
        Width = 627
        Height = 271
        Align = alClient
        KeyOptions = [keyUnique]
        TabOrder = 0
        TitleCaptions.Strings = (
          'String name'
          'Parameter')
        OnGetPickList = CaptionsGetPickList
        OnValidate = vleCaptionsValidate
        ColWidths = (
          150
          471)
        RowHeights = (
          18
          18)
      end
    end
    object pgCaptions3: TTabSheet
      Caption = 'Captions 3'
      ImageIndex = 3
      object vleCaptions3: TValueListEditor
        Left = 0
        Top = 0
        Width = 627
        Height = 271
        Align = alClient
        KeyOptions = [keyUnique]
        TabOrder = 0
        TitleCaptions.Strings = (
          'String name'
          'Parameter')
        OnGetPickList = CaptionsGetPickList
        OnValidate = vleCaptionsValidate
        ColWidths = (
          150
          471)
        RowHeights = (
          18
          18)
      end
    end
    object pgCaptions4: TTabSheet
      Caption = 'Captions 4'
      ImageIndex = 4
      object vleCaptions4: TValueListEditor
        Left = 0
        Top = 0
        Width = 627
        Height = 271
        Align = alClient
        KeyOptions = [keyUnique]
        TabOrder = 0
        TitleCaptions.Strings = (
          'String name'
          'Parameter')
        OnGetPickList = CaptionsGetPickList
        OnValidate = vleCaptionsValidate
        ColWidths = (
          150
          471)
        RowHeights = (
          18
          18)
      end
    end
  end
end
