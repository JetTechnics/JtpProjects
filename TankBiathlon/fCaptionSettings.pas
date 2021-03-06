unit fCaptionSettings;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.IniFiles,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids,
  Vcl.ValEdit, Vcl.ComCtrls, Vcl.StdCtrls,
  uCaptionSettingsKeys;

type
  TfrmCaptionSettings = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    pgcPages: TPageControl;
    pgStrings: TTabSheet;
    vleCaptionStrings: TValueListEditor;
    pgCaptions1: TTabSheet;
    pgCaptions2: TTabSheet;
    pgCaptions3: TTabSheet;
    pgCaptions4: TTabSheet;
    vleCaptions1: TValueListEditor;
    vleCaptions2: TValueListEditor;
    vleCaptions3: TValueListEditor;
    vleCaptions4: TValueListEditor;
    pgScenes: TTabSheet;
    vleScenes: TValueListEditor;
    procedure FormCreate(Sender: TObject);
    procedure vleCaptionStringsValidate(Sender: TObject; ACol, ARow: Integer;
      const KeyName, KeyValue: string);
    procedure CaptionsGetPickList(Sender: TObject; const KeyName: string;
      Values: TStrings);
    procedure vleCaptionsValidate(Sender: TObject; ACol, ARow: Integer;
      const KeyName, KeyValue: string);
  private
    FEditorArr: array[0..iCaptionsNum] of TValueListEditor;
    procedure GetCaptionsPickList(const List: TStrings);
    procedure ReadCaptions(const AFile: TMemIniFile);
    procedure ReadCaptionsN(const SectNum: integer; const AFile: TMemIniFile);
    procedure ReadScenes(const AFile: TMemIniFile);
    procedure ReadStringsSect(const AFile: TMemIniFile);
    procedure SaveCaptions(const AFile: TMemIniFile);
    procedure SaveCaptionsN(const SectNum: integer; const AFile: TMemIniFile);
    procedure SaveScenes(const AFile: TMemIniFile);
    procedure SaveStringsSect(const AFile: TMemIniFile);
  public
    procedure ReadSettings(const AFile: TMemIniFile);
    procedure SaveSettings(const AFile: TMemIniFile);
  end;

implementation

{$R *.dfm}

{ TfrmCaptionSettings }

procedure TfrmCaptionSettings.CaptionsGetPickList(Sender: TObject;
  const KeyName: string; Values: TStrings);
begin
  GetCaptionsPickList(Values);
end;

procedure TfrmCaptionSettings.FormCreate(Sender: TObject);
begin
  FEditorArr[0] := vleCaptionStrings;
  FEditorArr[1] := vleCaptions1;
  FEditorArr[2] := vleCaptions2;
  FEditorArr[3] := vleCaptions3;
  FEditorArr[4] := vleCaptions4;
end;

procedure TfrmCaptionSettings.GetCaptionsPickList(const List: TStrings);
var
  i: integer;
  k: TCaptionParamIdx;
  v: string;
begin
  List.Clear;
  List.Add(sStringEmpty);
  for i:=1 to iTanksNum do
    begin
      v := IntToStr(i) + '_';
      for k:=Low(TCaptionParamIdx) to High(TCaptionParamIdx) do
        List.Add(v+asCaptionParams[k]);
    end;
end;

procedure TfrmCaptionSettings.ReadCaptions(const AFile: TMemIniFile);
var
  i: integer;
begin
  for i:=1 to iCaptionsNum do
    ReadCaptionsN(i, AFile);
end;

procedure TfrmCaptionSettings.ReadCaptionsN(const SectNum: integer;
  const AFile: TMemIniFile);
var
  Ed: TValueListEditor;
  i: integer;
  lsSect: string;
  key: string;
  keyV: string;
  v: string;
  EdProp: TItemProp;
begin
  if SectNum in [1..iCaptionsNum] then
    begin
      Ed := FEditorArr[SectNum];
      lsSect := sCaptionsSectN+IntToStr(SectNum);
      for i:=1 to iStringsNum do
        begin
          key := sStringN+IntToStr(i);
          v := AFile.ReadString(lsSect, key, sStringEmpty);
          Ed.InsertRow(key, v, true);
          EdProp := Ed.ItemProps[key];
          EdProp.EditStyle := esPickList;
          keyV := AFile.ReadString(sStringsSect, key, '');
          if keyV <> '' then EdProp.KeyDesc := key + ' (' + keyV + ')';
        end;
    end;
