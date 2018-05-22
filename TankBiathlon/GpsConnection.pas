unit GpsConnection;

interface

uses
  Windows, WinSock,
  TypesJTP,
  Vehicle, Vector;


type TGpsData = record
  VehicleId : integer;
  Latitude, Longitude, Distance : single;
  hours, mins, secs, ms: integer;
  Battery : byte;
end;

type PGpsData = ^TGpsData;


const GpsPacketLen : integer = 32;

Var
  GpsTimeOut : single = 0.0;      // Следим за интервалом между пакетами.
Const                             // Если превысили MaxGpsTimeOut,
  MaxGpsTimeOut : single = 3.0;   // то рвём соединение.

Var
//  Для теста
TestCt : integer = 1;

GPSAddress : array[0..63] of AnsiChar;
GPSSocket : int64 = INVALID_SOCKET;
GPSPort: word;
AddrIn: sockaddr_in;

GpsConnect : integer = 0;




function GetGpsPacket( GpsData : PGpsData;  FrameTime : single ) : integer;


implementation


procedure ConnectToGpsServer();
var Res : integer;
    NotBlock : integer;
begin
  Res := 0;         GpsTimeOut := 0.0;

  if( GPSSocket = INVALID_SOCKET ) then begin
      GPSSocket := socket( AF_INET, SOCK_STREAM, IPPROTO_TCP );
      if( GPSSocket = INVALID_SOCKET ) then begin
          Res := WSAGetLastError();
      end;

      NotBlock := 1;
      Res := ioctlsocket( GPSSocket, FIONBIO, NotBlock );
      if( Res <> 0 )  then begin
          WSACleanup();    GPSSocket := INVALID_SOCKET;
      end;

      AddrIn.sin_family := AF_INET;
      AddrIn.sin_port := htons( GPSPort );
      AddrIn.sin_addr.S_addr := inet_addr( GPSAddress );
  end;

  Res := connect( GPSSocket, AddrIn, sizeof(AddrIn) );
  Res := WSAGetLastError();
  if( Res = WSAEISCONN )  then begin
    GpsConnect := 2;
  end;
end;



function GetGpsPacket( GpsData : PGpsData;  FrameTime : single ) : integer;
var
  Res : integer;
  buff: array[0..255] of dword;
  pVehicle : ^TVehicle;
begin
  GetGpsPacket := -1;  // не принят пакет.

  //  Для теста
  if( TEST <> 0 )  then begin

    pVehicle := @Vehicles[TestCt];

    pVehicle.TestTime := pVehicle.TestTime + FrameTime * 4; // четыре танка
    if( pVehicle.TestTime > GpsInterval ) then begin
      pVehicle.TestTime := 0.0; //-0.2 + Random*0.4;

//if( Random < 0.5 ) then TestTime := 1.0;

      GpsData.Latitude := Routes[pVehicle.CtRt].GpsPos.x;
      GpsData.Longitude := Routes[pVehicle.CtRt].GpsPos.z;
      GpsData.VehicleId := TestCt;

      Inc( pVehicle.CtRt );
      if( pVehicle.CtRt >= MaxRoute )  then pVehicle.CtRt := 0;

      GetGpsPacket := 0;
    end;

    Inc( TestCt );
    if( TestCt > MaxOneVehicles ) then
    TestCt := 1;
  end
  else begin
    // соединяемся
    if( GpsConnect = 1 ) then begin
        ConnectToGpsServer();
    end else
    // получаем пакеты
    if( GpsConnect = 2 ) then begin

      Res := recv( GPSSocket, buff, GpsPacketLen, 0 );
      if( Res = GpsPacketLen ) then begin

        GpsTimeOut := 0.0;

        CopyMemory( @GpsData.Latitude, @buff[0], 4 );     //  широта
        CopyMemory( @GpsData.Longitude, @buff[1], 4 );    //  долгота
        CopyMemory( @GpsData.Distance, @buff[2], 4 );     //  пройденное расстояние
        CopyMemory( @GpsData.VehicleId, @buff[6], 4 );    //  id танка

        // Если не пустое сообщение. Сервер шлёт и пустые сообщения для поддержания связи.
        if ( GpsData.Latitude <> FLT_UNDEF ) and ( GpsData.Longitude <> FLT_UNDEF ) and ( GpsData.VehicleId > 0 ) then begin
          GetGpsPacket := 0;
        end;

      end
      else begin
        GpsTimeOut := GpsTimeOut + FrameTime;

        // разорвём соединение
        if( GpsTimeOut > MaxGpsTimeOut )  then begin

          GpsTimeOut := 0.0;
          closesocket( GPSSocket );     GPSSocket := INVALID_SOCKET;
          GpsConnect := 1;
        end;
      end;

    end;
  end;
end;

end.
