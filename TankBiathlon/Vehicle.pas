unit Vehicle;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, JTPStudio, Math, TypesJTP, Vector;

const MAX_VCOORD = 7;

const MAX_VEHICLES = 32;

const MAX_ROUTE_PNTS = 2500; //302;

const MAX_FIX_POINTS = 4;     //  Сколько одинаковых точек будем выбрасывать

const MAX_ROUTE_LINES = 256;  //  Кол-во линий для показа дистанции между танками

const MAX_SIM_PNTS = 5;

const MAX_JMP_PAIRS = 8;


type TRoutePoint = record     //  Точка маршрута
  GpsPos: TVector;
  Pos: TVector;
end;


type TRouteJumper = record    //  Перемычка на штрафном круге
  p1, p2 : integer;
end;


type TGpsTime = record        //  Время со спутника GPS
  hr, min, sec, ms: integer
end;


type TCoordData = record
  Pos      : TVector;     //  записанные координаты (очередь FIFO)
  Time     : TGpsTime;    //  время этих координат, такая же очередь
  GpsCoord : TVector;
  Distance : single;
  Speed    : single;
end;


type TSimPoint = record
  Name     : TName;
  Pos      : TVector;
  MoveTime : single;
  SimSpeed : single;
  CtRt     : integer;
end;



type TVec2 = record
  x,y : single;
end;



Type  TVehicle = record     //  Подвижное средство

  Id      : integer;        //  уникальный id
  State   : dword;
  Head    : integer;        //  индекс последней записанной координаты
  Focus   : integer;        //  индекс координаты, к которой едем
  Name    : TName;          //  имя танка
  ModelName : TName;        //  имя модели танка
  PictName : TName;         //  имя прицепленой картинки к танку
  Pos     : TVector;        //  текущая координата
  NewPos  : TVector;        //  вновь полученная координата
  Orient  : TVector;        //  текущая ориентация
  Color   : TJTPColor;      //  цвет танка
  NewTime : TGpsTime;       //  её время
  Speed   : single;         //  текущая скорость
  SpeedFactor : single;     //  правка скорости, если отстаём/опрежаем
  TestTime : single;        //  для тестов
  Dir1, Dir2 : TVector;     //  направление
  Len     : single;         //  расстояние между точками
  CtFix   : integer;        //  сколько в режиме простоя
  CtRt    : integer;        //  для тестов
  MoveDir : TVector;

  Index   : integer;        //  Индекс танка в общем массиве, начиная с 1.

  NullSpeedTime : single;

  CoordData : array [0..MAX_VCOORD-1] of TCoordData;

  DistCoord : array [0..MAX_ROUTE_LINES-1] of TVec2;

  NewSpeed, NewDistance : single;
  dst_ct    : integer;     //  1/2 триггер на поправку дистанции

  UserSpeedFactor : single;    //  Поправка на скорость

  GpsCoord  : TVector;
  TrueSpeed : single;      //  текущая скорость
  SpeedsAvr : array [0..2] of single;
  CtSpeeds  : integer;
  MoveDistance : single;   //  пройденное расстояние

  //DebugId   : integer;

  SimPoints : array[0..MAX_SIM_PNTS] of TSimPoint;
  CtSim     : integer;
  SimSpeed  : single;

  Vcur: single; // Speed current from GPS
  Vmax: single; // Speed max from GPS

  procedure Initialize( VehicleName : PAnsiChar;  ArrayIndex : integer ); //, ModelName2: PAnsiChar;  State2: integer );
  procedure Reset();
  procedure ShowSimPoints( Alpha : single );
  {procedure StartForSimulation();
  procedure StopForSimulation();}
  procedure SetSelectFrame( Alpha : single );
  procedure SetTankPictAlpha( Alpha : single );
  procedure SetSize( NewSize : single );
  procedure SetColor( NewColor : TJTPColor );
  procedure GetNewCoord( Coord: TVector;  hr, min, sec, ms: integer;  Speed, Distance : single );
  procedure PushNewCoord();
  procedure DoFocusPos( Skip : integer );
  procedure DecHead();
  procedure DecFocus();
  procedure Process( FrameTime: single );
End;

PVehicle = ^TVehicle;


