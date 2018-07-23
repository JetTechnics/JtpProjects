unit uGPSServerConnect;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.WinSock,
  System.SysUtils, System.Variants, System.Classes,
  uGPSData;

type
  TLogGPSDataEvent = procedure(Sender: TObject; const GpsData: TGpsData) of object;
  TConnectionChangedEvent = procedure(Sender: TObject;
                              const OldState, NewState: TConnectState) of object;

  TGPSServerConnectObj = class(TObject)
  private
    FServerIP: string;
    FPort: integer;
    FState: TConnectState;
    FWorkThread: TThread;
    FOnUpdateUI: TNotifyEvent;
    FOnLogGpsData: TLogGPSDataEvent;
    FOnConnectionChanged: TConnectionChangedEvent;
    procedure ConnectStateChanged(Sender: TThread;
                const OldState, NewState: TConnectState);
    procedure DoConnect;
    procedure DoDisconnect;
    procedure DoLogGPSData(Sender: TObject; const GpsData: TGpsData);
  protected
    procedure UpdateUI; virtual;
    procedure DoConnectionChanged(const OldState, NewState: TConnectState); virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ToggleState(const AServerIP: string; const Port: integer);
    property ConnectState: TConnectState read FState write FState;
    property OnUpdateUI: TNotifyEvent read FOnUpdateUI write FOnUpdateUI;
    property OnLogGpsData: TLogGPSDataEvent read FOnLogGpsData write FOnLogGpsData;
    property OnConnectionChanged: TConnectionChangedEvent
                                    read FOnConnectionChanged
                                    write FOnConnectionChanged;
  end;

implementation

uses
  uGPSPacketsQueue;

{************ Copy from TypesJTP **********************}
//  Значения параметров движка, которые ничего не меняют.
const  FLT_UNDEF    : single  = 3.402823466e+38;
//const  COLOR_UNDEF  : dword   = $CCCCCCCC;
const  INT_UNDEF    : integer = $CCCCCCCC;
{************ End Copy from TypesJTP ******************}

const
  GpsPacketSize = 36;
  GpsMaxCompNameLen = 16-1-1;   // 16 bytes - 1 byte packet type - #0 byte

const
  GPS_TITLER_NAME: byte = 1;    // Packet type with computer name
  GpsPacketLen: integer = GpsPacketSize;   // Packet length

type
  TGpsPacketByte = array[1..GpsPacketSize] of byte;

var
  WSAStarted: boolean;

procedure CheckWSAStarted;
var
  WSAData: TWSAData;
begin
  if WSAStarted then Exit;
  WSAStartup(MakeWord(2,2), WSAData);
  WSAStarted := true;
end;

{ TGPSServerConnectThread }

type
  TConnectStateChangedEvent = procedure(Sender: TThread;
                                const OldState, NewState: TConnectState) of object;

  TGPSServerConnectThread = class(TThread)
  private
    FCompName: TGpsPacketByte;
    FServerIP: string;
    FServerIPa: array[0..63] of AnsiChar;
    FPort: integer;
    FConnectState: TConnectState;
    FGPSSocket: Int64;
    FGPSLastAccess: UInt64;
    FGPSLastBeat: UInt64;
    FOnStateChanged: TConnectStateChangedEvent;
    FOnLogGpsData: TLogGPSDataEvent;
    {$ifndef ver320}
    FOldState: TConnectState;
    FNewState: TConnectState;
    procedure DoStateChanged7;
    {$endif}
    procedure CheckIncomingData;
    procedure ConnectToGPSServer;
    procedure SetServerIP(const Value: string);
  protected
    procedure Execute; override;
    procedure DoStateChanged(const OldState, NewState: TConnectState); virtual;
    procedure DoLogGpsData(const GpsData: TGpsData); virtual;
  public
    constructor Create(const AServerIP: string; const Port: integer); reintroduce;
    property ServerIP: string read FServerIP write SetServerIP;
    property Port: integer read FPort;
    property OnStateChanged: TConnectStateChangedEvent read FOnStateChanged
                                                       write FOnStateChanged;
    property OnLogGpsData: TLogGPSDataEvent read FOnLogGpsData write FOnLogGpsData;
  end;

