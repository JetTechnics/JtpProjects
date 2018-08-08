unit Titers;

interface

uses
 Winapi.Windows,
 System.SysUtils, System.Classes, System.AnsiStrings, System.Math,
 JTPStudio, TypesJTP, Vector, Vehicle, uCaptionSettingsKeys, uParamStorage;

var
  GlobalScene1: TName;
  GlobalScene2: TName;
  GlobalScene3: TName;
  GlobalScene4: TName;

procedure ShowGlobalScene(VideoTrunk: integer; const SceneData: TStrings);
procedure UpdateGlobalScene(const SceneData: TStrings);
procedure CloseGlobalScene(const Idx: integer);

var
  CountriesScene: TName;

procedure ShowCountries(VideoTrunk: integer);
procedure CloseCountries;

var
  EkipagScene : TName;
  OtsechkaScene : TName;

procedure ShowCrew( VideoTrunk : integer );
procedure CloseCrew();

procedure ShowOtsechka( VideoTrunk : integer );
procedure CloseOtsechka();

implementation

//////////////// GLOBAL ////////////////////

procedure ShowGlobalScene(VideoTrunk: integer; const SceneData: TStrings);
var
  Res : UInt64;
  Scn : PName;
  PlaySceneData : TPlaySceneData;
  SurfElemData : TSurfElemData;
  s: string;
  objName: AnsiString;
  sceneIdx: integer;
  sData: WideString;
  aColor: TJTPColor;
  i, k: integer;
begin
  if (SceneData.Count < 2) or (SceneData.Names[0] <> '*****')
    then Exit;
  objName := AnsiString(SceneData.ValueFromIndex[0]);
  if objName = '' then Exit;

  PlaySceneData.Create;
  SurfElemData.Create;

  OpenRecords(0, nil);
  try
    sceneIdx := integer(SceneData.Objects[0]);
    case sceneIdx of
      1: Scn := @GlobalScene1;
      2: Scn := @GlobalScene2;
      3: Scn := @GlobalScene3;
      4: Scn := @GlobalScene4;
      else Exit;
    end;
    if Scn^.text[0] <> #0 then
      begin
        CloseScene(PAnsiChar(Scn), FLT_UNDEF, nil);
        Scn^.text[0] := #0;
      end;
    Res := PlayScene(PAnsiChar(objName), 0.0, 0, VideoTrunk, @PlaySceneData);
    if Res = JTP_OK
      then System.SysUtils.StrCopy(Scn^.text, PlaySceneData.SceneName.text)
      else Exit;

    for i:=1 to SceneData.Count-1 do
      begin
        s := SceneData.Names[i];
        k := System.Pos('_', s, 1);
        if k < 1 then k := System.Pos(' ', s, 1);
        objName := AnsiString(System.Copy(s, k+1, Length(s)));
        if k <= 1 then k := 1
                  else k := StrToIntDef(System.Copy(s, 1, k-1), 1);
        if k <= 0 then k := 1;
        sData := SceneData.ValueFromIndex[i];
        aColor.VSet(0,0,0,0);
        if sData = '$$$$$y' then aColor.VSet(1,1,0,1)
                            else
        if sData = '$$$$$b' then aColor.VSet(0,0,1,1)
                            else
        if sData = '$$$$$r' then aColor.VSet(1,0,0,1)
                            else
        if sData = '$$$$$g' then aColor.VSet(0,1,0,1);
        if (aColor.r = 0) and (aColor.g = 0) and (aColor.b = 0) and
           (aColor.a = 0) then
    Res := UpdateSurfaceElement(PAnsiChar(Scn), PAnsiChar(objName), k, 1, nil, PWideChar(sData), nil,
                                INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, FLT_UNDEF, 0, @SurfElemData)
                          else
    Res := UpdateSurfaceElement(PAnsiChar(Scn), PAnsiChar(objName), k, 1, nil, #9646#9646#9646#9646#9646, @aColor,
                                INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, FLT_UNDEF, 0, @SurfElemData);
        if Res <> JTP_OK then begin
          //AddErrorStrings( SurfElemData.pErrorsStr );
        end;
      end;
  finally
    CloseRecords(0, nil);
  end;
end;

procedure UpdateGlobalScene(const SceneData: TStrings);
var
  Res : UInt64;
  Scn : PName;
  sceneIdx: integer;
  SurfElemData : TSurfElemData;
  s: string;
  objName: AnsiString;
  sData: WideString;
  aColor: TJTPColor;
  i, k: integer;
