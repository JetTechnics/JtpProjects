unit PreviewUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TPreviewForm = class(TForm)
    PreviewPanel1: TPanel;
    PreviewPanel2: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PreviewForm: TPreviewForm;

implementation

{$R *.dfm}

end.
