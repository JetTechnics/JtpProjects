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
  GpsConnection in 'GpsConnection.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
