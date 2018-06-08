unit Poligon2D;

interface

uses
  Winapi.Windows, System.SysUtils,
  JTPStudio, TypesJTP,
  Vehicle, GpsConnection, Vector;

Var
  MaxTanks : integer = 0;

  GWheelDelta : integer = 0; // колесико мыши

  // Данные камеры.
  CameraSpeed : single;         //  скорость камеры
  //CamViewLen : single;        //  дистанция камеры
  CamViewDir : TVector;         //  направление
  CameraMoving : dword = 0;     //  флаги состояние движения камеры
  NewCameraMoving : dword = 0;  //  флаги нового состояния движения камеры
  CameraScroll : dword = 0;     //  состояние скроллирования (перемещение в плоскости горизонта) камеры.
  StartScrollTarget : TVector;
  StartScrollMouse : TPoint;

  const
    CAM_MOVE_TO_TANKS          : dword = $00000001;  // камера движется за такнками
    CAM_MOVE_TARGET_MED_POINT  : dword = $00000002;  // таргет камеры сначала стремится к точке между танками
    CAM_MOVE_POS_OVER_TARGET   : dword = $00000004;  // позиция камеры ставиться над точкой Target.
    CAM_MOVE_POS_INCLINE       : dword = $00000008;  // позиция камеры ставиться над точкой Target с наклоном.
    CAM_MOVE_POS : dword = 12; //CAM_MOVE_POS_OVER_TARGET or CAM_MOVE_POS_INCLINE;
    CAM_MOVE_COMMON            : dword = $00000010;  // камера движется к общему плану

Var
  ViewTanks : array[0..MaxOneVehicles] of integer;

Type TIdArray = array[0..MaxOneVehicles] of integer;
Type PIdArray = ^TIdArray;


// Public.
procedure  ShowPoligon2D( NumTanks: integer; VideoTrunk: integer;  Ids : PIdArray );

// Public.
procedure  ShowPoligon2D( NumTanks: integer; VideoTrunk: integer;  Ids : PIdArray );

function UpdateTankPoligon( SceneName: PAnsiChar;  Flags: dword;  pEvents: PJtpEvent;  FrameTime: single;  pReserve: pointer ) : UInt64;  stdcall;

// Private.
procedure MoveCameraToTanks( FrameTime: single );

implementation


procedure ShowPoligon2D( NumTanks: integer; VideoTrunk: integer;  Ids : PIdArray );
var
  Res : UInt64;
  i : integer;
  PlaySceneData : TPlaySceneData;
  CloneObjectData : TCloneObjectData;
  Color : TColor;
begin
  PlaySceneData.Create();

  GWheelDelta := 0;

  CameraMoving := 0;  NewCameraMoving := 0;

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

    for i := 1 to MaxOneVehicles do begin
      if( TEST <> 0 ) then begin
        Vehicles[i].Id := i;
        Vehicles[i].CtRt := Random(200);
      end
      else
        Vehicles[i].Id := Ids[i];
    end;

    //  закрасим танки
    Color.VSet(0,2,0,1);    Vehicles[1].SetColor( Color );
    Color.VSet(2,0,0,1);    Vehicles[2].SetColor( Color );
    Color.VSet(0,1,2,1);    Vehicles[3].SetColor( Color );
    Color.VSet(2,1.5,1,1);    Vehicles[4].SetColor( Color );
  end;

  SetSceneProcessCallback( @PoligonSceneName, @UpdateTankPoligon, 0, nil );

end;



function UpdateTankPoligon( SceneName: PAnsiChar;  Flags: dword;  pEvents: PJtpEvent;  FrameTime: single;  pReserve: pointer ) : UInt64;  stdcall;
var
  res, i : integer;
  GpsData : TGpsData;
  Pos, Dir, Target : TVector;
  fsize, Len, fx, fz : single;
  pEvent : PJtpEvent;
  Delta, CamLen, F, t : single;
  Color : TColor;
  MouseDelta : TPoint;
