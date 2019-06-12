
program ImapDemo;

uses
  Forms,
  ImapDemo1 in 'ImapDemo1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
