unit emerytura;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type


  { TEmerytura }

  TEmerytura = class
  private
  const
    ILOSC_EMERYTUR_W_ROKU = 12;
  var
    FBrutto, FBruttoRok: currency;

    procedure Wyczysc;
    procedure ObliczEmerytureBrutto(Podstawa, Procenty: currency);
    procedure ObliczEmerytureBruttoRok;
  public
    constructor Create;
    procedure Clear;

    function WyliczEmerytureBrutto(Podstawa, Procenty: currency): currency;
    function WyliczEmerytureBruttoStr(Podstawa, Procenty: currency): string;
    function WypiszEmerytureBruttoRok: currency;
    function WypiszEmerytureBruttoRokStr: string;
  end;



implementation

{ Temerytura }


procedure TEmerytura.Wyczysc;
begin
  FBrutto := 0;
  FBruttoRok := 0;
end;

procedure TEmerytura.ObliczEmerytureBrutto(Podstawa, Procenty: currency);
begin
  if (Podstawa <= 0) or (Procenty <= 0) then
  begin
    FBrutto := 0;
    //raise Exception.Create('Podstawa i procenty muszą być większe od zera.');
  end
  else
    FBrutto := Round(Podstawa * Procenty);
  FBrutto := FBrutto / 100;
  //FBrutto := Round(Podstawa * Procenty / 100);
  ObliczEmerytureBruttoRok;
end;

procedure TEmerytura.ObliczEmerytureBruttoRok;
begin
  FBruttoRok := FBrutto * ILOSC_EMERYTUR_W_ROKU;
  //FBruttoRok := Round(FBrutto * ILOSC_EMERYTUR_W_ROKU);
end;

constructor TEmerytura.Create;
begin
  Wyczysc;
end;

procedure TEmerytura.Clear;
begin
  Wyczysc;
end;

function TEmerytura.WyliczEmerytureBrutto(Podstawa, Procenty: currency): currency;
begin
  ObliczEmerytureBrutto(Podstawa, Procenty);
  Result := FBrutto;
end;

function TEmerytura.WyliczEmerytureBruttoStr(Podstawa, Procenty: currency): string;
begin
  ObliczEmerytureBrutto(Podstawa, Procenty);
  Result := CurrToStr(FBrutto);
end;

function TEmerytura.WypiszEmerytureBruttoRok: currency;
begin
  Result := FBruttoRok;
end;

function TEmerytura.WypiszEmerytureBruttoRokStr: string;
begin
  Result := CurrToStr(FBruttoRok);
end;



end.
