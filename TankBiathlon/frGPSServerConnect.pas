unit frGPSServerConnect;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.WinSock,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons;

resourcestring
  rsGPSLbl = ' GPS Server ';
  rsGPSDisconnected = '(disconnected) ';
  rsGPSConnected = '(connected) ';
  rsGPSConnecting = '(connecting...) ';
  rsGPSDisconnecting = '(disconnecting...) ';
  rsGPSConnect = 'Connect';
  rsGPSDisconnect = 'Disconnect';

type
  TConnectState = (csDisconnected, csDisconnecting, csConnecting, csConnected);

  TGPSServerConnectFrame = class(TFrame)
    GPSServerGroup: TGroupBox;
    lblGpsAddr: TLabel;
    lblGpsPort: TLabel;
    edGpsAddr: TEdit;
    edGpsPort: TEdit;
    btnConnect: TButton;
    procedure btnConnectClick(Sender: TObject);
  private
    FState: TConnectState;
    FForceDisconnect: boolean;
    FWorkThread: TThread;
    procedure DoConnect;
    procedure DoDisconnect;
    procedure ConnectStateChanged(Sender: TThread;
                const OldState, NewState: TConnectState);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateUI;
    property ConnectState: TConnectState read FState write FState;
  end;

implementation

uses
  TypesJTP, GpsConnection, uGPSPacketsQueue, MainUnit;

{$R *.dfm}

{ TGPSServerConnectThread }

type
  TConnectStateChangedEvent = procedure(Sender: TThread;
                                const OldState, NewState: TConnectState) of object;

  TGPSServerConnectThread = class(TThread)
  private
    FId: integer;
    FServerIP: string;
    FPort: integer;
    FConnectState: TConnectState;
    FGPSSocket: Int64;
    FGPSLastAccess: UInt64;
    FGPSLastBeat: UInt64;
    FOnStateChanged: TConnectStateChangedEvent;
    procedure CheckIncomingData;
    procedure ConnectToGPSServer;
  protected
    procedure Execute; override;
    procedure DoStateChanged(const OldState, NewState: TConnectState); virtual;
  public
    constructor Create(const ServerIP: string; const Port: integer); reintroduce;
    property ServerIP: string read FServerIP;
    property Port: integer read FPort;
    property OnStateChanged: TConnectStateChangedEvent read FOnStateChanged
                                                       write FOnStateChanged;
  end;

{ TGPSServerConnectThread }

procedure TGPSServerConnectThread.CheckIncomingData;
const
  GpsPacketLen: integer = 36;   // Packet length
  MaxGpsTimeout: UInt64 = 3000; // Если привысили MaxGpsTimeout то рвём соединение.
  BeatInterval: UInt64 = 1000;
var
  Res : integer;
  buff: array[0..255] of dword;
  GpsData: TGpsData;
  CurrentMills: UInt64;
  lId: array[1..9] of integer;

  function ReceivePacket: integer;
  var
    Len: integer;
  begin
    Len := 0;
    while Len < GpsPacketLen do
      begin
        Result := recv(FGPSSocket, buff, GpsPacketLen-Len, 0);
        if Result > 0 then Len := Len + Result
                      else Exit;
      end;
    Result := Len;
  end;

  procedure TearConnection;
  begin
    FGPSLastAccess := CurrentMills;
    closesocket(FGPSSocket);
    FGPSSocket := INVALID_SOCKET;
    FConnectState := csDisconnected;
    DoStateChanged(csConnected, FConnectState);
  end;

begin
  // соединяемся
  if (FConnectState = csDisconnected) then ConnectToGpsServer()
                       else
    // получаем пакеты
    if (FConnectState = csConnected) then
      begin
        CurrentMills := Winapi.Windows.GetTickCount64;
        if (CurrentMills - FGPSLastBeat > BeatInterval) then
          begin
            lId[1] := FId;
            lId[2] := 0; lId[3] := 0; lId[4] := 0; lId[5] := 0;
            lId[6] := 0; lId[7] := 0; lId[8] := 0; lId[9] := 0;
            Res := send(FGPSSocket, lId, SizeOf(lId), 0);
            if Res = SizeOf(lId)
              then FGPSLastBeat := CurrentMills;
          end;

        while true do
          begin
            Res := ReceivePacket;
            if (Res = GpsPacketLen) then
              begin
                FGPSLastAccess := Winapi.Windows.GetTickCount64;

                CopyMemory(@GpsData.Latitude, @buff[0], 4);     //  широта
                CopyMemory(@GpsData.Longitude, @buff[1], 4);    //  долгота
                CopyMemory(@GpsData.Distance, @buff[2], 4);     //  пройденное расстояние
                CopyMemory(@GpsData.VehicleId, @buff[6], 4);    //  id танка

                // Если не пустое сообщение. Сервер шлёт и
                // пустые сообщения для поддержания связи.
                if (GpsData.VehicleId > 0) then
                  begin
                    if (GpsData.Latitude <> FLT_UNDEF) and (GpsData.Latitude <> 0) and
                       (GpsData.Longitude <> FLT_UNDEF) and (GpsData.Longitude <> 0)
                      then uGPSPacketsQueue.PushPacket(TGPSPacket.Create(GpsData));
                    MainForm.AddLogGpsData(GpsData.VehicleId, GpsData.Latitude, GpsData.Longitude);
                  end;
              end
                                    else
              begin
                if (Res = 0) or
                   ((Res < 0) and (WSAGetLastError <> WSAEWOULDBLOCK)) or
                   (CurrentMills - FGPSLastAccess > MaxGpsTimeout)
                  then TearConnection;
                CurrentMills := Winapi.Windows.GetTickCount64;
                Break;
              end;
          end;
      end;
