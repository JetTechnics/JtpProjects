program TankBiathlon;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  JTPStudio in '..\JTPStudio\JTPStudio.pas',
  PluginJTP in '..\JTPStudio\PluginJTP.pas',
  TypesJTP in '..\JTPStudio\TypesJTP.pas',
  Decklink in '..\VideoSettings\Decklink.pas',
  VideoSetsHeader in '..\VideoSettings\VideoSetsHeader.pas',
  Poligon2D in 'Poligon2D.pas',
  Vehicle in 'Vehicle.pas',
  Vector in '..\JtpStudio\Vector.pas',
  GpsConnection in 'GpsConnection.pas',
  Titers in 'Titers.pas',
  GPSTelemetry in 'GpsTankTelemetry\GPSTelemetry.pas' {_GPSTelemetry},
  GPS_dm in 'GpsTankTelemetry\GPS_dm.pas' {_GPS_dm: TDataModule},
  uConsts in 'uConsts.pas',
  frGPSServerConnect in 'frGPSServerConnect.pas' {GPSServerConnectFrame: TFrame},
  uGPSPacketsQueue in 'uGPSPacketsQueue.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(T_GPSTelemetry, _GPSTelemetry);
  Application.CreateForm(T_GPS_dm, _GPS_dm);
  Application.Run;
end.
