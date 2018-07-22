unit Titers;

interface

uses
 Winapi.Windows,
 System.SysUtils, System.Classes, System.AnsiStrings, System.Math,
 JTPStudio, TypesJTP;

var
  GlobalScene: TName;
  CaptionIndex: integer;

procedure ShowGlobalScene(VideoTrunk: integer; const SceneData: TStrings);
procedure UpdateGlobalScene(const SceneData: TStrings);
procedure CloseGlobalScene;
function GetCaptionIndex: integer;

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
  PlaySceneData : TPlaySceneData;
  SurfElemData : TSurfElemData;
  s: string;
  objName: AnsiString;
  sceneIdx: integer;
  sData: WideString;
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
    if CaptionIndex <> sceneIdx then
      begin
        CaptionIndex := sceneIdx;
        if GlobalScene.text[0] <> #0 then
          begin
            CloseScene(@GlobalScene, FLT_UNDEF, nil);
            GlobalScene.text[0] := #0;
          end;
        Res := PlayScene(PAnsiChar(objName), 0.0, 0, VideoTrunk, @PlaySceneData);
        if Res = JTP_OK
          then System.SysUtils.StrCopy(GlobalScene.text, PlaySceneData.SceneName.text)
          else Exit;
      end
                                else
      begin
        if GlobalScene.text[0] = #0 then
          begin
            Res := PlayScene(PAnsiChar(objName), 0.0, 0, VideoTrunk, @PlaySceneData);
            if Res = JTP_OK
              then System.SysUtils.StrCopy(GlobalScene.text, PlaySceneData.SceneName.text)
              else Exit;
          end;
      end;

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
        Res := UpdateSurfaceElement(@GlobalScene, PAnsiChar(objName), k, 1, nil, PWideChar(sData), nil,
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
  SurfElemData : TSurfElemData;
  s: string;
  objName: AnsiString;
  sData: WideString;
  i, k: integer;
begin
  if (GlobalScene.text[0] = #0) or
     (SceneData.Count < 2) or (SceneData.Names[0] <> '*****') or
     (integer(SceneData.Objects[0]) <> CaptionIndex)
    then Exit;
  objName := AnsiString(SceneData.ValueFromIndex[0]);
  if objName = '' then Exit;

  OpenRecords(0, nil);
  try
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
        Res := UpdateSurfaceElement(@GlobalScene, PAnsiChar(objName), k, 1, nil, PWideChar(sData), nil,
                                    INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, FLT_UNDEF, 0, @SurfElemData);
        if Res <> JTP_OK then begin
          //AddErrorStrings( SurfElemData.pErrorsStr );
        end;
      end;
  finally
    CloseRecords(0, nil);
  end;
end;

procedure CloseGlobalScene;
begin
  if GlobalScene.text[0] <> #0 then
    begin
      OpenRecords(0, nil);

      CloseScene(@GlobalScene, FLT_UNDEF, nil);
      GlobalScene.text[0] := #0;
      CaptionIndex := 0;

      CloseRecords(0, nil);
  end;
end;

function GetCaptionIndex: integer;
begin
  if GlobalScene.text[0] = #0
    then Result := -1
    else Result := CaptionIndex;
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
