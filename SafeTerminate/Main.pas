{ SafeTerminateProcess implementation 2009 stOrM!
  based on an article by DrDobbs http://www.ddj.com/windows/184416547
}

unit Main;

interface

uses
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TMainForm = class(TForm)
    edtProcHandle: TEdit;
    edtExitResult: TEdit;
    btnTerminate:  TButton;
    btnRunProcess: TButton;
    procedure btnTerminateClick(Sender: TObject);
    procedure btnRunProcessClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    RemoteProcHandle: cardinal;
    function SafeTerminateProcess(const hProcess: cardinal;
      uExitCode: cardinal): boolean;
    procedure StartApp(const App, Parameters, CurDir: string);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  JwaWindows,
  JWsclToken,
  JwsclSid,
  JwsclKnownSid,
  JwsclTypes,
  JwsclAcl,
  JwsclConstants,
  JwsclLsa,
  JwsclExceptions,
  JwsclStrings;

// Get remote process handle from process id
function GetProcessHandleFromID(ID: DWORD): THandle;
begin
  Result := OpenProcess(PROCESS_CREATE_THREAD or PROCESS_QUERY_INFORMATION or
    PROCESS_VM_OPERATION or PROCESS_VM_WRITE or PROCESS_VM_READ, False, ID);
end;

// Create process
procedure TMainForm.StartApp(const App, Parameters, CurDir: string);
var
  StartupInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  pEnv: Pointer;
  pCurDir, pCmdLine: PChar;
begin
  ZeroMemory(@StartupInfo, sizeof(StartupInfo));
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.lpDesktop := 'winsta0\default';

  CreateEnvironmentBlock(@pEnv, 0, True);

  try
    if Length(Parameters) > 0 then
      pCmdLine := PChar('"' + App + '" ' + Parameters)
    else
      pCmdLine := PChar('"' + App + '" ');

    pCurDir := nil;
    if Length(CurDir) > 0 then
      pCurDir := PChar(CurDir);

    if not CreateProcess(PChar(App), pCmdLine, nil, nil, True,
      CREATE_NEW_CONSOLE or CREATE_UNICODE_ENVIRONMENT, pEnv, pCurDir,
      StartupInfo, ProcInfo) then
      raiseLastOsError;
  finally
    DestroyEnvironmentBlock(pEnv);
  end;

  // remote process handle
  RemoteProcHandle := GetProcessHandleFromID(ProcInfo.dwProcessId);

  //wait until process can receive user input
  WaitForInputIdle(ProcInfo.hProcess, 60 * 1000);

  CloseHandle(ProcInfo.hProcess);
  CloseHandle(ProcInfo.hThread);
end;

// SafeTerminateProcess implementation
function TMainForm.SafeTerminateProcess(const hProcess: cardinal;
  uExitCode: cardinal): boolean;
var
  dwTID, dwCode, dwErr: DWORD;
  hProcessDup: cardinal;
  bDup: BOOL;
  hrt:  cardinal;
  hKernel: HMODULE;
  bSuccess: BOOL;
  FARPROC: Pointer;
begin
  dwTID := 0;
  dwCode := 0;
  dwErr := 0;
  hProcessDup := INVALID_HANDLE_VALUE;
  hrt := NULL;
  bSuccess := False;

  if (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    bDup := DuplicateHandle(GetCurrentProcess(), hProcess,
      GetCurrentProcess(), @hProcessDup, PROCESS_ALL_ACCESS, False, 0);

    // Detect the special case where the process is
    // already dead...
    if (GetExitCodeProcess(hProcessDup, dwCode)) then
    begin
      hKernel := GetModuleHandle('Kernel32');
      FARPROC := GetProcAddress(hKernel, 'ExitProcess');
      hRT := CreateRemoteThread(hProcessDup, nil, 0, Pointer(FARPROC),
        @uExitCode, 0, @dwTID);

      if (hRT = NULL) then
        dwErr := GetLastError()
      else
        dwErr := ERROR_PROCESS_ABORTED;

      if (hrt <> Null) then
        WaitForSingleObject(hProcessDup,
          INFINITE);
      CloseHandle(hRT);
      bSuccess := True;

      if (bDup) then
        CloseHandle(hProcessDup);

      if not (bSuccess) then
        SetLastError(dwErr);

      Result := bSuccess;
    end;
  end;
end;

procedure TMainForm.btnRunProcessClick(Sender: TObject);
begin
  StartApp('c:\windows\system32\calc.exe', '', '');
  edtProcHandle.Text := IntToStr(RemoteProcHandle);
end;

procedure TMainForm.btnTerminateClick(Sender: TObject);
begin
  // might not be needed...
  JwEnablePrivilege(SE_DEBUG_NAME, pst_Enable);

  case SafeTerminateProcess(RemoteProcHandle, 0) of
    True: edtExitResult.Text  := 'Savely terminated!';
    False: edtExitResult.Text := 'Something went wrong';
  end;

end;

end.
