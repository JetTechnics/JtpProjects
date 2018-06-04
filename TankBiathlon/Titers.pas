unit Titers;

interface

uses
 Windows, System.SysUtils,
 JTPStudio, TypesJTP;

var
  EkipagScene : TName;

  OtsechkaScene : TName;


procedure ShowCrew( VideoTrunk : integer );
procedure CloseCrew();

procedure ShowOtsechka( VideoTrunk : integer );
procedure CloseOtsechka();




implementation


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
    StrCopy( EkipagScene.text, PlaySceneData.SceneName.text );

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
    StrCopy( OtsechkaScene.text, PlaySceneData.SceneName.text );

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
