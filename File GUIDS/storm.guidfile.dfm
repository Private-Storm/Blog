object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'frmMain'
  ClientHeight = 481
  ClientWidth = 752
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object gbFileInfo: TGroupBox
    Left = 24
    Top = 16
    Width = 705
    Height = 209
    Caption = 'Fileinformation'
    TabOrder = 0
    object lbName: TLabel
      Left = 24
      Top = 32
      Width = 35
      Height = 13
      Caption = 'lbName'
    end
    object lbGuid: TLabel
      Left = 24
      Top = 51
      Width = 83
      Height = 13
      Caption = 'Object Identifier:'
    end
    object btnChoiceFile: TButton
      Left = 616
      Top = 168
      Width = 75
      Height = 25
      Caption = 'File...'
      TabOrder = 0
      OnClick = btnChoiceFileClick
    end
  end
  object gbObjectInfo: TGroupBox
    Left = 24
    Top = 240
    Width = 705
    Height = 177
    Caption = 'Guid'
    TabOrder = 1
    object btnGuid: TButton
      Left = 576
      Top = 136
      Width = 115
      Height = 25
      Caption = 'Open file by Guid'
      Enabled = False
      TabOrder = 0
      OnClick = btnGuidClick
    end
    object memLog: TMemo
      Left = 24
      Top = 32
      Width = 665
      Height = 89
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object btnExit: TButton
    Left = 654
    Top = 438
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 2
    OnClick = btnExitClick
  end
  object Op: TOpenDialog
    DefaultExt = '*.exe'
    Filter = 'Executeable file|*.exe'
    Title = 'Select a file...'
    Left = 656
    Top = 32
  end
end