begin
  if (SceneData.Count < 2) or (SceneData.Names[0] <> '*****')
    then Exit;
  sceneIdx := integer(SceneData.Objects[0]);
  case sceneIdx of
    1: Scn := @GlobalScene1;
    2: Scn := @GlobalScene2;
    3: Scn := @GlobalScene3;
    4: Scn := @GlobalScene4;
    else Exit;
  end;
  if Scn^.text[0] = #0 then Exit;
  objName := AnsiString(SceneData.ValueFromIndex[0]);
  if objName = '' then Exit;

    SurfElemData.Create;

    for i:=1 to SceneData.Count-1 do
      begin
        s := SceneData.Names[i];
        k := System.Pos('_', s, 1);
        if k < 1 then k := System.Pos(' ', s, 1);
        objName := AnsiString(System.Copy(s, k+1, Length(s)));
        if k <= 1 then k := 1
                  else k := StrToIntDef(System.Copy(s, 1, k-1), 1);
        if k <= 0 then k := 1;
        sData := SceneData.ValueFromIndex[i];
        aColor.VSet(0,0,0,0);
        if sData = '$$$$$y' then aColor.VSet(1,1,0,1)
                            else
        if sData = '$$$$$b' then aColor.VSet(0,0,1,1)
                            else
        if sData = '$$$$$r' then aColor.VSet(1,0,0,1)
                            else
        if sData = '$$$$$g' then aColor.VSet(0,1,0,1);
        if (aColor.r = 0) and (aColor.g = 0) and (aColor.b = 0) and
           (aColor.a = 0) then
    Res := UpdateSurfaceElement(PAnsiChar(Scn), PAnsiChar(objName), k, 1, nil, PWideChar(sData), nil,
                                INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, FLT_UNDEF, 0, @SurfElemData)
                          else
    Res := UpdateSurfaceElement(PAnsiChar(Scn), PAnsiChar(objName), k, 1, nil, #9646#9646#9646#9646#9646, @aColor,
                                INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, FLT_UNDEF, 0, @SurfElemData);
        if Res <> JTP_OK then begin
          //AddErrorStrings( SurfElemData.pErrorsStr );
        end;
      end;
end;

procedure CloseGlobalScene(const Idx: integer);
var
  Scn: PName;
begin
  case Idx of
    1: Scn := @GlobalScene1;
    2: Scn := @GlobalScene2;
    3: Scn := @GlobalScene3;
    4: Scn := @GlobalScene4;
    else Exit;
  end;
  if Scn^.text[0] <> #0 then
    begin
      OpenRecords(0, nil);

      CloseScene(PAnsiChar(Scn), FLT_UNDEF, nil);
      Scn^.text[0] := #0;

      CloseRecords(0, nil);
  end;
end;

procedure ShowCountries(VideoTrunk: integer);
var
  Res : UInt64;
  Scn : PName;
  PlaySceneData : TPlaySceneData;
  SurfElemData : TSurfElemData;
  i: integer;
  sn: integer;
  sData: WideString;
begin
  PlaySceneData.Create;
  SurfElemData.Create;

  OpenRecords(0, nil);
  try
    if CountriesScene.text[0] <> #0 then
      begin
        CloseScene(@CountriesScene, FLT_UNDEF, nil);
        CountriesScene.text[0] := #0;
      end;
    Res := PlayScene('Countries', 0.0, 0, VideoTrunk, @PlaySceneData);
    if Res = JTP_OK
      then System.SysUtils.StrCopy(CountriesScene.text, PlaySceneData.SceneName.text)
      else Exit;
    for i:=1 to iTanksNum do
      begin
        sn := 2*(i-1)+1;
        Res := UpdateSurfaceElement(@CountriesScene, 'Countries', sn, 1,
                                PAnsiChar(Vehicles[TankIdRelative[i]].FlagPic), nil, nil,
                                INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, FLT_UNDEF, 0, @SurfElemData);
        if Res <> JTP_OK then begin
          //AddErrorStrings( SurfElemData.pErrorsStr );
        end;
        sData := CaptionParamStorage.GetParamDataIdx(cpiTeam_name, i);
        Res := UpdateSurfaceElement(@CountriesScene, 'Countries', sn+1, 1, nil, PWideChar(sData), nil,
                                INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, FLT_UNDEF, 0, @SurfElemData);
        if Res <> JTP_OK then begin
          //AddErrorStrings( SurfElemData.pErrorsStr );
        end;
      end;
  finally
    CloseRecords(0, nil);
  end;
