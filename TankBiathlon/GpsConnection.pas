unit GpsConnection;

interface

uses
  Windows, WinSock,
  TypesJTP,
  Vehicle, Vector, uGPSData;

Var
//  Для теста
TestCt : integer = 1;

function GetGpsPacket( GpsData : PGpsData;  FrameTime : single ) : integer;

implementation

uses
  uGPSPacketsQueue;

function GetGpsPacket( GpsData : PGpsData;  FrameTime : single ) : integer;
var
  pVehicle : ^TVehicle;
  Pkt: TGPSPacket;
begin
  Result := -1;  // не принят пакет.

  //  Для теста
  if( TEST <> 0 )  then begin

    pVehicle := @Vehicles[TestCt];

    pVehicle.TestTime := pVehicle.TestTime + FrameTime * 4; // четыре танка
    pVehicle.TestTime := pVehicle.TestTime * 5.0; // ускорение времени
    if( pVehicle.TestTime > GpsInterval ) then begin
      pVehicle.TestTime := 0; //-0.2 + Random() * 0.5;

//if( Random < 0.5 ) then TestTime := 1.0;

      GpsData.Latitude := Routes[pVehicle.CtRt].GpsPos.x;
      GpsData.Longitude := Routes[pVehicle.CtRt].GpsPos.z;
      GpsData.VehicleId := pVehicle.Id;

      Inc( pVehicle.CtRt );
      if( pVehicle.CtRt >= MaxRoute )
        then pVehicle.CtRt := 0;

      Result := 0;
    end;

    Inc( TestCt );
    if( TestCt > MaxOneVehicles ) then
    TestCt := 1;
  end
  else begin

    Pkt := uGPSPacketsQueue.PopPacket(true);
    try
      if Assigned(Pkt) then
        begin
          GpsData^.VehicleId := Pkt.DevId;
          GpsData^.Latitude  := Pkt.Lat;
          GpsData^.Longitude := Pkt.Lon;
          GpsData^.Distance  := Pkt.Alt;
          GpsData^.Battery   := Pkt.Battery;
          Result := 0;
        end;
    finally
      Pkt.Free;
    end;

  end;
end;

end.
