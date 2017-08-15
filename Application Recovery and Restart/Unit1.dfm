object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 308
  ClientWidth = 534
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblCrashCtdwn: TLabel
    Left = 16
    Top = 288
    Width = 166
    Height = 13
    Caption = 'Countdown till recovering process:'
  end
  object mmo1: TMemo
    Left = 16
    Top = 16
    Width = 505
    Height = 257
    Lines.Strings = (
      'Registering for Application Recovery'
      ''
      
        'To register a recovery callback, call the RegisterApplicationRec' +
        'overyCallback function. Windows '
      
        'Error Reporting (WER) calls your recovery callback before the ap' +
        'plication exits due to an '
      'unhandled exception or the application not responding.'
      ''
      
        'You use the recovery callback to try to save data and state info' +
        'rmation before the application '
      
        'terminates. You could then use the saved data and state informat' +
        'ion when the application is '
      'restarted.'
      ''
      
        'During the recovery process, you must call the ApplicationRecove' +
        'ryInProgress function within the '
      
        'specified ping interval; otherwise, the recovery process is term' +
        'inated. Calling '
      
        'ApplicationRecoveryInProgress lets WER know that you are still a' +
        'ctively recovering data. When '
      
        'the recovery process is complete, call the ApplicationRecoveryFi' +
        'nished function. Note that the '
      
        'ApplicationRecoveryFinished function should be the last call you' +
        ' make before exiting because the '
      'function immediately terminates the application.'
      ''
      
        'You should consider periodically saving temporary copies of the ' +
        'data and state information during '
      
        'the normal course of the application process. Periodically savin' +
        'g the data may save time in the '
      'recovery process.'
      ''
      
        'If a Windows application can also be updated, the application sh' +
        'ould also process the '
      
        'WM_QUERYENDSESSION and WM_ENDSESSION messages. The installer sen' +
        'ds these messages '
      
        'when the installer needs the application to shutdown in order to' +
        ' complete the installation or when a '
      
        'reboot is required to complete the installation. Note that in th' +
        'is case, the application has less time '
      
        'to perform recovery. For example, the application must respond t' +
        'o each messages within five '
      
        'seconds. The application could perform additional recovery in th' +
        'e WM_CLOSE message for which '
      'you have 30 seconds to respond.'
      ''
      
        'For console applications that could be updated, you should consi' +
        'der handling CTRL_C_EVENT '
      
        'notifications. For an example, see Registering for Application R' +
        'estart. The installer sends this '
      
        'notification when it needs the application to shutdown in order ' +
        'to complete the update. The '
      'application has 30 seconds to handle the notification.'
      ''
      
        'The following example shows how to register for recovery, a simp' +
        'le recovery callback '
      
        'implementation, and how to process the WM_QUERYENDSESSION and WM' +
        '_ENDSESSION '
      'messages. ')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object tmr1: TTimer
    Tag = 120
    Enabled = False
    OnTimer = tmr1Timer
    Left = 432
    Top = 216
  end
end
