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

const
  GPSQueueCheckInterval = 1000;
  GPSUnitsCleanInterval = 5000;

var
  //  Для теста
  TEST : integer = 0;

implementation

end.