{ TGPSServerConnectThread }

procedure TGPSServerConnectThread.CheckIncomingData;
const
  MaxGpsTimeout: UInt64 = 3000; // Если привысили MaxGpsTimeout то рвём соединение.
  BeatInterval: UInt64 = 1000;
var
  Res : integer;
  buff: array[0..255] of dword;
  GpsData: TGpsData;
  CurrentMills: UInt64;
  lId: TGpsPacketByte;

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
            CopyMemory(@lId[1], @FCompName[1], GpsPacketLen);
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
                CurrentMills := FGPSLastAccess;

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
  lId: TGpsPacketByte;
  SockSet: TFDSet;
  TimeoutStruct: TTimeVal;
begin
  Res := 0;
  CheckWSAStarted;
  FGPSLastAccess := Winapi.Windows.GetTickCount64;

  if FGPSSocket = INVALID_SOCKET then
    begin
      FGPSSocket := socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
      if FGPSSocket = INVALID_SOCKET then
        begin
          // Res := WSAGetLastError(); for debugging purposes
          WSACleanup();
          WSAStarted := false;
          FGPSSocket := INVALID_SOCKET;
          Exit;
        end;

      NotBlock := 1;
      Res := ioctlsocket(FGPSSocket, FIONBIO, NotBlock);
      if Res <> 0 then
        begin
          WSACleanup();
          WSAStarted := false;
          FGPSSocket := INVALID_SOCKET;
          Exit;
        end;
    end;

  AddrIn.sin_family := AF_INET;
  AddrIn.sin_port := htons(FPort);
  AddrIn.sin_addr.S_addr := inet_addr(FServerIPa);

  Res := connect(FGPSSocket, AddrIn, sizeof(AddrIn));
  Res := WSAGetLastError();
  if Res = WSAEWOULDBLOCK then
    begin
      SockSet.fd_count := 1;
      SockSet.fd_array[0] := FGPSSocket;
      TimeoutStruct.tv_sec := 3;
      TimeoutStruct.tv_usec := 0;
      Res := select(1, nil, @SockSet, nil, @TimeoutStruct);
      if Res = 1 then Res := WSAEISCONN
                 else
        begin
          closesocket(FGPSSocket);
          FGPSSocket := INVALID_SOCKET;
          Exit;
        end;
    end;
  if Res = WSAEISCONN then
    begin
      FConnectState := csConnected;
      DoStateChanged(csDisconnected, FConnectState);
      CopyMemory(@lId[1], @FCompName[1], GpsPacketLen);
      Res := send(FGPSSocket, lId, SizeOf(lId), 0);
      if Res = SizeOf(lId)
        then FGPSLastBeat := Winapi.Windows.GetTickCount64;
    end;
end;

constructor TGPSServerConnectThread.Create(const AServerIP: string;
  const Port: integer);
var
  sz: Cardinal;
  Res: BOOL;
  s: AnsiString;
begin
  inherited Create(true);
  FCompName[1] := GPS_TITLER_NAME;
  sz := MAX_COMPUTERNAME_LENGTH + 1;
  Res := GetComputerNameA(@FCompName[2], sz);
  if not Res then
    begin
      Randomize;
      s := AnsiString(IntToStr(Random(1000)));
      sz := Length(s);
      CopyMemory(@FCompName[2], PAnsiChar(s), sz);
    end;
  FillChar(FCompName[sz+2], GpsPacketLen-sz-1, 0);
  FreeOnTerminate := true;
  SetServerIP(AServerIP);
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

  {$ifdef ver320}
  TThread.Queue(nil,
      procedure
      begin
        FOnStateChanged(Self, OldState, NewState);
      end
    );
  {$else}
  FOldState := OldState;
  FNewState := NewState;
  Synchronize(DoStateChanged7);
  {$endif}
