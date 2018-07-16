unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uGPSData, uGPSServerConnect, StdCtrls{, WinSock};

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Label1: TLabel;
    LogListBox: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FConnectObj: TGPSServerConnectObj;
    FTankId: integer;
    FLat: single;
    FLon: single;
    procedure LogGPSData(Sender: TObject; const GpsData: TGpsData);
    procedure DoLogData;
  public
    procedure UpdateUI(Sender: TObject);

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Button1.Enabled := false;
  FConnectObj.ToggleState(Edit1.Text, StrToInt(Edit2.Text));
end;

procedure TForm1.DoLogData;
var
  i: integer;
  id: integer;
  s: string;
  pkts: string;
begin
  LogListBox.Items.BeginUpdate;
  try
    pkts := Format('%d%20.5f%20.5f', [FTankId, FLat, FLon]);
    try
      for i:=0 to LogListBox.Items.Count-1 do
        begin
          s := LogListBox.Items[i];
          id := StrToInt(System.Copy(s, 1, Pos(' ', s)-1));
          if id = FTankId then
            begin
              LogListBox.Items[i] := pkts;
              Exit;
            end;
        end;
      LogListBox.Items.Add(pkts);
    except
      LogListBox.Items.Add(pkts);
    end;
  finally
    LogListBox.Items.EndUpdate;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FConnectObj := TGPSServerConnectObj.Create;
  FConnectObj.OnUpdateUI := UpdateUI;
  FConnectObj.OnLogGpsData := LogGPSData;
  UpdateUI(Self);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FConnectObj.OnLogGpsData := nil;
  FConnectObj.OnUpdateUI := nil;
  FConnectObj.Free;
end;

procedure TForm1.LogGPSData(Sender: TObject; const GpsData: TGpsData);
begin
  FTankId := GpsData.VehicleId;
  FLat := GpsData.Latitude;
  FLon := GpsData.Longitude;
  TThread.Synchronize(nil, DoLogData);
end;

procedure TForm1.UpdateUI(Sender: TObject);
begin
  Button1.Enabled := true;
  case FConnectObj.ConnectState of
    csDisconnecting: Label1.Caption := 'Disconnecting...';
       csConnecting: Label1.Caption := 'Connecting...';
        csConnected: Label1.Caption := 'Connected';
    else Label1.Caption := 'Disconnected';
  end;
  if FConnectObj.ConnectState = csDisconnected
    then Button1.Caption := 'Connect'
    else Button1.Caption := 'Disconnect';
end;

end.
