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


unit SrcApiClass;

interface

uses { codegear units }
  SysUtils, ActiveX, ComObj, ShlObj, Dialogs,
  ComCtrls, Classes, Messages, Variants, Forms, SyncObjs,

  { imports }
  SearchAPILib_TLB,
  ADODB_TLB,

  { 3rd party units }
  UOleException,
  QPTimerU,

  { jwscl units }
  JwaWindows,
  JwsclUtils,
  JwsclExceptions;

const
  TS_THREAD_SEARCH_STARTED        = WM_USER + 1;     // OUT
  TS_THREAD_SEARCH_FINISHED       = WM_USER + 2;     // OUT
  TS_THREAD_SEARCH_ITEMS_COUNT    = WM_USER + 3;     // OUT
  TS_Thread_SEARCH_ITEMS_NEW_ENUM = WM_USER + 4;  // OUT

type
  // message is send when the thread executed a search
  TThreadSearchStartedMsg = record
    StartTime: integer;
  end;
  PThreadSearchStartedMsg = ^TThreadSearchStartedMsg;

  // message is send when the thread finished a search
  TThreadSearchFinishedMsg = record
    EndTime: integer;
  end;
  PThreadSearchFinishedMsg = ^TThreadSearchFinishedMsg;

  // message is send when the thread finished and we know how many items found
  TThreadSearchItemsCountMsg = record
    Items: integer;
  end;
  PThreadSearchItemsCountMsg = ^TThreadSearchItemsCountMsg;

  // enumeration started send the pointer back to the mainthread
  TThreadSearchItemsEnumMsg = record
    ItemName:  string;
    ItemCount: integer;
  end;
  PThreadSearchItemsEnumMsg = ^TThreadSearchItemsEnumMsg;

type
  PSearchThread = ^TSearchThread;

  TSearchThread = class(TJwThread)
  protected

    FConnectionStr: PWideChar;
    FSearchString:  PWideChar;

    { OleDBConnection inside a seperate thread to ensure no gui freezing}
    FAdoDBConnection: _Connection;
    FAdoRecordSet:    _Recordset;
    // FFileList: TFileObject;
  private

  public
    ThreadSearchStartedMsgPtr:    PThreadSearchStartedMsg;
    ThreadSearchFinishedMsgPtr:   PThreadSearchFinishedMsg;
    ThreadSearchItemsCountMsgPrt: PThreadSearchItemsCountMsg;
    ThreadSearchItemsEnumMsgPrt:  PThreadSearchItemsEnumMsg;

    constructor Create(const SearchPattern: PWideChar; pConnection: PWideChar;
      const FreeOnTerm: boolean);
    destructor Destroy; override;
    procedure Execute; override;
    // property FileList: FFilelist and so on
  end;

type
  TSearchApi = class(TObject)
  protected
    { SearchManager }
    FSearchManager:        ISearchManager;
    FSearchCatalogManager: ISearchCatalogManager;
    FQueryHelper:          ISearchQueryHelper;
    FSearchCrawlScopeManager: ISearchCrawlScopeManager;
    FSearchRoot:           ISearchRoot;

    {setter / getter }
    FConnectionString:  PWideChar;
    FConnectionTimeOut: cardinal;
    FSearchQuery, FSQL: PWideChar;

    FSearchCatalogStatus, FSearchCatalogStatusReason: string;

    FNumberOfItemsInCatalog:   integer;
    FNumberOfFilesToBeIndexed: integer;
    FLastindexedUrl:           PWideChar;
    FIndexerVersionString:     PWideChar;

    FContentLocale:      LCID;
    FQueryKeywordLocale: LCID;

    FSearchThread: TSearchThread;

    function GetSearchCatalogStatus: string;
    function GetSearchCatalogStatusReason: string;
    function GetNumberOfItemsInCatalog: integer;
    function GetNumberOfFilesToBeIndexed: integer;
    function GetIndexerVersionString: PWideChar;
    function GetLastIndexedURL: PWideChar;

  public
    constructor Create();
    destructor Destroy(); override;

    procedure ReIndexCatalog;
    procedure ReIndexViaPattern(MatchPattern: PWideChar);
    procedure ResetCatalog;
    procedure ReIndexRoot(Root: PWideChar);
    procedure RunQuery(SearchTxt: PWideChar);

    property SearchCatalogStatus: string Read GetSearchCatalogStatus
      Write FSearchCatalogStatus;
    property SearchCatalogStatusReason: string
      Read GetSearchCatalogStatusReason Write FSearchCatalogStatusReason;
    property NumberOfItemsInCatalog: integer
      Read GetNumberOfItemsInCatalog Write FNumberOfItemsInCatalog;
    property NumberOfFilesToBeIndexed: integer
      Read GetNumberOfFilesToBeIndexed Write FNumberOfFilesToBeIndexed;
    property IndexerVersionString: PWideChar
      Read GetIndexerVersionString Write FIndexerVersionString;
    property LastIndexedURL: PWideChar Read GetLastIndexedURL Write FLastIndexedURL;

  end;

