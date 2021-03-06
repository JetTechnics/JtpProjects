program Titler;

uses
  Vcl.Forms,
  TitlerUnit in 'TitlerUnit.pas' {MainForm},
  JTPStudio in '..\JTPStudio\JTPStudio.pas',
  VideoSetsHeader in '..\VideoSettings\VideoSetsHeader.pas',
  TypesJTP in '..\JTPStudio\TypesJTP.pas',
  PreviewUnit in 'PreviewUnit.pas' {PreviewForm},
  Vector in '..\JtpStudio\Vector.pas',
  PluginJTP in '..\JtpStudio\PluginJTP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TPreviewForm, PreviewForm);
  Application.Run;
end.
