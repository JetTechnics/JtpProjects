unit VideoSetsHeader;

interface

uses Vcl.Forms, Windows,
     JTPStudio;

type
  //  ������������ ��������� ��������.
  TVideoSets = record
    Version : integer;
    Flags : integer;
    Trunk1 : integer;
    Trunk2 : integer;
    procedure Clear();

  end;
  PVideoSets = ^TVideoSets;

  THwndArray = array [0..LAST_VIDEO_TRUNK] of HWND;
  PHwndArray = ^THwndArray;

  TTrunkFlagsArray = array [0..LAST_VIDEO_TRUNK] of integer;
  PTrunkFlagsArray = ^TTrunkFlagsArray;

  //  Callback �������, ����� ������� ����� ����� ��������.
  TVideoCloseSetsFunc = function ( Flags: integer;  VideoSets: PVideoSets ) : integer;  stdcall;

  //  ������� ������ ����� ����� ��������.
  TVideoStartSetsFunc = function ( Flags: integer;  MainApp: TApplication;  OutWindows: PHwndArray;  pTrunkFlags: PTrunkFlagsArray;  pCloseFunc: TVideoCloseSetsFunc;  pReserve: pointer ) : integer; stdcall;

implementation

procedure TVideoSets.Clear;
begin
  Version := 1;
  Flags := 0;
  Trunk1 := -1;    Trunk2 := -2;
end;

end.
