object Form1: TForm1
  Left = 193
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'TESTE IMAP demo'
  ClientHeight = 436
  ClientWidth = 931
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 22
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Server'
  end
  object Label2: TLabel
    Left = 22
    Top = 34
    Width = 48
    Height = 13
    Caption = 'Username'
  end
  object Label3: TLabel
    Left = 22
    Top = 60
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object Label4: TLabel
    Left = 10
    Top = 120
    Width = 100
    Height = 13
    Caption = 'Messages in mailbox:'
  end
  object Label6: TLabel
    Left = 390
    Top = 6
    Width = 47
    Height = 13
    Caption = 'Mailboxes'
  end
  object Label5: TLabel
    Left = 24
    Top = 85
    Width = 49
    Height = 13
    Caption = 'Dir tmp zip'
  end
  object Label7: TLabel
    Left = 719
    Top = 26
    Width = 41
    Height = 13
    Caption = 'Emitente'
  end
  object Label8: TLabel
    Left = 719
    Top = 106
    Width = 56
    Height = 13
    Caption = 'Destinat'#225'rio'
  end
  object Edit1: TEdit
    Left = 90
    Top = 2
    Width = 171
    Height = 21
    TabOrder = 0
    Text = 'imap.softrom.com.br'
  end
  object Edit2: TEdit
    Left = 90
    Top = 28
    Width = 171
    Height = 21
    TabOrder = 1
    Text = 'dev@empresa.com.br'
  end
  object Edit3: TEdit
    Left = 90
    Top = 54
    Width = 171
    Height = 21
    TabOrder = 2
    Text = 'senha'
  end
  object StringGrid1: TStringGrid
    Left = 6
    Top = 140
    Width = 707
    Height = 120
    ColCount = 6
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    TabOrder = 3
    OnClick = StringGrid1Click
  end
  object Button2: TButton
    Left = 6
    Top = 266
    Width = 95
    Height = 25
    Caption = 'Delete message'
    TabOrder = 4
    OnClick = Button2Click
  end
  object ListBox1: TListBox
    Left = 386
    Top = 26
    Width = 327
    Height = 89
    ItemHeight = 13
    TabOrder = 5
    OnClick = ListBox1Click
  end
  object Button1: TButton
    Left = 284
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 6
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 107
    Top = 268
    Width = 294
    Height = 141
    ScrollBars = ssVertical
    TabOrder = 7
  end
  object Edit4: TEdit
    Left = 90
    Top = 82
    Width = 171
    Height = 21
    TabOrder = 8
    Text = 'D:\tempZip'
  end
  object ListBox2: TListBox
    Left = 416
    Top = 266
    Width = 507
    Height = 143
    ItemHeight = 13
    TabOrder = 9
    OnClick = ListBox2Click
  end
  object EdtEmitDoc: TEdit
    Left = 719
    Top = 41
    Width = 206
    Height = 21
    TabOrder = 10
  end
  object EdtDestDoc: TEdit
    Left = 719
    Top = 121
    Width = 206
    Height = 21
    TabOrder = 11
  end
  object EdtEmitNome: TEdit
    Left = 719
    Top = 68
    Width = 206
    Height = 21
    TabOrder = 12
  end
  object EdtDestNome: TEdit
    Left = 719
    Top = 148
    Width = 206
    Height = 21
    TabOrder = 13
  end
  object IdIMAP41: TIdIMAP4
    IOHandler = IdSSLIOHandlerSocketOpenSSL1
    Password = 'softrom1'
    RetrieveOnSelect = rsHeaders
    Port = 993
    Username = 'emerson@softrom.com.br'
    Host = 'imap.softrom.com.br'
    UseTLS = utUseImplicitTLS
    SASLMechanisms = <>
    MilliSecsToWaitToClearBuffer = 100
    Left = 304
    Top = 48
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    Destination = 'imap.softrom.com.br:993'
    Host = 'imap.softrom.com.br'
    MaxLineAction = maException
    Port = 993
    DefaultPort = 0
    SSLOptions.Method = sslvSSLv2
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 344
    Top = 88
  end
  object XMLDocument1: TXMLDocument
    Left = 792
    Top = 8
    DOMVendorDesc = 'MSXML'
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 344
    Top = 40
  end
end