procedure OutputDbg(const DebugStr: string); overload;
procedure OutputDbg(const DebugStr: string; Args: array of const); overload;

implementation

uses Main;

procedure OutputDbg(const DebugStr: string); overload;
begin
{$IFDEF DEBUG}
  OutputDebugString(PChar(DebugStr));
{$ENDIF DEBUG}
end;

procedure OutputDbg(const DebugStr: string; Args: array of const); overload;
begin
{$IFDEF DEBUG}
  OutputDebugString(PChar(Format(DebugStr, Args)));
{$ENDIF DEBUG}
end;

{ TSearchApi }

constructor TSearchApi.Create;
var
  hr: HRESULT;
begin
  inherited;

  hr := CoInitializeEx(nil, COINIT_APARTMENTTHREADED or COINIT_DISABLE_OLE1DDE);
  if (SUCCEEDED(hr)) then

    try
      FSearchManager := CoCSearchManager.Create;
      FQueryHelper := nil;
      FSearchCatalogManager := nil;
      FSearchCrawlScopeManager := nil;

      // SystemIndex is the only valid catalog we can connect to
      hr := FSearchManager.GetCatalog('SystemIndex', FSearchCatalogManager);
      if (SUCCEEDED(hr)) then

        // get the queryhelper
        hr := FSearchCatalogManager.GetQueryHelper(FQueryHelper);
      if (SUCCEEDED(hr)) then

        // get searchcrawlscopemanager
        hr := FSearchCatalogManager.GetCrawlScopeManager(FSearchCrawlScopeManager);
      if (SUCCEEDED(hr)) then

        // add a new root to be indexed
        //FSearchCrawlScopeManager.AddRoot(FSearchRoot);

        // we get the connectionstring for the adodb right from the queryhelper
        FQueryHelper.Get_ConnectionString(FConnectionString);
      OutputDbg(FConnectionString);

      // we get the connectionTimeOut for the adodb right from the queryhelper
      FSearchCatalogManager.Get_ConnectTimeout(FConnectionTimeOut);
      OutputDbg(IntToStr(FConnectionTimeOut));

      //negative numbers means get all results.
      FQueryHelper.Set_QueryMaxResults(-1);

      // make sure we have the right locales
      // example:
      // if you have the English version with the Romanian MUI pack,
      // the content locale is 2072 (ro) and the keyword locale is 1033 (en-us).

      hr := FQueryHelper.Get_QueryContentLocale(FContentLocale);
      if (SUCCEEDED(hr)) then
        hr := FQueryHelper.Get_QueryKeywordLocale(FQueryKeywordLocale);
      if (SUCCEEDED(hr)) then
        hr := FQueryHelper.Set_QueryContentLocale(FContentLocale);
      if (SUCCEEDED(hr)) then
        hr := FQueryHelper.Set_QueryKeywordLocale(FQueryKeywordLocale);
      if (SUCCEEDED(hr)) then

    except
      on E: Exception do
        if (E is EOleException) then
          ShowOleException(EOleException(E))
        else
          MessageBox(Application.Handle, PWideChar(E.Message), 'Error',
            MB_OK + MB_ICONSTOP + MB_TOPMOST);
    end;

