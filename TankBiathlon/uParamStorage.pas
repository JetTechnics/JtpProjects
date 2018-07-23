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
    function GetParamData(Descr: TParamDescr): string;
    procedure SetParamData(Descr: TParamDescr; const Value: string);
    function GetParamDataIdx(const AParamIndex: TCaptionParamIdx;
                             const ATankId: integer): string;
    procedure SetParamDataIdx(const AParamIndex: TCaptionParamIdx;
                              const ATankId: integer;
                              const Value: string);
  public
    constructor Create;
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
    property ParamData[Descr: TParamDescr]: string read GetParamData
                                                   write SetParamData;
    property OnParamChanged: TParamChangedEvent read FOnParamChanged
                                                write FOnParamChanged;
  end;

var
  CaptionParamStorage: TCaptionParamStorage;

implementation

{ TCaptionParamStorage }

constructor TCaptionParamStorage.Create;
var
  Idx: TCaptionParamIdx;
  TankN: integer;
begin
  for Idx:=Low(TCaptionParamIdx) to High(TCaptionParamIdx) do
    for TankN:=1 to iTanksNum do
      FData[Idx, TankN] := IntToStr(TankN)+'_'+asCaptionParams[Idx]+'_'+IntToStr(Random(1000));
end;

function TCaptionParamStorage.GetParamData(Descr: TParamDescr): string;
begin
  Result := '';
  if Assigned(Descr) and Descr.IndexCorrect
    then Result := GetParamDataIdx(Descr.ParamIndex, Descr.TankId);
end;

function TCaptionParamStorage.GetParamDataIdx(
  const AParamIndex: TCaptionParamIdx; const ATankId: integer): string;
begin
  if (ATankId >= 1) and (ATankId <= iTanksNum) and
     (asCaptionParamTemplates[AParamIndex] <> '')
      then Result := Format(asCaptionParamTemplates[AParamIndex],
                            [FData[AParamIndex, ATankId]])
      else Result := FData[AParamIndex, ATankId];
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
  OldValue: string;
  OldValueFmt: string;
  Descr: TParamDescr;
begin
  if (ATankId >= 1) and (ATankId <= iTanksNum) and
     (not SameText(FData[AParamIndex, ATankId], Value)) then
    begin
      OldValue := FData[AParamIndex, ATankId];
      OldValueFmt := GetParamDataIdx(AParamIndex, ATankId);
      FData[AParamIndex, ATankId] := Value;

      Descr := TParamDescr.Create(ATankId, asCaptionParams[AParamIndex]);
      try
        if Assigned(FOnParamChanged)
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

initialization
  CaptionParamStorage := TCaptionParamStorage.Create;

finalization
  CaptionParamStorage.OnParamChanged := nil;
  CaptionParamStorage.Free;
  CaptionParamStorage := nil;

end.
