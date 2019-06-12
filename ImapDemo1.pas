unit ImapDemo1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls,
  IdUserPassProvider,
  IdSASLCollection,
  IdSASLLogin,
  IdMessage, System.Zip,
  IdIMAP4, IdCustomTCPServer, IdTCPServer, IdCmdTCPServer,
  IdExplicitTLSClientServerBase, IdIMAP4Server, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdMessageClient, IdServerIOHandler, IdSSL,
  IdSSLOpenSSL, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdAttachmentFile,
  Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc, IdAntiFreezeBase,
  Vcl.IdAntiFreeze, xmldom, XMLIntf, IdAntiFreeze, msxmldom, XMLDoc;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label4: TLabel;
    StringGrid1: TStringGrid;
    Button2: TButton;
    ListBox1: TListBox;
    Label6: TLabel;
    IdIMAP41: TIdIMAP4;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    Button1: TButton;
    Memo1: TMemo;
    Edit4: TEdit;
    Label5: TLabel;
    ListBox2: TListBox;
    XMLDocument1: TXMLDocument;
    EdtEmitDoc: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    EdtDestDoc: TEdit;
    EdtEmitNome: TEdit;
    EdtDestNome: TEdit;
    IdAntiFreeze1: TIdAntiFreeze;
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
  private
    { Private declarations }
    procedure extractFile(nome:String);
    procedure LOG(Texto:String);
  public
    { Public declarations }

    ThePassProvider: TIdUserPassProvider;
    TheSASLLogin: TIdSASLLogin;
    UsersFolders: TStringList;

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin

    ThePassProvider := TIdUserPassProvider.Create(nil);
    TheSASLLogin := TIdSASLLogin.Create(nil);
    UsersFolders := TStringList.Create;
    StringGrid1.Cells[0, 0] := 'Sequencial';
    StringGrid1.Cells[1, 0] := 'UID';
    StringGrid1.Cells[2, 0] := 'Lido';
    StringGrid1.Cells[3, 0] := 'Subject';
    StringGrid1.Cells[4, 0] := 'Mensagem';
    StringGrid1.Cells[5, 0] := 'A';
    StringGrid1.ColWidths[0] := 100;
    StringGrid1.ColWidths[1] := 60;
    StringGrid1.ColWidths[2] := 50;
    StringGrid1.ColWidths[3] := 150;
    StringGrid1.ColWidths[4] := 300;
    StringGrid1.ColWidths[5] := 30;
    StringGrid1.RowCount := 2;
    StringGrid1.Cells[0, 1] := '';
    StringGrid1.Cells[1, 1] := '';
    StringGrid1.Cells[2, 1] := '';
    StringGrid1.Cells[3, 1] := '';
    StringGrid1.Cells[4, 1] := '';
    StringGrid1.Cells[5, 1] := '';
end;

procedure TForm1.ListBox1Click(Sender: TObject);
var
    TheFlags: TIdMessageFlagsSet;
    TheUID: string;
    i,j: integer;
    nCount: integer;
    TheMsg: TIdMessage;
    TheBody:String;
    MailBoxName: string;
    ListMsgs:TidMessage;
    MsgSize: integer;
    TransferEncoding: string;

