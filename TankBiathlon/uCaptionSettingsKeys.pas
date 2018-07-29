unit uCaptionSettingsKeys;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils;

const
  iStringsNum = 20;
  iCaptionsNum = 4;
  iTanksNum = 4;

type
  TCaptionParamIdx =
    (cpiTeam_name, cpiGPS_id, cpiColor, cpiName1, cpiName2, cpiName3,
     cpiTargets_hit, cpiPenalty_laps, cpiPenalty_stops, cpiLap,
     cpiSpeed, cpiSpeed_max, cpiSpeed_ave);

const
  sScenesSect: string = 'CaptionSections';
  sCaptionScene: string = 'CaptionScene_';

  sStringsSect: string = 'Strings';
  sStringN: string = 'string_';
  sStringEmpty: string = 'Empty';

  sCaptionsSectN: string = 'Captions_';
  asCaptionParams: array[TCaptionParamIdx] of string =
    ('Team_name', 'GPS_id', 'Color', 'Name1', 'Name2', 'Name3',
     'Targets_hit', 'Penalty_laps', 'Penalty_stops', 'Lap',
     'Speed', 'Speed_max', 'Speed_ave');
  asCaptionParamTemplates: array[TCaptionParamIdx] of string =
    ('', '', '', '', '', '',
     '', '', '', '',
     '%s ÊÌ/×', '%s ÊÌ/×', '%s ÊÌ/×');

type
  TParamDescr = class(TObject)
  private
    FFullName: string;
    FTankId: integer;
    FName: string;
    FIndexCorrect: boolean;
    FParamIndex: TCaptionParamIdx;
    procedure UpdateParamIndex;
    procedure SetFullName(const Value: string);
    procedure SetName(const Value: string);
    procedure SetTankId(const Value: integer);
  public
    constructor Create(const AFullName: string); overload;
    constructor Create(ATankId: integer; const AName: string); overload;
    procedure SetTankIdAndName(ATankId: integer; const AName: string);
    property FullName: string read FFullName write SetFullName;
    property TankId: integer read FTankId write SetTankId;
    property Name: string read FName write SetName;
    property IndexCorrect: boolean read FIndexCorrect;
    property ParamIndex: TCaptionParamIdx read FParamIndex;
  end;

var
  TankIdRelative: array[1..iTanksNum] of integer;

implementation

{ TParamDescr }

constructor TParamDescr.Create(const AFullName: string);
begin
  FTankId := 0;
  FParamIndex := cpiTeam_name;
  SetFullName(AFullName);
end;

constructor TParamDescr.Create(ATankId: integer; const AName: string);
begin
  FParamIndex := cpiTeam_name;
  SetTankIdAndName(ATankId, AName);
end;

procedure TParamDescr.SetFullName(const Value: string);
var
  s: string;
  ln: integer;
begin
  FFullName := Value;
  FName := FFullName;
  ln := Length(FFullName);
  if ln > 2 then
    begin
      s := FFullName[1];
      FTankId := StrToIntDef(s, 0);
      FName := Copy(FFullName, 3, ln);
      UpdateParamIndex;
    end;
end;

procedure TParamDescr.SetName(const Value: string);
begin
  FName := Value;
  FFullName := IntToStr(FTankId) + '_' + FName;
  UpdateParamIndex;
end;

procedure TParamDescr.SetTankId(const Value: integer);
begin
  FTankId := Value;
  FFullName := IntToStr(FTankId) + '_' + FName;
  UpdateParamIndex;
end;

procedure TParamDescr.SetTankIdAndName(ATankId: integer; const AName: string);
begin
  if ATankId < 1 then ATankId := 1
                 else
    if ATankId > iTanksNum then ATankId := iTanksNum;
  FTankId := ATankId;
  SetName(AName);
end;

procedure TParamDescr.UpdateParamIndex;
var
  i: TCaptionParamIdx;
begin
  if FName <> '' then
    for i:=Low(TCaptionParamIdx) to High(TCaptionParamIdx) do
      if SameText(FName, asCaptionParams[i]) then
        begin
          FIndexCorrect := true;
          FParamIndex := i;
          Exit;
        end;
  FIndexCorrect := false;
end;

end.