end;

procedure TGPSServerConnectThread.ConnectToGPSServer;
var
  Res : integer;
  NotBlock : integer;
  AddrIn: sockaddr_in;
  lId: array[1..9] of integer;
begin
  Res := 0;
  FGPSLastAccess := Winapi.Windows.GetTickCount64;

  if FGPSSocket = INVALID_SOCKET then
    begin
      FGPSSocket := socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
      if FGPSSocket = INVALID_SOCKET
        then Res := WSAGetLastError();

      NotBlock := 1;
      Res := ioctlsocket(FGPSSocket, FIONBIO, NotBlock);
      if Res <> 0 then
        begin
          WSACleanup();
          FGPSSocket := INVALID_SOCKET;
          Exit;
        end;
    end;

  AddrIn.sin_family := AF_INET;
  AddrIn.sin_port := htons(FPort);
  AddrIn.sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(FServerIP)));

  Res := connect(FGPSSocket, AddrIn, sizeof(AddrIn));
  Res := WSAGetLastError();
  if Res = WSAEISCONN then
    begin
      FConnectState := csConnected;
      DoStateChanged(csDisconnected, FConnectState);
      lId[1] := FId;
      lId[2] := 0; lId[3] := 0; lId[4] := 0; lId[5] := 0;
      lId[6] := 0; lId[7] := 0; lId[8] := 0; lId[9] := 0;
      Res := send(FGPSSocket, lId, SizeOf(lId), 0);
      if Res = SizeOf(lId)
        then FGPSLastBeat := Winapi.Windows.GetTickCount64;
    end;
end;

constructor TGPSServerConnectThread.Create(const ServerIP: string;
  const Port: integer);
begin
  inherited Create(true);
  FId := Random(1000);
  FreeOnTerminate := true;
  FServerIP := ServerIP;
  FPort := Port;
  FConnectState := csDisconnected;
  FGPSSocket  := INVALID_SOCKET;
  FGPSLastAccess := Winapi.Windows.GetTickCount64;
end;

procedure TGPSServerConnectThread.DoStateChanged(const OldState,
  NewState: TConnectState);
begin
  if not Assigned(FOnStateChanged) then Exit;

  TThread.Queue(nil,
      procedure
      begin
        FOnStateChanged(Self, OldState, NewState);
      end
    );
end;

procedure TGPSServerConnectThread.Execute;
begin
  repeat
    try
      CheckIncomingData;
      Sleep(200);
    except
    end;
  until Terminated;
end;

{ TGPSServerConnectFrame }

procedure TGPSServerConnectFrame.btnConnectClick(Sender: TObject);
begin
  btnConnect.Enabled := false;
  GPSServerGroup.Enabled := false;
  if FState = csDisconnected
    then DoConnect
    else DoDisconnect;
end;

procedure TGPSServerConnectFrame.ConnectStateChanged(Sender: TThread;
  const OldState, NewState: TConnectState);
begin
  if Sender <> FWorkThread then Exit;

  if NewState = csConnected
    then FState := csConnected
    else FState := csConnecting;
  UpdateUI;
end;

constructor TGPSServerConnectFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWorkThread := nil;
  FState := csDisconnected;
  uGPSPacketsQueue.InitializeQueue;
end;

destructor TGPSServerConnectFrame.Destroy;
begin
  DoDisconnect;
  uGPSPacketsQueue.DeinitializeQueue;
  inherited Destroy;
end;

procedure TGPSServerConnectFrame.DoConnect;
begin
  if Assigned(FWorkThread) then Exit;

  FState := csConnecting;
  GPSServerGroup.Caption := rsGPSLbl + rsGPSConnecting;

  FWorkThread := TGPSServerConnectThread.Create(edGpsAddr.Text,
                                                StrToInt(edGpsPort.Text));
  TGPSServerConnectThread(FWorkThread).OnStateChanged := ConnectStateChanged;
  FWorkThread.Start;
  UpdateUI;
end;

procedure TGPSServerConnectFrame.DoDisconnect;
var
  Worker: TGPSServerConnectThread;
begin
  Worker := TGPSServerConnectThread(FWorkThread);
  FWorkThread := nil;
  if Assigned(Worker) then
    begin
      Worker.OnStateChanged := nil;
      Worker.Terminate;
    end;
  FState := csDisconnected;
  UpdateUI;
end;

procedure TGPSServerConnectFrame.UpdateUI;
var
  sLblCaption: string;
begin
  btnConnect.Enabled := true;
  GPSServerGroup.Enabled := true;
  if FState = csDisconnected then
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
      case FState of
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
