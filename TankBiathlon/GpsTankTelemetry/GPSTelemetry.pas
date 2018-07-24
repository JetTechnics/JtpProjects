unit GPSTelemetry;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Grids, Vcl.Buttons,
  Vcl.StdCtrls, IniFiles, Data.DB, Data.Win.ADODB, Vcl.Mask, Vcl.DBCtrls,
  Vcl.DBGrids, Math, System.StrUtils, JTPStudio, TypesJTP, Vector, Vehicle,
  Vcl.Samples.Spin, Vcl.DBCGrids, System.DateUtils, Vcl.ComCtrls, Poligon2D,
  uConsts, uGPSData, uCaptionSettingsKeys, uParamStorage;

const
  cShootingRubegQty = 10;

  cEkipagCount = 3;
  cOtsechkiCount = 3;
  cShootsCount = 3;

type TPlayers = record             //  участники
     PlayerName, AmplyaName : String;
end;

type TIntermediate = record        //  отсечки
     NumOtsec, TimeOtsec, DisplayPos, TimeMSec : String;
end;

type TShooting = record            //  стрельба
     MainShot, AddShot, MainHit, MainMiss, MainAll, AddHit, AddMiss, AddAll, ShotHit, ShotMiss, ShotAll,
     TimeShooting, TargetType, TargetName, TargetQuantity, TargetPicture : String;
end;

type TColorGPS = record
     iNum : integer;
     iGPS : integer;
     sColor : string;
     vColor : TColor;
     TeamName : string;
end;


Type  TVehicleData = record     //  Подвижное средство
  TeamName : string;                                // название команды
  Players : array [0..3] of TPlayers;               // участники команды
  Intermediate : array [0..50] of TIntermediate;    // отсечки
  Shooting : array [0..25] of TShooting;            // стрельба
  TotalTime : string;                               // общее время
  TotalTimeMS : string;                             // общее время  MSec
  DisplayPos : string;                              // позиция - Rank
  IRM : string;                                     // DSQ, DNF, DNS
  TankSmallPicture : string;                        // цвет
  CountryFlag : string;                             // флаг
  CountryName : string;                             // страна
end;

type
  T_GPSTelemetry = class(TForm)
    TimerTelemetry: TTimer;
    Panel1: TPanel;
    OpenDialog1: TOpenDialog;
    dsTanksData: TDataSource;
    qTanksData: TADOQuery;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    qOtsechki: TADOQuery;
    dsOtsechki: TDataSource;
    qInfo: TADOQuery;
    dsInfo: TDataSource;
    DBEdit2: TDBEdit;
    qOtsechkitblStateID: TAutoIncField;
    qOtsechkisGroupID: TWideStringField;
    qOtsechkiStateName: TWideStringField;
    qOtsechkiStateID: TWideStringField;
    qOtsechkiActiveState: TWideStringField;
    qOtsechkitblZaezdID: TAutoIncField;
    qOtsechkizGroupID: TWideStringField;
    qOtsechkiZaezdName: TWideStringField;
    qOtsechkiZaezdID: TWideStringField;
    qOtsechkiActiveZaezd: TWideStringField;
    qOtsechkitblTeamsID: TAutoIncField;
    qOtsechkitGroupID: TWideStringField;
    qOtsechkiTeamName: TWideStringField;
    qOtsechkiEkipag: TWideStringField;
    qOtsechkitTeamColorID: TWideStringField;
    qOtsechkitTeamID: TWideStringField;
    qOtsechkitblOtsechID: TAutoIncField;
    qOtsechkioGroupID: TWideStringField;
    qOtsechkioTeamID: TWideStringField;
    qOtsechkiNumOtsec: TWideStringField;
    qOtsechkiTimeOtsec: TWideStringField;
    qOtsechkiDisplayPos: TWideStringField;
    qOtsechkitmsec: TWideStringField;
    qOtsechkioTeamColorID: TWideStringField;
    qOtsechkiZaezd: TWideStringField;
    qOtsechkicTimeMS: TStringField;
    qInfotblTeamsID: TAutoIncField;
    qInfotGroupID: TWideStringField;
    qInfoTeamName: TWideStringField;
    qInfotEkipag: TWideStringField;
    qInfoTeamColorID: TWideStringField;
    qInfotTeamID: TWideStringField;
    qInfoiGroupID: TWideStringField;
    qInfoiTeamID: TWideStringField;
    qInfoiEkipag: TWideStringField;
    qInfoDisplayPos: TWideStringField;
    qInfofirenum: TWideStringField;
    qInfoIRM: TWideStringField;
    qInfoZaezd: TWideStringField;
    qInfoRubeg: TWideStringField;
    qInfoTime1: TWideStringField;
    qInfoS1: TWideStringField;
    qInfoMish1: TWideStringField;
    qInfop1: TWideStringField;
    qInfoa1: TWideStringField;
    qInfoMish2: TWideStringField;
    qInfoTime2: TWideStringField;
    qInfoS2: TWideStringField;
    qInfop2: TWideStringField;
    qInfoa2: TWideStringField;
    qInfoMish3: TWideStringField;
    qInfoTime3: TWideStringField;
    qInfoS3: TWideStringField;
    qInfop3: TWideStringField;
    qInfoa3: TWideStringField;
    qInfoTotalTime: TWideStringField;
    qInfotmsec: TWideStringField;
    qInfocMish1: TStringField;
    qInfocMish2: TStringField;
    qInfocMish3: TStringField;
    PageControl1: TPageControl;
    tsExtendedData: TTabSheet;
    tsTankGraphics: TTabSheet;
    qCountryLoc: TADOQuery;
    dsCountryLoc: TDataSource;
    Panel4: TPanel;
    btnRefreshLocal: TSpeedButton;
    qColorLoc: TADOQuery;
    dsColorLoc: TDataSource;
    Panel6: TPanel;
    Panel7: TPanel;
    DBGrid5: TDBGrid;
    Panel8: TPanel;
    Panel9: TPanel;
    DBGrid4: TDBGrid;
    DBNavigator1: TDBNavigator;
    DBNavigator2: TDBNavigator;
    ColorDialog1: TColorDialog;
    Splitter2: TSplitter;
    OpenDialogTanks: TOpenDialog;
    qColorLoctblColorID: TAutoIncField;
    qColorLocGroupID: TWideStringField;
    qColorLocColorImg: TWideStringField;
    qColorLocColorID: TWideStringField;
    qColorLocTexturePath: TWideStringField;
    qColorLocPicturePath: TWideStringField;
    qColorLocColorValue: TIntegerField;
    Panel11: TPanel;
    Panel12: TPanel;
    DBNavigator3: TDBNavigator;
    DBGrid6: TDBGrid;
    qMeshenyLoc: TADOQuery;
    dsMeshenyLoc: TDataSource;
    Splitter3: TSplitter;
    btnImportMesheny: TSpeedButton;
    btnImportColor: TSpeedButton;
    btnImportCountry: TSpeedButton;
    btnReloadGraphics: TSpeedButton;
    qMeshenyLoctblMeshenyID: TAutoIncField;
    qMeshenyLocGroupID: TWideStringField;
    qMeshenyLocMeshenyName: TWideStringField;
    qMeshenyLocMeshenyObject: TWideStringField;
    qMeshenyLocMeshenyCount: TWideStringField;
    qMeshenyLocMeshenyTryMain: TWideStringField;
    qMeshenyLocMeshenyCountMain: TWideStringField;
    qMeshenyLocMeshenyTryOther: TWideStringField;
    qMeshenyLocMeshenyCountOther: TWideStringField;
    qMeshenyLocMeshenyID: TWideStringField;
    qMeshenyLocPicturePath: TWideStringField;
    btnLoadGraphics: TSpeedButton;
    tsTitle3DGraphics: TTabSheet;
    Panel10: TPanel;
    Panel13: TPanel;
    DBNavigator4: TDBNavigator;
    DBGrid7: TDBGrid;
    tsBaseConnect: TTabSheet;
    Panel16: TPanel;
    Label2: TLabel;
    eBaseFile: TEdit;
    btnBaseFile: TButton;
    btnConnect: TSpeedButton;
    btnUnConnect: TSpeedButton;
    Label5: TLabel;
    eBaseFileLocal: TEdit;
    btnBaseFileLocal: TButton;
    btnConnectLocal: TSpeedButton;
    btnUnConnectLocal: TSpeedButton;
    Panel17: TPanel;
    btnRefresh: TSpeedButton;
    Panel15: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    btnMeshenTexture_Clear: TSpeedButton;
    eSpeedKMH: TEdit;
    eMoveDistanceM: TEdit;
    speQuantityOtsechekOnTitle: TSpinEdit;
    speQuantityPlayersOnTitle: TSpinEdit;
    speQuantityMisheniOnTitle: TSpinEdit;
    eMeshenTexture_Clear: TEdit;
    qColorLocRankColor: TIntegerField;
    btnEditGPS: TSpeedButton;
    pnlEditGPS: TPanel;
    cbEditGPS: TComboBox;
    btnSetNewGPS: TSpeedButton;
    tsShow: TTabSheet;
    rbEkipag: TRadioButton;
    rbOtsechki: TRadioButton;
    rbShooting: TRadioButton;
    Panel23: TPanel;
    ShapeTeam4: TShape;
    ShapeTeam3: TShape;
    ShapeTeam2: TShape;
    shapeTeam1: TShape;
    btnEkipag1: TSpeedButton;
    btnEkipag2: TSpeedButton;
    btnEkipag3: TSpeedButton;
    btnEkipag4: TSpeedButton;
    btnShooting1: TSpeedButton;
    btnShooting2: TSpeedButton;
    btnShooting3: TSpeedButton;
    btnShooting4: TSpeedButton;
    btnOtsechka1: TSpeedButton;
    btnOtsechka2: TSpeedButton;
    btnOtsechka3: TSpeedButton;
    btnOtsechka4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    btnCamera11: TSpeedButton;
    btnCamera12: TSpeedButton;
    btnCamera13: TSpeedButton;
    btnCamera14: TSpeedButton;
    btnCamera21: TSpeedButton;
    btnCamera22: TSpeedButton;
    btnCamera23: TSpeedButton;
    btnCamera24: TSpeedButton;
    btnUnSetCameras: TSpeedButton;
    btnMainView: TSpeedButton;
    Panel18: TPanel;
    btnOpenScenes: TSpeedButton;
    btnCloseScenes: TSpeedButton;
    Label11: TLabel;
    Panel25: TPanel;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Splitter4: TSplitter;
    DBGrid3: TDBGrid;
    Splitter5: TSplitter;
    Panel5: TPanel;
    btnGangeColorTanks: TSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    cbTank2: TComboBox;
    cbTank1: TComboBox;
    btnDist1: TSpeedButton;
    btnDist2: TSpeedButton;
    btnDist3: TSpeedButton;
    btnDist4: TSpeedButton;
    pnlColors: TPanel;
    sgColorTank: TStringGrid;
    ePlayer11: TEdit;
    ePlayer12: TEdit;
    ePlayer13: TEdit;
    ePlayer21: TEdit;
    ePlayer22: TEdit;
    ePlayer23: TEdit;
    ePlayer31: TEdit;
    ePlayer32: TEdit;
    ePlayer33: TEdit;
    ePlayer41: TEdit;
    ePlayer42: TEdit;
    ePlayer43: TEdit;
    eTeam1: TEdit;
    eTeam2: TEdit;
    eTeam3: TEdit;
    eTeam4: TEdit;
    eShooting11: TEdit;
    eShooting12: TEdit;
    eShooting13: TEdit;
    eShooting21: TEdit;
    eShooting22: TEdit;
    eShooting23: TEdit;
    eShooting31: TEdit;
    eShooting32: TEdit;
    eShooting33: TEdit;
    eShooting41: TEdit;
    eShooting42: TEdit;
    eShooting43: TEdit;
    eOtsechka11: TEdit;
    eOtsechka12: TEdit;
    eOtsechka13: TEdit;
    eOtsechka21: TEdit;
    eOtsechka22: TEdit;
    eOtsechka23: TEdit;
    eOtsechka31: TEdit;
    eOtsechka32: TEdit;
    eOtsechka33: TEdit;
    eOtsechka41: TEdit;
    eOtsechka42: TEdit;
    eOtsechka43: TEdit;
    chbShowSpeed: TCheckBox;
    chbShowDistance: TCheckBox;
    sgSpeed: TStringGrid;
    eSpeed1: TEdit;
    eDist1: TEdit;
    eSpeed2: TEdit;
    eDist2: TEdit;
    eSpeed3: TEdit;
    eDist3: TEdit;
    eSpeed4: TEdit;
    eDist4: TEdit;
    btnRefreshTankColor: TSpeedButton;
    eGPS2: TEdit;
    eGPS1: TEdit;
    eGPS3: TEdit;
    eGPS4: TEdit;
    shapeTeam11: TShape;
    shapeTeam22: TShape;
    shapeTeam33: TShape;
    shapeTeam44: TShape;
    Panel2: TPanel;
    rbShowEkipag2Tanks: TRadioButton;
    rbShowOtsechki2Tanks: TRadioButton;
    rbShowShooting2Tanks: TRadioButton;
    btnShowUnShowTitle2Tanks: TSpeedButton;
    chbChangePositionTablesOnTitle2Tanks: TCheckBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    eAddR: TEdit;
    R: TLabel;
    Label17: TLabel;
    eAddG: TEdit;
    Label18: TLabel;
    eAddB: TEdit;
    Label19: TLabel;
    eAddYR: TEdit;
    eAddYG: TEdit;
    qInfoGPSID: TWideStringField;
    procedure TimerTelemetryTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure btnBaseFileClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnUnConnectClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pCloseBase(Sender: TObject);
    procedure pCloseBaseLocal(Sender: TObject);
    procedure pRefresh(Sender: TObject);
    procedure pRefreshLocal(Sender: TObject);
    procedure pRefreshTankColor(lOpenClose_Active: boolean = false);
    procedure btnRefreshClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure pStrGrid(Sender: TObject);
    function fGetColorTank(TankName: string) : TColor;
    procedure sgColorTankDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure cbTank1DropDown(Sender: TObject);
    procedure cbTank1Change(Sender: TObject);
    procedure btnGangeColorTanksClick(Sender: TObject);
    procedure pSetTankIndex(TankIndex:integer);
    procedure pClearTankIndex;
    {
    procedure pShowTankPlayers(lOpenClose_Active: boolean = false);
    procedure pShowTankSpeed(Sender: TObject);
    }
    function fChangeTextSQL(lQ:TADOQuery):string;
    {
    procedure pShowIntermediates(lOpenClose_Active: boolean = false);
    procedure pShowShooting(lOpenClose_Active: boolean = false);
    }
    procedure FormCreate(Sender: TObject);
    function fConvertTime(vTimeTank : string) : string;
    function VrToStrCROP(Ho, Mi, Se, MSe : Integer; lShowMsec:boolean = false) : string;
    {
    procedure pShowTanksData(lOpenClose_Active: boolean = false);
    procedure pTitleClear(lOpenClose_Active: boolean = false);
    }
    procedure qOtsechkiCalcFields(DataSet: TDataSet);
    procedure rbEkipagClick(Sender: TObject);
    procedure rbOtsechkiClick(Sender: TObject);
    procedure rbShootingClick(Sender: TObject);
    procedure qInfoCalcFields(DataSet: TDataSet);
    function  fTargetName(lTargetType:string; var lTargetQty, lPicture: string):string;
    procedure btnRefreshTankColorClick(Sender: TObject);
    procedure btnBaseFileLocalClick(Sender: TObject);
    procedure btnConnectLocalClick(Sender: TObject);
    procedure btnUnConnectLocalClick(Sender: TObject);
    procedure btnRefreshLocalClick(Sender: TObject);
    procedure DBGrid4DblClick(Sender: TObject);
    procedure DBGrid4DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid5DblClick(Sender: TObject);
    function fFilePath(lFile:string):string;
    procedure DBGrid6DblClick(Sender: TObject);
    procedure btnImportMeshenyClick(Sender: TObject);
    procedure btnImportColorClick(Sender: TObject);
    procedure btnImportCountryClick(Sender: TObject);
    {
    procedure pArrayTexMsh_Refresh(lReload: boolean = false);
    procedure pArrayTexMsh_Create;
    }
    procedure btnReloadGraphicsClick(Sender: TObject);
    procedure DBNavigator3Click(Sender: TObject; Button: TNavigateBtn);
    procedure DBNavigator2Click(Sender: TObject; Button: TNavigateBtn);
    procedure DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
    procedure btnLoadGraphicsClick(Sender: TObject);
    function fTankColorGet(lColorID:string; var r, g, b: single; var TexturePath: string; var PicturePath: string ): boolean;
    function fCountryGet(lCountryName:string):string;

    {
    procedure pStartTelemetryScenes(Sender: TObject);
    procedure pCloseScenaTelemetry(Sender: TObject);
    procedure pShowScenaShoots(iTankIndex:integer; lOpenClose_Active: boolean = true);
    procedure pShowScenaEkipag(iTankIndex:integer; lOpenClose_Active: boolean = true);
    procedure pShowScenaOtsechka(iTankIndex:integer; lOpenClose_Active: boolean = true);
    procedure pUnShowAllScenes(Sender: TObject);
    }
    procedure btnShooting1Click(Sender: TObject);
    procedure btnEkipag1Click(Sender: TObject);
    procedure btnOtsechka1Click(Sender: TObject);
    procedure btnMeshenTexture_ClearClick(Sender: TObject);
    procedure pInitialVars(Sender: TObject);
    function fTankForColor(lColor:string; var TeamName:string):integer;
    function fNumColumnBtnForGPS(idGPS:integer):integer;
    function fNumColumnBtnForColor(ColorID:string):integer;
    procedure pRefreshButtons(Sender: TObject);
    procedure pInitialArray_FourTanks;
    procedure pInitial_TEdit_FourTanks(i, iGPS:integer);
    procedure btnEditGPSClick(Sender: TObject);
    procedure btnSetNewGPSClick(Sender: TObject);
    procedure dsTanksDataDataChange(Sender: TObject; Field: TField);
    procedure pButtonClear(Sender: TObject);
    {
    procedure pSetCamera(i, iNumCam: integer);
    }

    procedure pUnSetCamerasDists(Sender: TObject);
    procedure btnOpenScenesClick(Sender: TObject);
    procedure btnCloseScenesClick(Sender: TObject);
    procedure btnDist1Click(Sender: TObject);
    procedure pUnSetDist(Sender: TObject);
    procedure pUpdateSpeedDistValue(Sender: TObject);
    {
    function fShow2Tanks(iTypeTitle: integer = 1): boolean;
    procedure pClose2Tanks(iTypeTitle: integer = 1);
    procedure pUnShowAllScenes_2Tanks(Sender: TObject);
    }
    function fObjName(lObj:string; iNum:integer):string;
    {
    procedure pShowScenaEkipag_2Tanks(iNum:integer; iTankIndex:integer);
    procedure pShowScenaOtsechka_2Tanks(iNum:integer; iTankIndex:integer);
    procedure pShowScenaShoots_2Tanks(iNum:integer; iTankIndex:integer);
    procedure pShowUnShowTitle2Tanks(lShow:boolean = true);
    procedure btnShowUnShowTitle2TanksClick(Sender: TObject);
    procedure chbChangePositionTablesOnTitle2TanksClick(Sender: TObject);
    procedure pUpdateSpeed_2Tanks(lScenaName: PAnsiChar; iNum, iGPS, iStrNumDist, iStrNumSpeed : integer);
    procedure rbShowEkipag2TanksClick(Sender: TObject);
    procedure pCloseTitles2Tanks(Sender: TObject);
    }
    procedure btnUnSetCamerasClick(Sender: TObject);
    function fGetColorForGPS(iGPS:string; var lColorID : string):TColor;
    procedure pTankPanelColoring;
  private
    { Private declarations }
    glIniFileName:string;

    glArrEkipage  : array [1..MaxOneVehicles, 1..cEkipagCount] of TEdit;
    glArrShooting : array [1..MaxOneVehicles, 1..cShootsCount] of TEdit;
    glArrOtsechka : array [1..MaxOneVehicles, 1..cOtsechkiCount] of TEdit;
    glArrGPS : array [1..MaxOneVehicles] of TEdit;
    glArrTeams : array [1..MaxOneVehicles] of TEdit;
    glArrBtnSetCamera : array [1..2,1..MaxOneVehicles] of TSpeedButton;
    glArrShapeTeam, glArrShapeTeam1 : array [1..MaxOneVehicles] of TShape;
    glArrDist : array [1..MaxOneVehicles] of TSpeedButton;

    glArrValueSpeed, glArrValueDist : array [1..MaxOneVehicles] of TEdit;

    glArrTitleESO : array [1..12] of TSpeedButton;

    function GetTankIndexFromGPSId(const GPSId: integer): integer;
  public
    { Public declarations }
  end;

