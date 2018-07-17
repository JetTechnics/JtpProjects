unit uCaptionSettings;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.IniFiles,
  Vcl.Controls,
  uCaptionSettingsKeys;

type
  TParamDescr = class(TObject)
  private
    FFullName: string;
    FTankId: integer;
    FName: string;
    FValue: string;
  public
    constructor Create(const AFullName: string);
    property FullName: string read FFullName;
    property TankId: integer read FTankId;
    property Name: string read FName;
    property Value: string read FValue;
  end;

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
    procedure GetCaptionDataDescr(const CaptionN: integer; const AList: TStrings);
    function GetParamValue(const AParamDescr: TParamDescr): string;
  end;

implementation

uses
  fCaptionSettings;

{ TParamDescr }

constructor TParamDescr.Create(const AFullName: string);
var
  s: string;
  ln: integer;
begin
  FFullName := AFullName;
  FTankId := 0;
  FName := AFullName;
  FValue := '';
  ln := Length(FFullName);
  if ln > 2 then
    begin
      s := AFullName[1];
      FTankId := StrToIntDef(s, 0);
      FName := Copy(s, 3, ln);
    end;
end;

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
  Result := '';
  if not Assigned(AParamDescr) then Exit;

  AParamDescr.FValue := AParamDescr.FFullName + '_' + IntToStr(Random(10000));
  Result := AParamDescr.FValue;
end;

end.
