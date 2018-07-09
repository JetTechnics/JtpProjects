unit uGPSPacketsQueue;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.AnsiStrings,
  System.Generics.Collections,
  GpsConnection;

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
procedure InitializeQueue;
procedure DeinitializeQueue;
procedure PushPacket(APacket: TGPSPacket);
function PopPacket: TGPSPacket;

implementation

type
  TGPSPacketQueue = class(TObject)
  private
    FQueue: TQueue<TGPSPacket>;
    procedure QueueNotify(Sender: TObject; const Item: TGPSPacket;
                          Action: TCollectionNotification);
  public
    constructor Create;
    destructor Destroy; override;
    procedure PushPacket(APacket: TGPSPacket);
    function PopPacket: TGPSPacket;
  end;

var
  GPSPacketQueue: TGPSPacketQueue = nil;

{ TGPSPacketQueue }

constructor TGPSPacketQueue.Create;
begin
  FQueue := TQueue<TGPSPacket>.Create;
  FQueue.OnNotify := QueueNotify;
end;

destructor TGPSPacketQueue.Destroy;
begin
  TMonitor.Enter(Self);
  try
    FQueue.Free;
    FQueue := nil;
  except
  end;
  TMonitor.Exit(Self);
  inherited Destroy;
end;

function TGPSPacketQueue.PopPacket: TGPSPacket;
begin
  Result := nil;
  TMonitor.Enter(Self);
  try
    Result := FQueue.Extract;
  except
  end;
  TMonitor.Exit(Self);
end;

procedure TGPSPacketQueue.PushPacket(APacket: TGPSPacket);
begin
  TMonitor.Enter(Self);
  try
    FQueue.Enqueue(APacket);
  finally
    TMonitor.Exit(Self);
  end;
end;

procedure TGPSPacketQueue.QueueNotify(Sender: TObject; const Item: TGPSPacket;
  Action: TCollectionNotification);
begin
  if (Action = cnRemoved)
    then Item.Free;
end;

{ TGPSPacket }

constructor TGPSPacket.Create(const Data: TGpsData);
begin
  inherited Create;
    try
      FDevId := Data.VehicleId;
      // FPacketN := ;
      FBattery := Data.Battery;
      FLat := Data.Latitude;
      FLon := Data.Longitude;
      FAlt := Data.Distance;
      FSpeed := Data.Speed;
      FTimeMilli := Data.TimeMilli;
    except
    end;
end;

{ Globals }
procedure InitializeQueue;
begin
  if not Assigned(GPSPacketQueue)
    then GPSPacketQueue := TGPSPacketQueue.Create;
end;

procedure DeinitializeQueue;
begin
  if Assigned(GPSPacketQueue) then
    begin
      GPSPacketQueue.Free;
      GPSPacketQueue := nil;
    end;
end;

procedure PushPacket(APacket: TGPSPacket);
begin
  if Assigned(GPSPacketQueue)
    then GPSPacketQueue.PushPacket(APacket);
end;

function PopPacket: TGPSPacket;
begin
  if Assigned(GPSPacketQueue)
    then Result := GPSPacketQueue.PopPacket
    else Result := nil;
end;

end.
