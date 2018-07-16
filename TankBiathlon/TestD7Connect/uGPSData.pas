unit uGPSData;

interface

type
  TGpsData = record
    VehicleId : integer;
    Latitude, Longitude, Distance : single;
    TimeMilli: UInt64;
    PacketNum: integer;
    Battery : integer;
    Speed: single;
  end;
  PGpsData = ^TGpsData;

type
  TConnectState = (csDisconnected, csDisconnecting, csConnecting, csConnected);

implementation

end.