begin

  OpenRecords( 0, nil );

  //  Ловим события от мыши, кроме колеса.
  if( pEvents <> nil )  then begin
    pEvent := pEvents;
    while pEvent.EventType <> 0 do begin

      if( pEvent.EventType = EVENT_MOUSE ) then begin

        // Клик левой клавишей.
        if( ( pEvent.Flags and EM_LBUTTON_CLICK ) <> 0 ) then begin

        end;

        // Клик правой клавишей.
        if( ( pEvent.Flags and EM_RBUTTON_CLICK ) <> 0 ) then begin
          CameraMoving := 0;                      // останов камеры
          NewCameraMoving := 0;

          for i := 1 to MaxOneVehicles do begin   // скроем рамки танков
			    	Vehicles[i].SetSelectFrame( 0.0 );
    			end;
        end;

        // Удерживаем центральеую клавишу.
        if( ( pEvent.Flags and EM_MBUTTON_DOWN ) <> 0 ) then begin

          if( CameraScroll = 0 ) then begin
            CameraScroll := 1;

            StartScrollMouse := pEvent.PointXY;
            GetObjectSpace( @PoligonSceneName, 'Camera', @Pos, nil, nil, nil, @StartScrollTarget, nil, 0, nil );
          end;

          if( CameraScroll = 1 ) then begin

            GetObjectSpace( @PoligonSceneName, 'Camera', @Pos, nil, nil, nil, @Target, nil, 0, nil );
            Dir := Target - Pos;
            Len := VecLengthNormalize( Dir );

            MouseDelta := pEvent.PointXY - StartScrollMouse;
            fx := MouseDelta.x;
            fz := MouseDelta.y;

            Target.x := StartScrollTarget.x - fx * Len/900.0; // 900 подобрал под данный фокус камеры, он не меняется.
            Target.z := StartScrollTarget.z + fz * Len/900.0;

            Pos := Target - Dir * Len;

            SetObjectSpace( @PoligonSceneName, 'Camera', @Pos, nil, nil, nil, @Target, nil, 0.0, JTP_ABSOLUTE, nil );
          end;

        end else
          CameraScroll := 0;

        if( ( pEvent.Flags and EM_RBUTTON_CLICK ) <> 0 ) then begin
          CameraMoving := 0;
          NewCameraMoving := 0;
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

    SetObjectSpace( @PoligonSceneName, 'Camera', @Pos, nil, nil, nil, nil, nil, 0.0, JTP_ABSOLUTE, nil );

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

  // Танки на забеге.
  for i := 1 to MaxOneVehicles do begin
    if( ( Vehicles[i].State and VE_ENABLED ) <> 0 ) then begin
      //Vehicles[i].DebugId := i;
      Vehicles[i].Process( FrameTime );
      //  размер и цвет танков
      Vehicles[i].SetSize( fsize );
    end;
  end;

  // Камера.
  if( NewCameraMoving <> 0 ) then begin
    CameraMoving := NewCameraMoving;
    NewCameraMoving := 0;

    for i := 1 to MaxOneVehicles do begin   // скроем рамки танков
	    Vehicles[i].SetSelectFrame( 0.0 );
    end;

    i := 0;                              // покажем рамки выделенных танков
    while( ViewTanks[i] <> 0 ) do begin
      Vehicles[ViewTanks[i]].SetSelectFrame( 0.7 );
      inc(i);
    end;
  end;

  if( CameraMoving <> 0 ) then begin
    MoveCameraToTanks( FrameTime );
  end;

  CloseRecords( 0, nil );
end;



procedure  MoveCameraToTanks( FrameTime: single );
var
  tank : integer;
  pVehicle : ^TVehicle;
  Len, Len1, Len2, FactorY : single;
  Pos, Target, MedPos, MedTarget, Dir, vMin, vMax : TVector;
