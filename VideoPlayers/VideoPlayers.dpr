program VideoPlayers;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  JTPStudio in '..\JTPStudio\JTPStudio.pas',
  PluginJTP in '..\JtpStudio\PluginJTP.pas',
  TypesJTP in '..\JTPStudio\TypesJTP.pas',
  Vector in '..\JtpStudio\Vector.pas',
  VideoSetsHeader in '..\VideoSettings\VideoSetsHeader.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