const VE_ENABLED      = $00000001;
const VE_UPDATE_POS   = $00000002;
const VE_STARTED      = $00000004;


function FindVehicle( Name: PAnsichar ) : integer;
function FindVehicleByPoint( Name: PAnsichar; var TankId: integer ) : integer;


Const
  MaxOneVehicles = 4;                 // Сколько танков на забеге.
  VehiclesHeight : single = 1.5;      // Высота танков.
  GpsInterval : single = 1.0;

Var
  PoligonSceneName : TName;

  Routes      : array[0..MAX_ROUTE_PNTS-1] of TRoutePoint;          //  Точки маршрута
  //RoutesNames : array[0..MAX_ROUTE_PNTS-1] of PAnsiChar;
  MaxRoute    : integer = 0;

  Vehicles     : array[0..MAX_VEHICLES-1] of TVehicle;             //  Подвижные средства
  VehicleName  : PAnsiChar;
  MaxVehicles  : integer = 0;

//  var VColors  : array[0..MAX_VEHICLES-1] of TVector;

  //VehiclesStarted : integer = 0;          //  сцена запущена

  RouteLines : array[0..MAX_ROUTE_LINES-1] of PAnsiChar;

  RouteJumpers : array[0..MAX_JMP_PAIRS-1] of TRouteJumper;    //  Перемычки на штрафных кругах
  MaxRouteJumpers : integer;

  //  Привязка трэка к карте
  lon_f1 : single = 101000.0;
  lon_f2 : single = 3729235.0;
  lat_f1 : single = 176000.0;
  lat_f2 : single = 9774630.0;

  {lon_f1 : single = 559848.6357299343;
  lon_f2 : single = 21055266.16311491735;
  lat_f1 : single = 991917.7075679647;
  lat_f2 : single = 55267507.16385011021;}

  //  Поправка на дистанцию
  DistFactor : single = 1.424;

implementation

procedure TVehicle.Initialize( VehicleName : PAnsiChar; ArrayIndex : integer ); //, ModelName2: PAnsiChar;  State2: integer );
var Names : array [0..63] of TName;
    i, Res : integer;
    Clr, P : TVector;
    str : ansistring;
    PlayAnimationData : TJtpFuncData;