end;

{$ifndef ver320}
procedure TGPSServerConnectThread.DoStateChanged7;
begin
  FOnStateChanged(Self, FOldState, FNewState);
end;
{$endif}

procedure TGPSServerConnectThread.Execute;
begin
  repeat
    try
      CheckIncomingData;
      Sleep(100);
    except
    end;
  until Terminated;
end;

procedure TGPSServerConnectThread.SetServerIP(const Value: string);
begin
  SetString(FServerIP, PChar(Value), Length(Value));
  StrCopy(FServerIPa, PAnsiChar(AnsiString(FServerIP)));
end;

{ TGPSServerConnectObj }

procedure TGPSServerConnectObj.ConnectStateChanged(Sender: TThread;
  const OldState, NewState: TConnectState);
var
  PrevState: TConnectState;
begin
  if Sender <> FWorkThread then Exit;

  PrevState := FState;
  if NewState = csConnected
    then FState := csConnected
    else FState := csConnecting;
  DoConnectionChanged(PrevState, FState);
  UpdateUI;
end;

constructor TGPSServerConnectObj.Create;
begin
  inherited Create;
  CheckWSAStarted;
  FServerIP := '0.0.0.0';
  FPort := 0;
  FWorkThread := nil;
  FState := csDisconnected;
  uGPSPacketsQueue.InitializeQueue;
end;

destructor TGPSServerConnectObj.Destroy;
begin
  DoDisconnect;
  uGPSPacketsQueue.DeinitializeQueue;
  if WSAStarted then WSACleanup;
  inherited Destroy;
end;

procedure TGPSServerConnectObj.DoConnect;
var
  PrevState: TConnectState;
begin
  if Assigned(FWorkThread) then Exit;

  PrevState := FState;
  FState := csConnecting;

  FWorkThread := TGPSServerConnectThread.Create(FServerIP, FPort);
  TGPSServerConnectThread(FWorkThread).OnStateChanged := ConnectStateChanged;
  TGPSServerConnectThread(FWorkThread).OnLogGpsData := DoLogGPSData;
  FWorkThread.Start;
  DoConnectionChanged(PrevState, FState);
  UpdateUI;
end;

procedure TGPSServerConnectObj.DoConnectionChanged(const OldState,
  NewState: TConnectState);
begin
  if (NewState <> OldState) and
     Assigned(FOnConnectionChanged)
    then FOnConnectionChanged(Self, OldState, NewState);
end;

procedure TGPSServerConnectObj.DoDisconnect;
var
  Worker: TGPSServerConnectThread;
  PrevState: TConnectState;
begin
  Worker := TGPSServerConnectThread(FWorkThread);
  FWorkThread := nil;
  if Assigned(Worker) then
    begin
      Worker.OnLogGpsData := nil;
      Worker.OnStateChanged := nil;
      Worker.Terminate;
    end;
  PrevState := FState;
  FState := csDisconnected;
  DoConnectionChanged(PrevState, FState);
  UpdateUI;
end;

procedure TGPSServerConnectObj.DoLogGPSData(Sender: TObject;
  const GpsData: TGpsData);
begin
  if Assigned(FOnLogGpsData)
    then FOnLogGpsData(Self, GpsData);
end;

procedure TGPSServerConnectObj.ToggleState(const AServerIP: string; const Port: integer);
begin
  if FState = csDisconnected
    then begin
           FServerIP := AServerIP;
           FPort := Port;
           DoConnect;
         end
    else DoDisconnect;
end;

procedure TGPSServerConnectObj.UpdateUI;
begin
  if Assigned(FOnUpdateUI)
    then FOnUpdateUI(Self);
end;

initialization
  WSAStarted := false;

end.
