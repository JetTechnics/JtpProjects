unit uParamStorage;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  uCaptionSettingsKeys;

type
  TParamChangedEvent = procedure(Descr: TParamDescr;
                         const OldValue, NewValue,
                               OldValueFmt, NewValueFmt: string) of object;

  TCaptionParamStorage = class(TObject)
  private
    FData: array[TCaptionParamIdx, 1..iTanksNum] of string;
    FOnParamChanged: TParamChangedEvent;
    FOnEndUpdate: TNotifyEvent;
    FUpdating: boolean;
  public
    constructor Create;
    procedure BeginUpdate;
    procedure EndUpdate;
    function GetParamData(Descr: TParamDescr): string;
    procedure SetParamData(Descr: TParamDescr; const Value: string);
    function GetParamDataIdx(const AParamIndex: TCaptionParamIdx;
                             const ATankId: integer): string;
    procedure SetParamDataIdx(const AParamIndex: TCaptionParamIdx;
                              const ATankId: integer;
                              const Value: string);
    procedure SetParamDataV(const AParamIndex: TCaptionParamIdx;
                            const ATankId: integer;
                            const Value: string); overload;
    procedure SetParamDataV(const AParamIndex: TCaptionParamIdx;
                            const ATankId: integer;
                            const Value: integer); overload;
    procedure SetParamDataV(const AParamIndex: TCaptionParamIdx;
                            const ATankId: integer;
                            const Value: single); overload;
    procedure SetParamDataV(const AParamIndex: TCaptionParamIdx;
                            const ATankId: integer;
                            const Value: double); overload;
    procedure SetParamDataV(Descr: TParamDescr; const Value: string); overload;
    procedure SetParamDataV(Descr: TParamDescr; const Value: integer); overload;
    procedure SetParamDataV(Descr: TParamDescr; const Value: single); overload;
    procedure SetParamDataV(Descr: TParamDescr; const Value: double); overload;
    procedure ZeroSpeeds;
    property ParamData[Descr: TParamDescr]: string read GetParamData
                                                   write SetParamData;
    property OnParamChanged: TParamChangedEvent read FOnParamChanged
                                                write FOnParamChanged;
    property OnEndUpdate: TNotifyEvent read FOnEndUpdate write FOnEndUpdate;
  end;

var
  CaptionParamStorage: TCaptionParamStorage;

implementation

{ TCaptionParamStorage }

procedure TCaptionParamStorage.BeginUpdate;
begin
  FUpdating := true;
end;

constructor TCaptionParamStorage.Create;
var
  i: integer;
begin
  FUpdating := false;
  ZeroSpeeds;
  for i:=1 to iTanksNum do
    TankIdRelative[i] := i;
end;

procedure TCaptionParamStorage.EndUpdate;
begin
  FUpdating := false;
  if Assigned(FOnEndUpdate)
    then FOnEndUpdate(Self);
end;

function TCaptionParamStorage.GetParamData(Descr: TParamDescr): string;
begin
  Result := '';
  if Assigned(Descr) and Descr.IndexCorrect
    then Result := GetParamDataIdx(Descr.ParamIndex, Descr.TankId);
end;

function TCaptionParamStorage.GetParamDataIdx(
  const AParamIndex: TCaptionParamIdx; const ATankId: integer): string;
var
  Tnk: integer;
begin
  if (ATankId >= 1) and (ATankId <= iTanksNum)
    then Tnk := TankIdRelative[ATankId];

  if (Tnk >= 1) and (Tnk <= iTanksNum) and
     (asCaptionParamTemplates[AParamIndex] <> '')
      then Result := Format(asCaptionParamTemplates[AParamIndex],
                            [FData[AParamIndex, Tnk]])
      else Result := FData[AParamIndex, Tnk];
end;

procedure TCaptionParamStorage.SetParamData(Descr: TParamDescr;
  const Value: string);
begin
  if Assigned(Descr) and Descr.IndexCorrect
    then SetParamDataIdx(Descr.ParamIndex, Descr.TankId, Value);
end;

procedure TCaptionParamStorage.SetParamDataIdx(
  const AParamIndex: TCaptionParamIdx; const ATankId: integer;
  const Value: string);
var
  Tnk: integer;
  OldValue: string;
  OldValueFmt: string;
  Descr: TParamDescr;
begin
  if (ATankId >= 1) and (ATankId <= iTanksNum)
    then Tnk := TankIdRelative[ATankId];

  if (Tnk >= 1) and (Tnk <= iTanksNum) and
     (not SameText(FData[AParamIndex, Tnk], Value)) then
    begin
      OldValue := FData[AParamIndex, Tnk];
      OldValueFmt := GetParamDataIdx(AParamIndex, Tnk);
      FData[AParamIndex, Tnk] := Value;

      Descr := TParamDescr.Create(ATankId, asCaptionParams[AParamIndex]);
      try
        if (not FUpdating) and Assigned(FOnParamChanged)
          then FOnParamChanged(Descr,
                               OldValue, Value,
                               OldValueFmt, GetParamData(Descr));
      finally
        Descr.Free;
      end;
    end;
end;

procedure TCaptionParamStorage.SetParamDataV(
  const AParamIndex: TCaptionParamIdx; const ATankId: integer;
  const Value: string);
begin
  SetParamDataIdx(AParamIndex, ATankId, Value);
end;

procedure TCaptionParamStorage.SetParamDataV(
  const AParamIndex: TCaptionParamIdx; const ATankId, Value: integer);
begin
  SetParamDataIdx(AParamIndex, ATankId, IntToStr(Value));
end;

procedure TCaptionParamStorage.SetParamDataV(
  const AParamIndex: TCaptionParamIdx; const ATankId: integer;
  const Value: single);
begin
  SetParamDataIdx(AParamIndex, ATankId, FloatToStr(Value));
end;

procedure TCaptionParamStorage.SetParamDataV(
  const AParamIndex: TCaptionParamIdx; const ATankId: integer;
  const Value: double);
begin
  SetParamDataIdx(AParamIndex, ATankId, FloatToStr(Value));
end;

procedure TCaptionParamStorage.SetParamDataV(Descr: TParamDescr;
  const Value: string);
begin
  SetParamData(Descr, Value);
end;

procedure TCaptionParamStorage.SetParamDataV(Descr: TParamDescr;
  const Value: integer);
begin
  SetParamData(Descr, IntToStr(Value));
end;

procedure TCaptionParamStorage.SetParamDataV(Descr: TParamDescr;
  const Value: single);
begin
  SetParamData(Descr, FloatToStr(Value));
end;

procedure TCaptionParamStorage.SetParamDataV(Descr: TParamDescr;
  const Value: double);
begin
  SetParamData(Descr, FloatToStr(Value));
end;

procedure TCaptionParamStorage.ZeroSpeeds;
var
  Idx: TCaptionParamIdx;
  TankN: integer;
begin
  for Idx:=cpiSpeed to cpiSpeed_ave do
    for TankN:=1 to iTanksNum do
      SetParamDataIdx(Idx, TankN, '0');
end;

initialization
  CaptionParamStorage := TCaptionParamStorage.Create;

finalization
  CaptionParamStorage.OnParamChanged := nil;
  CaptionParamStorage.Free;
  CaptionParamStorage := nil;

end.
