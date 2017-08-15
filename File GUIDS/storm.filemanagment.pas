unit storm.filemanagment;

interface

uses Winapi.Windows;

type
  FILE_ID_TYPE = (FileIdType, ObjectIdType, MaximumFileIdType);
  {$EXTERNALSYM FILE_ID_TYPE}

type
  _File_ID_DESCRIPTOR = record
    dwSize: DWORD;
    cType: FILE_ID_TYPE;
    case integer of
      0:
        (FileId: LARGE_INTEGER);
      1:
        (ObjectID: TGUID);
  end;
  FILE_ID_DESCRIPTOR = _File_ID_DESCRIPTOR;
  {$EXTERNALSYM FILE_ID_DESCRIPTOR}
  LPFILE_ID_DESCRIPTOR = ^_File_ID_DESCRIPTOR;
  {$EXTERNALSYM LPFILE_ID_DESCRIPTOR}
  TFILE_ID_DESCRIPTOR = _File_ID_DESCRIPTOR;
  {$EXTERNALSYM TFILE_ID_DESCRIPTOR}

type
  _FILE_NAME_INFO = record
    FileNameLength: DWORD;
    FileName: array [0 .. Max_Path] of WCHAR;
  end;
  FILE_NAME_INFO = _FILE_NAME_INFO;
  {$EXTERNALSYM FILE_NAME_INFO}
  PFILE_NAME_INFO = ^_FILE_NAME_INFO;
  {$EXTERNALSYM PFILE_NAME_INFO}
  TFILE_NAME_INFO = _FILE_NAME_INFO;
  {$EXTERNALSYM TFILE_NAME_INFO}

type
  _FILE_INFO_BY_HANDLE_CLASS = (
    FileBasicInfo = 0,
    FileStandardInfo = 1,
    FileNameInfo = 2,
    FileRenameInfo = 3,
    FileDispositionInfo = 4,
    FileAllocationInfo = 5,
    FileEndOfFileInfo = 6,
    FileStreamInfo = 7,
    FileCompressionInfo = 8,
    FileAttributeTagInfo = 9,
    FileIdBothDirectoryInfo = 10,
    FileIdBothDirectoryRestartInfo = 11,
    FileIoPriorityHintInfo = 12,
    FileRemoteProtocolInfo = 13,
    MaximumFileInfoByHandlesClass = 14
    );
  FILE_INFO_BY_HANDLE_CLASS = _FILE_INFO_BY_HANDLE_CLASS;
  {$EXTERNALSYM FILE_INFO_BY_HANDLE_CLASS}
  PFILE_INFO_BY_HANDLE_CLASS = ^_FILE_INFO_BY_HANDLE_CLASS;
  {$EXTERNALSYM PFILE_INFO_BY_HANDLE_CLASS}
  TFILE_INFO_BY_HANDLE_CLASS = _FILE_INFO_BY_HANDLE_CLASS;
  {$EXTERNALSYM TFILE_INFO_BY_HANDLE_CLASS}
  PFILE_OBJECTID_BUFFER = ^FILE_OBJECTID_BUFFER;

  {$EXTERNALSYM PFILE_OBJECTID_BUFFER}
  _FILE_OBJECTID_BUFFER = record
  ObjectID: array [0 .. 15] of BYTE;
   case integer of
      0:
        (
          BirthVolumeId: array [0 .. 15] of BYTE;
          BirthObjectId: array [0 .. 15] of BYTE;
          DomainId: array [0 .. 15] of BYTE);
      1:
        (
          ExtendedInfo: array [0 .. 47] of BYTE
        )
  end;
  {$EXTERNALSYM _FILE_OBJECTID_BUFFER}
  FILE_OBJECTID_BUFFER = _FILE_OBJECTID_BUFFER;
  {$EXTERNALSYM FILE_OBJECTID_BUFFER}
  TFileObjectIdBuffer = FILE_OBJECTID_BUFFER;
  PFileObjectIdBuffer = PFILE_OBJECTID_BUFFER;

implementation

end.
