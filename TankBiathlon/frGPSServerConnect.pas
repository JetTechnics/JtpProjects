unit frGPSServerConnect;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons,
  uGPSData, uGPSServerConnect;

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
    GPSCleanEventTimer: TTimer;
    procedure btnConnectClick(Sender: TObject);
  private
    FConnectObj: TGPSServerConnectObj;
    procedure LogGPSData(Sender: TObject; const GpsData: TGpsData);
    procedure ConnectionChanged(Sender: TObject;
                                const OldState, NewState: TConnectState);
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

  FConnectObj.ToggleState(edGpsAddr.Text, StrToInt(edGpsPort.Text));
end;

procedure TGPSServerConnectFrame.ConnectionChanged(Sender: TObject;
  const OldState, NewState: TConnectState);
begin
  if OldState = csDisconnected
    then MainForm.LogListBox.Clear;
end;

constructor TGPSServerConnectFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConnectObj := TGPSServerConnectObj.Create;
  FConnectObj.OnUpdateUI := UpdateUI;
  FConnectObj.OnConnectionChanged := ConnectionChanged;
  FConnectObj.OnLogGpsData := LogGPSData;
end;

destructor TGPSServerConnectFrame.Destroy;
begin
  GPSCleanEventTimer.Enabled := false;
  GPSCleanEventTimer.OnTimer := nil;
  FConnectObj.OnLogGpsData := nil;
  FConnectObj.OnConnectionChanged := nil;
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
  MainForm.AddLogGpsData(GpsData, Winapi.Windows.GetTickCount);
end;

procedure TGPSServerConnectFrame.UpdateUI(Sender: TObject);
var
  sLblCaption: string;
begin
  btnConnect.Enabled := true;
  GPSServerGroup.Enabled := true;
  GPSCleanEventTimer.Enabled := false;
  if FConnectObj.ConnectState = csDisconnected then
    begin
      GPSServerGroup.Caption := rsGPSLbl + rsGPSDisconnected;
      GPSServerGroup.Color := clBtnFace;
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
        csDisconnecting: begin
                           sLblCaption := rsGPSLbl + rsGPSDisconnecting;
                           GPSServerGroup.Color := clYellow;
                         end;
           csConnecting: begin
                           sLblCaption := rsGPSLbl + rsGPSConnecting;
                           GPSServerGroup.Color := clRed;
                         end;
            csConnected: begin
                           sLblCaption := rsGPSLbl + rsGPSConnected;
                           GPSServerGroup.Color := clGreen;
                           GPSCleanEventTimer.Enabled := true;
                         end;
        else begin
               sLblCaption := rsGPSLbl + rsGPSDisconnected;
               GPSServerGroup.Color := clBtnFace;
             end;
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
