 unit uCaptionSettings;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.IniFiles,
  Vcl.Controls,
  uCaptionSettingsKeys, uParamStorage;

type
  TCaptionSettings = class(TMemIniFile)
  private
    FListArr: array[1..iCaptionsNum] of TStrings;
    procedure ClearList(const AList: TStrings);
  public
    constructor Create(const FileName: string; const Encoding: TEncoding;
      CaseSensitive: Boolean); overload; override;
    destructor Destroy; override;
    function Edit: boolean;
    procedure GetCaptionData(const CaptionN: integer; const AList: TStrings);
    procedure GetCaption1DescrData(const Descr: TParamDescr;
                const Value: string;
                const CaptionN: integer; const AList: TStrings);
    procedure GetCaptionDataDescr(const CaptionN: integer; const AList: TStrings);
    function GetParamValue(const AParamDescr: TParamDescr): string;
  end;

implementation

uses
  fCaptionSettings;

{ TCaptionSettings }

procedure TCaptionSettings.ClearList(const AList: TStrings);
var
  i: integer;
begin
  for i:=0 to AList.Count-1 do
    AList.Objects[i].Free;
  AList.Clear;
end;

constructor TCaptionSettings.Create(const FileName: string;
  const Encoding: TEncoding; CaseSensitive: Boolean);
var
  i: integer;
begin
  inherited Create(FileName, Encoding, CaseSensitive);
  for i:=1 to iCaptionsNum do
    begin
      FListArr[i] := TStringList.Create;
      GetCaptionDataDescr(i, FListArr[i]);
    end;
end;

destructor TCaptionSettings.Destroy;
var
  i: integer;
begin
  for i:=1 to iCaptionsNum do
    begin
      ClearList(FListArr[i]);
      FListArr[i].Free;
      FListArr[i] := nil;
    end;
  inherited Destroy;
end;

function TCaptionSettings.Edit: boolean;
var
  Editor: TfrmCaptionSettings;
  i: integer;
begin
  Result := false;
  Editor := TfrmCaptionSettings.Create(nil);
  try
    Editor.ReadSettings(Self);
    if Editor.ShowModal = mrOk then
      begin
        Editor.SaveSettings(Self);
        Result := true;
      end;
  finally
    Editor.Free;
  end;

  if Result then
    for i:=1 to iCaptionsNum do
      GetCaptionDataDescr(i, FListArr[i]);
end;

procedure TCaptionSettings.GetCaption1DescrData(const Descr: TParamDescr;
  const Value: string;
  const CaptionN: integer; const AList: TStrings);
var
  i: integer;
  key: string;
  v: string;
  lList: TStrings;
  lDescr: TParamDescr;
begin
  AList.Clear;
  if (not Descr.IndexCorrect) or
     (CaptionN < 1) or (CaptionN > iCaptionsNum) then Exit;
  key := sCaptionScene+IntToStr(CaptionN);
  v := ReadString(sScenesSect, key, '');
  if v <> '' then AList.AddPair('*****', v, TObject(CaptionN))
             else Exit;

  lList := FListArr[CaptionN];
  for i:=0 to lList.Count-1 do
    begin
      lDescr := TParamDescr(lList.Objects[i]);
      if (not lDescr.IndexCorrect) or
         (lDescr.TankId <> Descr.TankId) or
         (lDescr.ParamIndex <> Descr.ParamIndex)
        then Continue;

      key := lList.Names[i];
      v := ReadString(sStringsSect, key, '');
      if v <> '' then key := v;
      AList.AddPair(key, Value);
    end;
end;

procedure TCaptionSettings.GetCaptionData(const CaptionN: integer;
  const AList: TStrings);
var
  i: integer;
  key: string;
  v: string;
  lList: TStrings;
begin
  AList.Clear;
  if (CaptionN < 1) or (CaptionN > iCaptionsNum) then Exit;
  key := sCaptionScene+IntToStr(CaptionN);
  v := ReadString(sScenesSect, key, '');
  if v <> '' then AList.AddPair('*****', v, TObject(CaptionN))
             else Exit;

  lList := FListArr[CaptionN];
  for i:=0 to lList.Count-1 do
    begin
      key := lList.Names[i];
      v := ReadString(sStringsSect, key, '');
      if v <> '' then key := v;
      v := GetParamValue(TParamDescr(lList.Objects[i]));
      AList.AddPair(key, v);
    end;
end;

procedure TCaptionSettings.GetCaptionDataDescr(const CaptionN: integer;
  const AList: TStrings);
var
  lsSect: string;
  i: integer;
  key: string;
  v: string;
begin
  ClearList(AList);
  if (CaptionN < 1) or (CaptionN > iCaptionsNum) then Exit;
  lsSect := sCaptionsSectN + IntToStr(CaptionN);
  for i:=1 to iStringsNum do
    begin
      key := sStringN+IntToStr(i);
      v := ReadString(lsSect, key, '');
      if v <> '' then AList.AddPair(key, v, TParamDescr.Create(v));
    end;
end;

function TCaptionSettings.GetParamValue(const AParamDescr: TParamDescr): string;
begin
  Result := CaptionParamStorage.ParamData[AParamDescr];
end;

end.
