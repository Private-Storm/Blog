program pkverifier;

uses
  Vcl.Forms,
  storm.pkverifier.main in 'storm.pkverifier.main.pas' {MainForm},
  storm.pkverifier.thrd in 'storm.pkverifier.thrd.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Onyx Blue');
  Application.CreateForm(TMainForm, MainForm);
  {$IFDEF DEBUG}
   ReportMemoryLeaksOnShutdown := true;
  {$ENDIF}
  Application.Run;
end.