end;

procedure TfrmCaptionSettings.ReadScenes(const AFile: TMemIniFile);
var
  i: integer;
  key: string;
  v: string;
begin
  for i:=1 to iCaptionsNum do
    begin
      key := sCaptionScene+IntToStr(i);
      v := AFile.ReadString(sScenesSect, key, sStringEmpty);
      vleScenes.InsertRow(key, v, true);
    end;
end;

procedure TfrmCaptionSettings.ReadSettings(const AFile: TMemIniFile);
begin
  ReadScenes(AFile);
  ReadStringsSect(AFile);
  ReadCaptions(AFile);
end;

procedure TfrmCaptionSettings.ReadStringsSect(const AFile: TMemIniFile);
var
  i: integer;
  key: string;
  v: string;
begin
  for i:=1 to iStringsNum do
    begin
      key := sStringN+IntToStr(i);
      v := AFile.ReadString(sStringsSect, key, sStringEmpty);
      vleCaptionStrings.InsertRow(key, v, true);
    end;
end;

procedure TfrmCaptionSettings.SaveCaptions(const AFile: TMemIniFile);
var
  i: integer;
begin
  for i:=1 to iCaptionsNum do
    SaveCaptionsN(i, AFile);
end;

procedure TfrmCaptionSettings.SaveCaptionsN(const SectNum: integer;
  const AFile: TMemIniFile);
var
  Ed: TValueListEditor;
  i: integer;
  lsSect: string;
  key: string;
  v: string;
begin
  if SectNum in [1..iCaptionsNum] then
    begin
      Ed := FEditorArr[SectNum];
      lsSect := sCaptionsSectN+IntToStr(SectNum);
      for i:=1 to iStringsNum do
        begin
          key := sStringN+IntToStr(i);
          v := Ed.Values[key];
          if (v <> '') and (not SameText(v, sStringEmpty))
            then AFile.WriteString(lsSect, key, v);
        end;
    end;
end;

procedure TfrmCaptionSettings.SaveScenes(const AFile: TMemIniFile);
var
  i: integer;
  key: string;
  v: string;
begin
  for i:=1 to iCaptionsNum do
    begin
      key := sCaptionScene+IntToStr(i);
      v := vleScenes.Values[key];
      if (v <> '') and (not SameText(v, sStringEmpty))
        then AFile.WriteString(sScenesSect, key, v);
    end;
end;

procedure TfrmCaptionSettings.SaveSettings(const AFile: TMemIniFile);
begin
  AFile.Clear;
  SaveScenes(AFile);
  SaveStringsSect(AFile);
  SaveCaptions(AFile);
  AFile.UpdateFile;
end;

procedure TfrmCaptionSettings.SaveStringsSect(const AFile: TMemIniFile);
var
  i: integer;
  key: string;
  v: string;
begin
  for i:=1 to iStringsNum do
    begin
      key := sStringN+IntToStr(i);
      v := vleCaptionStrings.Values[key];
      if (v <> '') and (not SameText(v, sStringEmpty))
        then AFile.WriteString(sStringsSect, key, v);
    end;
end;

procedure TfrmCaptionSettings.vleCaptionStringsValidate(Sender: TObject; ACol,
  ARow: Integer; const KeyName, KeyValue: string);
var
  v: string;
begin
  if ACol <> 1 then Exit;

  if (KeyValue <> '') and (not SameText(KeyValue, sStringEmpty))
    then v := KeyName + ' (' + KeyValue + ')'
    else v := '';
  vleCaptions1.ItemProps[KeyName].KeyDesc := v;
  vleCaptions2.ItemProps[KeyName].KeyDesc := v;
  vleCaptions3.ItemProps[KeyName].KeyDesc := v;
  vleCaptions4.ItemProps[KeyName].KeyDesc := v;
end;

procedure TfrmCaptionSettings.vleCaptionsValidate(Sender: TObject; ACol,
  ARow: Integer; const KeyName, KeyValue: string);
var
  List: TStrings;
begin
  if (ACol <> 1) or
     (KeyValue = '') or SameText(KeyValue, sStringEmpty)
    then Exit;

  List := TStringList.Create;
  try
    GetCaptionsPickList(List);
    if List.IndexOf(KeyValue) < 0 then
      raise Exception.Create('Illegal parameter name');
  finally
    List.Free;
  end;
end;

end.