begin
    if ListBox1.ItemIndex <> -1 then
    begin
        Screen.Cursor := crHourGlass;
        MailBoxName := ListBox1.Items[ListBox1.ItemIndex];
        if IdIMAP41.SelectMailBox(MailBoxName) = False then
        begin
            Screen.Cursor := crDefault;
            ShowMessage('Error selecting '+MailBoxName);
            Exit;
        end;
        TheMsg := TIdMessage.Create(nil);
        nCount := IdIMAP41.MailBox.TotalMsgs;
        if nCount = 0 then
        begin
            StringGrid1.RowCount := 2;
            StringGrid1.Cells[0, 1] := '';
            StringGrid1.Cells[1, 1] := '';
            StringGrid1.Cells[2, 1] := '';
            StringGrid1.Cells[3, 1] := '';
            StringGrid1.Cells[4, 1] := '';
            StringGrid1.Cells[5, 1] := '';
            ShowMessage('There are no messages in '+MailBoxName);
        end else
        begin
            StringGrid1.RowCount := nCount + 1;
            for i := 0 to nCount-1 do
            begin
                IdIMAP41.GetUID(i+1, TheUID);
                IdIMAP41.UIDRetrieveFlags(TheUID, TheFlags);
                IdIMAP41.UIDRetrieveHeader(TheUID, TheMsg);
                IdIMAP41.UIDRetrieveText(TheUID, TheBody);

                StringGrid1.Cells[0, i+1] := IntToStr(i+1);
                StringGrid1.Cells[1, i+1] := TheUID;
                if mfSeen in TheFlags then
                    StringGrid1.Cells[2, i+1] := 'Sim'
                else
                    StringGrid1.Cells[2, i+1] := 'N�o';

                StringGrid1.Cells[3, i+1] := TheMsg.Subject;
                StringGrid1.Cells[4, i+1] := TheBody;
                LOG(' Email '+TheUID+' recebido de '+TheMsg.From.Text);
                IdIMAP41.UIDRetrieveStructure(TheUID,TheMsg);

                for j:= 0 to TheMsg.MessageParts.Count-1 do
                begin
                  if (pos('application/x-zip-compressed',TheMsg.MessageParts.items[j].ContentType)>0)then
                  begin
                     TransferEncoding := TheMsg.MessageParts[j].ContentTransfer;
                     msgsize := 0;
                     if (IdIMAP41.UIDRetrievePartToFile(TheUID,j,MsgSize,Edit4.Text+'\email'+TheUID+'.zip', TransferEncoding)) then
                     begin
                           extractFile(Edit4.Text+'\email'+TheUID+'.zip');
                           LOG(' Anexo '+Edit4.Text+'\email'+TheUID+'.zip');
                           StringGrid1.Cells[5, i+1] := 'S';
                     end
                     else
                           StringGrid1.Cells[5, i+1] := 'N';
                  end else
                     StringGrid1.Cells[5, i+1] := 'N';
                end;
            end;
        end;
        TheMsg.Destroy;
        Screen.Cursor := crDefault;
    end;
end;

procedure TForm1.ListBox2Click(Sender: TObject);
Var
  I:Integer;
  protNFe,
  infProt,
  NFe,
  infNFe,
  ide,
  emit,
  enderEmit,
  dest,
  enderDest,
  det,
  prod,
  imposto,
  ICMS,
  PIS,
  COFINS,
  IPI,
  IPITrib,
  total,
  ICMSTot,
  transp: IXMLNode;
