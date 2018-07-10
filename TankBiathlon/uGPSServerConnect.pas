unit uGPSServerConnect;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.WinSock,
  System.SysUtils, System.Variants, System.Classes,
  GpsConnection;

type
  TConnectState = (csDisconnected, csDisconnecting, csConnecting, csConnected);

  TLogGPSDataEvent = procedure(Sender: TObject; const GpsData: TGpsData) of object;

  TGPSServerConnectObj = class(TObject)
  private
    FServerIP: string;
    FPort: integer;
    FState: TConnectState;
    FWorkThread: TThread;
    FOnUpdateUI: TNotifyEvent;
    FOnLogGpsData: TLogGPSDataEvent;
    procedure ConnectStateChanged(Sender: TThread;
                const OldState, NewState: TConnectState);
    procedure DoConnect;
    procedure DoDisconnect;
    procedure DoLogGPSData(Sender: TObject; const GpsData: TGpsData);
  protected
    procedure UpdateUI; virtual;
  public
    constructor Create(const ServerIP: string; const Port: integer);
    destructor Destroy; override;
    procedure ToggleState;
    property ConnectState: TConnectState read FState write FState;
    property OnUpdateUI: TNotifyEvent read FOnUpdateUI write FOnUpdateUI;
    property OnLogGpsData: TLogGPSDataEvent read FOnLogGpsData write FOnLogGpsData;
  end;

implementation

uses
  TypesJTP, uGPSPacketsQueue;

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
    FOnLogGpsData: TLogGPSDataEvent;
    procedure CheckIncomingData;
    procedure ConnectToGPSServer;
  protected
    procedure Execute; override;
    procedure DoStateChanged(const OldState, NewState: TConnectState); virtual;
    procedure DoLogGpsData(const GpsData: TGpsData); virtual;
  public
    constructor Create(const ServerIP: string; const Port: integer); reintroduce;
    property ServerIP: string read FServerIP;
    property Port: integer read FPort;
    property OnStateChanged: TConnectStateChangedEvent read FOnStateChanged
                                                       write FOnStateChanged;
    property OnLogGpsData: TLogGPSDataEvent read FOnLogGpsData write FOnLogGpsData;
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
                CopyMemory(@GpsData.TimeMilli, @buff[3], 8);    //  время
                CopyMemory(@GpsData.PacketNum, @buff[5], 4);    //  номер пакета
                CopyMemory(@GpsData.VehicleId, @buff[6], 4);    //  id танка
                CopyMemory(@GpsData.Battery, @buff[7], 4);      //  уровень батареи
                CopyMemory(@GpsData.Speed, @buff[8], 4);        //  скорость

                // Если не пустое сообщение. Сервер шлёт и
                // пустые сообщения для поддержания связи.
                if (GpsData.VehicleId > 0) then
                  begin
                    if (GpsData.Latitude <> FLT_UNDEF) and (GpsData.Latitude <> 0) and
                       (GpsData.Longitude <> FLT_UNDEF) and (GpsData.Longitude <> 0)
                      then uGPSPacketsQueue.PushPacket(TGPSPacket.Create(GpsData));
                    //MainForm.AddLogGpsData(GpsData.VehicleId, GpsData.Latitude, GpsData.Longitude);
                    DoLogGpsData(GpsData);
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
  SetString(FServerIP, PChar(ServerIP), Length(ServerIP));
  FPort := Port;
  FConnectState := csDisconnected;
  FGPSSocket  := INVALID_SOCKET;
  FGPSLastAccess := Winapi.Windows.GetTickCount64;
end;

procedure TGPSServerConnectThread.DoLogGpsData(const GpsData: TGpsData);
begin
  if Assigned(FOnLogGpsData)
    then FOnLogGpsData(Self, GpsData);
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

{ TGPSServerConnectObj }

procedure TGPSServerConnectObj.ConnectStateChanged(Sender: TThread;
  const OldState, NewState: TConnectState);
begin
  if Sender <> FWorkThread then Exit;

  if NewState = csConnected
    then FState := csConnected
    else FState := csConnecting;
  UpdateUI;
end;

constructor TGPSServerConnectObj.Create(const ServerIP: string; const Port: integer);
begin
  inherited Create;
  FServerIP := ServerIP;
  FPort := Port;
  FWorkThread := nil;
  FState := csDisconnected;
  uGPSPacketsQueue.InitializeQueue;
end;

destructor TGPSServerConnectObj.Destroy;
begin
  DoDisconnect;
  uGPSPacketsQueue.DeinitializeQueue;
  inherited Destroy;
end;

procedure TGPSServerConnectObj.DoConnect;
begin
  if Assigned(FWorkThread) then Exit;

  FState := csConnecting;

  FWorkThread := TGPSServerConnectThread.Create(FServerIP, FPort);
  TGPSServerConnectThread(FWorkThread).OnStateChanged := ConnectStateChanged;
  TGPSServerConnectThread(FWorkThread).OnLogGpsData := DoLogGPSData;
  FWorkThread.Start;
  UpdateUI;
end;

procedure TGPSServerConnectObj.DoDisconnect;
var
  Worker: TGPSServerConnectThread;
begin
  Worker := TGPSServerConnectThread(FWorkThread);
  FWorkThread := nil;
  if Assigned(Worker) then
    begin
      Worker.OnLogGpsData := nil;
      Worker.OnStateChanged := nil;
      Worker.Terminate;
    end;
  FState := csDisconnected;
  UpdateUI;
end;

procedure TGPSServerConnectObj.DoLogGPSData(Sender: TObject;
  const GpsData: TGpsData);
begin
  if Assigned(FOnLogGpsData)
    then FOnLogGpsData(Self, GpsData);
end;

procedure TGPSServerConnectObj.ToggleState;
begin
  if FState = csDisconnected
    then DoConnect
    else DoDisconnect;
end;

procedure TGPSServerConnectObj.UpdateUI;
begin
  if Assigned(FOnUpdateUI)
    then FOnUpdateUI(Self);
end;

end.
