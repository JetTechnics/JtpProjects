unit GPS_dm;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  T_GPS_dm = class(TDataModule)
    qImportColor: TADOQuery;
    qImportSource: TADOQuery;
    qImportMesheny: TADOQuery;
    qColor_Get: TADOQuery;
    AutoIncField1: TAutoIncField;
    WideStringField1: TWideStringField;
    WideStringField2: TWideStringField;
    WideStringField3: TWideStringField;
    WideStringField4: TWideStringField;
    WideStringField5: TWideStringField;
    IntegerField1: TIntegerField;
    qCountry_Get: TADOQuery;
    qTmp: TADOQuery;
    qMesheny_Get: TADOQuery;
    AutoIncField2: TAutoIncField;
    WideStringField6: TWideStringField;
    WideStringField7: TWideStringField;
    WideStringField8: TWideStringField;
    WideStringField9: TWideStringField;
    WideStringField10: TWideStringField;
    WideStringField11: TWideStringField;
    WideStringField12: TWideStringField;
    WideStringField13: TWideStringField;
    WideStringField14: TWideStringField;
    WideStringField15: TWideStringField;
    qTankForColor: TADOQuery;
    qTeamInZaezd: TADOQuery;
    qOtsechkiForTeam: TADOQuery;
    qUpdateGPS: TADOQuery;
    AutoIncField3: TAutoIncField;
    WideStringField16: TWideStringField;
    WideStringField17: TWideStringField;
    WideStringField18: TWideStringField;
    WideStringField19: TWideStringField;
    AutoIncField4: TAutoIncField;
    WideStringField20: TWideStringField;
    WideStringField21: TWideStringField;
    WideStringField22: TWideStringField;
    WideStringField23: TWideStringField;
    AutoIncField5: TAutoIncField;
    WideStringField24: TWideStringField;
    WideStringField25: TWideStringField;
    WideStringField26: TWideStringField;
    WideStringField27: TWideStringField;
    WideStringField28: TWideStringField;
    AutoIncField6: TAutoIncField;
    WideStringField29: TWideStringField;
    WideStringField30: TWideStringField;
    WideStringField31: TWideStringField;
    WideStringField32: TWideStringField;
    WideStringField33: TWideStringField;
    WideStringField34: TWideStringField;
    WideStringField35: TWideStringField;
    WideStringField36: TWideStringField;
    StringField1: TStringField;
    qTankPlayersForTeam: TADOQuery;
    DBTanks: TADOConnection;
    DBLocal: TADOConnection;
    qInfoForTeam: TADOQuery;
    qImportCountry: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  _GPS_dm: T_GPS_dm;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

end.
