// Copyright 2010 stOrM!

// Licensed under the Apache License, Version 2.0 (the "License"); you may not
// use this file except in compliance with the License. You may obtain a copy
// of the License at

//   http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
// License for the specific language governing permissions and limitations
// under the License.


unit Main;

interface

uses
  Messages, Variants, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, pngimage, PngSpeedButton,
  ImgList, AdvGroupBox, JvExStdCtrls, JvMemo, Buttons,
  Clipbrd,

  JwaWindows;

type
  TMainForm = class(TForm)
    WLMLogo: TImage;
    imgClient: TImage;
    imgHeader: TImage;
    grpFirstAccount: TAdvGroupBox;
    ilGrpBox: TImageList;
    lblUsr: TLabel;
    edtUsr: TEdit;
    edtPw: TEdit;
    lblPW: TLabel;
    grpAllAccounts: TAdvGroupBox;
    CredentialsLog: TJvMemo;
    btnDecrypt: TPngSpeedButton;
    btnclose: TPngSpeedButton;
    btnClipboard: TPngSpeedButton;
    btnPrev: TPngSpeedButton;
    btnNext: TPngSpeedButton;
    procedure btnGetClick(Sender: TObject);
    procedure btncloseClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnClipboardClick(Sender: TObject);
    procedure JvClipboardMonitor1Change(Sender: TObject);
    procedure JvClipboardViewer1Text(Sender: TObject; AText: string);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    function Tokenize(s: string; index: integer; sep: char): string;
    procedure DecryptWLPassword;
    procedure CopyPWToClipboard(szPW: string);
  end;

const
  ANYSIZE_ARRAY = 1;

type
  TPCredentialsArray = array [0 .. ANYSIZE_ARRAY - 1] of PCREDENTIALW;
  PCredentialsArray = ^TPCredentialsArray;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.JvClipboardMonitor1Change(Sender: TObject);
begin
  ShowMessage(
    'Your password is successfully stored into the clipboard. Use "ctrl+v" to past it back.');
end;

procedure TMainForm.JvClipboardViewer1Text(Sender: TObject; AText: string);
begin
  CredentialsLog.lines.Add(AText);
end;

function TMainForm.Tokenize(s: string; index: integer; sep: char): string;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  Try
    Repeat
      if Pos(sep, s) <> 0 then
      begin
        sl.Add(Copy(s, 1, Pos(sep, s) - 1));
        System.Delete(s, 1, Pos(sep, s));
      end
      else
      begin
        sl.Add(s);
        s := '';
      end;
    until s = '';
    if index <= sl.Count then
      Result := sl.Strings[index - 1]
    else
      Result := '';
  finally
    sl.Free;
  end;
end;

procedure TMainForm.DecryptWLPassword();
var
  dwCount: DWORD;
  CredArray: PCredentialsArray;
  I: integer;
  Pwd: string;
begin
  dwCount := 0;
  CredArray := nil;
  CredentialsLog.lines.Clear;
  edtUsr.Text := '';
  edtPw.Text := '';

  try
    Win32Check(CredEnumerate('WindowsLive:name=*', 0, dwCount,
        PCREDENTIALW(CredArray)));

    for I := 0 to dwCount - 1 do
    begin
      with CredentialsLog.lines, CredArray^[I]^ do
      begin
        if CredentialBlobSize > 0 then
        begin
          setlength(Pwd, CredentialBlobSize div sizeof(char));
          CopyMemory(@Pwd[1], CredentialBlob, CredentialBlobSize);
          btnNext.Enabled := CredentialBlobSize <> 0;
          btnPrev.Enabled := not(btnNext.Tag = 0);
          btnClipboard.Enabled := (edtPw.Text > '');
        end
        else
        begin
          setlength(Pwd, 0);
        end;
        if (I = 0) then
        begin
          edtUsr.Text := Username;
          edtPw.Text := Pwd;
        end;
        Add(Format('Username: %s Password: %s', [Username, Pwd]));
      end;
    end;
  except
    ShowMessage(
      'Sorry no accounts found maybe the user doesn''t saved the password');
  end;
  if dwCount > 0 then
    SecureZeroMemory(@Pwd[1], Length(Pwd));
  CredFree(CredArray);
end;

procedure TMainForm.btnGetClick(Sender: TObject);
begin
  DecryptWLPassword;
end;

procedure TMainForm.btnNextClick(Sender: TObject);
var
  PW, Usr: string;
begin
  if not(btnNext.Tag = CredentialsLog.lines.Count - 1) then
  begin
    btnNext.Tag := btnNext.Tag + 1;
    btnPrev.Tag := btnNext.Tag;
    btnNext.Enabled := True;
    btnPrev.Enabled := True;
    Usr := Tokenize(CredentialsLog.lines.Strings[btnNext.Tag], 2, ' ');
    PW := Tokenize(CredentialsLog.lines.Strings[btnNext.Tag], 4, ' ');
    edtUsr.Text := Usr;
    edtPw.Text := PW;
    SecureZeroMemory(@PW[1], Length(PW));
  end
  else if (btnNext.Tag = CredentialsLog.lines.Count - 1) then
  begin
    btnNext.Enabled := False;
    btnPrev.Enabled := True;
    btnPrev.Tag := btnNext.Tag;
    SecureZeroMemory(@PW[1], Length(PW));
  end;
end;

procedure TMainForm.btnPrevClick(Sender: TObject);
var
  PW, Usr: string;
begin
  if not(btnPrev.Tag = 0) and (btnNext.Tag > 0) then
  begin
    btnPrev.Tag := btnPrev.Tag - 1;
    btnNext.Tag := btnNext.Tag;
    btnNext.Enabled := True;
    btnPrev.Enabled := True;
    Usr := Tokenize(CredentialsLog.lines.Strings[btnPrev.Tag], 2, ' ');
    PW := Tokenize(CredentialsLog.lines.Strings[btnPrev.Tag], 4, ' ');
    edtUsr.Text := Usr;
    edtPw.Text := PW;
    SecureZeroMemory(@PW[1], Length(PW));
  end
  else if (btnPrev.Tag = 0) then
  begin
    btnNext.Enabled := True;
    btnPrev.Enabled := False;
    btnNext.Tag := btnPrev.Tag;
    SecureZeroMemory(@PW[1], Length(PW));
  end;
end;

procedure TMainForm.CopyPWToClipboard(szPW: string);
begin
  Clipboard.AsText := szPW;
  SecureZeroMemory(@szPW[1], Length(szPW))
end;

procedure TMainForm.btnClipboardClick(Sender: TObject);
begin
  CopyPWToClipboard(edtPw.Text);
end;

procedure TMainForm.btncloseClick(Sender: TObject);
begin
  Close;
end;

end.
