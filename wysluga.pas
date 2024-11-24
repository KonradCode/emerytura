unit wysluga;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  { Twysluga  - poprawiona przez GTP }
  TwyslugaGTP = class
  private

  const
    WYSLUGA_PRZYSZLA_START = 0;
    WYSLUGA_PRZYSZLA_KONIEC = 14;
    LATA_SLUZBY_MINIMUM = 15;
    MNOZNIK_ROCZNY = 2.6;
    PROCENT_MIN_LATA = 40;
    PROCENT_MAX_LATA = 75;
    PROCENT_MAX = 80;

  type
    wysluga15Lat = array[WYSLUGA_PRZYSZLA_START..WYSLUGA_PRZYSZLA_KONIEC] of currency;

  var
    fLat, fMiesiecy: integer;
    fwysluga15: wysluga15Lat;
    fWysluga: currency;

    procedure Ustaw(lata, miesiace: integer);
    procedure Wyczysc;
    function Wylicz(lata, miesiace: integer): currency;
    procedure Wylicz15Lat;
    procedure Wylicz15LatDla0;
    function CzyTablicaDomyslna(const Tablica: wysluga15Lat): boolean;

  public
    constructor Create;
    procedure Clear;
    function Oblicz(lata, miesiace: integer): currency;
    procedure WyliczWysluge15;
    procedure UstawWyslugeStr(Awysluga: string);
    function Wypisz: currency;
    function WypiszStr: string;
    function Wypisz15lat: wysluga15Lat;
    function WypiszWyslugeZaRok(ARok: integer): currency;
    function Wypisz15latStr: string;
  end;


implementation

uses Math;

constructor TwyslugaGTP.Create;
begin
  Wyczysc();
end;

procedure TwyslugaGTP.Clear;
begin
  Wyczysc();
end;

procedure TwyslugaGTP.Wyczysc;
begin
  fLat := 0;
  fMiesiecy := 0;
  fWysluga := 0;
  fwysluga15 := Default(wysluga15Lat);
end;

procedure TwyslugaGTP.Ustaw(lata, miesiace: integer);
begin
  fLat := lata;
  fMiesiecy := miesiace;
end;

function TwyslugaGTP.Wylicz(lata, miesiace: integer): currency;
begin
  if lata < LATA_SLUZBY_MINIMUM then
    Exit(0);

  Result := PROCENT_MIN_LATA + (lata - LATA_SLUZBY_MINIMUM) *
    MNOZNIK_ROCZNY + miesiace * (MNOZNIK_ROCZNY / 12);
  if Result > PROCENT_MAX_LATA then
    Result := PROCENT_MAX_LATA;
end;

procedure TwyslugaGTP.Wylicz15Lat;
var
  i: integer;
begin
  fwysluga15[0] := fWysluga + MNOZNIK_ROCZNY;
  for i := WYSLUGA_PRZYSZLA_START + 1 to WYSLUGA_PRZYSZLA_KONIEC do
    fwysluga15[i] := Min(single(fwysluga15[i - 1]) + MNOZNIK_ROCZNY, PROCENT_MAX_LATA);
end;

procedure TwyslugaGTP.Wylicz15LatDla0;
var
  i: integer;
begin
  for i := WYSLUGA_PRZYSZLA_START to WYSLUGA_PRZYSZLA_KONIEC do
    fwysluga15[i] := Min(single(Wylicz(fLat + 1 + i, fMiesiecy)), PROCENT_MAX_LATA);
end;

function TwyslugaGTP.CzyTablicaDomyslna(const Tablica: wysluga15Lat): boolean;
var
  I: integer;
begin
  //Result := Tablica = Default(wysluga15Lat);

  for I := Low(Tablica) to High(Tablica) do
  begin
    if Tablica[I] <> Default(currency) then // Sprawdza, czy każdy element = 0
      Exit(False);
  end;
  Result := True;
end;

function TwyslugaGTP.Oblicz(lata, miesiace: integer): currency;
begin
  Wyczysc;
  Ustaw(lata, miesiace);
  fWysluga := Wylicz(lata, miesiace);

  if CzyTablicaDomyslna(fwysluga15) then
    WyliczWysluge15;

  Result := fWysluga;
end;

procedure TwyslugaGTP.WyliczWysluge15;
var i:integer;
begin
  if fWysluga <= 0 then
    Wylicz15LatDla0
  else if fWysluga >= PROCENT_MAX_LATA then
      for i := Low(fwysluga15) to High(fwysluga15) do
    fwysluga15[i] := fWysluga

    //FillChar(fwysluga15, SizeOf(fwysluga15), PROCENT_MAX_LATA)
  else
    Wylicz15Lat;
end;

procedure TwyslugaGTP.UstawWyslugeStr(Awysluga: string);
begin
  try
    fWysluga := StrToCurr(Awysluga);
  except
    on E: EConvertError do
      raise Exception.Create('Nieprawidłowy format danych w wysłudze.');
  end;
end;

function TwyslugaGTP.Wypisz: currency;
begin
  Result := fWysluga;  // Prosto zwróćmy przechowywaną wartość
end;

function TwyslugaGTP.WypiszStr: string;
begin
  Result := CurrToStr(fWysluga);
  // Użyj funkcji `CurrToStr`, by zamienić `Currency` na string
end;

function TwyslugaGTP.Wypisz15lat: wysluga15Lat;
begin
  Result := fwysluga15;
  // Bez potrzeby dodatkowego przetwarzania, po prostu zwróć tablicę
end;

function TwyslugaGTP.WypiszWyslugeZaRok(ARok: integer): currency;
begin

  WyliczWysluge15; //wylicz zawsze bez wzgledy na to co obecnie jest wyliczone
  // Sprawdź, czy rok mieści się w dozwolonym zakresie (0 do 14)
  if (ARok >= WYSLUGA_PRZYSZLA_START) and (ARok <= WYSLUGA_PRZYSZLA_KONIEC) then
    Result := fwysluga15[ARok]  // Zwróć wartość z tablicy dla podanego roku
  else
    Result := 0;

end;

function TwyslugaGTP.Wypisz15latStr: string;
var
  i: integer;
begin
  // Zainicjalizuj pusty string
  Result := '';

  // Przejdź po całej tablicy i dodaj elementy do wyniku
  for i := 0 to High(fwysluga15) do
  begin
    // Formatowanie tekstu i dodawanie nowych linii
    Result := Result + Format('Element %d: %.2f', [i, fwysluga15[i]]) + sLineBreak;
  end;
end;


end.