end;

procedure CloseCountries;
begin
  if CountriesScene.text[0] <> #0 then
    begin
      OpenRecords(0, nil);

      CloseScene(@CountriesScene, FLT_UNDEF, nil);
      CountriesScene.text[0] := #0;

      CloseRecords(0, nil);
    end;
end;

////////////////////////////////////////////

////////////////   ЭКИПАЖ   ////////////////

procedure ShowCrew( VideoTrunk : integer );
var
  Res : UInt64;
  PlaySceneData : TPlaySceneData;
  SurfElemData : TSurfElemData;
  FilePath : TPath;
begin
  PlaySceneData.Create();
  SurfElemData.Create;

  OpenRecords( 0, nil );

  Res := PlayScene( 'Ekipag', 0.0, 0, VideoTrunk, @PlaySceneData );
  if( Res = JTP_OK ) then begin
    System.SysUtils.StrCopy( EkipagScene.text, PlaySceneData.SceneName.text );

    // Страна
    Res := UpdateSurfaceElement( @EkipagScene, 'Status', 1, 1, nil, 'БЕЛОРУССИЯ', nil,
											            INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, FLT_UNDEF, 0, @SurfElemData );
    if( Res <> JTP_OK ) then begin
      //AddErrorStrings( SurfElemData.pErrorsStr );
    end;

    // флаг, обновим текстуру на объекте 'Flag'.
    FilePath.text := 'Resources/Flags/BLR.tga';
    Res := SetObjectTexture( @EkipagScene, 'Flag', @FilePath, 1, 0.0, 0, nil );

    // танчик, обновим картинку на текстуре объекта 'Status'.
    FilePath.text := 'Resources/Color_Tank/Blue.tga';
    Res := UpdateSurfaceElement( @EkipagScene, 'Status', 6, 1, @FilePath, nil, nil,
											            INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, FLT_UNDEF, 0, @SurfElemData );
  end;

  CloseRecords( 0, nil );
end;


procedure CloseCrew();
begin
	if( EkipagScene.text[0] <> #0 ) then begin

    OpenRecords( 0, nil );

    CloseScene( @EkipagScene, FLT_UNDEF, nil );
    EkipagScene.text[0] := #0;

    CloseRecords( 0, nil );
  end;
end;
//////////////////////////////////////////////




////////////////   ОТСЕЧКА   ////////////////

procedure ShowOtsechka( VideoTrunk : integer );
var
  Res : UInt64;
  PlaySceneData : TPlaySceneData;
  SurfElemData : TSurfElemData;
  FilePath : TPath;
begin
	PlaySceneData.Create();
  SurfElemData.Create;

  OpenRecords( 0, nil );

  Res := PlayScene( 'Otsechka', 0.0, 0, VideoTrunk, @PlaySceneData );
  if( Res = JTP_OK ) then begin
    System.SysUtils.StrCopy( OtsechkaScene.text, PlaySceneData.SceneName.text );

    // Страна
    Res := UpdateSurfaceElement( @OtsechkaScene, 'Status', 1, 1, nil, 'АРМЕНИЯ', nil,
											            INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, FLT_UNDEF, 0, @SurfElemData );

		// флаг, обновим текстуру на объекте 'Flag'.
    FilePath.text := 'Resources/Flags/ARM.tga';
    Res := SetObjectTexture( @OtsechkaScene, 'Flag', @FilePath, 1, 0.0, 0, nil );

    // танчик, обновим картинку на текстуре объекта 'Status'.
    FilePath.text := 'Resources/Color_Tank/Green.tga';
    Res := UpdateSurfaceElement( @OtsechkaScene, 'Status', 3, 1, @FilePath, nil, nil,
											            INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, FLT_UNDEF, 0, @SurfElemData );

  end;

  CloseRecords( 0, nil );
end;



procedure CloseOtsechka();
begin
	if( OtsechkaScene.text[0] <> #0 ) then begin

    OpenRecords( 0, nil );

    CloseScene( @OtsechkaScene, FLT_UNDEF, nil );
    OtsechkaScene.text[0] := #0;

    CloseRecords( 0, nil );
  end;
end;
//////////////////////////////////////////////

end.
