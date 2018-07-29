unit uGPSPacketsQueue;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.AnsiStrings,
  uGPSData;

type
  TGPSPacket = class(TObject)
  private
    FBattery: integer;
    FDevId: integer;
    FTimeMilli: UInt64;
    FAlt: single;
    FLon: single;
    FLat: single;
    FPacketN: integer;
    FSpeed: single;
  public
    constructor Create(const Data: TGpsData);
    property DevId: integer read FDevId write FDevId;
    property PacketN: integer read FPacketN write FPacketN;
    property Battery: integer read FBattery write FBattery;
    property Lat: single read FLat write FLat;
    property Lon: single read FLon write FLon;
    property Alt: single read FAlt write FAlt;
    property Speed: single read FSpeed write FSpeed;
    property TimeMilli: UInt64 read FTimeMilli write FTimeMilli;
  end;

{ Globals }
const
  DefPacketQueueSize = 32;
  DefPacketQueueGap  = 16;

procedure InitializeQueue;
procedure DeinitializeQueue;
procedure PushPacket(APacket: TGPSPacket; const ToMainQueue: boolean);
function PopPacket(const FromMainQueue: boolean): TGPSPacket;

implementation

type
  TGPSPacketQueue = class(TObject)
  private
    FQueue: TList;
    FCritSect: TRTLCriticalSection;
    FSizeLimit: integer;
    FSizeGap: integer;
    procedure CheckLimit;
    procedure SetSizeLimit(const Value: integer);
    procedure SetSizeGap(const Value: integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure PushPacket(APacket: TGPSPacket);
    function PopPacket: TGPSPacket;
    property SizeLimit: integer read FSizeLimit write SetSizeLimit default DefPacketQueueSize;
    property SizeGap: integer read FSizeGap write SetSizeGap default DefPacketQueueGap;
  end;

var
  GPSPacketQueueMain: TGPSPacketQueue = nil;
  GPSPacketQueueAux: TGPSPacketQueue = nil;

{ TGPSPacketQueue }

procedure TGPSPacketQueue.CheckLimit;
var
  lim: integer;
  gap: integer;
begin
  if FSizeLimit > 1
    then lim := FSizeLimit
    else lim := 1;
  if FSizeGap > 0
    then gap := FSizeGap
    else gap := 0;
  if FQueue.Count > lim+gap then
    try
      while FQueue.Count > lim do
        begin
          TGPSPacket(FQueue.Items[0]).Free;
          FQueue.Delete(0);
        end;
    except
    end;
end;

procedure TGPSPacketQueue.Clear;
begin
  EnterCriticalSection(FCritSect);
  try
    try
      while FQueue.Count > 0 do
        begin
          TGPSPacket(FQueue.Items[0]).Free;
          FQueue.Delete(0);
        end;
    finally
      FQueue.Clear;
    end;
  except
  end;
  LeaveCriticalSection(FCritSect);
end;

constructor TGPSPacketQueue.Create;
begin
  InitializeCriticalSection(FCritSect);
  FQueue := TList.Create;
  FSizeLimit := DefPacketQueueSize;
  FSizeGap := DefPacketQueueGap;
end;

destructor TGPSPacketQueue.Destroy;
begin
  EnterCriticalSection(FCritSect);
  try
    Clear;
    FQueue.Free;
  except
  end;
  FQueue := nil;
  LeaveCriticalSection(FCritSect);
  DeleteCriticalSection(FCritSect);
  inherited Destroy;
end;

function TGPSPacketQueue.PopPacket: TGPSPacket;
begin
  Result := nil;
  EnterCriticalSection(FCritSect);
  try
    if FQueue.Count > 0 then
      begin
        Result := TGPSPacket(FQueue.Items[0]);
        FQueue.Delete(0);
      end;
  except
  end;
  LeaveCriticalSection(FCritSect);
end;

procedure TGPSPacketQueue.PushPacket(APacket: TGPSPacket);
begin
  EnterCriticalSection(FCritSect);
  if Assigned(APacket) then
    try
      FQueue.Add(APacket);
      CheckLimit;
    except
    end;
  LeaveCriticalSection(FCritSect);
end;

procedure TGPSPacketQueue.SetSizeGap(const Value: integer);
begin
  EnterCriticalSection(FCritSect);
  if Value <> FSizeGap then
    try
      FSizeGap := Value;
      CheckLimit;
    except
    end;
  LeaveCriticalSection(FCritSect);
end;

procedure TGPSPacketQueue.SetSizeLimit(const Value: integer);
begin
  EnterCriticalSection(FCritSect);
  if Value <> FSizeLimit then
    try
      FSizeLimit := Value;
      CheckLimit;
    except
    end;
  LeaveCriticalSection(FCritSect);
end;

{ TGPSPacket }

constructor TGPSPacket.Create(const Data: TGpsData);
begin
  inherited Create;
    try
      FLat := Data.Latitude;
      FLon := Data.Longitude;
      FAlt := Data.Distance;
      FTimeMilli := Data.TimeMilli;
      FPacketN := Data.PacketNum;
      FDevId := Data.VehicleId;
      FBattery := Data.Battery;
      FSpeed := Data.Speed;
    except
    end;
end;

{ Globals }
procedure InitializeQueue;
begin
  if not Assigned(GPSPacketQueueMain)
    then GPSPacketQueueMain := TGPSPacketQueue.Create;
  if not Assigned(GPSPacketQueueAux)
    then GPSPacketQueueAux := TGPSPacketQueue.Create;
end;

procedure DeinitializeQueue;
begin
  if Assigned(GPSPacketQueueMain) then
    begin
      GPSPacketQueueMain.Free;
      GPSPacketQueueMain := nil;
    end;
  if Assigned(GPSPacketQueueAux) then
    begin
      GPSPacketQueueAux.Free;
      GPSPacketQueueAux := nil;
    end;
end;

procedure PushPacket(APacket: TGPSPacket; const ToMainQueue: boolean);
begin
  if ToMainQueue then
    begin
      if Assigned(GPSPacketQueueMain)
        then GPSPacketQueueMain.PushPacket(APacket);
    end
                 else
    begin
      if Assigned(GPSPacketQueueAux)
        then GPSPacketQueueAux.PushPacket(APacket);
    end;
end;

function PopPacket(const FromMainQueue: boolean): TGPSPacket;
begin
  if FromMainQueue then
    begin
      if Assigned(GPSPacketQueueMain)
        then Result := GPSPacketQueueMain.PopPacket
        else Result := nil;
    end
                   else
    begin
      if Assigned(GPSPacketQueueAux)
        then Result := GPSPacketQueueAux.PopPacket
        else Result := nil;
    end;
end;

end.
