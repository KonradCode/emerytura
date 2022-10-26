unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    Image1: TImage;
    StaticText1: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure StaticText1DblClick(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}
uses VersionSupport,lclintf;
{ TForm2 }

procedure TForm2.FormCreate(Sender: TObject);
var zawartosc :string ;
 begin
 zawartosc            :=  StaticText1.Caption;//.Replace('wersja','wer');
 StaticText1.Caption  := zawartosc.Replace('wersja','wersja '+GetFileVersion);


end;

procedure TForm2.StaticText1DblClick(Sender: TObject);
begin
  OpenURL('https://github.com/KonradCode/emerytura/releases/');
end;

end.