end;

function TSearchApi.GetIndexerVersionString: PWideChar;
begin
  FSearchManager.GetIndexerVersionStr(Result);
end;

function TSearchApi.GetLastIndexedURL: PWideChar;
begin
  // admin rights needed otherwise result = null
  FSearchCatalogManager.URLBeingIndexed(Result);
end;

function TSearchApi.GetNumberOfItemsInCatalog: integer;
begin
  // the total number of items indexed
  FSearchCatalogManager.NumberOfItems(Result);
end;

function TSearchApi.GetNumberOfFilesToBeIndexed: integer;
var
  // contains a pointer to the number of items in the notification queue.
  plNotificationQueue,
  // contains a pointer to the number of items in the high priority queue.
  plHighPriorityQueue: integer;
  hr: HRESULT;
begin
  hr := FSearchCatalogManager.NumberOfItemsToIndex(Result, plNotificationQueue,
    plHighPriorityQueue);
  if Succeeded(hr) then
    OutputDbg('Getting number of items to be indexed')
  else
    OutputDbg('Getting number of items to be indexed failed');
end;

function TSearchApi.GetSearchCatalogStatus: string;
var
  hr: HRESULT;
  fCatStat, fCatReason: TOleEnum;
begin
  hr := FSearchCatalogManager.GetCatalogStatus(fCatStat, fCatReason);

  if (SUCCEEDED(hr)) then
    case fCatStat of
      CATALOG_STATUS_IDLE: Result := 'Idle';
      CATALOG_STATUS_PAUSED: Result := 'Paused';
      CATALOG_STATUS_RECOVERING: Result := 'Recovering';
      CATALOG_STATUS_FULL_CRAWL: Result := 'Full crawl';
      CATALOG_STATUS_INCREMENTAL_CRAWL: Result := 'Incremental crawl';
      CATALOG_STATUS_PROCESSING_NOTIFICATIONS: Result := 'Processing notifications';
      CATALOG_STATUS_SHUTTING_DOWN: Result := 'Shutting down';
    end;

  SearchCatalogStatus := Result;

end;

function TSearchApi.GetSearchCatalogStatusReason: string;
var
  hr: HRESULT;
  fCatStat, fCatReason: TOleEnum;
begin
  hr := FSearchCatalogManager.GetCatalogStatus(fCatStat, fCatReason);

  if (SUCCEEDED(hr)) then
    case fCatReason of
      CATALOG_PAUSED_REASON_NONE: Result := 'None';
      CATALOG_PAUSED_REASON_HIGH_IO: Result := 'High IO';
      CATALOG_PAUSED_REASON_HIGH_CPU: Result := 'High CPU';
      CATALOG_PAUSED_REASON_HIGH_NTF_RATE: Result := 'High NTF rate';
      CATALOG_PAUSED_REASON_LOW_BATTERY: Result := 'Low battery';
      CATALOG_PAUSED_REASON_LOW_MEMORY: Result := 'Low memory';
      CATALOG_PAUSED_REASON_LOW_DISK: Result := 'Low disk';
      CATALOG_PAUSED_REASON_DELAYED_RECOVERY: Result := 'Delayed recovery';
      CATALOG_PAUSED_REASON_USER_ACTIVE: Result := 'User active';
      CATALOG_PAUSED_REASON_EXTERNAL: Result := 'External';
      CATALOG_PAUSED_REASON_UPGRADING: Result := 'Upgrading';
    end;

  SearchCatalogStatusReason := Result;
end;

procedure TSearchApi.ReIndexCatalog;
var
  hr: HRESULT;
