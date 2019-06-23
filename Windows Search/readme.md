## Windows Search 

Out of curiosity I gave the Windows Search a try and made a small implementation for Delphi. Well it never reached a stage where I could say it is nearly complete. It was / is still a starting point not more, at least it worked for me. 



Well, to give you an idea how this works, have a look below.

*Messages I'll be watching for inside the WindowProc...*

```
procedure TMainForm.WndProc(var AMsg: TMessage);
begin
  with AMsg do
  begin
    case Msg of
      TS_THREAD_SEARCH_STARTED: OnThreadSearchStartedMsg(
          PThreadSearchStartedMsg(WParam));
      TS_THREAD_SEARCH_FINISHED: OnThreadSearchFinishedMsg(
          PThreadSearchFinishedMsg(WParam));
      TS_THREAD_SEARCH_ITEMS_COUNT: OnThreadSearchItemsCountMsg(
          PThreadSearchItemsCountMsg(WParam));
      TS_Thread_SEARCH_ITEMS_NEW_ENUM: OnThreadSearchItemsEnumMsg(
          PThreadSearchItemsEnumMsg(WParam));
    end;
  end;
  inherited;
end;
```
I've created my own FileList which holds all informations which could be found in the search results (filesize, path, thumbnail and stuff like that. The List gets filled under:

```
procedure TMainForm.OnThreadSearchItemsEnumMsg(
  const ThreadSearchItemsEnumPtr: PThreadSearchItemsEnumMsg);
var
  f: TFileObject;

  Child: PVirtualNode;
  NodeData: PNodeData;
  idx: integer;
begin
  ...
end;

initialization
  SearchManager := TSearchApi.Create;
  FileList  := TObjectList.Create;
  NodeCount := 0;
  FillDriveList;

finalization
  FreeAndNil(FileList);
  FreeAndNil(SearchManager);  
```

When done the Tree is filled with those informations.

Blog entry: [Windows Search](http://private-storm.de/2009/07/04/windows-search-project/)

Microsoft: [Windows Search API](https://docs.microsoft.com/de-de/windows/desktop/search/windows-search)


