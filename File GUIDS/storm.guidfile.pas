unit storm.guidfile;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  ActiveX,

  storm.filemanagment;

type
  TfrmMain = class(TForm)
    gbFileInfo: TGroupBox;
    gbObjectInfo: TGroupBox;
    btnExit: TButton;
    btnChoiceFile: TButton;
    lbName: TLabel;
    btnGuid: TButton;
    Op: TOpenDialog;
    lbGuid: TLabel;
    memLog: TMemo;
    procedure btnChoiceFileClick(Sender: TObject);
    procedure btnGuidClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
  private
    gObID, gRoot: string;
    function FilenameToGUIDStr(const AFilename: String): Boolean;
    function PrintGUID(AGUID: TGUID): string;
    function OpenFilenameFromGUID(const ARoot: string;
      ACLSIDStr: string): Boolean;
    procedure Read1KFromFile(AMemo: TMemo; AFile: string);
  public
    { Public-Deklarationen }
  end;

var
  frmMain: TfrmMain;

function OpenFileByID(hFile: THandle; lpFileID: LPFILE_ID_DESCRIPTOR;
  dwDesiredAccess: DWORD; dwShareMode: DWORD;
  lpSecurityAttributes: PSecurityAttributes; dwFlags: DWORD): THandle; stdcall;
  external kernel32 name 'OpenFileById';
{$EXTERNALSYM OpenFileByID}
function GetFileInformationByHandleEx(hFile: THandle;
  FileInformationClass: FILE_INFO_BY_HANDLE_CLASS; lpFileInformation: LPVOID;
  dwBufferSize: DWORD): BOOL; stdcall;
  external kernel32 name 'GetFileInformationByHandleEx';
{$EXTERNALSYM GetFileInformationByHandleEx}

implementation

{$R *.dfm}

procedure TfrmMain.btnChoiceFileClick(Sender: TObject);
begin
  if Op.Execute then
  begin
    lbName.Caption := Format('Name: %s',[Op.FileName]);
    if FilenameToGUIDStr(Op.FileName) then
      btnGuid.Enabled := True;
    gRoot := ExtractFileDrive(Op.FileName + ':\');
  end;
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.btnGuidClick(Sender: TObject);
begin
  OpenFilenameFromGUID(gRoot, gObID);
end;

function TfrmMain.FilenameToGUIDStr(const AFilename: String): Boolean;
var
  h: THandle;
  buf: FILE_OBJECTID_BUFFER;
  lpOutBuffer: Cardinal;
  GUID: TGUID;
begin
  gObID := '';
  try
    h := CreateFile(PChar(AFilename), 0, FILE_SHARE_READ or FILE_SHARE_WRITE or
      FILE_SHARE_DELETE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

    if not(h = INVALID_HANDLE_VALUE) then
      if (DeviceIoControl(h, FSCTL_CREATE_OR_GET_OBJECT_ID
        { FSCTL_GET_OBJECT_ID }
        { FSCTL_SET_OBJECT_ID } , nil, 0, @buf, sizeof(buf), lpOutBuffer, nil))
      then
        CopyMemory(@GUID, @buf.ObjectID, sizeof(GUID));

    lbGuid.Caption := Format('Object Identifier: %s', [PrintGUID(GUID)]);
    gObID := PrintGUID(GUID);
  except
    Result := False;
    RaiseLastOSError;
  end;
  CloseHandle(h);
  Result := True;
end;

function TfrmMain.OpenFilenameFromGUID(const ARoot: string;
  ACLSIDStr: string): Boolean;
var
  hRoot: THandle;
  h: THandle;
  desc: File_ID_DESCRIPTOR;
  pFilenameInfoClass: PFILE_NAME_INFO;
  dwSize: DWORD;
begin
  Result := False;
  hRoot := CreateFile(PChar(ARoot), 0, FILE_SHARE_READ or FILE_SHARE_WRITE or
    FILE_SHARE_DELETE, nil, OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, 0);

  if (hRoot <> INVALID_HANDLE_VALUE) then
  begin
    desc.dwSize := sizeof(desc);
    desc.cType := ObjectIdType;

    if (SUCCEEDED(CLSIDFromString(PChar(ACLSIDStr), desc.ObjectID))) then
      try
        h := OpenFileByID(hRoot, @desc, GENERIC_READ, FILE_SHARE_READ or
          FILE_SHARE_WRITE or FILE_SHARE_DELETE, nil, 0);

        if (h <> INVALID_HANDLE_VALUE) then
        begin
          dwSize := sizeof(TFILE_NAME_INFO) + sizeof(WCHAR) * $8000;
          pFilenameInfoClass := AllocMem(dwSize);

          if Assigned(pFilenameInfoClass) then
          begin
            if not GetFileInformationByHandleEx(h, FileNameInfo,
              pFilenameInfoClass, dwSize) then
              RaiseLastOSError;
          end;
          CloseHandle(h);
          Result := True;

          memLog.Lines.Add(pFilenameInfoClass.FileName);
          // Read1KFromFile(Memo1, pFilenameInfoClass.FileName);

        end;
      except
        CloseHandle(hRoot);
        RaiseLastOSError;
      end;
    CloseHandle(hRoot);
    FreeMem(pFilenameInfoClass, sizeof(pFilenameInfoClass));
  end;
end;

function TfrmMain.PrintGUID(AGUID: TGUID): string;
begin
  Result := GUIDToString(AGUID);
end;

procedure TfrmMain.Read1KFromFile(AMemo: TMemo; AFile: string);
var
  Stream: TFileStream;
  Buffer: array [0 .. 1023] of Char;
  TempStr: string;
  i: Integer;
begin
  AMemo.Clear;
  Stream := TFileStream.Create(AFile, fmOpenRead);
  try
    Stream.Read(Buffer[0], sizeof(Buffer));
  finally
    Stream.Free;
  end;
  // Replace null (#0) values with #216 (Ø)
  for i := Low(Buffer) to High(Buffer) do
    if Buffer[i] = #0 then
      Buffer[i] := 'Ø';
  TempStr := Buffer;
  AMemo.Lines.Add(TempStr);
end;

end.