begin
  // re-indexes all URLs in the catalog. Old information remains in the catalog
  // until replaced by new information during re-indexing.

  hr := FSearchCatalogManager.Reindex;
  if Succeeded(hr) then
    OutputDbg('Reindexing Catalog items')
  else
    OutputDbg('Reindexing failed');
end;

procedure TSearchApi.ResetCatalog;
var
  hr: HRESULT;
begin
  // resets the underlying catalog by rebuilding the databases and performing
  // a full indexing.
  // resetting can take a very long time, which little or
  // no information is available to be searched.

  hr := FSearchCatalogManager.Reset;
  if Succeeded(hr) then
    OutputDbg('Resetting Catalog items')
  else
    OutputDbg('Resetting failed');
end;

procedure TSearchApi.RunQuery(SearchTxt: PWideChar);
var
  pszSQLStr, pszConStr: PWideChar;
begin
  if SearchTxt > '' then
  begin
    FQueryHelper.GenerateSQLFromUserQuery(SearchTxt, pszSQLStr);
    FQueryHelper.Get_ConnectionString(pszConStr);
    FSearchThread := TSearchThread.Create(pszSQLStr, pszConStr, True);
    FSearchThread.Resume;
  end;
end;

procedure TSearchApi.ReIndexViaPattern(MatchPattern: PWideChar);
var
  hr: HRESULT;
begin
  // reindexes all items that match the provided pattern.
  // the pattern can be a standard pattern such as *.pdf or a pattern in the
  // form of a url such as file:///c:\MyStuff\*.pdf.

  if MatchPattern > '' then
  begin
    hr := FSearchCatalogManager.ReindexMatchingURLs(MatchPattern);
    if Succeeded(hr) then
      OutputDbg('Pattern based reindexing initialized')
    else
      OutputDbg('Pattern based reindexing failed');
  end;
end;

procedure TSearchApi.ReIndexRoot(Root: PWideChar);
var
  hr: HRESULT;
begin
  if Root > '' then
  begin
    hr := FSearchCatalogManager.ReindexSearchRoot(Root);
    if Succeeded(hr) then
      OutputDbg(Format('Root reindex initialized %0:s', [Root]))
    else
      OutputDbg(Format('Root reindex failed %0:s', [Root]));
  end;
end;

destructor TSearchApi.Destroy;
begin
  { clean up }
  FSearchManager := nil;
  FSearchCatalogManager := nil;
  FQueryHelper := nil;

  CoTaskMemFree(FConnectionString);
  CoUninitialize;

  inherited Destroy;
end;

{ TSearchThread }

constructor TSearchThread.Create(const SearchPattern: PWideChar;
  pConnection: PWideChar; const FreeOnTerm: boolean);
begin
  FSearchString  := SearchPattern;
  FConnectionStr := pConnection;
  FAdoDBConnection := CoConnection.Create;
  FAdoRecordSet  := CoRecordset.Create;

  inherited Create(False, Format('SearchApi_SearchThread (%s)', [SearchPattern]));

  FreeOnTerminate := FreeOnTerm;
end;

destructor TSearchThread.Destroy;
begin
  OutputDbg('SearchApi_SearchThread destroyd');

  FAdoDBConnection := nil;
  FAdoRecordSet := nil;

  CoUninitialize;

  inherited Destroy;
end;

procedure TSearchThread.Execute;
var
  LastError: DWORD;
  pStrSQL:  string;
  iCounter: integer;
