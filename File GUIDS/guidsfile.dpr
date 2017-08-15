program guidsfile;

uses
  Vcl.Forms,
  storm.guidfile in 'storm.guidfile.pas' {frmMain},
  storm.filemanagment in 'storm.filemanagment.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