var
  _GPSTelemetry: T_GPSTelemetry;

  glTankIndex : integer = 0;    // выделенный танк

  VehiclesData     : array[0..MAX_VEHICLES-1] of TVehicleData;               //  Данные танков

  glTrackPath : string;                                                      // файл примера трека танков

  glScenaName_Shoot, glScenaName_Ekipag, glScenaName_Otsechka : PAnsiChar;   // сцены телеметрии
  glScenaName_Shoot_2Tanks, glScenaName_Ekipag_2Tanks, glScenaName_Otsechka_2Tanks : PAnsiChar;   // сцены телеметрии

  glMoveDistanceM, glSpeedKMH, glMeshenTexture_Clear : string;
  glQuantityOtsechekOnTitle, glQuantityPlayersOnTitle, glQuantityMisheniOnTitle: integer;

  glArrColorGPS: array [1..MaxOneVehicles] of TColorGPS;

  glGPS_OnShow, glGPS1_OnShow, glGPS2_OnShow: integer;

implementation

uses MainUnit, GPS_dm;

{$R *.dfm}

procedure T_GPSTelemetry.FormCreate(Sender: TObject);
var lIniFile:TIniFile;
    i:integer;
begin
  glIniFileName:=ChangeFileExt(Application.ExeName,'.ini');
  lIniFile:=TIniFile.Create(glIniFileName);
  eBaseFile.Text:=lIniFile.ReadString('BASE','FILE_NAME','');
  lIniFile.WriteString('BASE','FILE_NAME',eBaseFile.Text);
  eBaseFileLocal.Text:=lIniFile.ReadString('BASE_LOCAL','FILE_NAME','');
  lIniFile.WriteString('BASE_LOCAL','FILE_NAME',eBaseFileLocal.Text);
  //** DevOutputIndex:=StrToIntDef(lIniFile.ReadString('DECKLINK','NUMBER','0'),0);
  //** lIniFile.WriteString('DECKLINK','NUMBER',IntToStr(DevOutputIndex));
  //** MainForm.TankNumsEdit.Text:=lIniFile.ReadString('TANKS','QUANTITY','12');
  //** lIniFile.WriteString('TANKS','QUANTITY',MainForm.TankNumsEdit.Text);
  glTrackPath := lIniFile.ReadString('TANKS','TRACK','Resources\Track3.txt');
  lIniFile.WriteString('TANKS','TRACK',glTrackPath);

  eMoveDistanceM.Text:=' ' + lIniFile.ReadString('TANKS','DESTANCE_M','М');
  eSpeedKMH.Text:=' ' + lIniFile.ReadString('TANKS','SPEED_KMH','КМ/Ч');
  eMeshenTexture_Clear.Text:=lIniFile.ReadString('TANKS','TARGET_TEXTURE_CLEAR','');
  speQuantityOtsechekOnTitle.Value:=StrToIntDef(lIniFile.ReadString('TANKS','QuantityOtsechekOnTitle','3'),3);
  speQuantityPlayersOnTitle.Value:=StrToIntDef(lIniFile.ReadString('TANKS','QuantityPlayersOnTitle','3'),3);
  speQuantityMisheniOnTitle.Value:=StrToIntDef(lIniFile.ReadString('TANKS','QuantityMisheniOnTitle','3'),3);

  chbShowSpeed.Checked := lIniFile.ReadBool('TANKS','SHOW_SPEED',chbShowSpeed.Checked);
  chbShowDistance.Checked := lIniFile.ReadBool('TANKS','SHOW_DIST',chbShowDistance.Checked);

  eAddR.Text := lIniFile.ReadString('TANKS','TANK_COLOR_R_ADD','0');
  eAddG.Text := lIniFile.ReadString('TANKS','TANK_COLOR_G_ADD','0');
  eAddB.Text := lIniFile.ReadString('TANKS','TANK_COLOR_B_ADD','0');
  eAddYR.Text := lIniFile.ReadString('TANKS','TANK_COLOR_YR_ADD','0');
  eAddYG.Text := lIniFile.ReadString('TANKS','TANK_COLOR_YG_ADD','0');

  lIniFile.Free;

  for i := 1 to MAX_VEHICLES do
    cbEditGPS.Items.Add(IntToStr(i));

  PageControl1.ActivePage := tsBaseConnect ;

  glArrEkipage[1,1] := ePlayer11;
  glArrEkipage[1,2] := ePlayer12;
  glArrEkipage[1,3] := ePlayer13;

  glArrEkipage[2,1] := ePlayer21;
  glArrEkipage[2,2] := ePlayer22;
  glArrEkipage[2,3] := ePlayer23;

  glArrEkipage[3,1] := ePlayer31;
  glArrEkipage[3,2] := ePlayer32;
  glArrEkipage[3,3] := ePlayer33;

  glArrEkipage[4,1] := ePlayer41;
  glArrEkipage[4,2] := ePlayer42;
  glArrEkipage[4,3] := ePlayer43;

  glArrShooting[1,1] := eShooting11;
  glArrShooting[1,2] := eShooting12;
  glArrShooting[1,3] := eShooting13;

  glArrShooting[2,1] := eShooting21;
  glArrShooting[2,2] := eShooting22;
  glArrShooting[2,3] := eShooting23;

  glArrShooting[3,1] := eShooting31;
  glArrShooting[3,2] := eShooting32;
  glArrShooting[3,3] := eShooting33;

  glArrShooting[4,1] := eShooting41;
  glArrShooting[4,2] := eShooting42;
  glArrShooting[4,3] := eShooting43;

  glArrOtsechka[1,1] := eOtsechka11;
  glArrOtsechka[1,2] := eOtsechka12;
  glArrOtsechka[1,3] := eOtsechka13;

  glArrOtsechka[2,1] := eOtsechka21;
  glArrOtsechka[2,2] := eOtsechka22;
  glArrOtsechka[2,3] := eOtsechka23;

  glArrOtsechka[3,1] := eOtsechka31;
  glArrOtsechka[3,2] := eOtsechka32;
  glArrOtsechka[3,3] := eOtsechka33;

  glArrOtsechka[4,1] := eOtsechka41;
  glArrOtsechka[4,2] := eOtsechka42;
  glArrOtsechka[4,3] := eOtsechka43;

  glArrGPS[1] := eGPS1;
  glArrGPS[2] := eGPS2;
  glArrGPS[3] := eGPS3;
  glArrGPS[4] := eGPS4;

  glArrBtnSetCamera[1,1] := btnCamera11;
  glArrBtnSetCamera[1,2] := btnCamera12;
  glArrBtnSetCamera[1,3] := btnCamera13;
  glArrBtnSetCamera[1,4] := btnCamera14;

  glArrBtnSetCamera[2,1] := btnCamera21;
  glArrBtnSetCamera[2,2] := btnCamera22;
  glArrBtnSetCamera[2,3] := btnCamera23;
  glArrBtnSetCamera[2,4] := btnCamera24;

  glArrTeams[1] := eTeam1;
  glArrTeams[2] := eTeam2;
  glArrTeams[3] := eTeam3;
  glArrTeams[4] := eTeam4;

  glArrShapeTeam[1] := ShapeTeam1;
  glArrShapeTeam[2] := ShapeTeam2;
  glArrShapeTeam[3] := ShapeTeam3;
  glArrShapeTeam[4] := ShapeTeam4;

  glArrShapeTeam1[1] := ShapeTeam11;
  glArrShapeTeam1[2] := ShapeTeam22;
  glArrShapeTeam1[3] := ShapeTeam33;
  glArrShapeTeam1[4] := ShapeTeam44;

  glArrDist[1] := btnDist1;
  glArrDist[2] := btnDist2;
  glArrDist[3] := btnDist3;
  glArrDist[4] := btnDist4;

  glArrValueSpeed[1] := eSpeed1;
  glArrValueSpeed[2] := eSpeed2;
  glArrValueSpeed[3] := eSpeed3;
  glArrValueSpeed[4] := eSpeed4;
  glArrValueDist[1] := eDist1;
  glArrValueDist[2] := eDist2;
  glArrValueDist[3] := eDist3;
  glArrValueDist[4] := eDist4;


  glArrTitleESO[1] := btnEkipag1;
  glArrTitleESO[2] := btnEkipag2;
  glArrTitleESO[3] := btnEkipag3;
  glArrTitleESO[4] := btnEkipag4;

  glArrTitleESO[5] := btnShooting1;
  glArrTitleESO[6] := btnShooting2;
  glArrTitleESO[7] := btnShooting3;
  glArrTitleESO[8] := btnShooting4;

  glArrTitleESO[9]  := btnOtsechka1;
  glArrTitleESO[10] := btnOtsechka2;
  glArrTitleESO[11] := btnOtsechka3;
  glArrTitleESO[12] := btnOtsechka4;

end;

procedure T_GPSTelemetry.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TimerTelemetry.Enabled:=false;
end;

procedure T_GPSTelemetry.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 if MessageDlg('Закрыть окно ?', mtConfirmation, [mbOk, mbNo], 0) = mrNo then
    CanClose := False;
end;

procedure T_GPSTelemetry.FormDestroy(Sender: TObject);
var lIniFile:TIniFile;
begin
  lIniFile:=TIniFile.Create(glIniFileName);
  lIniFile.WriteString('TANKS','DESTANCE_M',eMoveDistanceM.Text);
  lIniFile.WriteString('TANKS','SPEED_KMH',eSpeedKMH.Text);
  lIniFile.WriteString('TANKS','TARGET_TEXTURE_CLEAR',eMeshenTexture_Clear.Text);
  lIniFile.WriteString('TANKS','QuantityOtsechekOnTitle',speQuantityOtsechekOnTitle.Text);
  lIniFile.WriteString('TANKS','QuantityPlayersOnTitle',speQuantityPlayersOnTitle.Text);
  lIniFile.WriteString('TANKS','QuantityMisheniOnTitle',speQuantityMisheniOnTitle.Text);
  lIniFile.WriteBool('TANKS','SHOW_SPEED',chbShowSpeed.Checked);
  lIniFile.WriteBool('TANKS','SHOW_DIST',chbShowDistance.Checked);

  lIniFile.WriteString('TANKS','TANK_COLOR_R_ADD',eAddR.Text);
  lIniFile.WriteString('TANKS','TANK_COLOR_G_ADD',eAddG.Text);
  lIniFile.WriteString('TANKS','TANK_COLOR_B_ADD',eAddB.Text);
  lIniFile.WriteString('TANKS','TANK_COLOR_YR_ADD',eAddYR.Text);
  lIniFile.WriteString('TANKS','TANK_COLOR_YG_ADD',eAddYG.Text);

  lIniFile.Free;

  pCloseBase(nil);
  pCloseBaseLocal(nil);
end;

procedure T_GPSTelemetry.FormShow(Sender: TObject);
begin
  TimerTelemetry.Enabled:=true;
end;

procedure T_GPSTelemetry.pCloseBase(Sender: TObject);
begin
  qOtsechki.Close;
  qTanksData.Close;
  _GPS_dm.DBTanks.Connected:=false;
end;

procedure T_GPSTelemetry.pCloseBaseLocal(Sender: TObject);
begin
  qCountryLoc.Close;
  _GPS_dm.DBLocal.Connected:=false;
end;

{
function GetRValue(rgb: DWORD): Byte;
begin
  Result := Byte(rgb);
end;

function GetGValue(rgb: DWORD): Byte;
begin
  Result := Byte(rgb shr 8);
end;

function GetBValue(rgb: DWORD): Byte;
begin
  Result := Byte(rgb shr 16);
end;
}
function T_GPSTelemetry.fTankColorGet(lColorID:string; var r, g, b: single; var TexturePath: string; var PicturePath: string ): boolean;
var
   iColor: integer;
   lDecSepar : char;
begin
   lDecSepar := FormatSettings.DecimalSeparator;

   r:=0;
   g:=0;
   b:=0;
   TexturePath:='';
   PicturePath:='';

   Result:=true;

   if not _GPS_dm.DBLocal.Connected then
     EXIT;

   _GPS_dm.qColor_Get.Close;
   _GPS_dm.qColor_Get.Parameters.ParamByName('ColorID').Value := lColorID;
   _GPS_dm.qColor_Get.Open;
   iColor:=StrToIntDef(_GPS_dm.qColor_Get.FieldByName('ColorValue').AsString, clWhite);
   TexturePath:=_GPS_dm.qColor_Get.FieldByName('TexturePath').AsString;
   PicturePath:=_GPS_dm.qColor_Get.FieldByName('PicturePath').AsString;
   _GPS_dm.qColor_Get.Close;
   if (iColor < 0)and(TexturePath = '')and(PicturePath = '')then
     Result:=false;
   r := GetRValue(iColor) / 255;
   g := GetGValue(iColor) / 255;
   b := GetBValue(iColor) / 255;

   eAddR.Text := AnsiReplaceStr(eAddR.Text,'.',lDecSepar) ;
   eAddR.Text := AnsiReplaceStr(eAddR.Text,',',lDecSepar) ;
   eAddG.Text := AnsiReplaceStr(eAddG.Text,'.',lDecSepar) ;
   eAddG.Text := AnsiReplaceStr(eAddG.Text,'.',lDecSepar) ;
   eAddB.Text := AnsiReplaceStr(eAddB.Text,'.',lDecSepar) ;
   eAddB.Text := AnsiReplaceStr(eAddB.Text,'.',lDecSepar) ;
   eAddYR.Text := AnsiReplaceStr(eAddYR.Text,'.',lDecSepar) ;
   eAddYR.Text := AnsiReplaceStr(eAddYR.Text,'.',lDecSepar) ;
   eAddYG.Text := AnsiReplaceStr(eAddYG.Text,'.',lDecSepar) ;
   eAddYG.Text := AnsiReplaceStr(eAddYG.Text,'.',lDecSepar) ;

   if lColorID = 'r' then  r:=r + abs(StrToFloatDef(eAddR.Text,0)) else
   if lColorID = 'g' then  g:=g + abs(StrToFloatDef(eAddG.Text,0)) else
   if lColorID = 'b' then  b:=b + abs(StrToFloatDef(eAddB.Text,0)) else
   if lColorID = 'y' then
     begin
       r:=r+ abs(StrToFloatDef(eAddYR.Text,0));
       g:=g+ abs(StrToFloatDef(eAddYG.Text,0));
     end;
end;

procedure T_GPSTelemetry.pRefreshTankColor(lOpenClose_Active: boolean = false);
var i,iFT,c, iRes:integer;
    r, g, b: single;
    TexturePath, PicturePath, lColorID: string;
    lColor: TVector;
    Names : array [0..1] of TName;
