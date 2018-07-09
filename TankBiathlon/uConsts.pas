unit uConsts;

interface

uses
  Vector;

Var
    Poligon2DSceneName: PAnsiChar;
    VStatusSceneName : PAnsiChar;

    GWheelDelta : integer = 0; // колесико мыши

    FamilyIndex2 : integer;   //  индекс SurfElement второй фамилии экипажа (когда клонируем фамилии)

    DirectCameraToTanksStart : integer = 0;
    PosRate, TargRate, ViewLen : single;       //  параметры приближения камеры к танку
    ViewDir : TVector;

    GeneralViewT, GeneralViewP : TVector;      //  точка таргет и позиции общего плана

    DistTanks : array [1..2] of integer;       //  id двух танков, для которых вычисляется дистанция.
//    DistF : single = 0.0;
    LineIndex : integer;
    LineSpeed : single;
    LinePos, LineDir : TVector;
    LineUpdate : integer;

    TableTank : integer;   //  индекс танка, с которого показывается табличка

    CapturedTankId : integer;
    PointTankId : integer;
    CapturedPoint : integer;

    RoutesEdit : integer;
    SimEdit    : integer;

    Height2d : single = 1.5;

    UserSpeedFactors : array [1..4] of single = (1,1,1,1);

implementation

end.
