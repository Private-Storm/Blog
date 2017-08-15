object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'SafeTerminateProcess Test'
  ClientHeight = 295
  ClientWidth = 471
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object edtProcHandle: TEdit
    Left = 56
    Top = 64
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'edtProcHandle'
  end
  object edtExitResult: TEdit
    Left = 56
    Top = 91
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'edtExitResult'
  end
  object btnTerminate: TButton
    Left = 56
    Top = 144
    Width = 75
    Height = 25
    Caption = 'btnTerminate'
    TabOrder = 2
    OnClick = btnTerminateClick
  end
  object btnRunProcess: TButton
    Left = 56
    Top = 113
    Width = 97
    Height = 25
    Caption = 'btnRunProcess'
    TabOrder = 3
    OnClick = btnRunProcessClick
  end
end