begin
  (*
  pStrGrid(sgColorTank);

  if not _GPS_dm.DBTanks.Connected or not _GPS_dm.DBLocal.Connected then
    EXIT;

  if (Scenes[0].Text[0] <> #0) then      // сцены есть, значит двиг стартован
    begin
      if lOpenClose_Active then OpenRecords(nil);

//      for i := 0 to MAX_VEHICLES - 1 do begin
//        if ((Vehicles[i].State and VE_ENABLED) <> 0)and((Vehicles[i].State and VE_STARTED) <> 0) then
      for iFT := 1 to high(FourTanks) do
          begin
            i:=FourTanks[iFT];
            _GPS_dm.qTankPlayersForTeam.Close;
            _GPS_dm.qTankPlayersForTeam.Parameters.ParamByName('GPSID').Value:=IntToStr(i);
            _GPS_dm.qTankPlayersForTeam.Open;
            lColorID:=_GPS_dm.qTankPlayersForTeam.FieldByName('TeamColorID').AsString;
            _GPS_dm.qTankPlayersForTeam.Close;
            if lColorID <> '' then
              begin
                if fTankColorGet(lColorID, r, g, b, TexturePath, PicturePath) then
                  begin
                    lColor.VSet( r, g, b, FLT_UNDEF );
                    SetObjectSpace( Poligon2DSceneName, PAnsiChar(AnsiString(Vehicles[i].ModelName.Text)),nil,nil,nil,nil,nil,@lColor,0.0,0,nil);
                    GetChildsNamesByBase( Poligon2DSceneName, Vehicles[i].Name.text, 'Bubble', @Names, 0, nil );
                    Names[1].Text:=#0;
{
                    iRes:=AssignObjectsTexture( Poligon2DSceneName,
                            @Names,
                            PAnsiChar(AnsiString(VehiclesData[i].CountryFlag)),
                            1,
                            0.0, 0.0, 0, nil );
}
                    iRes:=UpdateSurfaceElement( Poligon2DSceneName, Names[0].text, 1, 1,
                            PAnsiChar(AnsiString(VehiclesData[i].CountryFlag)),
                            nil,
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

                  end
                  else
                  begin
                    if lColorID = 'y' then  c:=1 else
                    if lColorID = 'r' then  c:=2 else
                    if lColorID = 'g' then  c:=3 else
                    if lColorID = 'b' then  c:=4 ;
                    SetObjectSpace( Poligon2DSceneName, PAnsiChar(AnsiString(Vehicles[i].ModelName.Text)),nil,nil,nil,nil,nil,@VColors[c],0.0,0,nil);
                  end;
              end;
          end;
//      end;

      if lOpenClose_Active then CloseRecords(nil);
      sleep(100);
    end;

  pStrGrid(sgColorTank);
  *)
  qTanksData.Close;
  qTanksData.Open;
end;

function T_GPSTelemetry.fCountryGet(lCountryName:string):string;
begin
  if not _GPS_dm.DBLocal.Connected then
    EXIT;

  _GPS_dm.qCountry_Get.Close;
  _GPS_dm.qCountry_Get.Parameters.ParamByName('CountryName').Value := lCountryName;
  _GPS_dm.qCountry_Get.Open;
  Result:=_GPS_dm.qCountry_Get.FieldByName('FlagImg').AsString;
  _GPS_dm.qCountry_Get.Close;
end;

function T_GPSTelemetry.fChangeTextSQL(lQ:TADOQuery):string;
var s,s1,s2:string;
begin
  lQ.Close;
  s1:=lQ.SQL.Text;
  result := s1;
  s:=trim(Copy(s1,Pos('tblInfo',s1),8));
  s2:=qTanksData.FieldByName('z.GroupID').AsString;
  if Copy(s2,1,5) = 'State' then s2:=Copy(s2,6,1) else s2:='0';
  if s2 <> '0' then
    result := AnsiReplaceStr( s1 , s ,'tblInfo'+s2 );
end;

procedure T_GPSTelemetry.pInitialArray_FourTanks;
var i:integer;
begin
  if not _GPS_dm.DBTanks.Connected then EXIT;

  _GPS_dm.qTeamInZaezd.Close;
  _GPS_dm.qTeamInZaezd.Open;

  i:=0;
  while not _GPS_dm.qTeamInZaezd.Eof do
    begin
      inc(i);
      if i <= MaxOneVehicles then
        begin
          Vehicles[i].Id := StrToIntDef(_GPS_dm.qTeamInZaezd.FieldByName('GPSID').AsString, 0);
          // pInitial_TEdit_FourTanks(i, Vehicles[i].Id);
        end
                             else
        break;
      _GPS_dm.qTeamInZaezd.Next;
    end;
  _GPS_dm.qTeamInZaezd.Close;
end;

    //  Id четырёх танков на забеге
procedure T_GPSTelemetry.pInitial_TEdit_FourTanks(i, iGPS:integer);
var lStr:string;
    lEdit : TEdit;
    lChangeBtn: TButton;
begin
  lStr := 'Tank' + IntToStr(i) + 'Edit';
  lEdit := TEdit( MainForm.Poligon2DGroupBox.FindChildControl( lStr ) );     // находим окошко с id GPS

  if trim(lEdit.Text) <> trim(IntToStr(iGPS)) then                        // если новое значение не равно значению в окошке, то меняем
    begin
      lEdit.Text := IntToStr(iGPS);

      if Poligon2DSceneName <> nil then
        begin
          lStr := 'Tank' + IntToStr(i) + 'ChangeButton';
          lChangeBtn := TButton( MainForm.Poligon2DGroupBox.FindChildControl( lStr ) );
          lChangeBtn.Click;

          if( TEST = 1 ) then begin                  // если тест, то выставим
            Vehicles[iGPS].CtRt := (i-1)*40;         //  начальную точку маршрута для тестов
            Vehicles[iGPS].MoveDistance := i*40;
          end;
        end;
    end;
end;

procedure T_GPSTelemetry.pButtonClear(Sender: TObject);
var i, j: integer;
begin
  for i := 1 to MaxOneVehicles do
    begin
      for j:=1 to cEkipagCount do
        glArrEkipage[i,j].Text := '';
      for j:=1 to cShootsCount do
        glArrShooting[i,j].Text := '';
      for j:=1 to cOtsechkiCount do
       glArrOtsechka[i,j].Text := '';
    end;
end;

procedure T_GPSTelemetry.pRefresh(Sender: TObject);

   function fShotToResult(lShot:string; var iHit, iMiss, iAll: integer):string;
   var i:integer;
   begin
     iHit:=0;
     iMiss:=0;
     for i:=1 to length(lShot) do
       begin
         if lShot[i] = '1' then inc(iHit) else
         if lShot[i] = '0' then inc(iMiss);
       end;
     iAll:=iHit + iMiss;
     Result:=IntToStr(iHit)+'/'+IntToStr(iAll)
   end;

var lQty, lPic, lTex, lStr:string;
    i,j,c,iHit,iMiss,iAll{, iColBtn}:integer;
    r,g,b:single;
    {iTargetQty, iShotHitQty, iHitTargetQty : integer;}
    {iQtyOts, iQtyOtsOnTitle, i1, j1: integer;}
    {iResult, iRemainder: Word;}
begin
  if not _GPS_dm.DBTanks.Connected then
    EXIT;

  qTanksData.Close;                      // переоткрываем qTanksData , чтобы сработала функция fChangeTextSQL
  qTanksData.Open;

  pInitialArray_FourTanks;               // заполняем массив с GPS для показа карты

  pButtonClear(nil);                     // очищаем значения в строках подсмотра

//      for i := 0 to MAX_VEHICLES - 1 do begin
//        if ((Vehicles[i].State and VE_ENABLED) <> 0)and((Vehicles[i].State and VE_STARTED) <> 0)
//            or (Scenes[0].Text[0] = #0) then   // если танк на поле или сцена не загружена
      for i := 1 to MaxOneVehicles do
          begin
            // обновляем экипаж
            _GPS_dm.qTankPlayersForTeam.Close;
            _GPS_dm.qTankPlayersForTeam.Parameters.ParamByName('GPSID').Value:=IntToStr(Vehicles[i].Id);
            _GPS_dm.qTankPlayersForTeam.Open;

            VehiclesData[i].TeamName := _GPS_dm.qTankPlayersForTeam.FieldByName('TeamName').AsString;
            VehiclesData[i].CountryName := _GPS_dm.qTankPlayersForTeam.FieldByName('CountryName').AsString;
            VehiclesData[i].CountryFlag := fCountryGet(_GPS_dm.qTankPlayersForTeam.FieldByName('CountryName').AsString);
            fTankColorGet(_GPS_dm.qTankPlayersForTeam.FieldByName('TeamColorID').AsString, r, g, b, lTex, lPic);
            VehiclesData[i].TankSmallPicture := lPic;

            // iColBtn:=fNumColumnBtnForGPS(i);

            for j:=0 to high(VehiclesData[i].Players) do
              begin
                VehiclesData[i].Players[j].PlayerName:='';
                VehiclesData[i].Players[j].AmplyaName:='';
              end;
            j:=0;
            while not _GPS_dm.qTankPlayersForTeam.Eof do
              begin
                if j <= high(VehiclesData[i].Players) then
                  begin
                    VehiclesData[i].Players[j].PlayerName:=_GPS_dm.qTankPlayersForTeam.FieldByName('PlayerName').AsString;
                    VehiclesData[i].Players[j].AmplyaName:=_GPS_dm.qTankPlayersForTeam.FieldByName('AmplyaName').AsString;

                    {if (iColBtn > 0) and (iColBtn <= MaxOneVehicles) and (j+1 <= cEkipagCount) then
                      glArrEkipage[iColBtn, j+1].Text := VehiclesData[i].Players[j].PlayerName;}
                  end;
                inc(j);
                _GPS_dm.qTankPlayersForTeam.Next;
              end;
            _GPS_dm.qTankPlayersForTeam.Close;

            // обновляем отсечки
            _GPS_dm.qOtsechkiForTeam.Close;
            _GPS_dm.qOtsechkiForTeam.Parameters.ParamByName('GPSID').Value:=IntToStr(Vehicles[i].Id);
            _GPS_dm.qOtsechkiForTeam.Open;
            for j:=0 to high(VehiclesData[i].Intermediate) do
              begin
                VehiclesData[i].Intermediate[j].NumOtsec:='';
                VehiclesData[i].Intermediate[j].TimeOtsec:='';
                VehiclesData[i].Intermediate[j].DisplayPos:='';
                VehiclesData[i].Intermediate[j].TimeMSec:='';
              end;
            // j:=0;
            while not _GPS_dm.qOtsechkiForTeam.Eof do
              begin
                j := StrToIntDef(_GPS_dm.qOtsechkiForTeam.FieldByName('NumOtsec').AsString, 0)-1;
                if (j >= 0) and (j <= high(VehiclesData[i].Intermediate)) then
                  begin
                    VehiclesData[i].Intermediate[j].NumOtsec:=_GPS_dm.qOtsechkiForTeam.FieldByName('NumOtsec').AsString;
                    VehiclesData[i].Intermediate[j].TimeOtsec:=_GPS_dm.qOtsechkiForTeam.FieldByName('TimeOtsec').AsString;
                    VehiclesData[i].Intermediate[j].DisplayPos:=_GPS_dm.qOtsechkiForTeam.FieldByName('DisplayPos').AsString;
                    VehiclesData[i].Intermediate[j].TimeMSec:=_GPS_dm.qOtsechkiForTeam.FieldByName('tmsec').AsString;
                  end;
                // inc(j);
                _GPS_dm.qOtsechkiForTeam.Next;
              end;
            _GPS_dm.qOtsechkiForTeam.Close;

            // отсечки
            {iQtyOts:=0;
            for i1:=0 to high(VehiclesData[i].Intermediate) do
              begin
                if (VehiclesData[i].Intermediate[i1].NumOtsec <> '') then
                  inc(iQtyOts);
              end;
            DivMod(iQtyOts, cOtsechkiCount, iResult, iRemainder);
            j1:=0;
            for i1:=0 to iQtyOts - 1 do
              begin
                if ((i1 + 1) > (iResult * cOtsechkiCount))
                   or
                   (((iRemainder = 0)and(iResult > 0))and((i1 + 1) > (iQtyOts - cOtsechkiCount))) then
                  begin
                    if (iColBtn > 0) and (iColBtn <= MaxOneVehicles) and (j1+1 <= cOtsechkiCount) then
                      glArrOtsechka[iColBtn, j1+1].Text := fConvertTime(VehiclesData[i].Intermediate[i1].TimeMSec);
                    inc(j1);
                  end;
              end;}

            // обновляем стрельбу
            _GPS_dm.qInfoForTeam.Close;
            _GPS_dm.qInfoForTeam.SQL.Text := fChangeTextSQL(_GPS_dm.qInfoForTeam);
            _GPS_dm.qInfoForTeam.Parameters.ParamByName('GPSID').Value:=IntToStr(Vehicles[i].Id);
            _GPS_dm.qInfoForTeam.Open;
            for j:=0 to high(VehiclesData[i].Shooting) do
              begin
                VehiclesData[i].Shooting[j].MainShot:='';
                VehiclesData[i].Shooting[j].AddShot:='';
                VehiclesData[i].Shooting[j].TimeShooting:='';
                VehiclesData[i].Shooting[j].TargetType:='';
                VehiclesData[i].Shooting[j].TargetName:='';
                VehiclesData[i].Shooting[j].MainHit:='0';
                VehiclesData[i].Shooting[j].MainMiss:='0';
                VehiclesData[i].Shooting[j].MainAll:='0';
                VehiclesData[i].Shooting[j].AddHit:='0';
                VehiclesData[i].Shooting[j].AddMiss:='0';
                VehiclesData[i].Shooting[j].AddAll:='0';
                VehiclesData[i].Shooting[j].ShotHit:='0';
                VehiclesData[i].Shooting[j].ShotMiss:='0';
                VehiclesData[i].Shooting[j].ShotAll:='0';
              end;
            j:=0;
            while not _GPS_dm.qInfoForTeam.Eof do
              begin
                if j <= high(VehiclesData[i].Shooting) then
                  begin
                    for c:=1 to cShootingRubegQty do
                      begin
                        if _GPS_dm.qInfoForTeam.FindField('p'+IntTostr(c)) <> nil then
                          begin
                            VehiclesData[i].Shooting[j].MainShot:= _GPS_dm.qInfoForTeam.FieldByName('p'+IntTostr(c)).AsString;
                            fShotToResult(VehiclesData[i].Shooting[j].MainShot, iHit, iMiss, iAll);
                            VehiclesData[i].Shooting[j].MainHit:= IntToStr(iHit);
                            VehiclesData[i].Shooting[j].MainMiss:= IntToStr(iMiss);
                            VehiclesData[i].Shooting[j].MainAll:= IntToStr(iAll);

                            VehiclesData[i].Shooting[j].ShotHit:= IntToStr(StrToIntDef(VehiclesData[i].Shooting[j].ShotHit,0) +
                                                                           StrToIntDef(VehiclesData[i].Shooting[j].MainHit,0)) ;
                            VehiclesData[i].Shooting[j].ShotMiss:= IntToStr(StrToIntDef(VehiclesData[i].Shooting[j].ShotMiss,0) +
                                                                            StrToIntDef(VehiclesData[i].Shooting[j].MainMiss,0)) ;
                            VehiclesData[i].Shooting[j].ShotAll:= IntToStr(StrToIntDef(VehiclesData[i].Shooting[j].ShotHit,0) +
                                                                           StrToIntDef(VehiclesData[i].Shooting[j].ShotMiss,0)) ;
                          end;
                        if _GPS_dm.qInfoForTeam.FindField('a'+IntTostr(c)) <> nil then
                          begin
                            VehiclesData[i].Shooting[j].AddShot:= _GPS_dm.qInfoForTeam.FieldByName('a'+IntTostr(c)).AsString;
                            fShotToResult(VehiclesData[i].Shooting[j].AddShot, iHit, iMiss, iAll);
                            VehiclesData[i].Shooting[j].AddHit:= IntToStr(iHit);
                            VehiclesData[i].Shooting[j].AddMiss:= IntToStr(iMiss);
                            VehiclesData[i].Shooting[j].AddAll:= IntToStr(iAll);

                            VehiclesData[i].Shooting[j].ShotHit:= IntToStr(StrToIntDef(VehiclesData[i].Shooting[j].ShotHit,0) +
                                                                           StrToIntDef(VehiclesData[i].Shooting[j].AddHit,0)) ;
                            VehiclesData[i].Shooting[j].ShotMiss:= IntToStr(StrToIntDef(VehiclesData[i].Shooting[j].ShotMiss,0) +
                                                                            StrToIntDef(VehiclesData[i].Shooting[j].AddMiss,0)) ;
                            VehiclesData[i].Shooting[j].ShotAll:= IntToStr(StrToIntDef(VehiclesData[i].Shooting[j].ShotHit,0) +
                                                                           StrToIntDef(VehiclesData[i].Shooting[j].ShotMiss,0)) ;
                          end;
                        if _GPS_dm.qInfoForTeam.FindField('Time'+IntTostr(c)) <> nil then
                          VehiclesData[i].Shooting[j].TimeShooting:= _GPS_dm.qInfoForTeam.FieldByName('Time'+IntTostr(c)).AsString;
                        if _GPS_dm.qInfoForTeam.FindField('Mish'+IntTostr(c)) <> nil then
                          begin
                            VehiclesData[i].Shooting[j].TargetType:= _GPS_dm.qInfoForTeam.FieldByName('Mish'+IntTostr(c)).AsString;
                            VehiclesData[i].Shooting[j].TargetName:=fTargetName(VehiclesData[i].Shooting[j].TargetType, lQty, lPic);
                            VehiclesData[i].Shooting[j].TargetQuantity:=lQty;
                            VehiclesData[i].Shooting[j].TargetPicture:=lPic;
                          end;

                        {if VehiclesData[i].Shooting[j].TargetType <> '' then
                          if (iColBtn > 0) and (iColBtn <= MaxOneVehicles) and (j+1 <= cShootsCount) then
                            begin
                              // количество сбитых из всего мишеней
                              iTargetQty := StrToIntDef(VehiclesData[i].Shooting[j].TargetQuantity, 0);
                              iShotHitQty := StrToIntDef(VehiclesData[i].Shooting[j].ShotHit, 0);
                              iHitTargetQty := Min( iShotHitQty , iTargetQty );            // проверяем, что кол-во сбитых мишеней не больше общего кол-ва мишеней

                              lStr := ' ';
                              if (StrToIntDef(VehiclesData[i].Shooting[j].ShotAll, 0) <> 0)and(iTargetQty > 0) then  // если были выстелы, значит есть результат
                                lStr := IntToStr(iHitTargetQty)+'/'+IntToStr(iTargetQty);

                              glArrShooting[iColBtn, j+1].Text := VehiclesData[i].Shooting[j].TargetType + '  ' + lStr;
                            end;}

                        inc(j);
                    end;
                  end;
                _GPS_dm.qInfoForTeam.Next;
              end;
            VehiclesData[i].TotalTime:=_GPS_dm.qInfoForTeam.FieldByName('TotalTime').AsString;
            VehiclesData[i].TotalTimeMS :=_GPS_dm.qInfoForTeam.FieldByName('tmsec').AsString;
            VehiclesData[i].DisplayPos:=_GPS_dm.qInfoForTeam.FieldByName('DisplayPos').AsString;
            VehiclesData[i].IRM:=_GPS_dm.qInfoForTeam.FieldByName('IRM').AsString;
            _GPS_dm.qInfoForTeam.Close;
          end;
//      end;

  qTanksData.Close;
  qTanksData.Open;
  qOtsechki.Close;
  qOtsechki.Open;
  qInfo.Close;
  qInfo.SQL.Text := fChangeTextSQL(qInfo);
  qInfo.Open;

  pRefreshButtons(nil);

  pTankPanelColoring;
end;

procedure T_GPSTelemetry.pRefreshLocal(Sender: TObject);
var i,j:integer;
begin
  if not _GPS_dm.DBLocal.Connected then
    EXIT;

  qCountryLoc.Close;
  qCountryLoc.Open;
  qColorLoc.Close;
  qColorLoc.Open;
  qMeshenyLoc.Close;
  qMeshenyLoc.Open;
end;

procedure T_GPSTelemetry.btnRefreshClick(Sender: TObject);
begin
  pRefresh(nil);
end;

procedure T_GPSTelemetry.btnRefreshLocalClick(Sender: TObject);
begin
  pRefreshLocal(nil);
end;

procedure T_GPSTelemetry.btnRefreshTankColorClick(Sender: TObject);
begin
  pRefreshTankColor(true);

//  pTankPanelColoring;

end;

procedure T_GPSTelemetry.TimerTelemetryTimer(Sender: TObject);
begin
  if PageControl1.ActivePage = tsExtendedData then
    pStrGrid(sgSpeed);
  pUpdateSpeedDistValue(nil);
  {pShowTankSpeed(nil);}   //  скорость
end;

procedure T_GPSTelemetry.pStrGrid(Sender: TObject);
var i, j, iFT:integer;
begin
  with (Sender as TStringGrid) do
    begin
      if MaxOneVehicles + 1 <> ColCount then
        begin
          ColCount := Max(MaxOneVehicles + 1,2);
          RowCount := 2;
          FixedCols := 1;
          FixedRows := 1;
        end;
      Cells[0,0]:='IdGPS-танк';
      if Name = 'sgSpeed' then Cells[0,1]:='скорость' else
      if Name = 'sgColorTank' then Cells[0,1]:='цвет';

      j:=1;
//      for i := 0 to MAX_VEHICLES - 1 do begin
//        if ((Vehicles[i].State and VE_ENABLED) <> 0)and((Vehicles[i].State and VE_STARTED) <> 0) then
      for iFT := 1 to MaxOneVehicles do
          begin
            i:=Vehicles[iFT].Id;

            Cells[j,0]:=IntToStr(i) + ' - ' + Vehicles[i].ModelName.Text;
            if Name = 'sgSpeed' then
              Cells[j,1]:=FormatFloat('0',Vehicles[i].MoveDistance) + ' / ' + FormatFloat('0.0',Vehicles[i].TrueSpeed)
            else
            if Name = 'sgColorTank' then
              Cells[j,1]:=IntToStr(fGetColorTank(AnsiString(Vehicles[i].ModelName.Text)));
            inc(j);
          end;
//      end;
    end;
end;

procedure T_GPSTelemetry.btnBaseFileClick(Sender: TObject);
var lIniFile:TIniFile;
begin
  if _GPS_dm.DBTanks.Connected then
    begin
      ShowMessage('База уже подключена !'+#13#10+#13#10+'Чтобы изменить файл, нужно сначала отключить текущий файл !');
      EXIT;
    end;

  if OpenDialog1.Execute then
    eBaseFile.Text:=OpenDialog1.FileName;

  lIniFile:=TIniFile.Create(glIniFileName);
  lIniFile.WriteString('BASE','FILE_NAME',eBaseFile.Text);
  lIniFile.Free;
end;

procedure T_GPSTelemetry.btnBaseFileLocalClick(Sender: TObject);
var lIniFile:TIniFile;
begin
  if _GPS_dm.DBLocal.Connected then
    begin
      ShowMessage('База уже подключена !'+#13#10+#13#10+'Чтобы изменить файл, нужно сначала отключить текущий файл !');
      EXIT;
    end;

  if OpenDialog1.Execute then
    eBaseFileLocal.Text:=OpenDialog1.FileName;

  lIniFile:=TIniFile.Create(glIniFileName);
  lIniFile.WriteString('BASE_LOCAL','FILE_NAME',eBaseFileLocal.Text);
  lIniFile.Free;
end;

procedure T_GPSTelemetry.btnConnectClick(Sender: TObject);
var lProvider:string;
begin
  if _GPS_dm.DBTanks.Connected then
    begin
      ShowMessage('База уже подключена !');
      EXIT;
    end;

  if not FileExists(eBaseFile.Text) then
    begin
      ShowMessage(eBaseFile.Text + #13#10 + 'Файл Базы не найден !');
      EXIT;
    end;

  {$IfDef WIN64}
  lProvider:='Microsoft.ACE.OLEDB.12.0';
  {$Else}
  lProvider:='Microsoft.Jet.OLEDB.4.0';
  {$EndIf}

  _GPS_dm.DBTanks.ConnectionString:='Provider='+lProvider+';Data Source='+eBaseFile.Text+';Persist Security Info=False;';
  try
    _GPS_dm.DBTanks.Connected := True;
  except
    ShowMessage('Не могу Подключиться к Базе !'+#13#10+ #13#10+eBaseFile.Text);
  end;

  pRefreshTankColor(true);

  pRefresh(nil);
end;

procedure T_GPSTelemetry.btnConnectLocalClick(Sender: TObject);
var lProvider:string;
begin
  if _GPS_dm.DBLocal.Connected then
    begin
      ShowMessage('База уже подключена !');
      EXIT;
    end;

  if not FileExists(eBaseFileLocal.Text) then
    begin
      ShowMessage(eBaseFileLocal.Text + #13#10 + 'Файл Базы не найден !');
      EXIT;
    end;

  {$IfDef WIN64}
  lProvider:='Microsoft.ACE.OLEDB.12.0';
  {$Else}
  lProvider:='Microsoft.Jet.OLEDB.4.0';
  {$EndIf}

  _GPS_dm.DBLocal.ConnectionString:='Provider='+lProvider+';Data Source='+eBaseFileLocal.Text+';Persist Security Info=False;';
  try
    _GPS_dm.DBLocal.Connected := True;
  except
    ShowMessage('Не могу Подключиться к Базе !'+#13#10+ #13#10+eBaseFile.Text);
  end;

//  pRefreshTankColor(true);

  pRefreshLocal(nil);

  {pArrayTexMsh_Refresh;}     // создаём текстуры
end;

procedure T_GPSTelemetry.btnEditGPSClick(Sender: TObject);
begin
  pnlEditGPS.Visible:=true;
  cbEditGPS.Text:=qTanksData.FieldByName('GPSID').AsString;
end;

procedure T_GPSTelemetry.btnSetNewGPSClick(Sender: TObject);
begin
  _GPS_dm.qUpdateGPS.Parameters.ParamByName('tblZaezdMapID').Value:=qTanksData.FieldByName('tblZaezdMapID').AsInteger;
  _GPS_dm.qUpdateGPS.Parameters.ParamByName('GPSID').Value:=cbEditGPS.Text;
  _GPS_dm.qUpdateGPS.ExecSQL;
  pnlEditGPS.Visible:=false;

  pRefresh(nil);
  pRefreshTankColor(true);
end;

procedure T_GPSTelemetry.btnUnConnectClick(Sender: TObject);
begin
  pCloseBase(nil);
end;

procedure T_GPSTelemetry.btnUnConnectLocalClick(Sender: TObject);
begin
  pCloseBaseLocal(nil);
end;

procedure T_GPSTelemetry.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var lColor: TColor;
    i:integer;
    s:string;
begin
  lColor:= -1;

  if (Pos('TeamColorID',Column.FieldName) > 0) and (trim(Column.Field.AsString) <> '') then// and (not (gdFocused in State)) then
    begin
      lColor:=clWhite;
      if Column.Field.AsString = 'y' then lColor := clYellow else
      if Column.Field.AsString = 'g' then lColor := clGreen else
      if Column.Field.AsString = 'b' then lColor := clBlue else
      if Column.Field.AsString = 'r' then lColor := clRed;
      (Sender as TDBGrid).Canvas.Brush.Color := lColor;
    end;

  if (Column.FieldName = 'GPSID') and (trim(Column.Field.AsString) <> '') then
    begin
      for i := 0 to sgColorTank.ColCount - 1 do
        begin
          s:=sgColorTank.Cells[i,0];
          if trim(Column.Field.AsString) = trim(Copy(s,1,Pos(' ',s))) then
            begin
              lColor := StrToIntDef(sgColorTank.Cells[i,1], clWhite);
              break;
            end;
        end;
    end;

   if lColor > -1 then
     begin
       (Sender as TDBGrid).Canvas.Brush.Color := lColor;
       (Sender as TDBGrid).DefaultDrawColumnCell(Rect, DataCol, Column, State);
     end;
end;

function T_GPSTelemetry.fGetColorTank(TankName: string) : TColor;
Var
  pColor : TVector;
  R, G, B : integer;
  i, iR, iG, iB : single;
begin
  GetObjectSpace( Poligon2DSceneName, PAnsiChar(AnsiString(TankName)), nil, nil, nil, nil, nil, @pColor, 0, nil );

  iR:=pColor.x;
  iG:=pColor.y;
  iB:=pColor.z;

  i:=Max(Max(iR,iG),iB);
  if i > 1 then
    begin
      iR:=iR / i;
      iG:=iG / i;
      iB:=iB / i;
    end;

  R:=round(iR * 255);
  G:=round(iG * 255);
  B:=round(iB * 255);

  Result := RGB(R, G, B);
end;

procedure T_GPSTelemetry.sgColorTankDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (ACol > 0) and (ARow > 0) then
    begin
      (Sender as TStringGrid).Canvas.Brush.Color:=StrToIntDef((Sender as TStringGrid).Cells[ACol, 1], clWhite);
      (Sender as TStringGrid).Canvas.FillRect(Rect);
    end;
end;

procedure T_GPSTelemetry.cbTank1Change(Sender: TObject);
begin
  (Sender as TComboBox).Color:=fGetColorTank((Sender as TComboBox).Text);
end;

procedure T_GPSTelemetry.cbTank1DropDown(Sender: TObject);
var iFT:integer;
begin
  (Sender as TComboBox).Color:=clWhite;
  (Sender as TComboBox).Items.Clear;

  for iFT := 1 to MaxOneVehicles do
    (Sender as TComboBox).Items.Add(glArrColorGPS[iFT].TeamName);
end;

procedure T_GPSTelemetry.btnGangeColorTanksClick(Sender: TObject);
var
  vi1, vi2: integer;
  pColor1, pColor2 : TJTPColor;
begin
  vi1 := cbTank1.ItemIndex+1;
  vi2 := cbTank2.ItemIndex+1;
  if (vi1 < 1) or
     (vi2 < 1) or
     (MessageDlg('Поменять цвета у танков ?', mtConfirmation, [mbOk, mbNo], 0) <> mrOk) then
    EXIT;

  pColor1 := Vehicles[vi1].Color;
  pColor2 := Vehicles[vi2].Color;

  Vehicles[vi1].SetColor(pColor2);
  Vehicles[vi2].SetColor(pColor1);
  {
  OpenRecords(nil);

  GetObjectSpace( Poligon2DSceneName, PAnsiChar(AnsiString(cbTank1.Text)), nil, nil, nil, nil, nil, @pColor1, 0, nil );
  GetObjectSpace( Poligon2DSceneName, PAnsiChar(AnsiString(cbTank2.Text)), nil, nil, nil, nil, nil, @pColor2, 0, nil );

  SetObjectSpace( Poligon2DSceneName, PAnsiChar(AnsiString(cbTank1.Text)), nil, nil, nil, nil, nil, @pColor2, 0.0, 0, nil );
  SetObjectSpace( Poligon2DSceneName, PAnsiChar(AnsiString(cbTank2.Text)), nil, nil, nil, nil, nil, @pColor1, 0.0, 0, nil );

  CloseRecords(nil);

  sleep(100);     // поставил слип, чтобы в двиге прошло изменение цвета

  cbTank1Change(cbTank1);
  cbTank1Change(cbTank2);

  pRefreshTankColor(true);
  }
end;

{
procedure T_GPSTelemetry.pShowTankPlayers(lOpenClose_Active: boolean = false);
begin
  if glTankIndex = 0 then
    EXIT;

  if lOpenClose_Active then OpenRecords( nil );

  pTitleClear(false);

  UpdateSurfaceElement( VStatusSceneName, 'Status', 2, 1, nil, PAnsiChar(AnsiString(VehiclesData[glTankIndex].TeamName)), COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
  UpdateSurfaceElement( VStatusSceneName, 'Status', FamilyIndex2, 1, nil, PAnsiChar(AnsiString(VehiclesData[glTankIndex].Players[0].PlayerName)), COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
  UpdateSurfaceElement( VStatusSceneName, 'Status', FamilyIndex2+1, 1, nil, PAnsiChar(AnsiString(VehiclesData[glTankIndex].Players[1].PlayerName)), COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
  UpdateSurfaceElement( VStatusSceneName, 'Status', FamilyIndex2+2, 1, nil, PAnsiChar(AnsiString(VehiclesData[glTankIndex].Players[2].PlayerName)), COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
  if lOpenClose_Active then CloseRecords( nil );
end;
}

{
procedure T_GPSTelemetry.pShowIntermediates(lOpenClose_Active: boolean = false);
var i:integer;
begin
  if glTankIndex = 0 then
    EXIT;

  if lOpenClose_Active then OpenRecords( nil );

  pTitleClear(false);

  UpdateSurfaceElement( VStatusSceneName, 'Status', 2, 1, nil, PAnsiChar(AnsiString(VehiclesData[glTankIndex].TeamName)), COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
  for i:=0 to high(VehiclesData[glTankIndex].Intermediate) do
    begin
      if VehiclesData[glTankIndex].Intermediate[i].NumOtsec = '' then
        break;
      UpdateSurfaceElement( VStatusSceneName, 'Status', FamilyIndex2+i, 1, nil,
         PAnsiChar(AnsiString('отс. '+VehiclesData[glTankIndex].Intermediate[i].NumOtsec
                              + ' время '+fConvertTime(VehiclesData[glTankIndex].Intermediate[i].TimeMSec)
//                              + ' позиция '+VehiclesData[glTankIndex].Intermediate[i].DisplayPos
//                              + ' время '+VehiclesData[glTankIndex].Intermediate[i].TimeOtsec
                              )),
         COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
    end;
  if lOpenClose_Active then CloseRecords( nil );
end;
}

{
procedure T_GPSTelemetry.pShowShooting(lOpenClose_Active: boolean = false);
var i, iShotHitQty, iHitTargetQty, iTargetQty:integer;
    lStr:string;
begin
  if glTankIndex = 0 then
    EXIT;

  if lOpenClose_Active then OpenRecords( nil );

  pTitleClear(false);

  UpdateSurfaceElement( VStatusSceneName, 'Status', 2, 1, nil, PAnsiChar(AnsiString(VehiclesData[glTankIndex].TeamName)), COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
  for i:=0 to high(VehiclesData[glTankIndex].Shooting) do
    begin
      if VehiclesData[glTankIndex].Shooting[i].TargetName = '' then
        break;

      iTargetQty := StrToIntDef(VehiclesData[glTankIndex].Shooting[i].TargetQuantity, 0);
      iShotHitQty := StrToIntDef(VehiclesData[glTankIndex].Shooting[i].ShotHit, 0);
      if iShotHitQty > iTargetQty then
        iHitTargetQty := iTargetQty
        else
        iHitTargetQty := iShotHitQty;

      // количество сбитых из всего мишеней
      if (StrToIntDef(VehiclesData[glTankIndex].Shooting[i].ShotAll, 0) <> 0)and(iTargetQty > 0) then
        lStr := IntToStr(iHitTargetQty)+'/'+IntToStr(iTargetQty)
        else
        lStr := ' ';

      UpdateSurfaceElement( VStatusSceneName, 'Status', FamilyIndex2+i, 1, nil,
         PAnsiChar(AnsiString(VehiclesData[glTankIndex].Shooting[i].TargetName + lStr
//                               + IntToStr(iHitTargetQty) + '/' + IntToStr(iTargetQty)
//                               + ' Shots: ' + //VehiclesData[glTankIndex].Shooting[i].ShotHit + '/' +
//                                               VehiclesData[glTankIndex].Shooting[i].ShotAll
                              )),
         COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
    end;
  if lOpenClose_Active then CloseRecords( nil );
end;
}

{
procedure T_GPSTelemetry.pTitleClear(lOpenClose_Active: boolean = false);
begin
//  if lOpenClose_Active then OpenRecords( nil );
          //  наименование танка
  UpdateSurfaceElement( VStatusSceneName, 'Status', 1, 1, nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
          //  экипаж
  UpdateSurfaceElement( VStatusSceneName, 'Status', 2, 1, nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
  UpdateSurfaceElement( VStatusSceneName, 'Status', FamilyIndex2, 1, nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
  UpdateSurfaceElement( VStatusSceneName, 'Status', FamilyIndex2+1, 1, nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
  UpdateSurfaceElement( VStatusSceneName, 'Status', FamilyIndex2+2, 1, nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
          //  флаг
  UpdateSurfaceElement( VStatusSceneName, 'Status', 3, 1, 'Resources\Scenes\VehicleStatus\Fra.dds', nil, COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

//  if lOpenClose_Active then CloseRecords( nil );
end;
}

procedure T_GPSTelemetry.pSetTankIndex(TankIndex:integer);
begin
  if TankIndex > 0 then glTankIndex := TankIndex;
end;

procedure T_GPSTelemetry.pClearTankIndex;
begin
  glTankIndex := 0;
end;

{
procedure T_GPSTelemetry.pShowTanksData(lOpenClose_Active: boolean = false);
begin
  if rbEkipag.Checked then begin pShowTankPlayers(lOpenClose_Active) end else
  if rbOtsechki.Checked then pShowIntermediates(lOpenClose_Active) else
  if rbShooting.Checked then begin pShowShooting(lOpenClose_Active) end;
end;
}

function  T_GPSTelemetry.fTargetName(lTargetType:string; var lTargetQty, lPicture: string):string;
begin
  if not _GPS_dm.DBLocal.Connected then
    EXIT;

  lTargetQty:='';
  lPicture:='';
  _GPS_dm.qMesheny_Get.Close;
  _GPS_dm.qMesheny_Get.Parameters.ParamByName('MeshenyID').Value := lTargetType;
  _GPS_dm.qMesheny_Get.Open;
  Result:=_GPS_dm.qMesheny_Get.FieldByName('MeshenyName').AsString;
  lTargetQty:=_GPS_dm.qMesheny_Get.FieldByName('MeshenyCount').AsString;
  lPicture:=_GPS_dm.qMesheny_Get.FieldByName('PicturePath').AsString;
  _GPS_dm.qMesheny_Get.Close;
end;

function T_GPSTelemetry.GetTankIndexFromGPSId(const GPSId: integer): integer;
var
  i: integer;
begin
  Result := -1;
  for i:=1 to MaxOneVehicles do
    begin
      if Vehicles[i].Id = GPSId then
        begin
          Result := i;
          Exit;
        end;
    end;
end;

procedure T_GPSTelemetry.qInfoCalcFields(DataSet: TDataSet);
var lQty, lPic:string;
    i:integer;
begin
  for i:=1 to cShootingRubegQty do
    begin
      if (DataSet.FindField('Mish'+IntTostr(i)) <> nil)and
         (DataSet.FindField('cMish'+IntTostr(i)) <> nil) then
        DataSet.FieldByName('cMish'+IntTostr(i)).AsString := fTargetName(DataSet.FieldByName('Mish'+IntTostr(i)).AsString, lQty, lPic);
    end;
end;

procedure T_GPSTelemetry.qOtsechkiCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('cTimeMS').AsString := fConvertTime(DataSet.FieldByName('tmsec').AsString);
end;

procedure T_GPSTelemetry.rbEkipagClick(Sender: TObject);
begin
  {pShowTanksData(true);}
end;

procedure T_GPSTelemetry.rbOtsechkiClick(Sender: TObject);
begin
  {pShowTanksData(true);}
end;

procedure T_GPSTelemetry.rbShootingClick(Sender: TObject);
begin
  {pShowTanksData(true);}
end;

function  T_GPSTelemetry.fConvertTime(vTimeTank : string) : string;
var
   CurTime : TDateTime;
   HourT, MinT, SecT, MSecT : Word;
begin
   CurTime := EncodeTime(0, 0, 0, 0);
   CurTime := IncMilliSecond(CurTime, Max(StrToIntDef(vTimeTank, 0), 0));
   DecodeTime(CurTime, HourT, MinT, SecT, MSecT);

   Result:=VrToStrCROP(HourT, MinT, SecT, MSecT);
end;

function  T_GPSTelemetry.VrToStrCROP(Ho, Mi, Se, MSe : Integer; lShowMsec:boolean = false) : string;
var
  S, MS : string;
begin
  if MSe = 0   then MS:='000'                else
  if MSe < 10  then MS:='00' + IntToStr(MSe) else
  if MSe < 100 then MS:='0'  + IntToStr(MSe) else
                    MS:=IntToStr(MSe);

  if lShowMsec then
    begin
      MS:=Copy(MS,1,1);
      S:=IntToStr(Se)+'.'+MS;
    end
    else
      S:=IntToStr(Se);

  if (Se<10) and (((Mi > 0) or (Ho > 0)) or (not lShowMsec)) then
    S:='0'+S;

  if (Mi > 0) or (not lShowMsec) then
    begin
      S:=IntToStr(Mi)+':'+S;
    end
  else if Ho > 0 then
    S:=IntToStr(Mi)+':'+S;

  if Ho > 0 then
    begin
      if Mi<10 then S:='0'+S;
      S:=IntToStr(Ho)+':'+S;
    end;

  Result:=S;
end;

function T_GPSTelemetry.fFilePath(lFile:string):string;
var lPath:string;
begin
  lPath := ExtractFilePath(Application.ExeName);
  Result := Copy(lFile,length(lPath)+1,length(lFile));
end;

procedure T_GPSTelemetry.DBGrid4DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var lColor: TColor;
    i:integer;
    s:string;
begin
  lColor:= -1;

  if Column.FieldName = 'ColorValue' then
    lColor := StrToIntDef(Column.Field.AsString, clWhite);

  if lColor > -1 then
    begin
      (Sender as TDBGrid).Canvas.Brush.Color := lColor;
      (Sender as TDBGrid).DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
end;

procedure T_GPSTelemetry.DBGrid4DblClick(Sender: TObject);
begin
  if (Sender as TDBGrid).SelectedField.FieldName = 'ColorValue' then
    begin
      if ColorDialog1.Execute then
        begin
          qColorLoc.Edit;
          qColorLoc.FieldByName('ColorValue').AsInteger := ColorDialog1.Color;
          qColorLoc.Post;
          pRefreshLocal(nil);
        end;
    end
  else
  if (Sender as TDBGrid).SelectedField.FieldName = 'TexturePath' then
    begin
      OpenDialogTanks.InitialDir := ExtractFilePath(Application.ExeName);
      if OpenDialogTanks.Execute then
        begin
          qColorLoc.Edit;
          qColorLoc.FieldByName('TexturePath').AsString := fFilePath(OpenDialogTanks.FileName);
          qColorLoc.Post;
          pRefreshLocal(nil);
        end;
    end
  else
  if (Sender as TDBGrid).SelectedField.FieldName = 'PicturePath' then
    begin
      OpenDialogTanks.InitialDir := ExtractFilePath(Application.ExeName);
      if OpenDialogTanks.Execute then
        begin
          qColorLoc.Edit;
          qColorLoc.FieldByName('PicturePath').AsString := fFilePath(OpenDialogTanks.FileName);
          qColorLoc.Post;
          pRefreshLocal(nil);
        end;
    end;
end;

procedure T_GPSTelemetry.DBGrid5DblClick(Sender: TObject);
begin
  if (Sender as TDBGrid).SelectedField.FieldName = 'FlagImg' then
    begin
      OpenDialogTanks.InitialDir := ExtractFilePath(Application.ExeName);
      if OpenDialogTanks.Execute then
        begin
          qCountryLoc.Edit;
          qCountryLoc.FieldByName('FlagImg').AsString := fFilePath(OpenDialogTanks.FileName);
          qCountryLoc.Post;
          pRefreshLocal(nil);
        end;
    end;
end;

procedure T_GPSTelemetry.DBGrid6DblClick(Sender: TObject);
begin
  if (Sender as TDBGrid).SelectedField.FieldName = 'PicturePath' then
    begin
      OpenDialogTanks.InitialDir := ExtractFilePath(Application.ExeName);
      if OpenDialogTanks.Execute then
        begin
          qMeshenyLoc.Edit;
          qMeshenyLoc.FieldByName('PicturePath').AsString := fFilePath(OpenDialogTanks.FileName);
          qMeshenyLoc.Post;
          pRefreshLocal(nil);
        end;
    end;
end;

procedure T_GPSTelemetry.DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
begin
  if Button = nbInsert then
    (Sender as TDBNavigator).DataSource.DataSet.FieldByName('CountryName').Value := '...';
end;

procedure T_GPSTelemetry.DBNavigator2Click(Sender: TObject; Button: TNavigateBtn);
begin
  if Button = nbInsert then
    (Sender as TDBNavigator).DataSource.DataSet.FieldByName('ColorImg').Value := '...';
end;

procedure T_GPSTelemetry.DBNavigator3Click(Sender: TObject;  Button: TNavigateBtn);
begin
  if Button = nbInsert then
    (Sender as TDBNavigator).DataSource.DataSet.FieldByName('MeshenyName').Value := '...';
end;

procedure T_GPSTelemetry.dsTanksDataDataChange(Sender: TObject; Field: TField);
begin
  if not _GPS_dm.DBTanks.Connected then
    EXIT;

  if pnlEditGPS.Visible then
    cbEditGPS.Text:=qTanksData.FieldByName('GPSID').AsString;
end;

procedure T_GPSTelemetry.btnImportColorClick(Sender: TObject);
begin
  _GPS_dm.qImportSource.Close;
  _GPS_dm.qImportSource.SQL.Text := 'select *  from  tblColor';
  _GPS_dm.qImportSource.Open;
  while not _GPS_dm.qImportSource.Eof do
    begin
      _GPS_dm.qImportColor.Parameters.ParamByName('GroupID').Value:=_GPS_dm.qImportSource.FieldByName('GroupID').AsString;
      _GPS_dm.qImportColor.Parameters.ParamByName('GroupID').Value:=_GPS_dm.qImportSource.FieldByName('GroupID').AsString;
      _GPS_dm.qImportColor.Parameters.ParamByName('ColorID').Value:=_GPS_dm.qImportSource.FieldByName('ColorID').AsString;
      _GPS_dm.qImportColor.ExecSQL;
      _GPS_dm.qImportSource.Next;
    end;
  pRefreshLocal(nil);
end;

procedure T_GPSTelemetry.btnImportCountryClick(Sender: TObject);
begin
  _GPS_dm.qImportSource.Close;
  _GPS_dm.qImportSource.SQL.Text := 'select *  from  tblCountry';
  _GPS_dm.qImportSource.Open;
  while not _GPS_dm.qImportSource.Eof do
    begin
      _GPS_dm.qImportCountry.Parameters.ParamByName('GroupID').Value:=_GPS_dm.qImportSource.FieldByName('GroupID').AsString;
      _GPS_dm.qImportCountry.Parameters.ParamByName('CountryName').Value:=_GPS_dm.qImportSource.FieldByName('CountryName').AsString;
      _GPS_dm.qImportCountry.ExecSQL;
      _GPS_dm.qImportSource.Next;
    end;
  pRefreshLocal(nil);
end;

procedure T_GPSTelemetry.btnImportMeshenyClick(Sender: TObject);
begin
  _GPS_dm.qImportSource.Close;
  _GPS_dm.qImportSource.SQL.Text := 'select *  from  tblMesheny';
  _GPS_dm.qImportSource.Open;
  while not _GPS_dm.qImportSource.Eof do
    begin
      _GPS_dm.qImportMesheny.Parameters.ParamByName('GroupID').Value:=_GPS_dm.qImportSource.FieldByName('GroupID').AsString;
      _GPS_dm.qImportMesheny.Parameters.ParamByName('MeshenyName').Value:=_GPS_dm.qImportSource.FieldByName('MeshenyName').AsString;
      _GPS_dm.qImportMesheny.Parameters.ParamByName('MeshenyCount').Value:=_GPS_dm.qImportSource.FieldByName('MeshenyCount').AsString;
      _GPS_dm.qImportMesheny.Parameters.ParamByName('MeshenyID').Value:=_GPS_dm.qImportSource.FieldByName('MeshenyID').AsString;
      _GPS_dm.qImportMesheny.ExecSQL;
      _GPS_dm.qImportSource.Next;
    end;
  pRefreshLocal(nil);
end;

{
//==============================================================================
//========================   pArrayTexMsh_Refresh  =============================
//==============================================================================
procedure T_GPSTelemetry.pArrayTexMsh_Refresh(lReload: boolean = false);
var iRes: integer;
begin
  pArrayTexMsh_Create;
//  pArrayScenes_Create;     //создаём массив сцен
  if lReload then
    iRes:=ReloadScenes(0,nil,@Textures,nil,nil);//ReloadScenes(0,@Scenes,@Textures,@Meshes);

  sleep(5000); // спим пока двиг не перегрузит текстуры
end;

//==============================================================================
//========================   pArrayTexMsh_Create  =============================
//==============================================================================
procedure T_GPSTelemetry.pArrayTexMsh_Create;
  procedure ArrClear;
  var i,j:integer;
  begin
    for i:=0 to high(Textures) do
      for j:=0 to 255 do
        Textures[i].Text[j]:=#0;

    for i:=0 to high(Meshes) do
      for j:=0 to 255 do
        Meshes[i].Text[j]:=#0;
  end;

  procedure ArrCreate(DS:TADOQuery; var i, j: integer; lParam:string = ''; lParamValue:integer = 0);
  begin
    DS.Close;
    if lParam <> '' then
      DS.Parameters.ParamByName(lParam).Value:=lParamValue;
    DS.Open;
    while not DS.Eof do
      begin
        if trim(DS.FieldByName('Tex').AsString) <> '' then
          if AnsiUpperCase(trim(Copy(trim(DS.FieldByName('Tex').AsString),
                                     LastDelimiter('.',trim(DS.FieldByName('Tex').AsString))+1,
                                     3))) <> 'MSH' then
            begin
              StrPCopy(Textures[i].Text,DS.FieldByName('Tex').AsString);
              i:=i+1;
            end;
        if trim(DS.FieldByName('Msh').AsString) <> '' then
          if AnsiUpperCase(trim(Copy(trim(DS.FieldByName('Msh').AsString),
                                     LastDelimiter('.',trim(DS.FieldByName('Msh').AsString))+1,
                                     3))) = 'MSH' then
          begin
            StrPCopy(Meshes[j].Text,DS.FieldByName('Msh').AsString);
            j:=j+1;
          end;
        DS.Next;
      end;
  end;

var iTex, iMsh: integer;
begin
  ArrClear;
  iTex:=0;
  iMsh:=0;
  _GPS_dm.qTmp.SQL.Text:='select PicturePath as Tex, '' '' as Msh from tblMesheny';
  ArrCreate(_GPS_dm.qTmp,iTex,iMsh);
  _GPS_dm.qTmp.SQL.Text:='select PicturePath as Tex, '' '' as Msh from tblColor';
  ArrCreate(_GPS_dm.qTmp,iTex,iMsh);
  _GPS_dm.qTmp.SQL.Text:='select TexturePath as Tex, '' '' as Msh from tblColor';
  ArrCreate(_GPS_dm.qTmp,iTex,iMsh);
  _GPS_dm.qTmp.SQL.Text:='select FlagImg as Tex, '' '' as Msh from tblCountry';
  ArrCreate(_GPS_dm.qTmp,iTex,iMsh);
  _GPS_dm.qTmp.Close;

  Textures[iTex].Text := 'Resources\Scenes\VehicleStatus\Fra.dds';          inc(iTex);
  Textures[iTex].Text[0] := #0;
end;
}

procedure T_GPSTelemetry.btnReloadGraphicsClick(Sender: TObject);
begin
  {pArrayTexMsh_Refresh(true);}
end;

procedure T_GPSTelemetry.btnLoadGraphicsClick(Sender: TObject);
begin
  {pArrayTexMsh_Refresh; // создаём текстуры}
end;

{
procedure T_GPSTelemetry.pStartTelemetryScenes(Sender: TObject);
var  lColor : TVector;
     lOpenRec: boolean;
begin
try
  OpenRecords(nil);

//  lOpenRec := false;
  lColor.VSet( 1.0, 1.0, 1.0, 0.0 );
  if glScenaName_Shoot = nil then
    begin
//      if not lOpenRec then begin OpenRecords(nil); lOpenRec := true; end;

      PlayScene( 'Shoots', 0.0, 0, 0, 0, nil );
      glScenaName_Shoot := GetLastSceneName();

      if glScenaName_Shoot <> nil then
        begin
          SetObjectSpace( glScenaName_Shoot, 'Status', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
          SetObjectSpace( glScenaName_Shoot, 'Flag', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
        end;
    end;

  if glScenaName_Ekipag = nil then
    begin
//      if not lOpenRec then begin OpenRecords(nil); lOpenRec := true; end;

      PlayScene( 'Ekipag', 0.0, 0, 0, 0, nil );
      glScenaName_Ekipag := GetLastSceneName();

      if glScenaName_Ekipag <> nil then
        begin
          SetObjectSpace( glScenaName_Ekipag, 'Status', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
          SetObjectSpace( glScenaName_Ekipag, 'Flag', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
        end;
    end;

  if glScenaName_Otsechka = nil then
    begin
//      if not lOpenRec then begin OpenRecords(nil); lOpenRec := true; end;

      PlayScene( 'Otsechka', 0.0, 0, 0, 0, nil );
      glScenaName_Otsechka := GetLastSceneName();

      if glScenaName_Otsechka <> nil then
        begin
          SetObjectSpace( glScenaName_Otsechka, 'Status', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
          SetObjectSpace( glScenaName_Otsechka, 'Flag', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
        end;
    end;

  if glScenaName_Ekipag_2Tanks = nil then
    begin
//      if not lOpenRec then begin OpenRecords(nil); lOpenRec := true; end;

      PlayScene( 'Ekipag_2Tanks', 0.0, 0, 0, 0, nil );
      glScenaName_Ekipag_2Tanks := GetLastSceneName();

      if glScenaName_Ekipag_2Tanks <> nil then
        begin
          SetObjectSpace( glScenaName_Ekipag_2Tanks, 'Status', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
          SetObjectSpace( glScenaName_Ekipag_2Tanks, 'Flag', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
          SetObjectSpace( glScenaName_Ekipag_2Tanks, 'Status_B', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
          SetObjectSpace( glScenaName_Ekipag_2Tanks, 'Flag_B', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
        end;
    end;

  if glScenaName_Otsechka_2Tanks = nil then
    begin
//      if not lOpenRec then begin OpenRecords(nil); lOpenRec := true; end;

      PlayScene( 'Otsechka_2Tanks', 0.0, 0, 0, 0, nil );
      glScenaName_Otsechka_2Tanks := GetLastSceneName();

      if glScenaName_Otsechka_2Tanks <> nil then
        begin
          SetObjectSpace( glScenaName_Otsechka_2Tanks, 'Status', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
          SetObjectSpace( glScenaName_Otsechka_2Tanks, 'Flag', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
          SetObjectSpace( glScenaName_Otsechka_2Tanks, 'Status_B', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
          SetObjectSpace( glScenaName_Otsechka_2Tanks, 'Flag_B', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
        end;
    end;

  if glScenaName_Shoot_2Tanks = nil then
    begin
//      if not lOpenRec then begin OpenRecords(nil); lOpenRec := true; end;

      PlayScene( 'Shoots_2Tanks', 0.0, 0, 0, 0, nil );
      glScenaName_Shoot_2Tanks := GetLastSceneName();

      if glScenaName_Shoot_2Tanks <> nil then
        begin
          SetObjectSpace( glScenaName_Shoot_2Tanks, 'Status', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
          SetObjectSpace( glScenaName_Shoot_2Tanks, 'Flag', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
          SetObjectSpace( glScenaName_Shoot_2Tanks, 'Status_B', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
          SetObjectSpace( glScenaName_Shoot_2Tanks, 'Flag_B', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
        end;
    end;

//  if lOpenRec then CloseRecords( nil );
finally
  CloseRecords( nil );
end;

end;
}

{
procedure T_GPSTelemetry.pCloseScenaTelemetry(Sender: TObject);
var  lOpenRec: boolean;
begin
try
  OpenRecords(nil);
//  lOpenRec := false;
  if glScenaName_Shoot <> nil then
    begin
//      if not lOpenRec then begin OpenRecords(nil); lOpenRec := true; end;
      CloseScene( glScenaName_Shoot, 0.0 );
      glScenaName_Shoot := nil;
    end;
  if glScenaName_Ekipag <> nil then
    begin
//      if not lOpenRec then begin OpenRecords(nil); lOpenRec := true; end;
      CloseScene( glScenaName_Ekipag, 0.0 );
      glScenaName_Ekipag := nil;
    end;
  if glScenaName_Otsechka <> nil then
    begin
//      if not lOpenRec then begin OpenRecords(nil); lOpenRec := true; end;
      CloseScene( glScenaName_Otsechka, 0.0 );
      glScenaName_Otsechka := nil;
    end;
  if glScenaName_Ekipag_2Tanks <> nil then
    begin
//      if not lOpenRec then begin OpenRecords(nil); lOpenRec := true; end;
      CloseScene( glScenaName_Ekipag_2Tanks, 0.0 );
      glScenaName_Ekipag_2Tanks := nil;
    end;
  if glScenaName_Otsechka_2Tanks <> nil then
    begin
//      if not lOpenRec then begin OpenRecords(nil); lOpenRec := true; end;
      CloseScene( glScenaName_Otsechka_2Tanks, 0.0 );
      glScenaName_Otsechka_2Tanks := nil;
    end;
  if glScenaName_Shoot_2Tanks <> nil then
    begin
//      if not lOpenRec then begin OpenRecords(nil); lOpenRec := true; end;
      CloseScene( glScenaName_Shoot_2Tanks, 0.0 );
      glScenaName_Shoot_2Tanks := nil;
    end;
//  if lOpenRec then CloseRecords( nil );
finally
  CloseRecords( nil );
end;

end;
}

procedure T_GPSTelemetry.pInitialVars(Sender: TObject);
begin
  glMoveDistanceM:=eMoveDistanceM.Text;
  glSpeedKMH:=eSpeedKMH.Text;
  glMeshenTexture_Clear:=eMeshenTexture_Clear.Text;
  glQuantityOtsechekOnTitle:=speQuantityOtsechekOnTitle.Value;
  glQuantityPlayersOnTitle:=speQuantityPlayersOnTitle.Value;
  glQuantityMisheniOnTitle:=speQuantityMisheniOnTitle.Value;
end;

{
procedure T_GPSTelemetry.pShowScenaShoots(iTankIndex:integer; lOpenClose_Active: boolean = true);
var i, iShotHitQty, iHitTargetQty, iTargetQty, j, iRes, iQtyMisheniOnTitle:integer;
    Names : array [0..1] of TName;
    lStr:string;
    lColor : TVector;
begin
  pInitialVars(nil);

  if glScenaName_Shoot <> nil then
    begin
      if lOpenClose_Active then OpenRecords( nil );

      if iTankIndex = 0 then
        lColor.VSet( 1.0, 1.0, 1.0, 0.0 )
        else
        lColor.VSet( 1.0, 1.0, 1.0, 1.0 );

      SetObjectSpace( glScenaName_Shoot, 'Status', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
      SetObjectSpace( glScenaName_Shoot, 'Flag', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );

      if iTankIndex = 0 then
        begin
          if lOpenClose_Active then CloseRecords( nil );
          EXIT;
        end;

      for i:=0 to high(Names) do
        for j:=0 to 63 do
          Names[i].Text[j]:=#0;

      // команда
      UpdateSurfaceElement( glScenaName_Shoot, 'Status', 1, 1,
                            nil,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].TeamName)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // танчик
      iRes:=UpdateSurfaceElement( glScenaName_Shoot, 'Status', 3, 1,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].TankSmallPicture)),
                            nil,
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // флаг
      StrCopy(Names[0].Text,'Flag');
      Names[1].Text:=#0;
      iRes:=AssignObjectsTexture( glScenaName_Shoot,
                            @Names,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].CountryFlag)),
                            1,
                            0.0, 0.0, 0, nil );

      // расстояние
      if not chbShowDistance.Checked then
        UpdateSurfaceElement( glScenaName_Shoot, 'Status', 4, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
        else
        UpdateSurfaceElement( glScenaName_Shoot, 'Status', 4, 1,
                            nil,
                            PAnsiChar(AnsiString(FormatFloat('0',Vehicles[iTankIndex].MoveDistance) + glMoveDistanceM)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // скорость
      if not chbShowSpeed.Checked then
        UpdateSurfaceElement( glScenaName_Shoot, 'Status', 5, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
        else
        UpdateSurfaceElement( glScenaName_Shoot, 'Status', 5, 1,
                            nil,
                            PAnsiChar(AnsiString(FormatFloat('0',Vehicles[iTankIndex].TrueSpeed) + glSpeedKMH)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );


      // мишени
      iQtyMisheniOnTitle:=glQuantityMisheniOnTitle;      // количество отсечек на титре
      j:=0;
      for i:=0 to high(VehiclesData[iTankIndex].Shooting) do
        begin
          if VehiclesData[iTankIndex].Shooting[i].TargetType = '' then
            break;

          // мишеньки картинки
          iRes:=UpdateSurfaceElement( glScenaName_Shoot, 'Status', 6+i, 1,
                                PAnsiChar(AnsiString(VehiclesData[iTankIndex].Shooting[i].TargetPicture)),
                                nil,
                                COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

          // количество сбитых из всего мишеней
          iTargetQty := StrToIntDef(VehiclesData[iTankIndex].Shooting[i].TargetQuantity, 0);
          iShotHitQty := StrToIntDef(VehiclesData[iTankIndex].Shooting[i].ShotHit, 0);

          iHitTargetQty := Min( iShotHitQty , iTargetQty );            // проверяем, что кол-во сбитых мишеней не больше общего кол-ва мишеней

          lStr := ' ';
          if (StrToIntDef(VehiclesData[iTankIndex].Shooting[i].ShotAll, 0) <> 0)and(iTargetQty > 0) then  // если были выстелы, значит есть результат
            lStr := IntToStr(iHitTargetQty)+'/'+IntToStr(iTargetQty);

          UpdateSurfaceElement( glScenaName_Shoot, 'Status', 9+i, 1, nil, PAnsiChar(AnsiString(lStr)),
                                COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

          inc(j);
        end;

      // очищаем пустые строки мишеней на титре
      for i := j to iQtyMisheniOnTitle - 1 do
        begin
          // чистим мишеньки
          iRes:=UpdateSurfaceElement( glScenaName_Shoot, 'Status', 6+i, 1,
                                PAnsiChar(AnsiString(glMeshenTexture_Clear)),
                                nil,
                                COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
          // чистим количество
          iRes:=UpdateSurfaceElement( glScenaName_Shoot, 'Status', 9+i, 1,
                                      nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
        end;
    end;

  if lOpenClose_Active then CloseRecords( nil );
end;

procedure T_GPSTelemetry.pShowScenaEkipag(iTankIndex:integer; lOpenClose_Active: boolean = true);
var i, j, iRes, iQtyPlayersOnEkipage:integer;
    Names : array [0..1] of TName;
    lStr:string;
    lColor : TVector;
begin
  pInitialVars(nil);

  if glScenaName_Ekipag <> nil then
    begin
      if lOpenClose_Active then OpenRecords( nil );

      if iTankIndex = 0 then
        lColor.VSet( 1.0, 1.0, 1.0, 0.0 )
        else
        lColor.VSet( 1.0, 1.0, 1.0, 1.0 );

      SetObjectSpace( glScenaName_Ekipag, 'Status', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
      SetObjectSpace( glScenaName_Ekipag, 'Flag', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );

      if iTankIndex = 0 then
        begin
          if lOpenClose_Active then CloseRecords( nil );
          EXIT;
        end;

      for i:=0 to high(Names) do
        for j:=0 to 63 do
          Names[i].Text[j]:=#0;

      // команда
      UpdateSurfaceElement( glScenaName_Ekipag, 'Status', 1, 1,
                            nil,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].TeamName)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // флаг
      StrCopy(Names[0].Text,'Flag');
      Names[1].Text:=#0;
      iRes:=AssignObjectsTexture( glScenaName_Ekipag,
                            @Names,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].CountryFlag)),
                            1,
                            0.0, 0.0, 0, nil );

      // танчик
      iRes:=UpdateSurfaceElement( glScenaName_Ekipag, 'Status', 6, 1,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].TankSmallPicture)),
                            nil,
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // расстояние
      if not chbShowDistance.Checked then
        UpdateSurfaceElement( glScenaName_Ekipag, 'Status', 7, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
        else
        UpdateSurfaceElement( glScenaName_Ekipag, 'Status', 7, 1,
                            nil,
                            PAnsiChar(AnsiString(FormatFloat('0',Vehicles[iTankIndex].MoveDistance) + glMoveDistanceM)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // скорость
      if not chbShowSpeed.Checked then
        UpdateSurfaceElement( glScenaName_Ekipag, 'Status', 8, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
        else
        UpdateSurfaceElement( glScenaName_Ekipag, 'Status', 8, 1,
                            nil,
                            PAnsiChar(AnsiString(FormatFloat('0',Vehicles[iTankIndex].TrueSpeed) + glSpeedKMH)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // экипаж
      iQtyPlayersOnEkipage:=glQuantityPlayersOnTitle;      // количество отсечек на титре
      j:=0;
      for i:=0 to high(VehiclesData[iTankIndex].Players) do
        begin
          if VehiclesData[iTankIndex].Players[i].PlayerName = '' then
            break;

          // фамилии
          iRes:=UpdateSurfaceElement( glScenaName_Ekipag, 'Status', 3+i, 1,
                                nil,
                                PAnsiChar(AnsiString(VehiclesData[iTankIndex].Players[i].PlayerName)),
                                COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

          inc(j);
        end;

      // очищаем пустые фамилии на титре
      for i := j to iQtyPlayersOnEkipage - 1 do
        begin
          iRes:=UpdateSurfaceElement( glScenaName_Ekipag, 'Status', 3+i, 1,
                                      nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
        end;
    end;

  if lOpenClose_Active then CloseRecords( nil );
end;

procedure T_GPSTelemetry.pShowScenaOtsechka(iTankIndex:integer; lOpenClose_Active: boolean = true);
var i, j, iRes:integer;
    Names : array [0..1] of TName;
    lColor : TVector;
    iQtyOts, iQtyOtsOnTitle:integer;
    iResult, iRemainder: Word;
begin
  pInitialVars(nil);

  if glScenaName_Otsechka <> nil then
    begin
      if lOpenClose_Active then OpenRecords( nil );

      if iTankIndex = 0 then
        lColor.VSet( 1.0, 1.0, 1.0, 0.0 )
        else
        lColor.VSet( 1.0, 1.0, 1.0, 1.0 );

      SetObjectSpace( glScenaName_Otsechka, 'Status', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
      SetObjectSpace( glScenaName_Otsechka, 'Flag', nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );

      if iTankIndex = 0 then
        begin
          if lOpenClose_Active then CloseRecords( nil );
          EXIT;
        end;

      for i:=0 to high(Names) do
        for j:=0 to 63 do
          Names[i].Text[j]:=#0;

      // команда
      UpdateSurfaceElement( glScenaName_Otsechka, 'Status', 1, 1,
                            nil,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].TeamName)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // флаг
      StrCopy(Names[0].Text,'Flag');
      Names[1].Text:=#0;
      iRes:=AssignObjectsTexture( glScenaName_Otsechka,
                            @Names,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].CountryFlag)),
                            1,
                            0.0, 0.0, 0, nil );

      // танчик
      iRes:=UpdateSurfaceElement( glScenaName_Otsechka, 'Status', 3, 1,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].TankSmallPicture)),
                            nil,
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // расстояние
      if not chbShowDistance.Checked then
        UpdateSurfaceElement( glScenaName_Otsechka, 'Status', 4, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
        else
        UpdateSurfaceElement( glScenaName_Otsechka, 'Status', 4, 1,
                            nil,
                            PAnsiChar(AnsiString(FormatFloat('0',Vehicles[iTankIndex].MoveDistance) + glMoveDistanceM)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // скорость
      if not chbShowSpeed.Checked then
        UpdateSurfaceElement( glScenaName_Otsechka, 'Status', 5, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
        else
        UpdateSurfaceElement( glScenaName_Otsechka, 'Status', 5, 1,
                            nil,
                            PAnsiChar(AnsiString(FormatFloat('0',Vehicles[iTankIndex].TrueSpeed) + glSpeedKMH)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // отсечки
      iQtyOts:=0;
      for i:=0 to high(VehiclesData[iTankIndex].Intermediate) do
        begin
          if (VehiclesData[iTankIndex].Intermediate[i].NumOtsec <> '') then
            inc(iQtyOts);
        end;

      iQtyOtsOnTitle:=glQuantityOtsechekOnTitle;      // количество отсечек на титре

      DivMod(iQtyOts, iQtyOtsOnTitle, iResult, iRemainder);

      j:=0;
      for i:=0 to iQtyOts - 1 do
        begin
          if ((i + 1) > (iResult * iQtyOtsOnTitle))
             or
             (((iRemainder = 0)and(iResult > 0))and((i + 1) > (iQtyOts - iQtyOtsOnTitle))) then
            begin
              // название отсечки
              iRes:=UpdateSurfaceElement( glScenaName_Otsechka, 'Status', 6+j, 1,
                                          nil,
                                          PAnsiChar(AnsiString('ОТСЕЧКА '+VehiclesData[iTankIndex].Intermediate[i].NumOtsec)),
                                          COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
              // время отсечки
              iRes:=UpdateSurfaceElement( glScenaName_Otsechka, 'Status', 9+j, 1,
                                          nil,
                                          PAnsiChar(AnsiString(fConvertTime(VehiclesData[iTankIndex].Intermediate[i].TimeMSec))),
                                          COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
              inc(j);
            end;
        end;

      // очищаем пустые отсечки на титре
      for i := j to iQtyOtsOnTitle - 1 do
        begin
          // название отсечки
          iRes:=UpdateSurfaceElement( glScenaName_Otsechka, 'Status', 6+i, 1,
                                      nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
          // время отсечки
          iRes:=UpdateSurfaceElement( glScenaName_Otsechka, 'Status', 9+i, 1,
                                      nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
        end;
    end;

  if lOpenClose_Active then CloseRecords( nil );
end;
}

{
procedure T_GPSTelemetry.pShowTankSpeed(Sender: TObject);
var pColor : TVector;
begin
  if (glGPS_OnShow = 0)and(not btnShowUnShowTitle2Tanks.Down) then
    EXIT;
try
  OpenRecords( nil );

  if glScenaName_Otsechka <> nil then
    begin
      GetObjectSpace( glScenaName_Otsechka, 'Status', nil, nil, nil, nil, nil, @pColor, 0, nil );
      if pColor.w > 0 then
        begin
          // расстояние
          if not chbShowDistance.Checked then
            UpdateSurfaceElement( glScenaName_Otsechka, 'Status', 4, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
            else
            UpdateSurfaceElement( glScenaName_Otsechka, 'Status', 4, 1,
                                nil,
                                PAnsiChar(AnsiString(FormatFloat('0',Vehicles[glGPS_OnShow].MoveDistance) + glMoveDistanceM)),
                                COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
          // скорость
          if not chbShowSpeed.Checked then
            UpdateSurfaceElement( glScenaName_Otsechka, 'Status', 5, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
            else
            UpdateSurfaceElement( glScenaName_Otsechka, 'Status', 5, 1,
                                nil,
                                PAnsiChar(AnsiString(FormatFloat('0',Vehicles[glGPS_OnShow].TrueSpeed) + glSpeedKMH)),
                                COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
        end;
    end;

  if glScenaName_Ekipag <> nil then
    begin
      GetObjectSpace( glScenaName_Ekipag, 'Status', nil, nil, nil, nil, nil, @pColor, 0, nil );
      if pColor.w > 0 then
        begin
          // расстояние
          if not chbShowDistance.Checked then
            UpdateSurfaceElement( glScenaName_Ekipag, 'Status', 7, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
            else
            UpdateSurfaceElement( glScenaName_Ekipag, 'Status', 7, 1,
                                nil,
                                PAnsiChar(AnsiString(FormatFloat('0',Vehicles[glGPS_OnShow].MoveDistance) + glMoveDistanceM)),
                                COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

          // скорость
          if not chbShowSpeed.Checked then
            UpdateSurfaceElement( glScenaName_Ekipag, 'Status', 8, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
            else
            UpdateSurfaceElement( glScenaName_Ekipag, 'Status', 8, 1,
                                nil,
                                PAnsiChar(AnsiString(FormatFloat('0',Vehicles[glGPS_OnShow].TrueSpeed) + glSpeedKMH)),
                                COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
        end;
    end;

  if glScenaName_Shoot <> nil then
    begin
      GetObjectSpace( glScenaName_Shoot, 'Status', nil, nil, nil, nil, nil, @pColor, 0, nil );
      if pColor.w > 0 then
        begin
          // расстояние
          if not chbShowDistance.Checked then
            UpdateSurfaceElement( glScenaName_Shoot, 'Status', 4, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
            else
            UpdateSurfaceElement( glScenaName_Shoot, 'Status', 4, 1,
                                nil,
                                PAnsiChar(AnsiString(FormatFloat('0',Vehicles[glGPS_OnShow].MoveDistance) + glMoveDistanceM)),
                                COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

          // скорость
          if not chbShowSpeed.Checked then
            UpdateSurfaceElement( glScenaName_Shoot, 'Status', 5, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
            else
            UpdateSurfaceElement( glScenaName_Shoot, 'Status', 5, 1,
                                nil,
                                PAnsiChar(AnsiString(FormatFloat('0',Vehicles[glGPS_OnShow].TrueSpeed) + glSpeedKMH)),
                                COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
        end;
    end;


  if btnShowUnShowTitle2Tanks.Down then
    begin
      if rbShowEkipag2Tanks.Checked then
        begin
          pUpdateSpeed_2Tanks(glScenaName_Ekipag_2Tanks, 1, glGPS1_OnShow, 7, 8);
          pUpdateSpeed_2Tanks(glScenaName_Ekipag_2Tanks, 2, glGPS2_OnShow, 7, 8);
        end
      else
      if rbShowOtsechki2Tanks.Checked then
        begin
          pUpdateSpeed_2Tanks(glScenaName_Otsechka_2Tanks, 1, glGPS1_OnShow, 4, 5);
          pUpdateSpeed_2Tanks(glScenaName_Otsechka_2Tanks, 2, glGPS2_OnShow, 4, 5);
        end
      else
      if rbShowShooting2Tanks.Checked then
        begin
          pUpdateSpeed_2Tanks(glScenaName_Shoot_2Tanks, 1, glGPS1_OnShow, 4, 5);
          pUpdateSpeed_2Tanks(glScenaName_Shoot_2Tanks, 2, glGPS2_OnShow, 4, 5);
        end;
    end;

finally
  CloseRecords( nil );
end;

end;

procedure T_GPSTelemetry.pUpdateSpeed_2Tanks(lScenaName: PAnsiChar; iNum, iGPS, iStrNumDist, iStrNumSpeed : integer);
var pColor : TVector;
begin
  if lScenaName <> nil then
    begin
      GetObjectSpace( lScenaName, PAnsiChar(AnsiString(fObjName('Status',iNum))), nil, nil, nil, nil, nil, @pColor, 0, nil );
      if pColor.w > 0 then
        begin
          // расстояние
          if not chbShowDistance.Checked then
            UpdateSurfaceElement( lScenaName, PAnsiChar(AnsiString(fObjName('Status',iNum))), iStrNumDist, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
            else
            UpdateSurfaceElement( lScenaName, PAnsiChar(AnsiString(fObjName('Status',iNum))), iStrNumDist, 1,
                                nil,
                                PAnsiChar(AnsiString(FormatFloat('0',Vehicles[iGPS].MoveDistance) + glMoveDistanceM)),
                                COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

          // скорость
          if not chbShowSpeed.Checked then
            UpdateSurfaceElement( lScenaName, PAnsiChar(AnsiString(fObjName('Status',iNum))), iStrNumSpeed, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
            else
            UpdateSurfaceElement( lScenaName, PAnsiChar(AnsiString(fObjName('Status',iNum))), iStrNumSpeed, 1,
                                nil,
                                PAnsiChar(AnsiString(FormatFloat('0',Vehicles[iGPS].TrueSpeed) + glSpeedKMH)),
                                COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
        end;
    end;
end;

procedure T_GPSTelemetry.pUnShowAllScenes(Sender: TObject);
begin
  pShowScenaShoots(0, false);
  pShowScenaEkipag(0, false);
  pShowScenaOtsechka(0, false);
end;
}

procedure T_GPSTelemetry.btnMeshenTexture_ClearClick(Sender: TObject);
begin
  OpenDialogTanks.InitialDir := ExtractFilePath(Application.ExeName);
  if OpenDialogTanks.Execute then
    eMeshenTexture_Clear.Text := fFilePath(OpenDialogTanks.FileName);
end;

procedure T_GPSTelemetry.btnShooting1Click(Sender: TObject);
{var i, j: integer;}
begin
  {
  OpenRecords( nil );

  pUnShowAllScenes(nil);

  if (Sender as TSpeedButton) = btnShooting1 then j:=1 else
  if (Sender as TSpeedButton) = btnShooting2 then j:=2 else
  if (Sender as TSpeedButton) = btnShooting3 then j:=3 else
  if (Sender as TSpeedButton) = btnShooting4 then j:=4 ;

  i:=0;
  if (Sender as TSpeedButton).Down then
    i:=glArrColorGPS[j].iGPS;//i:=FourTanks[j];
  pShowScenaShoots(i, false);

  glGPS_OnShow := i;

  CloseRecords( nil );
  }
end;

procedure T_GPSTelemetry.btnEkipag1Click(Sender: TObject);
{var i, j: integer;}
begin
  {
  OpenRecords( nil );

  pUnShowAllScenes(nil);

  if (Sender as TSpeedButton) = btnEkipag1 then j:=1 else
  if (Sender as TSpeedButton) = btnEkipag2 then j:=2 else
  if (Sender as TSpeedButton) = btnEkipag3 then j:=3 else
  if (Sender as TSpeedButton) = btnEkipag4 then j:=4 ;

  i:=0;
  if (Sender as TSpeedButton).Down then
    i:=glArrColorGPS[j].iGPS;//i:=FourTanks[j];
  pShowScenaEkipag(i, false);

  glGPS_OnShow := i;

  CloseRecords( nil );
  }
end;

procedure T_GPSTelemetry.btnOtsechka1Click(Sender: TObject);
{var i, j: integer;}
begin
  {
  OpenRecords( nil );

  pUnShowAllScenes(nil);

  if (Sender as TSpeedButton) = btnOtsechka1 then j:=1 else
  if (Sender as TSpeedButton) = btnOtsechka2 then j:=2 else
  if (Sender as TSpeedButton) = btnOtsechka3 then j:=3 else
  if (Sender as TSpeedButton) = btnOtsechka4 then j:=4 ;

  i:=0;
  if (Sender as TSpeedButton).Down then
    i:=glArrColorGPS[j].iGPS;//i:=FourTanks[j];
  pShowScenaOtsechka(i, false);

  glGPS_OnShow := i;

  CloseRecords( nil );
  }
end;

{
procedure T_GPSTelemetry.pSetCamera(i, iNumCam: integer);
var lCheckBox : TCheckBox;
    lStr : string;
begin
    //  Наведём камеру на танк(и)
    lStr := 'TankBox' + IntToStr(i);
    lCheckBox := TCheckBox( MainForm.Poligon2DGroupBox.FindChildControl( lStr ) );
    lCheckBox.Checked := true;

    if iNumCam = 1 then
      MainForm.DirectCamButtonClick(MainForm.DirectCamButton)
    else
    if iNumCam = 2 then
      MainForm.DirectCamButton2Click(MainForm.DirectCamButton2);
end;
}

{
procedure T_GPSTelemetry.btnCamera11Click(Sender: TObject);
var lEdit : TEdit;
    lStr : string;
    i,j,k:integer;
    lBtn: TSpeedButton;
    lCheckBox:TCheckBox;
begin
  //  Наведём камеру на танк(и)
  for i:= 1 to 2 do
    for j:=1 to MaxOneVehicles do
      begin
        if glArrBtnSetCamera[i,j] = (Sender as TSpeedButton) then
          begin
            if (Sender as TSpeedButton).Down then
              for k:=1 to MaxOneVehicles do
                begin
                  lStr := 'Tank' + IntToStr(k) + 'Edit';
                  lEdit := TEdit( MainForm.Poligon2DGroupBox.FindChildControl( lStr ) );     // находим окошко с id GPS
                  if trim(lEdit.Text) = IntToStr(glArrColorGPS[j].iGPS) then
                    pSetCamera(k,i);
                end
              else
              pUnSetCamerasDists(nil);

            break;
          end;
      end;
end;
}

{
procedure T_GPSTelemetry.btnMainViewClick(Sender: TObject);
begin
  MainForm.GeneralViewButtonClick(MainForm.GeneralViewButton);
end;
}

function fTankCheckBoxCecked: integer;
var lEdit : TEdit;
    lStr : string;
    i,j:integer;
    lCheckBox:TCheckBox;
begin
  j:=0;
              for i:=1 to MaxOneVehicles do
                begin
                  lStr := 'TankBox' + IntToStr(i);
                  lCheckBox := TCheckBox( MainForm.Poligon2DGroupBox.FindChildControl( lStr ) );
                  if lCheckBox.Checked then
                    inc(j);
                end;
  Result := j;
end;

procedure T_GPSTelemetry.btnDist1Click(Sender: TObject);
{var lEdit : TEdit;
    lStr : string;
    i,j:integer;
    lBtn: TSpeedButton;
    lCheckBox:TCheckBox;}
begin
  {
  for i:= 1 to MaxOneVehicles do
      begin
        if glArrDist[i] = (Sender as TSpeedButton) then
          begin
            if (Sender as TSpeedButton).Down then
              for j:=1 to MaxOneVehicles do
                begin
                  lStr := 'Tank' + IntToStr(j) + 'Edit';
                  lEdit := TEdit( MainForm.Poligon2DGroupBox.FindChildControl( lStr ) );     // находим окошко с id GPS
                  if trim(lEdit.Text) = IntToStr(glArrColorGPS[i].iGPS) then
                    begin
                      lStr := 'TankBox' + IntToStr(j);
                      lCheckBox := TCheckBox( MainForm.Poligon2DGroupBox.FindChildControl( lStr ) );

                      if fTankCheckBoxCecked < 2 then
                        lCheckBox.Checked := true
                      else
                      if fTankCheckBoxCecked > 2 then
                        pUnSetCamerasDists(nil);

                      if fTankCheckBoxCecked = 2 then
                        MainForm.DistButtonClick(MainForm.DistButton);

                    end;
                end
              else
              pUnSetCamerasDists(nil);

            break;
          end;
      end;
  }
end;

{
procedure T_GPSTelemetry.pCloseTitles2Tanks(Sender: TObject);
begin
  if btnShowUnShowTitle2Tanks.Down then
    begin
      btnShowUnShowTitle2Tanks.Down := false;
      btnShowUnShowTitle2TanksClick(btnShowUnShowTitle2Tanks);
    end;
end;
}

procedure T_GPSTelemetry.pUnSetDist(Sender: TObject);
{var lStr : string;
    i:integer;
    lCheckBox:TCheckBox;}
begin
  {
  for i:= 1 to MaxOneVehicles do
      glArrDist[i].Down:=false;
  for i:=1 to MaxOneVehicles do
    begin
      lStr := 'TankBox' + IntToStr(i);
      lCheckBox := TCheckBox( MainForm.Poligon2DGroupBox.FindChildControl( lStr ) );
      lCheckBox.Checked := false;
    end;
  MainForm.DetachCamButtonClick(MainForm.DetachCamButton);

  pCloseTitles2Tanks(nil);
  }
end;

procedure T_GPSTelemetry.btnUnSetCamerasClick(Sender: TObject);
begin
  {pUnSetCamerasDists(nil);}
end;

procedure T_GPSTelemetry.pUnSetCamerasDists(Sender: TObject);
{
var lStr : string;
    i,j,k:integer;
    lBtn: TSpeedButton;
    lCheckBox:TCheckBox;
}
begin
  {
  for i:= 1 to 2 do
    for j:=1 to MaxOneVehicles do
      glArrBtnSetCamera[i,j].Down:=false;
  for i:= 1 to MaxOneVehicles do
      glArrDist[i].Down:=false;
  for i:=1 to MaxOneVehicles do
    begin
      lStr := 'TankBox' + IntToStr(i);
      lCheckBox := TCheckBox( MainForm.Poligon2DGroupBox.FindChildControl( lStr ) );
      lCheckBox.Checked := false;
    end;
  MainForm.DetachCamButtonClick(MainForm.DetachCamButton);

  pCloseTitles2Tanks(nil);
  }
end;

function T_GPSTelemetry.fTankForColor(lColor:string; var TeamName:string):integer;
begin
  Result:=0;

  if not _GPS_dm.DBTanks.Connected then
    EXIT;

  TeamName:='';
  _GPS_dm.qTankForColor.Close;
  _GPS_dm.qTankForColor.Parameters.ParamByName('TeamColorID').Value := lColor;
  _GPS_dm.qTankForColor.Open;
  Result:=StrToIntDef(_GPS_dm.qTankForColor.FieldByName('GPSID').AsString, 0);
  TeamName:=_GPS_dm.qTankForColor.FieldByName('TeamName').AsString;
  _GPS_dm.qTankForColor.Close;
end;

function T_GPSTelemetry.fNumColumnBtnForGPS(idGPS:integer):integer;
var i:integer;
begin
  Result := 0;
  for i:=1 to high(glArrColorGPS) do
    if glArrColorGPS[i].iGPS = idGPS then
      begin
        Result := i;
        break;
      end;
end;

function T_GPSTelemetry.fNumColumnBtnForColor(ColorID:string):integer;
var i:integer;
begin
  Result := 0;
  for i:=1 to high(glArrColorGPS) do
    if trim(glArrColorGPS[i].sColor) = trim(ColorID) then
      begin
        Result := i;
        break;
      end;
end;

procedure T_GPSTelemetry.pRefreshButtons(Sender: TObject);
var i, idGPS: integer;
    lTeamName: string;
    lColor : TColor;
    dwColor: DWord;
    JTPColor: TJTPColor;
    VehIdx: integer;
    j, iCol: integer;
    iSplMax, i1, j1: integer;
    iResult, iRemainder: Word;
    iTargetQty, iShotHitQty, iHitTargetQty : integer;
    iHitTargetTotal: integer;
    lStr: string;
    doRec: boolean;
begin
  if not _GPS_dm.DBLocal.Connected then
    EXIT;

  for i := 1 to MaxOneVehicles do
    glArrGPS[i].Text := '';

  qColorLoc.Close;
  qColorLoc.Open;
  i:=1;
  while not qColorLoc.Eof do
    begin
      glArrColorGPS[i].iNum := i;
      glArrColorGPS[i].iGPS := fTankForColor(qColorLoc.FieldByName('ColorID').AsString, lTeamName);
      glArrColorGPS[i].sColor := qColorLoc.FieldByName('ColorID').AsString;
      glArrColorGPS[i].vColor := StrToIntDef(qColorLoc.FieldByName('ColorValue').AsString, clWhite);
      glArrColorGPS[i].TeamName := lTeamName;
      VehIdx := GetTankIndexFromGPSId(glArrColorGPS[i].iGPS);
      if (VehIdx > 0) and (VehIdx <= MAX_VEHICLES) then
        begin
          dwColor := Vcl.Graphics.ColorToRGB(glArrColorGPS[i].vColor);
          JTPColor.VSet(GetRValue(dwColor)/255, GetGValue(dwColor)/255, GetBValue(dwColor)/255, 1);
          doRec := (Vehicles[VehIdx].ModelName.text[0] <> #0);
          if doRec then OpenRecords(0, nil);
          Vehicles[VehIdx].SetColor(JTPColor);
          if doRec then CloseRecords(0, nil);
        end;

      if i <= MaxOneVehicles then
        begin
          glArrTeams[i].Text := glArrColorGPS[i].TeamName;
          // glArrTeams[i].Color := glArrColorGPS[i].vColor;
          CaptionParamStorage.SetParamDataV(cpiTeam_name, i, glArrTeams[i].Text);

          glArrShapeTeam[i].Brush.Color := glArrColorGPS[i].vColor;
          glArrShapeTeam1[i].Brush.Color := glArrColorGPS[i].vColor;

          glArrGPS[i].Text:=IntToStr(glArrColorGPS[i].iGPS);
          CaptionParamStorage.SetParamDataV(cpiGPS_id, i, glArrGPS[i].Text);
          glArrGPS[i].Color := glArrColorGPS[i].vColor;
          CaptionParamStorage.SetParamDataV(cpiColor, i, glArrColorGPS[i].sColor);

          if (VehIdx > 0) and (VehIdx <= MaxOneVehicles) then
            begin
              // Crew
              for j:=1 to cEkipagCount do
                begin
                  glArrEkipage[i,j].Text := VehiclesData[VehIdx].Players[j-1].PlayerName;
                  case j of
                    1: CaptionParamStorage.SetParamDataV(cpiName1, i, glArrEkipage[i,j].Text);
                    2: CaptionParamStorage.SetParamDataV(cpiName2, i, glArrEkipage[i,j].Text);
                    3: CaptionParamStorage.SetParamDataV(cpiName3, i, glArrEkipage[i,j].Text);
                  end;
                end;

              // Splits
              iSplMax:=0;
              for i1:=0 to high(VehiclesData[VehIdx].Intermediate) do
                begin
                  if VehiclesData[VehIdx].Intermediate[i1].NumOtsec <> '' then
                    iSplMax := i1 + 1;
                end;
              DivMod(iSplMax, cOtsechkiCount, iResult, iRemainder);
              for i1:=1 to iRemainder do
                begin
                  j1 := iResult + i1 - 1;
                  if VehiclesData[VehIdx].Intermediate[j1].NumOtsec <> '' then
                    glArrOtsechka[i,i1].Text :=
                      fConvertTime(VehiclesData[VehIdx].Intermediate[j1].TimeMSec);
                end;

              // Targets
              iHitTargetTotal := 0;
              for j:=1 to cShootsCount do
                if VehiclesData[VehIdx].Shooting[j-1].TargetType <> '' then
                  begin
                    // количество сбитых из всего мишеней
                    iTargetQty := StrToIntDef(VehiclesData[VehIdx].Shooting[j-1].TargetQuantity, 0);
                    iShotHitQty := StrToIntDef(VehiclesData[VehIdx].Shooting[j-1].ShotHit, 0);
                    iHitTargetQty := Min(iShotHitQty, iTargetQty);            // проверяем, что кол-во сбитых мишеней не больше общего кол-ва мишеней
                    iHitTargetTotal := iHitTargetTotal + iHitTargetQty;

                    lStr := ' ';
                    if (StrToIntDef(VehiclesData[VehIdx].Shooting[j-1].ShotAll, 0) <> 0)and(iTargetQty > 0) then  // если были выстелы, значит есть результат
                      lStr := IntToStr(iHitTargetQty)+'/'+IntToStr(iTargetQty);

                    glArrShooting[i,j].Text := VehiclesData[VehIdx].Shooting[j-1].TargetType + '  ' + lStr;
                  end;
              CaptionParamStorage.SetParamDataV(cpiTargets_hit, i, iHitTargetTotal);
            end;

          case i of
            1: MainForm.Tank1Edit.Text := IntToStr(glArrColorGPS[i].iGPS);
            2: MainForm.Tank2Edit.Text := IntToStr(glArrColorGPS[i].iGPS);
            3: MainForm.Tank3Edit.Text := IntToStr(glArrColorGPS[i].iGPS);
            4: MainForm.Tank4Edit.Text := IntToStr(glArrColorGPS[i].iGPS);
          end;
        end;

      inc(i);

      qColorLoc.Next;
    end;
end;

procedure T_GPSTelemetry.btnOpenScenesClick(Sender: TObject);
begin
  {pStartTelemetryScenes(nil);}
end;

procedure T_GPSTelemetry.btnCloseScenesClick(Sender: TObject);
begin
  {pCloseScenaTelemetry(nil);}
end;

procedure T_GPSTelemetry.pUpdateSpeedDistValue(Sender: TObject);
var i:integer;
begin
  for i:=1 to high(glArrColorGPS) do
    begin
      glArrValueSpeed[i].Text:=FormatFloat('0',Vehicles[glArrColorGPS[i].iGPS].TrueSpeed);
      glArrValueDist[i].Text:=FormatFloat('0',Vehicles[glArrColorGPS[i].iGPS].MoveDistance);
    end;
end;

{
procedure T_GPSTelemetry.btnShowUnShowTitle2TanksClick(Sender: TObject);
begin
  pShowUnShowTitle2Tanks(btnShowUnShowTitle2Tanks.Down);
end;
}

{
procedure T_GPSTelemetry.chbChangePositionTablesOnTitle2TanksClick( Sender: TObject);
begin
  if btnShowUnShowTitle2Tanks.Down then
    pShowUnShowTitle2Tanks(btnShowUnShowTitle2Tanks.Down);
end;
}

{
procedure T_GPSTelemetry.rbShowEkipag2TanksClick(Sender: TObject);
begin
  if btnShowUnShowTitle2Tanks.Down then
    begin
      OpenRecords( nil );
      pUnShowAllScenes_2Tanks(nil);
      CloseRecords( nil );

      pShowUnShowTitle2Tanks(btnShowUnShowTitle2Tanks.Down);
    end;
end;
}

{
procedure T_GPSTelemetry.pShowUnShowTitle2Tanks(lShow:boolean = true);
var iTitleType, i:integer;
    lRes:boolean;
begin
  if rbShowEkipag2Tanks.Checked then iTitleType := 1 else
  if rbShowShooting2Tanks.Checked then iTitleType := 2 else
  if rbShowOtsechki2Tanks.Checked then iTitleType := 3;

  if btnShowUnShowTitle2Tanks.Down then
    begin
      btnShowUnShowTitle2Tanks.Caption := 'СНЯТЬ';

      for i := low(glArrTitleESO) to high(glArrTitleESO) do     // отжимаем все кнопочки титров
        glArrTitleESO[i].Down := false;

      OpenRecords(nil);

      pUnShowAllScenes(nil);

      lRes := fShow2Tanks(iTitleType);

      CloseRecords(nil);

      if not lRes then
        begin
          btnShowUnShowTitle2Tanks.Down := false;
          btnShowUnShowTitle2Tanks.Caption := 'Показать';
        end;

    end
    else
    begin
      btnShowUnShowTitle2Tanks.Caption := 'Показать';
      pClose2Tanks(iTitleType);
    end;
end;
}

{
procedure T_GPSTelemetry.pClose2Tanks(iTypeTitle: integer = 1);
begin
  OpenRecords( nil );

  pUnShowAllScenes_2Tanks(nil);

  CloseRecords( nil );
end;
}

{
procedure T_GPSTelemetry.pUnShowAllScenes_2Tanks(Sender: TObject);
begin
  pShowScenaEkipag_2Tanks(1, 0);
  pShowScenaEkipag_2Tanks(2, 0);

  pShowScenaShoots_2Tanks(1, 0);
  pShowScenaShoots_2Tanks(2, 0);

  pShowScenaOtsechka_2Tanks(1, 0);
  pShowScenaOtsechka_2Tanks(2, 0);
end;
}

(*
function T_GPSTelemetry.fShow2Tanks(iTypeTitle: integer = 1): boolean;
var lEdit : TEdit;
    lStr, lStr1 : string;
    i,j,k:integer;
    lCheckBox:TCheckBox;
    iGPS1, iGPS2: integer;
begin
  iGPS1:=0;
  iGPS2:=0;

  Result := true;

  j:=0;
  for i:=1 to MaxOneVehicles do
    begin
      if glArrDist[i].Down then
        begin
          inc(j);
          if j = 1 then iGPS1 := StrToIntDef(glArrGPS[i].Text,0) else
          if j = 2 then iGPS2 := StrToIntDef(glArrGPS[i].Text,0);
        end;
    end;

  if (iGPS1 = 0) or (iGPS2 = 0) then
    begin
      j:=0;
      for i:= 1 to 2 do
        for k:=1 to MaxOneVehicles do
          begin
            if glArrBtnSetCamera[i,k].Down then
              begin
                inc(j);
                if j = 1 then iGPS1 := StrToIntDef(glArrGPS[k].Text,0) else
                if j = 2 then iGPS2 := StrToIntDef(glArrGPS[k].Text,0);
              end;
          end;
    end;
{
  j:=0;
  for i:=1 to MaxOneVehicles do
    begin
      lStr := 'TankBox' + IntToStr(i);
      lCheckBox := TCheckBox( MainForm.Poligon2DGroupBox.FindChildControl( lStr ) );
      if lCheckBox.Checked then
        begin
          inc(j);
          lStr1 := 'Tank' + IntToStr(i) + 'Edit';
          lEdit := TEdit( MainForm.Poligon2DGroupBox.FindChildControl( lStr1 ) );     // находим окошко с id GPS
          if j = 1 then iGPS1 := StrToIntDef(lEdit.Text,0) else
          if j = 2 then iGPS2 := StrToIntDef(lEdit.Text,0);
        end;
    end;
}
  if not chbChangePositionTablesOnTitle2Tanks.Checked then
    begin
      glGPS1_OnShow:=iGPS1;
      glGPS2_OnShow:=iGPS2;
    end
    else
    begin
      glGPS1_OnShow:=iGPS2;
      glGPS2_OnShow:=iGPS1;
    end;

  if (j > 1)and(glGPS1_OnShow > 0)and(glGPS2_OnShow > 0) then
    begin
      if iTypeTitle = 1 then
        begin
          pShowScenaEkipag_2Tanks(1, glGPS1_OnShow);
          pShowScenaEkipag_2Tanks(2, glGPS2_OnShow);
        end
      else
      if iTypeTitle = 2 then
        begin
          pShowScenaShoots_2Tanks(1, glGPS1_OnShow);
          pShowScenaShoots_2Tanks(2, glGPS2_OnShow);
        end
      else
      if iTypeTitle = 3 then
        begin
          pShowScenaOtsechka_2Tanks(1, glGPS1_OnShow);
          pShowScenaOtsechka_2Tanks(2, glGPS2_OnShow);
        end;
    end
    else
      Result := false;
end;
*)

function T_GPSTelemetry.fObjName(lObj:string; iNum:integer):string;
begin
  Result := lObj;
  if iNum = 2 then
    Result := lObj + '_B';
end;

{
procedure T_GPSTelemetry.pShowScenaEkipag_2Tanks(iNum:integer; iTankIndex:integer);
var i, j, iRes, iQtyPlayersOnEkipage:integer;
    Names : array [0..1] of TName;
    lStr:string;
    lColor : TVector;
begin
  pInitialVars(nil);

  if glScenaName_Ekipag_2Tanks <> nil then
    begin
      if iTankIndex = 0 then
        lColor.VSet( 1.0, 1.0, 1.0, 0.0 )
        else
        lColor.VSet( 1.0, 1.0, 1.0, 1.0 );

      SetObjectSpace( glScenaName_Ekipag_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
      SetObjectSpace( glScenaName_Ekipag_2Tanks, PAnsiChar(AnsiString(fObjName('Flag',iNum))), nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );

      if iTankIndex = 0 then
        EXIT;

      for i:=0 to high(Names) do
        for j:=0 to 63 do
          Names[i].Text[j]:=#0;

      // команда
      UpdateSurfaceElement( glScenaName_Ekipag_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 1, 1,
                            nil,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].TeamName)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // флаг
      StrCopy(Names[0].Text,PAnsiChar(AnsiString(fObjName('Flag',iNum))) );
      Names[1].Text:=#0;
      iRes:=AssignObjectsTexture( glScenaName_Ekipag_2Tanks,
                            @Names,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].CountryFlag)),
                            1,
                            0.0, 0.0, 0, nil );

      // танчик
      iRes:=UpdateSurfaceElement( glScenaName_Ekipag_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 6, 1,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].TankSmallPicture)),
                            nil,
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // расстояние
      if not chbShowDistance.Checked then
        UpdateSurfaceElement( glScenaName_Ekipag, PAnsiChar(AnsiString(fObjName('Status',iNum))), 7, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
        else
        UpdateSurfaceElement( glScenaName_Ekipag_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 7, 1,
                            nil,
                            PAnsiChar(AnsiString(FormatFloat('0',Vehicles[iTankIndex].MoveDistance) + glMoveDistanceM)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // скорость
      if not chbShowSpeed.Checked then
        UpdateSurfaceElement( glScenaName_Ekipag_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 8, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
        else
        UpdateSurfaceElement( glScenaName_Ekipag_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 8, 1,
                            nil,
                            PAnsiChar(AnsiString(FormatFloat('0',Vehicles[iTankIndex].TrueSpeed) + glSpeedKMH)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // экипаж
      iQtyPlayersOnEkipage:=glQuantityPlayersOnTitle;      // количество отсечек на титре
      j:=0;
      for i:=0 to high(VehiclesData[iTankIndex].Players) do
        begin
          if VehiclesData[iTankIndex].Players[i].PlayerName = '' then
            break;

          // фамилии
          iRes:=UpdateSurfaceElement( glScenaName_Ekipag_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 3+i, 1,
                                nil,
                                PAnsiChar(AnsiString(VehiclesData[iTankIndex].Players[i].PlayerName)),
                                COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

          inc(j);
        end;

      // очищаем пустые фамилии на титре
      for i := j to iQtyPlayersOnEkipage - 1 do
        begin
          iRes:=UpdateSurfaceElement( glScenaName_Ekipag_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 3+i, 1,
                                      nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
        end;
    end;
end;
}

{
procedure T_GPSTelemetry.pShowScenaShoots_2Tanks(iNum:integer; iTankIndex:integer);
var i, iShotHitQty, iHitTargetQty, iTargetQty, j, iRes, iQtyMisheniOnTitle:integer;
    Names : array [0..1] of TName;
    lStr:string;
    lColor : TVector;
begin
  pInitialVars(nil);

  if glScenaName_Shoot_2Tanks <> nil then
    begin
      if iTankIndex = 0 then
        lColor.VSet( 1.0, 1.0, 1.0, 0.0 )
        else
        lColor.VSet( 1.0, 1.0, 1.0, 1.0 );

      SetObjectSpace( glScenaName_Shoot_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
      SetObjectSpace( glScenaName_Shoot_2Tanks, PAnsiChar(AnsiString(fObjName('Flag',iNum))), nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );

      if iTankIndex = 0 then
        EXIT;

      for i:=0 to high(Names) do
        for j:=0 to 63 do
          Names[i].Text[j]:=#0;

      // команда
      UpdateSurfaceElement( glScenaName_Shoot_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 1, 1,
                            nil,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].TeamName)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // танчик
      iRes:=UpdateSurfaceElement( glScenaName_Shoot_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 3, 1,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].TankSmallPicture)),
                            nil,
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // флаг
      StrCopy(Names[0].Text,PAnsiChar(AnsiString(fObjName('Flag',iNum))) );
      Names[1].Text:=#0;
      iRes:=AssignObjectsTexture( glScenaName_Shoot_2Tanks,
                            @Names,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].CountryFlag)),
                            1,
                            0.0, 0.0, 0, nil );

      // расстояние
      if not chbShowDistance.Checked then
        UpdateSurfaceElement( glScenaName_Shoot_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 4, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
        else
        UpdateSurfaceElement( glScenaName_Shoot_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 4, 1,
                            nil,
                            PAnsiChar(AnsiString(FormatFloat('0',Vehicles[iTankIndex].MoveDistance) + glMoveDistanceM)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // скорость
      if not chbShowSpeed.Checked then
        UpdateSurfaceElement( glScenaName_Shoot_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 5, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
        else
        UpdateSurfaceElement( glScenaName_Shoot_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 5, 1,
                            nil,
                            PAnsiChar(AnsiString(FormatFloat('0',Vehicles[iTankIndex].TrueSpeed) + glSpeedKMH)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );


      // мишени
      iQtyMisheniOnTitle:=glQuantityMisheniOnTitle;      // количество отсечек на титре
      j:=0;
      for i:=0 to high(VehiclesData[iTankIndex].Shooting) do
        begin
          if VehiclesData[iTankIndex].Shooting[i].TargetType = '' then
            break;

          // мишеньки картинки
          iRes:=UpdateSurfaceElement( glScenaName_Shoot_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 6+i, 1,
                                PAnsiChar(AnsiString(VehiclesData[iTankIndex].Shooting[i].TargetPicture)),
                                nil,
                                COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

          // количество сбитых из всего мишеней
          iTargetQty := StrToIntDef(VehiclesData[iTankIndex].Shooting[i].TargetQuantity, 0);
          iShotHitQty := StrToIntDef(VehiclesData[iTankIndex].Shooting[i].ShotHit, 0);

          iHitTargetQty := Min( iShotHitQty , iTargetQty );            // проверяем, что кол-во сбитых мишеней не больше общего кол-ва мишеней

          lStr := ' ';
          if (StrToIntDef(VehiclesData[iTankIndex].Shooting[i].ShotAll, 0) <> 0)and(iTargetQty > 0) then  // если были выстелы, значит есть результат
            lStr := IntToStr(iHitTargetQty)+'/'+IntToStr(iTargetQty);

          UpdateSurfaceElement( glScenaName_Shoot_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 9+i, 1, nil, PAnsiChar(AnsiString(lStr)),
                                COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

          inc(j);
        end;

      // очищаем пустые строки мишеней на титре
      for i := j to iQtyMisheniOnTitle - 1 do
        begin
          // чистим мишеньки
          iRes:=UpdateSurfaceElement( glScenaName_Shoot_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 6+i, 1,
                                PAnsiChar(AnsiString(glMeshenTexture_Clear)),
                                nil,
                                COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
          // чистим количество
          iRes:=UpdateSurfaceElement( glScenaName_Shoot_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 9+i, 1,
                                      nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
        end;
    end;
end;
}

{
procedure T_GPSTelemetry.pShowScenaOtsechka_2Tanks(iNum:integer; iTankIndex:integer);
var i, j, iRes:integer;
    Names : array [0..1] of TName;
    lColor : TVector;
    iQtyOts, iQtyOtsOnTitle:integer;
    iResult, iRemainder: Word;
begin
  pInitialVars(nil);

  if glScenaName_Otsechka_2Tanks <> nil then
    begin
      if iTankIndex = 0 then
        lColor.VSet( 1.0, 1.0, 1.0, 0.0 )
        else
        lColor.VSet( 1.0, 1.0, 1.0, 1.0 );

      SetObjectSpace( glScenaName_Otsechka_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );
      SetObjectSpace( glScenaName_Otsechka_2Tanks, PAnsiChar(AnsiString(fObjName('Flag',iNum))), nil, nil, nil, nil, nil, @lColor, 0.0, 0, nil );

      if iTankIndex = 0 then
        EXIT;

      for i:=0 to high(Names) do
        for j:=0 to 63 do
          Names[i].Text[j]:=#0;

      // команда
      UpdateSurfaceElement( glScenaName_Otsechka_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 1, 1,
                            nil,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].TeamName)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // флаг
      StrCopy(Names[0].Text,PAnsiChar(AnsiString(fObjName('Flag',iNum))) );
      Names[1].Text:=#0;
      iRes:=AssignObjectsTexture( glScenaName_Otsechka_2Tanks,
                            @Names,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].CountryFlag)),
                            1,
                            0.0, 0.0, 0, nil );

      // танчик
      iRes:=UpdateSurfaceElement( glScenaName_Otsechka_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 3, 1,
                            PAnsiChar(AnsiString(VehiclesData[iTankIndex].TankSmallPicture)),
                            nil,
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // расстояние
      if not chbShowDistance.Checked then
        UpdateSurfaceElement( glScenaName_Otsechka_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 4, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
        else
        UpdateSurfaceElement( glScenaName_Otsechka_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 4, 1,
                            nil,
                            PAnsiChar(AnsiString(FormatFloat('0',Vehicles[iTankIndex].MoveDistance) + glMoveDistanceM)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // скорость
      if not chbShowSpeed.Checked then
        UpdateSurfaceElement( glScenaName_Otsechka_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 5, 1,
                            nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil )
        else
        UpdateSurfaceElement( glScenaName_Otsechka_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 5, 1,
                            nil,
                            PAnsiChar(AnsiString(FormatFloat('0',Vehicles[iTankIndex].TrueSpeed) + glSpeedKMH)),
                            COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );

      // отсечки
      iQtyOts:=0;
      for i:=0 to high(VehiclesData[iTankIndex].Intermediate) do
        begin
          if (VehiclesData[iTankIndex].Intermediate[i].NumOtsec <> '') then
            inc(iQtyOts);
        end;

      iQtyOtsOnTitle:=glQuantityOtsechekOnTitle;      // количество отсечек на титре

      DivMod(iQtyOts, iQtyOtsOnTitle, iResult, iRemainder);

      j:=0;
      for i:=0 to iQtyOts - 1 do
        begin
          if ((i + 1) > (iResult * iQtyOtsOnTitle))
             or
             (((iRemainder = 0)and(iResult > 0))and((i + 1) > (iQtyOts - iQtyOtsOnTitle))) then
            begin
              // название отсечки
              iRes:=UpdateSurfaceElement( glScenaName_Otsechka_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 6+j, 1,
                                          nil,
                                          PAnsiChar(AnsiString('ОТСЕЧКА '+VehiclesData[iTankIndex].Intermediate[i].NumOtsec)),
                                          COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
              // время отсечки
              iRes:=UpdateSurfaceElement( glScenaName_Otsechka_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 9+j, 1,
                                          nil,
                                          PAnsiChar(AnsiString(fConvertTime(VehiclesData[iTankIndex].Intermediate[i].TimeMSec))),
                                          COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
              inc(j);
            end;
        end;

      // очищаем пустые отсечки на титре
      for i := j to iQtyOtsOnTitle - 1 do
        begin
          // название отсечки
          iRes:=UpdateSurfaceElement( glScenaName_Otsechka_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 6+i, 1,
                                      nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
          // время отсечки
          iRes:=UpdateSurfaceElement( glScenaName_Otsechka_2Tanks, PAnsiChar(AnsiString(fObjName('Status',iNum))), 9+i, 1,
                                      nil, ' ', COLOR_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, INT_UNDEF, 0.0, 0, nil );
        end;
    end;
end;
}

function T_GPSTelemetry.fGetColorForGPS(iGPS:string; var lColorID : string):TColor;
var
  i:integer;
begin
  Result := clNone;
  lColorID := '';
  for i := low(glArrColorGPS) to high(glArrColorGPS) do
    begin
      if glArrColorGPS[i].iGPS = StrToIntDef(iGPS,0) then
        begin
          Result := glArrColorGPS[i].vColor;
          lColorID := glArrColorGPS[i].sColor;
          break;
        end;
    end;
end;

procedure T_GPSTelemetry.pTankPanelColoring;
var
  lColorID1, lColorID2, lColorID3, lColorID4: string;
begin
  MainForm.Tank1Panel.Color := fGetColorForGPS(MainForm.Tank1Edit.Text, lColorID1);
  MainForm.Tank2Panel.Color := fGetColorForGPS(MainForm.Tank2Edit.Text, lColorID2);
  MainForm.Tank3Panel.Color := fGetColorForGPS(MainForm.Tank3Edit.Text, lColorID3);
  MainForm.Tank4Panel.Color := fGetColorForGPS(MainForm.Tank4Edit.Text, lColorID4);
end;

end.