begin

  // Камера движеся за танками, расчитаем среднюю точку между ними. Это будет таргет камеры.
  // Определим мин.макс. коор-ты таков, для расчёта средней точки и высоты камеры над ландшафтом.
  vMin.VSet(99999,0,99999);
  vMax.VSet(-99999,0,-99999);

  if( ( CameraMoving and CAM_MOVE_TO_TANKS ) <> 0 ) then begin

    tank := 0;
    while( ViewTanks[tank] <> 0 ) do begin
      pVehicle := @Vehicles[ViewTanks[tank]];

      // мин/макс коор-та х
      if( pVehicle.Pos.x < vMin.x ) then
        vMin.x := pVehicle.Pos.x;
      if( pVehicle.Pos.x > vMax.x ) then
        vMax.x := pVehicle.Pos.x;

      // мин/макс коор-та z
      if( pVehicle.Pos.z < vMin.z ) then
        vMin.z := pVehicle.Pos.z;
      if( pVehicle.Pos.z > vMax.z ) then
        vMax.z := pVehicle.Pos.z;

      Inc( tank );
    end;

    MedTarget := (vMin + vMax) / 2.0;
  end
  else
  if( ( CameraMoving and CAM_MOVE_COMMON ) <> 0 ) then begin
    MedTarget.VSet( 0.0, 0.0, 150.0 );  // в центр полигона
  end;

  GetObjectSpace( @PoligonSceneName, 'Camera', @Pos, nil, nil, nil, @Target, nil, 0, nil );

  //  Хар-ки камеры.
  CameraSpeed := 500.0;

  // Двигаем таргет камеры до средней точки.
  if( ( CameraMoving and CAM_MOVE_TARGET_MED_POINT ) <> 0 ) then begin
    Dir := MedTarget - Target;
    Dir.y := 0.0; // считаем в плоскости горизонта (xz)
    Len := VecLengthNormalize( Dir );
    if( Len > 0.1 ) then begin

      Target := Target + Dir * (CameraSpeed * FrameTime);

      // Достигли точки
      if( VecDot( MedTarget-Target, Dir ) <= 0.0 ) then begin
        Target := MedTarget;
        CameraMoving := CameraMoving and not CAM_MOVE_TARGET_MED_POINT;
      end;
    end;
  end
  else begin
    Target := MedTarget;
  end;

  if( ( CameraMoving and CAM_MOVE_COMMON ) <> 0 ) then begin
    Len := 3800.0;
    FactorY := 2.0;
  end
  else begin
    // Высота камеры в зависимости от мин/макс коор-ат танков.
    Len1 := vMax.x - vMin.x;
    Len2 := vMax.z - vMin.z;
    if( Len1 > Len2 ) then Len := Len1
    else Len := Len2;
    Len := Len * 1.7;
    if( Len < 900.0 ) then Len := 900.0;

    FactorY := 1.0;
  end;

  if( ( CameraMoving and CAM_MOVE_POS ) <> 0 ) then begin
    if( ( CameraMoving and CAM_MOVE_POS_OVER_TARGET ) <> 0 ) then begin
      CamViewDir.VSet( 0.0, -1.0, 0.01 );  // над target
    end;
    if( ( CameraMoving and CAM_MOVE_POS_INCLINE ) <> 0 ) then begin
      CamViewDir.VSet( 0.0, -0.5, 0.5 );   // с наклоном
    end;
  end;

  // Двигаем позицию камеры до точки над точкой таргет (смотрим на полигон сверху или с наклоном).
  MedPos := Target - CamViewDir * Len;

  if( ( CameraMoving and CAM_MOVE_POS ) <> 0 ) then begin
    Dir := MedPos - Pos;
    Len := VecLengthNormalize( Dir );
    if( Len > 0.1 ) then begin

      Pos.x := Target.x;
      Pos.z := Pos.z + Dir.z * (CameraSpeed * FrameTime);
      Pos.y := Pos.y + Dir.y * (CameraSpeed * FrameTime * FactorY);

      // Достигли точки
      if( VecDot( MedPos-Pos, Dir ) <= 0.0 ) then begin
        Pos := MedPos;
        CameraMoving := CameraMoving and not CAM_MOVE_POS;
      end;
    end;
  end
  else begin
    Pos := MedPos;
  end;

  // Если двигались к общему плану и остальные флаги уже сброшены, сбрасываем состояние камеры.
  if( CameraMoving = CAM_MOVE_COMMON ) then
    CameraMoving := 0;

  if( Pos.z > (Target.z-10.0) ) then
    Pos.z := Target.z-10.0;

  SetObjectSpace( @PoligonSceneName, 'Camera', @Pos, nil, nil, nil, @Target, nil, 0.0, JTP_ABSOLUTE, nil );
end;

end.