begin

  if( VehicleName <> nil ) then StrCopy( Name.text, VehicleName )
  else  Name.text[0] := #0;

  TestTime := 0.0;

  if( ArrayIndex < 10 )  then str := 'TankModel0'
  else  str := 'TankModel';
  str := str + IntToStr(ArrayIndex);
  StrCopy( ModelName.text, PAnsiChar(str) );

  if( ArrayIndex < 10 )  then str := 'TankText0'
  else  str := 'TankText';
  str := str + IntToStr(ArrayIndex);
  StrCopy( PictName.text, PAnsiChar(str) );

  //State := 0; //State2;
  State := VE_ENABLED or VE_STARTED;

  Head := -2;    Focus := -1;     CtRt := 0;       Len := 0.0;      Speed := 0.0;     SpeedFactor := 1.0;

  Dir1.VSet(0,0,1);    Dir2.VSet(0,0,1);

  if (Color.r = 0) and (Color.g = 0) and (Color.b = 0) and
     (Color.a = 0) then
    case ArrayIndex of
      1: Color.VSet(1,1,0,1);
      2: Color.VSet(0,0,1,1);
      3: Color.VSet(1,0,0,1);
      4: Color.VSet(0,1,0,1);
    end;

  Orient.x := FLT_UNDEF;     Orient.z := FLT_UNDEF;    //  наклоны по карте высот, используем только Orient.y

  TrueSpeed := 0.0;   MoveDistance := 0.0;
  CtSpeeds := 0;        dst_ct := 0;
  NullSpeedTime := 0.0;
  //DebugId := 0;
  UserSpeedFactor := 1.0;

  Vcur := 0;
  Vmax := 0;

  Index := ArrayIndex;

  MoveDir.VSet(0,0,1);    // смотрит на север, азимут 0.

  SetSelectFrame( 0.0 );    //  скроем/покажем рамку
  SetTankPictAlpha( 1.0 );  //  и прикреплённую картинку

  // Анимация иконки танка.
  PlayAnimationData.Create();
  Res := PlayAnimation( @PoligonSceneName, @ModelName, 'Animation', FLT_UNDEF, 0, @PlayAnimationData );

  {if( ModelName2 <> nil ) then begin
      GetChildsNamesByBase( @PoligonSceneName, @Name, ModelName2, @Names, 0, nil );
      if( Names[0].text[0] <> #0 ) then  StrCopy( ModelName.text, Names[0].text );
  end;}

  {if( SimPoints[0].Name.text[0] = #0 ) then begin
      Clr := Color;    Clr.w:=0;
      P.VSet(0,99999,0,0);
      for i:=1 to (MAX_SIM_PNTS-1) do begin
        CloneObject( @PoligonSceneName, 'SimPoint', nil, nil, nil, nil, 0.0, 0, nil );
        StrCopy( @SimPoints[i].Name, GetLastObjectName( @PoligonSceneName ) );
        SetObjectSpace( @PoligonSceneName, @SimPoints[i].Name, @P, nil, nil, nil, nil, @Clr, 0.0, JTP_ABSOLUTE, nil );
        Str := IntToStr(i);
        UpdateSurfaceElement( @PoligonSceneName, @SimPoints[i].Name, 1, 1, nil, PAnsiChar(Str), COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
        SimPoints[i].CtRt := 0;
      end;
  end;
  SimPoints[0].CtRt := 0;
  SimPoints[0].SimSpeed := 0.0;
  SimSpeed := 0.0;
  CtSim := 0;}

end;



procedure TVehicle.Reset();
Var
  Pos : TVector;
begin
  State := 0;

  Pos.VSet( 0.0, 7300.0, 0.0 );
  SetObjectSpace( @PoligonSceneName, @Name, @Pos, nil, nil, nil, nil, nil, 0.0, JTP_ABSOLUTE, nil );
end;



procedure TVehicle.ShowSimPoints( Alpha : single );
var i : integer;
    Clr, P, D, Ps : TVector;
    zr: boolean;
begin
{
    GetObjectSpace( @PoligonSceneName, @ModelName, nil, nil, nil, nil, nil, @Clr, 0, nil );
    Clr.w := Alpha;

    GetObjectSpace( @PoligonSceneName, @Name, @P, nil, nil, nil, nil, nil, 0, nil );
    P.z := P.z+50.0;

    for i:=1 to (MAX_SIM_PNTS-1) do begin
      if( SimPoints[i].CtRt = 0 ) then
        Ps := P
      else
        Ps := SimPoints[i].Pos;
      SetObjectSpace( @PoligonSceneName, @SimPoints[i].Name, @Ps, nil, nil, nil, nil, @Clr, 0.0, JTP_ABSOLUTE, nil );
      P.z := P.z+50.0;
    end;
}
end;


(*
procedure TVehicle.StartForSimulation();
var Dir : TVector;
    i, k, pnt, NextRt, Rt, Rt2 : integer;
    L : single;
begin
    //ShowSimPoints( 0.0 );

    State := VE_ENABLED or VE_STARTED;

    CtRt := SimPoints[0].CtRt;     CtSim := 1;

    Pos := SimPoints[0].Pos;
    Focus := 1;
    Head := 1;

    CoordData[0].Pos := Pos;
    CoordData[1].Pos := Routes[CtRt].Pos;

    Dir := VecNormalize( CoordData[1].Pos - Pos );
    Dir1 := Dir;  Dir2 := Dir;

    //  скорость до точки
    for pnt := 0 to (MAX_SIM_PNTS-2) do begin
      L := 0.0;
      Rt := SimPoints[pnt].CtRt;
      if( pnt = 0 ) then begin
        Rt:=Rt-1;  if(Rt<0) then Rt:=MaxRoute-1;
      end;
      for k := 0  to  (MaxRoute-1) do begin
        Rt2 := Rt+1;    if( Rt2 >= MaxRoute )  then Rt2 := 0;
        L := L + ( Routes[Rt2].Pos - Routes[Rt].Pos ).Length();
        if( Rt2 = SimPoints[pnt+1].CtRt ) then break;

        //  тест на перемычку
        NextRt := -1;
        for i := 0 to (MaxRouteJumpers-1) do begin
          if( Rt2 = RouteJumpers[i].p1 ) and ( pnt > 0 )  then begin
            if( SimPoints[pnt+1].CtRt > RouteJumpers[i].p1 ) and ( SimPoints[pnt+1].CtRt < RouteJumpers[i].p2 ) then
              NextRt := RouteJumpers[i].p1+1
            else
              NextRt := RouteJumpers[i].p2;
            break;
          end;
        end;

        if( NextRt > 0 )  then Rt := NextRt
        else inc(Rt);
        if( Rt >= MaxRoute )  then Rt := 0;
      end;
      SimPoints[pnt+1].SimSpeed := L / SimPoints[pnt+1].MoveTime;
    end;

    SimSpeed := SimPoints[1].SimSpeed;

    SetObjectSpace( @PoligonSceneName, @Name, @Pos, nil, nil, nil{@Dir}, nil, nil, 0.0, JTP_ABSOLUTE, nil );

    DoFocusPos(0);
end;



procedure TVehicle.StopForSimulation();
var Dir : TVector;
    j : integer;
begin
    State := VE_ENABLED;

    CtRt := SimPoints[0].CtRt;     CtSim := 1;

    Pos := SimPoints[0].Pos;

    CoordData[0].Pos := Pos;
    j := CtRt+1;    if( j >= (MaxRoute-1) ) then j:=0;
    CoordData[1].Pos := Routes[j].Pos;

    Dir := VecNormalize( CoordData[1].Pos - Pos );

    SetObjectSpace( @PoligonSceneName, @Name, @Pos, nil, nil, nil{@Dir}, nil, nil, 0.0, JTP_ABSOLUTE, nil );
end;
*)


procedure TVehicle.SetSelectFrame( Alpha : single );
var
  TempName : AnsiString;
  VColor: TJTPColor;
  SetObjectSpaceData : TSetObjectSpace;
  Res : UInt64;
begin
  VColor.VSet( FLT_UNDEF, FLT_UNDEF, FLT_UNDEF, Alpha );

  if( Index < 10 )  then TempName := 'TankFrame0'
  else  TempName := 'TankFrame';
  TempName := TempName + IntToStr(Index);

  SetObjectSpaceData.Create();
  Res := SetObjectSpace( @PoligonSceneName, PAnsiChar(TempName), nil, nil, nil, nil, nil, @VColor, 0.0, JTP_ABSOLUTE, @SetObjectSpaceData );

end;



procedure TVehicle.SetTankPictAlpha( Alpha : single );
var
  TempName : AnsiString;
  VColor: TJTPColor;
  SetObjectSpaceData : TSetObjectSpace;
  Res : UInt64;
begin
  VColor.VSet( FLT_UNDEF, FLT_UNDEF, FLT_UNDEF, Alpha );

  {if( Index < 10 )  then TempName := 'Bubble0'
  else  TempName := 'Bubble';
  TempName := TempName + IntToStr(Index);

  SetObjectSpaceData.Create();
  Res := SetObjectSpace( @PoligonSceneName, PAnsiChar(TempName), nil, nil, nil, nil, nil, @VColor, 0.0, JTP_ABSOLUTE, @SetObjectSpaceData );}

  //  Прицепленная к иконке картинка.
  if( Index < 10 )  then TempName := 'TankText0'
  else  TempName := 'TankText';
  TempName := TempName + IntToStr(Index);

  SetObjectSpaceData.Create();
  Res := SetObjectSpace( @PoligonSceneName, PAnsiChar(TempName), nil, nil, nil, nil, nil, @VColor, 0.0, JTP_ABSOLUTE, @SetObjectSpaceData );

end;



procedure TVehicle.SetSize( NewSize : single );
var Size : TVector;
    SetObjectSpaceData : TSetObjectSpace;
    TempName : AnsiString;
begin
  Size.VSet( NewSize, NewSize, NewSize );

  if( ModelName.text[0] <> #0 ) then
      SetObjectSpace( @PoligonSceneName, @ModelName, nil, nil, @Size, nil, nil, nil, 0.0, JTP_ABSOLUTE, nil );

  // Сдвиг прицепленной к иконке танка картинки.
  if( Index < 10 )  then TempName := 'TankText0'
  else  TempName := 'TankText';
  TempName := TempName + IntToStr(Index);
  SetObjectSpaceData.Create();
  SetObjectSpaceData.BillboardRingShift := -NewSize * 0.45;
  SetObjectSpace( @PoligonSceneName, PAnsiChar(TempName), nil, nil, nil, nil, nil, nil, 0.0, JTP_ABSOLUTE, @SetObjectSpaceData );
end;



procedure TVehicle.SetColor( NewColor : TJTPColor );
begin
  Color := NewColor;

  if ModelName.text[0] <> #0 then
    begin
      SetObjectSpace(@PoligonSceneName, @ModelName, nil, nil, nil, nil, nil, @Color, 0.0, JTP_ABSOLUTE, nil);

    end;
end;



procedure TVehicle.GetNewCoord( Coord: TVector;  hr, min, sec, ms: integer;  Speed, Distance : single );
var  Coord2 : TVector;
begin

//if(Focus>=1)and(DebugId=4)and(CtRt>45)  then
//  exit;

    //  пересчитаем GPS координаты в наши
    Coord2.x := Coord.z * lon_f1 - lon_f2;
    Coord2.z := Coord.x * lat_f1 - lat_f2;

//    Coord2.x := (Coord.z * 100.0 - 3690.0) * 1010.0 - 2335.0;
//    Coord2.z := (Coord.x * 100.0 - 5553.0) * 1760.0 - 1350.0;

    Coord2.y :=  Coord.y;

    GpsCoord := Coord;

    NewSpeed := Speed;

    NewDistance := Speed; //Distance;
    inc(dst_ct);
    if( dst_ct = 2 )  then begin
        dst_ct := 0;    NewDistance := NewDistance + 0.5;
    end;

    NewPos := Coord2;
    NewTime.hr := hr;    NewTime.min := min;    NewTime.sec := sec;  NewTime.ms := ms;

    State := State or VE_UPDATE_POS;
end;



procedure TVehicle.PushNewCoord();
var L : single;
    Remain : TVector;
label EndL;
begin
  if( Head < 0 )  then begin      //  начальная позиция, ставим на карту
      Inc( Head );
      Inc( Focus );
      CoordData[Focus].Pos := NewPos;    Pos := NewPos;
      CoordData[Focus].GpsCoord := GpsCoord;
      if( Head = 0 )  then DoFocusPos( 1 );
      Dir1 := Dir2;
  end else begin

      Inc( Head );
      if( Head = 1 )  then  Focus := 1;

      //  если такая же точка, выкинем её по счетчику CtFix
      if( Head > 0 )  then begin
        L := ( NewPos - CoordData[Head-1].Pos ).Length();
        if ( L < 1.0 ) then begin

          Speed := 0;      SpeedsAvr[0]:=0;  SpeedsAvr[1]:=0;  SpeedsAvr[2]:=0;       TrueSpeed := 0;
          CoordData[Head].Distance := 0;
          NewDistance := 0;

          Inc( CtFix );
          if( CtFix <= MAX_FIX_POINTS ) then begin
            DecHead();
            goto EndL;
          end else begin
          end;
        end;
      end;
      CtFix := 0;

      //  много точек в ожидании, надо ускориться
      if( (Head-Focus) >= 2 )  then begin
          if( SpeedFactor <= 1.0 )  then SpeedFactor := 1.1;
      end;

      //  достигли предела, сдвинем точки
      if( Head >= MAX_VCOORD )  then begin
          DecHead();
          DecFocus();

          CopyMemory( @CoordData[0], @CoordData[1], SizeOf(TCoordData)*(MAX_VCOORD-1) );

          if( Speed > 0.0 ) then begin
              if( SpeedFactor <= 1.3 )  then SpeedFactor := 1.3;

              Remain := Pos - CoordData[Focus-1].Pos;

              CoordData[Focus-1].Pos := CoordData[Focus-1].Pos + Remain;
          end;

          Pos := CoordData[Focus-1].Pos;
          DoFocusPos( 0 );
      end;

      CoordData[Head].Pos := NewPos;     CoordData[Head].Time := NewTime;

      CoordData[Head].Speed := NewSpeed;     CoordData[Head].Distance := NewDistance;

      CoordData[Head].GpsCoord := GpsCoord;
  end;

EndL:
  State := State and not VE_UPDATE_POS;
end;



procedure TVehicle.DoFocusPos( Skip : integer );
Var GpsDelta, Dl : TVector;
    L : single;
begin
  Dir1 := Dir2;

  Dl := CoordData[Focus].Pos - CoordData[Focus-1].Pos;

  Len := Dl.Length();

  if( Len < 0.1 )  then begin
      Speed := 0;      SpeedsAvr[0]:=0;  SpeedsAvr[1]:=0;  SpeedsAvr[2]:=0;       TrueSpeed := 0;
      CoordData[Focus].Distance := 0.0;
  end else begin
      Speed := Len / GpsInterval;
      Dir2 := VecNormalize( Dl );

      MoveDir := Dir2;

      if( ( State and VE_STARTED ) <> 0 )  then begin
        MoveDistance := MoveDistance + CoordData[Focus].Distance;

        SpeedsAvr[CtSpeeds] := CoordData[Focus].Speed;
        Inc( CtSpeeds );   if( CtSpeeds > 2 )  then CtSpeeds := 0;

        TrueSpeed := ( SpeedsAvr[0] + SpeedsAvr[1] + SpeedsAvr[2] ) / 3;
        TrueSpeed := TrueSpeed * 3600.0 / 1000.0 ;
      end;
  end;
end;



procedure TVehicle.DecHead();
begin
  Dec( Head );   if( Head<0 ) then Head := 0;
end;


procedure TVehicle.DecFocus();
begin
  Dec( Focus );   if( Focus < 1 ) then Focus := 1;
end;



procedure TVehicle.Process( FrameTime: single );
Var Dir, Remain : TVector;
    Factor, Len1 : single;
    i, NextRt : integer;
begin

  if ( (State and VE_STARTED) = 0 ) then exit;

  //if ( (State and VE_UPDATE_POS) <> 0 ) and ( SimSpeed = 0.0 )  then begin
  if ( (State and VE_UPDATE_POS) <> 0 ) then begin
      PushNewCoord();
  end;

  if( Focus >= 1 )  then begin

      //  Симуляция
      {if( CtSim >= MAX_SIM_PNTS ) then exit;

      if( SimSpeed > 0.0 ) and ( CtSim < MAX_SIM_PNTS )  then begin

        Len1 := (CoordData[0].Pos-Pos).Length();
        Factor := Len1 / Len;
        if( Factor > 1.0 ) then Factor := 1.0;
        //  движемся от предыдущей точки к текущей
        Dir := VecLerp( Dir1, Dir2, Factor );
        Dir := VecNormalize(Dir);
        Pos := Pos + ( MoveDir * (SimSpeed*FrameTime) );

        //  достигли текущую точку
        if( VecDot( MoveDir, CoordData[1].Pos - Pos ) <= 0.0 )  then begin

          CoordData[0].Pos := Pos;

          //  следующая точка симуляции
          if( CtRt = SimPoints[CtSim].CtRt )  then begin
            Inc( CtSim );
            if( CtSim < MAX_SIM_PNTS ) then
              SimSpeed := SimPoints[CtSim].SimSpeed;
          end;

          //  тест на перемычку
          NextRt := -1;
          for i := 0 to (MaxRouteJumpers-1) do begin
            if( CtRt = RouteJumpers[i].p1 )  then begin
              if( SimPoints[CtSim].CtRt > RouteJumpers[i].p1 ) and ( SimPoints[CtSim].CtRt < RouteJumpers[i].p2 ) then
                NextRt := RouteJumpers[i].p1+1
              else
                NextRt := RouteJumpers[i].p2;
              break;
            end;
          end;

          if( NextRt >= 0 )  then CtRt := NextRt
          else Inc( CtRt );
          if( CtRt >= MaxRoute ) then CtRt := 0;
          CoordData[1].Pos := Routes[CtRt].Pos;

          DoFocusPos( 0 );
        end;

        SetObjectSpace( @PoligonSceneName, @Name, @Pos, nil, nil, @Dir, nil, nil, 0.0, JTP_ABSOLUTE, nil );

        TrueSpeed := SimSpeed / DistFactor * UserSpeedFactor;
        TrueSpeed := TrueSpeed * 3600.0 / 1000.0;

        exit;
      end;}

      //  Стоим на месте
      if( Speed = 0.0 )  then begin

         NullSpeedTime := NullSpeedTime + FrameTime;
         if( NullSpeedTime > 2.0 ) then begin
             SpeedsAvr[0]:=0;  SpeedsAvr[1]:=0;  SpeedsAvr[2]:=0;       TrueSpeed := 0;
         end;

         Pos := CoordData[Focus].Pos;
         SetObjectSpace( @PoligonSceneName, @Name, @Pos, nil, nil, nil, nil, nil, 0.0, JTP_ABSOLUTE, nil );
         if( (Head-Focus) > 2 )  then begin
            Inc(Focus);
            Pos := CoordData[Focus-1].Pos;
            DoFocusPos( 0 );
            if( Speed > 0.0 ) then SpeedFactor := 1.0
            else  TrueSpeed := 0.0;
         end;
         exit;
      end;

      NullSpeedTime := 0.0;

      //  Ускорение или замедление
      if( SpeedFactor > 1.0 )  then begin
          SpeedFactor := SpeedFactor + FrameTime;
      end;

      if( SpeedFactor < 1.0 )  then begin
          SpeedFactor := SpeedFactor - FrameTime;      if( SpeedFactor < 0.4 )  then SpeedFactor := 0.4;
      end;

      Len1 := (CoordData[Focus-1].Pos-Pos).Length();
      Factor := Len1 / Len;
      //  движемся от предыдущей точки к текущей
      Dir := VecLerp( Dir1, Dir2, Factor );
      Dir := VecNormalize(Dir);
      Pos := Pos + ( Dir * (Speed*SpeedFactor*FrameTime) );

      //  достигли текущую точку
      if( VecDot( Dir, CoordData[Focus].Pos - Pos ) <= 0.0 )  then begin

          //  новая координата для вычисления дистанции между двумя танками
          i := MAX_ROUTE_LINES-1;
          while( i>0 )  do begin
            DistCoord[i] := DistCoord[i-1];
            dec(i);
          end;

          DistCoord[0].x := CoordData[Focus].GpsCoord.x;
          DistCoord[0].y := CoordData[Focus].GpsCoord.z;

          Remain := Pos - CoordData[Focus].Pos;

          Inc( Focus );

          if( Focus > Head ) then begin    //  за пределами головы, будем стоять
              DecFocus();
              Speed := 0;
              Pos := CoordData[Focus].Pos;
              //DoFocusPos( 1 );
              exit;
          end;

          //  если список ожидающих близок к заполнению, сдвинем список
          if( Head >= (MAX_VCOORD-2) )  then begin

              DecHead();
              DecFocus();

              CopyMemory( @CoordData[0], @CoordData[1], SizeOf(TCoordData)*(MAX_VCOORD-1) );

              if( SpeedFactor <= 1.3 )  then SpeedFactor := 1.3;
          end;

          CoordData[Focus-1].Pos := CoordData[Focus-1].Pos + Remain;
          Pos := CoordData[Focus-1].Pos;
          DoFocusPos( 0 );

          if( (Head-Focus) < 2 )  then         //  разница невелика, нормальная скорость
              SpeedFactor := 1.0;

          if( Head = Focus )  then             //  достигли головы списка, замедлимся
              SpeedFactor := 0.9;
      end;

      SetObjectSpace( @PoligonSceneName, @Name, @Pos, nil, nil, nil{@Dir}, nil, nil, 0.0, JTP_ABSOLUTE, nil );
  end;
end;



function FindVehicle( Name: PAnsichar ) : integer;
var i: integer;
begin
   for i := 1 to (MAX_VEHICLES-1) do begin
     if( StrComp( Vehicles[i].ModelName.Text, Name ) = 0 )  then begin
        FindVehicle := i;    exit;
     end;
   end;

   FindVehicle := 0;
end;



function FindVehicleByPoint( Name: PAnsichar; var TankId: integer ) : integer;
var i,j: integer;
begin
    TankId := 0;

    for i := 1 to (MAX_VEHICLES-1) do begin
      for j := 1 to (MAX_SIM_PNTS-1) do begin
        if( StrComp( @Vehicles[i].SimPoints[j].Name, Name ) = 0 )  then begin
          TankId := i;    FindVehicleByPoint := j;    exit;
        end;
      end;
    end;

    FindVehicleByPoint := 0;
end;


end.
