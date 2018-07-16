program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uGPSData in 'uGPSData.pas',
  uGPSPacketsQueue in 'uGPSPacketsQueue.pas',
  uGPSServerConnect in 'uGPSServerConnect.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
