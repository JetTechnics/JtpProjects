unit Poligon2D;

interface

uses
  Winapi.Windows, System.SysUtils,
  JTPStudio, TypesJTP,
  Vehicle, GpsConnection, Vector;

procedure  ShowPoligon2D( NumTanks: integer; VideoTrunk: integer );

Var
  MaxTanks : integer = 0;

  GWheelDelta : integer = 0; // колесико мыши

function UpdateTankPoligon( SceneName: PAnsiChar;  Flags: dword;  pEvents: PJtpEvent;  FrameTime: single;  pReserve: pointer ) : UInt64;  stdcall;

implementation


procedure ShowPoligon2D( NumTanks: integer; VideoTrunk: integer );
var
  Res : UInt64;
  i : integer;
  PlaySceneData : TPlaySceneData;
  CloneObjectData : TCloneObjectData;
begin
  PlaySceneData.Create();

  GWheelDelta := 0;

  //  Запускаем показ полигона. Инициируем подвижные средства (танки, катера и т.п.).
  Res := PlayScene( 'Poligon2D', 0.0, 0, VideoTrunk, @PlaySceneData );
  if( Res = JTP_OK ) then begin

 		StrCopy( PoligonSceneName.text, PlaySceneData.SceneName.text );

    MaxTanks := NumTanks;

    //  Инициализируем подвижные средства
    for i := 1 to MaxTanks do begin

      Res := CloneObject( @PoligonSceneName, 'Tank', nil, nil, nil, nil, 0.0, JTP_ABSOLUTE, @CloneObjectData );

      Vehicles[i].Initialize( @CloneObjectData.ObjectName, i );
    end;

    if( TEST <> 0 ) then begin
      for i := 1 to MaxOneVehicles do begin
        Vehicles[i].CtRt := Random(100);
      end;
    end;
  end;

  SetSceneProcessCallback( @PoligonSceneName, @UpdateTankPoligon, 0, nil );

end;



function UpdateTankPoligon( SceneName: PAnsiChar;  Flags: dword;  pEvents: PJtpEvent;  FrameTime: single;  pReserve: pointer ) : UInt64;  stdcall;
var
  res, i : integer;
  GpsData : TGpsData;
  Pos, Dir, Target : TVector;
  fsize : single;
  pEvent : PJtpEvent;
  Delta, CamLen, F, t : single;
  Color : TColor;
begin

  OpenRecords( 0, nil );

  //  Ловим события от мыши, кроме колеса.
  if( pEvents <> nil )  then begin
      pEvent := pEvents;
      while pEvent.EventType <> 0 do begin

        if( pEvent.EventType = EVENT_MOUSE ) then begin

          if( ( pEvent.Flags and EM_LBUTTON_CLICK ) <> 0 ) then begin

          end;
        end;

        Inc( pEvent );
      end;
  end;

  //  Колесо мыши, приближаем/отдаляем камеру
  if( GWheelDelta <> 0 )  then begin

    if( GWheelDelta > 0 )  then Delta := -150.0
    else  Delta := 150.0;

    GetObjectSpace( @PoligonSceneName, 'Camera', @Pos, nil, nil, nil, @Target, nil, 0, nil );
    Dir := VecNormalize( Pos - Target ) * Delta;
    Pos := Pos + Dir;

    SetObjectSpace( @PoligonSceneName, 'Camera', @Pos, nil, nil, nil, nil, nil, 0.0, 0, nil );

    GWheelDelta := 0;
  end;

  // Получим пакет с GPS.
  res := GetGpsPacket( @GpsData, FrameTime );
  if( res = 0 ) then begin

    // Найдём танк с нужным id.
    for i := 1 to MaxOneVehicles do begin
      if( Vehicles[i].Id = GpsData.VehicleId ) then begin
        Pos.x := GpsData.Latitude;
        Pos.z := GpsData.Longitude;
        Pos.y := VehiclesHeight;
        Vehicles[GpsData.VehicleId].GetNewCoord( Pos,  0, 0, 0, 0, 0, 0 );
      end;
    end;
  end;

  fsize := 3.0;

  for i := 1 to MaxOneVehicles do begin
    if( Vehicles[i].State and VE_ENABLED ) <> 0  then begin
      //Vehicles[i].DebugId := i;
      Vehicles[i].Process( FrameTime );
      //  размер танков
      Color.VSet(1,0,0,1);
      Vehicles[i].SetSizeColor( fsize, Color );
    end;
  end;

  CloseRecords( 0, nil );
end;

end.