begin
  if (UpperCase(ExtractFileExt(ListBox2.Items[ListBox2.ItemIndex])) <> '.XML') then
  begin
      ShowMessage('O arquivo n�o � xml. '+UpperCase(ExtractFileExt(ListBox2.Items[ListBox2.ItemIndex])));
      exit;
  end;

  XMLDocument1.FileName := ListBox2.Items[ListBox2.ItemIndex];
  XMLDocument1.Active := True;

  try
  //estrutura do xml
  if (XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe') <> nil) then
    NFe := XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe');
  if (NFe <> nil) then
    infNFe := NFe.ChildNodes.FindNode('infNFe');
  if (infNFe <> nil) then
    emit := infNFe.ChildNodes.FindNode('emit');
  if (infNFe <> nil) then
    dest := infNFe.ChildNodes.FindNode('dest');

   EdtEmitDoc.Text  := emit.ChildNodes['CNPJ'].text;
   EdtEmitNome.Text := emit.ChildNodes['xNome'].text;

   EdtDestDoc.Text  := dest.ChildNodes['CNPJ'].text;
   EdtDestNome.Text := dest.ChildNodes['xNome'].text;

  except
  on E: Exception do
     begin
        LOG(' ERRO xml '+ListBox2.Items[ListBox2.ItemIndex]+' inv�lido. '+e.Message);
        ShowMessage('Formato de xml incorreto.');
     end;

  end;

end;

procedure TForm1.LOG(Texto: String);
var
  ARQ:TextFile;
begin
    try
      AssignFile(ARQ, ExtractFilePath(Application.ExeName)+'LOG\'+FormatDateTime('ddmmyyyy',now)+'.txt');

      {$I-}
      Reset(ARQ);
      {$I+}

      if (IOResult <> 0) then
        Rewrite(ARQ)
      else
      begin
        CloseFile(ARQ);
        Append(ARQ);
      end;
      Writeln(ARQ,FormatDateTime('dd/mm/yyyy hh:mm:ss',now)+Texto);
      CloseFile(ARQ);
  except
    on E: Exception do
      begin
        Writeln(ARQ,FormatDateTime('dd/mm/yyyy hh:mm:ss',now)+e.Message);
        CloseFile(ARQ);
      end;
    end;
end;

procedure TForm1.StringGrid1Click(Sender: TObject);
Var
  Body:String;
  ID:String;
begin
  ID := StringGrid1.Cells[1,StringGrid1.Row];
  if (StrToIntDef(ID,0)>0)  then
    if (IdIMAP41.UIDRetrieveText(ID, Body))then
      Memo1.Text := Body;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin

    UsersFolders.Destroy;
    TheSASLLogin.Destroy;
    ThePassProvider.Destroy;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
    TheUID: string;
begin
    //Delete selected message..
    if StringGrid1.Selection.Top > 0 then begin
        Screen.Cursor := crHourGlass;
        TheUID := StringGrid1.Cells[1, StringGrid1.Selection.Top];
        if IdIMAP41.UIDDeleteMsg(TheUID) = True then begin
            if IdIMAP41.ExpungeMailBox = True then begin
                Screen.Cursor := crDefault;
                LOG(' Email deletado. UID:'+TheUID);
                ShowMessage('Successfully deleted message - select another mailbox then reselect this mailbox to see its omission');
            end else begin
                Screen.Cursor := crDefault;
                LOG(' Email deletado. UID:'+TheUID);
                ShowMessage('Succeeded in setting delete flag on message, but expunge failed - is this a read-only mailbox?');
            end;
        end else begin
            Screen.Cursor := crDefault;
            LOG(' ERRO deletar Email. UID:'+TheUID);
            ShowMessage('Failed to set delete flag on message - is this a read-only mailbox?');
        end;
    end;
end;

procedure TForm1.extractFile(nome: String);
var
    Zip :TZipFile;
    I:Integer;
begin
  try
  Zip := TZipFile.Create;
  Try
    Zip.Open (nome, zmRead);
    For I := 0 To High (Zip.FileNames) Do
    begin
      ListBox2.Items.Add(ExtractFileDir(nome)+'\'+Zip.FileNames[i]);
      LOG(' Extraindo '+Zip.FileNames[i]);
    end;

    Zip.ExtractAll(ExtractFileDir(nome));
  Finally
    Zip.Free;
  End;
  except
  on E: Exception do
     begin
       LOG(' ERRO ao extrair '+nome);
     end;

  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
    i: integer;
    bRet: Boolean;
begin
    if (not DirectoryExists(Edit4.Text)) then
        ForceDirectories(Edit4.Text);

    if (not DirectoryExists(ExtractFilePath(Application.ExeName)+'LOG')) then
        ForceDirectories(ExtractFilePath(Application.ExeName)+'LOG');

    try

    if Button1.Caption = 'Disconnect' then begin
        Screen.Cursor := crHourGlass;
        IdIMAP41.Disconnect;
        Button1.Caption := 'Connect';
        Screen.Cursor := crDefault;
    end else begin
        Screen.Cursor := crHourGlass;
        IdIMAP41.Host := Edit1.Text;
        IdIMAP41.Username := Edit2.Text;
        IdIMAP41.Password := Edit3.Text;
        //LTheSASLListEntry := TheSmtp.FSASLMechanisms.Add;
        //LTheSASLListEntry.SASL := TheSASLLogin;
        IdIMAP41.ConnectTimeout:=3500;
        IdIMAP41.ReadTimeout := 3500;
        IdSSLIOHandlerSocketOpenSSL1.ConnectTimeout := 3500;
        IdIMAP41.Connect;
        ListBox1.Clear;
        bRet := IdIMAP41.ListMailBoxes(UsersFolders);
        if bRet = False then begin
            ShowMessage('Failed to retrieve folder names!');
        end;
        for i := 0 to UsersFolders.Count-1 do begin
            ListBox1.Items.Add(UsersFolders[i]);
        end;

        Button1.Caption := 'Disconnect';
        LOG(' CONECTADO');
        Screen.Cursor := crDefault;
    end;
    except
  on E: Exception do
     begin
       LOG(' ERRO: '+e.Message);
     end;

    end;

end;

end.