begin
  inherited Execute;

  CoInitializeEx(nil, COINIT_APARTMENTTHREADED or COINIT_DISABLE_OLE1DDE);

  OutputDbg('SearchApi_SearchThread executing');

  LastError := 0;
  SetLastError(LastError);

  iCounter := 0;

  try
    FAdoDBConnection.Open(FConnectionStr, '', '', 0);

  except
    on E: EOleSysError do
    begin
      // LastError := E.ErrorCode;
      Terminate;
    end;

  end;

  if not (FAdoDBConnection.State = adStateOpen) then
  begin
    FAdoDBConnection.Open(FConnectionStr, '', '', 0);
  end;

  pStrSQL := string(FSearchString);
  UniqueString(pStrSQL);

  FAdoRecordSet.Open(pStrSQL, FAdoDBConnection, adOpenUnspecified, adLockOptimistic,
    adAsyncFetchNonBlocking);

  StartPeriod;

  while not (Terminated) do
  begin

    // thread starts searching
    New(ThreadSearchStartedMsgPtr);
    ThreadSearchStartedMsgPtr^.StartTime := ElapsedCount;
    // can you be sure Mainform still exists here, so it's safe to access mainform.handle?
    // you could handle this in main thread (do not close mainform until thread is closed)
    if not (PostMessage(MainForm.Handle, TS_THREAD_SEARCH_STARTED,
      integer(ThreadSearchStartedMsgPtr), 0)) then
    begin
      Dispose(ThreadSearchStartedMsgPtr);
      // is it wise to continue executing if we cannot send our message??
      // what happens if we close the mainform while the thread is still
      //running?
    end;

    if not (FAdoRecordSet.RecordCount <= 0) then
    begin
      FAdoRecordSet.MoveFirst;

      try
        try
          while not (FAdoRecordSet.EOF) do
          begin
            repeat
              Inc(iCounter);

              New(ThreadSearchItemsEnumMsgPrt);
              ThreadSearchItemsEnumMsgPrt^.ItemName  := FAdoRecordSet.Fields[0].Value;
              ThreadSearchItemsEnumMsgPrt^.ItemCount := iCounter;

              if not (PostMessage(MainForm.Handle, TS_Thread_SEARCH_ITEMS_NEW_ENUM,
                integer(ThreadSearchItemsEnumMsgPrt), 0)) then
                Dispose(ThreadSearchItemsEnumMsgPrt);

              FAdoRecordSet.MoveNext;
            until
              FAdoRecordSet.EOF;
          end;

        finally
          EndPeriod;

          // thread finished searching lets count the items found
          New(ThreadSearchItemsCountMsgPrt);
          ThreadSearchItemsCountMsgPrt^.Items := iCounter;

          if not (PostMessage(MainForm.Handle, TS_THREAD_SEARCH_ITEMS_COUNT,
            integer(ThreadSearchItemsCountMsgPrt), 0)) then
          begin
            Dispose(ThreadSearchItemsCountMsgPrt);
          end;

          // thread finished searching inform our mainthread
          New(ThreadSearchFinishedMsgPtr);
          ThreadSearchFinishedMsgPtr^.EndTime := ElapsedCount;

          if not (PostMessage(MainForm.Handle, TS_THREAD_SEARCH_FINISHED,
            integer(ThreadSearchFinishedMsgPtr), 0)) then
          begin
            Dispose(ThreadSearchFinishedMsgPtr);
          end;
        end;

      except
        FAdoRecordSet.Close;
        FAdoDBConnection.Close;
        Terminate;
      end;

      Terminate;
    end;
    // thread finished searching inform our mainthread
    New(ThreadSearchFinishedMsgPtr);
    ThreadSearchFinishedMsgPtr^.EndTime := ElapsedCount;

    if not (PostMessage(MainForm.Handle, TS_THREAD_SEARCH_FINISHED,
      integer(ThreadSearchFinishedMsgPtr), 0)) then
    begin
      Dispose(ThreadSearchFinishedMsgPtr);
    end;

    // thread finished searching lets count the items found
    New(ThreadSearchItemsCountMsgPrt);
    ThreadSearchItemsCountMsgPrt^.Items := iCounter;

    if not (PostMessage(MainForm.Handle, TS_THREAD_SEARCH_ITEMS_COUNT,
      integer(ThreadSearchItemsCountMsgPrt), 0)) then
    begin
      Dispose(ThreadSearchItemsCountMsgPrt);
    end;

    Terminate;
  end;

end;


end.
