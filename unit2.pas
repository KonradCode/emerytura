unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    ButtonObliczProcenty: TButton;
    Label4: TLabel;
    Label5: TLabel;
    EditLata: TEdit;
    EditMiesiace: TEdit;
    procedure ButtonObliczProcentyClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure EditMiesiaceChange(Sender: TObject);
  private

  public

  end;

var
  ObliczanieWyslugiForm: TForm2;

implementation

uses Unit1;

{$R *.lfm}

{ TForm2 }

procedure TForm2.ButtonObliczProcentyClick(Sender: TObject);

begin
  Form1.FWysluga.oblicz(StrToInt(EditLata.Text), StrToInt(EditMiesiace.Text));
  //Kontrola działania'+LineEnding+' Wysługa w %:  '+
  //ShowMessage(Form1.wyslugaObj.wypisz15latStr);
  Form1.EditWysluga.Text := Form1.FWysluga.wypiszStr;
  if StrToInt(EditLata.Text) >= 32 then Form1.CheckBox32Lata.Checked := True;
  self.Close;
end;

procedure TForm2.FormDeactivate(Sender: TObject);
begin

  Form1.EditWysluga.Text := Form1.FWysluga.WypiszStr;

end;

procedure TForm2.EditMiesiaceChange(Sender: TObject);
begin
  if StrToInt(EditMiesiace.Text) > 12 then EditMiesiace.Text := '12';
end;

end.
