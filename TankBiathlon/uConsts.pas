unit uConsts;

interface

uses
  Vector;

Var
    Poligon2DSceneName: PAnsiChar;
    VStatusSceneName : PAnsiChar;

    GWheelDelta : integer = 0; // �������� ����

    FamilyIndex2 : integer;   //  ������ SurfElement ������ ������� ������� (����� ��������� �������)

    DirectCameraToTanksStart : integer = 0;
    PosRate, TargRate, ViewLen : single;       //  ��������� ����������� ������ � �����
    ViewDir : TVector;

    GeneralViewT, GeneralViewP : TVector;      //  ����� ������ � ������� ������ �����

    DistTanks : array [1..2] of integer;       //  id ���� ������, ��� ������� ����������� ���������.
//    DistF : single = 0.0;
    LineIndex : integer;
    LineSpeed : single;
    LinePos, LineDir : TVector;
    LineUpdate : integer;

    TableTank : integer;   //  ������ �����, � �������� ������������ ��������

    CapturedTankId : integer;
    PointTankId : integer;
    CapturedPoint : integer;

    RoutesEdit : integer;
    SimEdit    : integer;

    Height2d : single = 1.5;

    UserSpeedFactors : array [1..4] of single = (1,1,1,1);

const
  sGPSServerSect: string = 'GPSServer';

  sTestOpt_key: string = 'test_mode';
  sGPSServerIP_key: string = 'gps_server_addr';
  sGPSServerPort_key: string = 'gps_server_port';

  iTestOpt_def: integer = 0;
  sGPSServerIP_def: string = '94.228.243.168';
  sGPSServerPort_def: string = '6543';

  sUISect: string = 'UI_Settings';

  sShowFlags_key: string = 'show_flags';
  iShowFlags_def: integer = 1;

implementation

end.
