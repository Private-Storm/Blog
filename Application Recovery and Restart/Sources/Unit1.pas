unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  JwaAppRecovery;

type
  APPLICATION_RECOVERY_CALLBACK = function(pvParameter: Pointer): DWORD; cdecl;
  TApplicationRecoveryCallback = APPLICATION_RECOVERY_CALLBACK;

type
  TForm1 = class(TForm)
    mmo1:          TMemo;
    tmr1:          TTimer;
    lblCrashCtdwn: TLabel;
    procedure tmr1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure Crash;
  end;

var
  Form1:    TForm1;
  pbCancel: Bool;
  success:  longbool;

implementation

{$R *.dfm}

function ApplicationCallBack(pvParameter: Pointer): DWORD; cdecl;
begin
  ApplicationRecoveryInProgress(pbCancel);
  form1.mmo1.Lines.SaveToFile('recovery.dat');
  ApplicationRecoveryFinished(success);

  Result := 0;
end;

procedure TForm1.Crash;
begin
  asm
    MOV EAX, 0;
    CALL EAX;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RegisterApplicationRestart(nil, RESTART_NO_FLAGS);
  RegisterApplicationRecoveryCallback(@ApplicationCallBack,
    nil, RECOVERY_DEFAULT_PING_INTERVAL, 0);
  pbCancel := False;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  tmr1.Enabled := True;

  if FileExists('recovery.dat') then
  begin

    try
      mmo1.Lines.Clear;
      mmo1.Lines.LoadFromFile('recovery.dat');
    finally
      DeleteFile('recovery.dat');
    end;

  end;

end;

function SecToTime(Sec: integer): string;
var
  H, M, S: string;
  ZH, ZM, ZS: integer;
begin
  ZH := Sec div 3600;
  ZM := Sec div 60 - ZH * 60;
  ZS := Sec - (ZH * 3600 + ZM * 60);
  H  := IntToStr(ZH);
  M  := IntToStr(ZM);
  S  := IntToStr(ZS);
  Result := H + ':' + M + ':' + S;
end;

procedure TForm1.tmr1Timer(Sender: TObject);
begin
  tmr1.Tag := tmr1.Tag - 1;
  lblCrashCtdwn.Caption := Format('Countdown till recovering process: %s',
    [SecToTime(tmr1.Tag)]);
  case tmr1.Tag of
    0:
    begin
      JITEnable := 1;
      Crash;
    end;
  end;
end;

end.
