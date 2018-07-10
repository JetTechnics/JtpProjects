unit frGPSServerConnect;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons,
  GpsConnection, uGPSServerConnect;

resourcestring
  rsGPSLbl = ' GPS Server ';
  rsGPSDisconnected = '(disconnected) ';
  rsGPSConnected = '(connected) ';
  rsGPSConnecting = '(connecting...) ';
  rsGPSDisconnecting = '(disconnecting...) ';
  rsGPSConnect = 'Connect';
  rsGPSDisconnect = 'Disconnect';

type
  TGPSServerConnectFrame = class(TFrame)
    GPSServerGroup: TGroupBox;
    lblGpsAddr: TLabel;
    lblGpsPort: TLabel;
    edGpsAddr: TEdit;
    edGpsPort: TEdit;
    btnConnect: TButton;
    procedure btnConnectClick(Sender: TObject);
  private
    FConnectObj: TGPSServerConnectObj;
    procedure LogGPSData(Sender: TObject; const GpsData: TGpsData);
    function GetConnectState: TConnectState;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateUI(Sender: TObject);
    property ConnectState: TConnectState read GetConnectState;
  end;

implementation

uses
  MainUnit;

{$R *.dfm}

{ TGPSServerConnectFrame }

procedure TGPSServerConnectFrame.btnConnectClick(Sender: TObject);
begin
  btnConnect.Enabled := false;
  GPSServerGroup.Enabled := false;
  FConnectObj.ToggleState;
end;

constructor TGPSServerConnectFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConnectObj := TGPSServerConnectObj.Create(edGpsAddr.Text,
                                             StrToInt(edGpsPort.Text));
  FConnectObj.OnUpdateUI := UpdateUI;
  FConnectObj.OnLogGpsData := LogGPSData;
end;

destructor TGPSServerConnectFrame.Destroy;
begin
  FConnectObj.OnLogGpsData := nil;
  FConnectObj.OnUpdateUI := nil;
  FConnectObj.Free;
  inherited Destroy;
end;

function TGPSServerConnectFrame.GetConnectState: TConnectState;
begin
  Result := FConnectObj.ConnectState;
end;

procedure TGPSServerConnectFrame.LogGPSData(Sender: TObject;
  const GpsData: TGpsData);
begin
  MainForm.AddLogGpsData(GpsData.VehicleId, GpsData.Latitude, GpsData.Longitude);
end;

procedure TGPSServerConnectFrame.UpdateUI(Sender: TObject);
var
  sLblCaption: string;
begin
  btnConnect.Enabled := true;
  GPSServerGroup.Enabled := true;
  if FConnectObj.ConnectState = csDisconnected then
    begin
      GPSServerGroup.Caption := rsGPSLbl + rsGPSDisconnected;
      lblGpsAddr.Enabled := true;
      lblGpsPort.Enabled := true;
      edGpsAddr.Enabled := true;
      edGpsAddr.Brush.Color := clWindow;
      edGpsPort.Enabled := true;
      edGpsPort.Brush.Color := clWindow;
      btnConnect.Caption := rsGPSConnect;
    end
                                               else
    begin
      case FConnectObj.ConnectState of
        csDisconnecting: sLblCaption := rsGPSLbl + rsGPSDisconnecting;
           csConnecting: sLblCaption := rsGPSLbl + rsGPSConnecting;
            csConnected: sLblCaption := rsGPSLbl + rsGPSConnected;
        else sLblCaption := rsGPSLbl + rsGPSDisconnected;
      end;
      GPSServerGroup.Caption := sLblCaption;
      lblGpsAddr.Enabled := false;
      lblGpsPort.Enabled := false;
      edGpsAddr.Enabled := false;
      edGpsAddr.Brush.Color := clBtnFace;
      edGpsPort.Enabled := false;
      edGpsPort.Brush.Color := clBtnFace;
      btnConnect.Caption := rsGPSDisconnect;
    end;
end;

end.
