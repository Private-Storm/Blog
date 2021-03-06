object MainForm: TMainForm
  Left = 0
  Top = 0
  Anchors = [akLeft]
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Windows Licence - Verification'
  ClientHeight = 478
  ClientWidth = 780
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    780
    478)
  PixelsPerInch = 96
  TextHeight = 18
  object Label1: TLabel
    Left = 17
    Top = 438
    Width = 100
    Height = 18
    Caption = #169' 2010 stOrM!'
    Enabled = False
  end
  object btnClose: TButton
    Left = 646
    Top = 428
    Width = 112
    Height = 40
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
    ExplicitLeft = 647
    ExplicitTop = 438
  end
  object pg: TPageControl
    Left = 17
    Top = 18
    Width = 741
    Height = 398
    ActivePage = tsAuto
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    ExplicitWidth = 742
    ExplicitHeight = 408
    object tsAuto: TTabSheet
      Caption = 'Auto'
      OnShow = tsAutoShow
      ExplicitWidth = 734
      ExplicitHeight = 375
      DesignSize = (
        733
        365)
      object gpInfo: TGroupBox
        Left = 16
        Top = 16
        Width = 699
        Height = 304
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Information'
        TabOrder = 0
        ExplicitWidth = 700
        ExplicitHeight = 314
        DesignSize = (
          699
          304)
        object log: TMemo
          Left = 16
          Top = 24
          Width = 667
          Height = 264
          Anchors = [akLeft, akTop, akRight, akBottom]
          ScrollBars = ssVertical
          TabOrder = 0
          ExplicitWidth = 668
          ExplicitHeight = 274
        end
      end
      object btnStart: TButton
        Left = 637
        Top = 328
        Width = 78
        Height = 28
        Anchors = [akRight, akBottom]
        Caption = 'Verify'
        TabOrder = 1
        OnClick = btnStartClick
        ExplicitLeft = 638
        ExplicitTop = 338
      end
    end
    object tsManuell: TTabSheet
      Caption = 'User'
      ImageIndex = 1
      OnShow = tsManuellShow
      ExplicitWidth = 734
      ExplicitHeight = 375
      DesignSize = (
        733
        365)
      object GroupBox1: TGroupBox
        Left = 15
        Top = 16
        Width = 699
        Height = 304
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Information'
        TabOrder = 0
        ExplicitWidth = 700
        ExplicitHeight = 314
        DesignSize = (
          699
          304)
        object Label2: TLabel
          Left = 16
          Top = 153
          Width = 23
          Height = 18
          Caption = 'Log'
        end
        object lbPidgenPath: TLabel
          Left = 16
          Top = 32
          Width = 118
          Height = 18
          Caption = 'Pidgenn DLL Path:'
        end
        object lbConfigKey: TLabel
          Left = 30
          Top = 69
          Width = 104
          Height = 18
          Caption = 'KeyConfig Path:'
        end
        object lbLicenceKey: TLabel
          Left = 52
          Top = 109
          Width = 82
          Height = 18
          Caption = 'Licence Key:'
        end
        object lbMPCID: TLabel
          Left = 520
          Top = 109
          Width = 50
          Height = 18
          Caption = 'MPCID:'
        end
        object log2: TMemo
          Left = 16
          Top = 177
          Width = 667
          Height = 111
          Anchors = [akLeft, akTop, akRight, akBottom]
          ScrollBars = ssVertical
          TabOrder = 6
          ExplicitWidth = 668
          ExplicitHeight = 121
        end
        object edtPidgenPath: TEdit
          Left = 140
          Top = 29
          Width = 489
          Height = 26
          TabOrder = 0
          Text = 'c:\windows\system32\'
          TextHint = 'pidgenx.dll'
        end
        object edtKeyConfPath: TEdit
          Left = 140
          Top = 61
          Width = 489
          Height = 26
          TabOrder = 2
          Text = 'c:\windows\system32\spp\tokens\pkeyconfig\pkeyconfig.xrm-ms'
          TextHint = 'pkeyconfig.xrm-ms'
        end
        object edttMCPID: TEdit
          Left = 576
          Top = 106
          Width = 53
          Height = 26
          TabOrder = 5
          Text = '00392'
        end
        object btnPidgenPath: TButton
          Left = 635
          Top = 30
          Width = 49
          Height = 25
          Caption = '...'
          TabOrder = 1
          OnClick = btnPidgenPathClick
        end
        object btnKeyConfPath: TButton
          Left = 635
          Top = 62
          Width = 49
          Height = 25
          Caption = '...'
          TabOrder = 3
          OnClick = btnKeyConfPathClick
        end
        object edtLicence: TMaskEdit
          Left = 140
          Top = 106
          Width = 301
          Height = 26
          EditMask = 'AAAAA-AAAAA-AAAAA-AAAAA-AAAAA;1;_'
          MaxLength = 29
          TabOrder = 4
          Text = ''
        end
      end
      object btnStartman: TButton
        Left = 640
        Top = 330
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Verify'
        TabOrder = 1
        OnClick = btnStartmanClick
        ExplicitLeft = 624
        ExplicitTop = 336
      end
      object pb: TProgressBar
        Left = 16
        Top = 332
        Width = 376
        Height = 20
        Anchors = [akLeft, akRight, akBottom]
        Position = 100
        Style = pbstMarquee
        TabOrder = 2
        ExplicitTop = 342
        ExplicitWidth = 377
      end
    end
  end
  object FO: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 536
  end
end
