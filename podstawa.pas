unit podstawa;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  { Tpodstawa }
  Tpodstawa = class
  private

  const
    KOLUMNA_ROK = 0;
    KOLUMNA_WALORYZACJA = 1;
    KOLUMNA_PODSTAWA = 2;

  type
    PodstawaZwaloryzowanaCurr = array of currency;
    PodstawaZwaloryzowanaStr = array of string;
    PodstawyZwaloryzowaneStr = array of array of string;

    waloryzacjaWRoku = array [KOLUMNA_ROK..KOLUMNA_WALORYZACJA] of string;

    //    tabelaWaloryzacjiWLatach = array[0..14, 0..1] of string;
    tabelaWaloryzacjiWLatach = array[0..14] of waloryzacjaWRoku;
    TabelaWaloryzacjiPodstawy = array [KOLUMNA_ROK..KOLUMNA_PODSTAWA]of string;
    TabelaWaloryzacjiPodstawyLata =array of TabelaWaloryzacjiPodstawy ;

  const
    // roczna waloryzacja podstawy
    TABELA_WALORYZACJI: tabelaWaloryzacjiWLatach = (
      ('2016', '100,24'),
      ('2017', '100,44'),
      ('2018', '102,98'),
      ('2019', '102,86'),
      ('2020', '103,56'),
      ('2021', '104,24'),
      ('2022', '107,00'),
      ('2023', '114,80'),
      ('2024', '112,30'),
      ('2025', '100,00'),
      ('2026', '100,00'),
      ('2027', '100,00'),
      ('2028', '100,00'),
      ('2029', '100,00'),
      ('2030', '100,00')
      );



    procedure wyczysc;
    procedure wylicz(Apodstawa: currency; Adodatek15: currency = 0);


  public

    fPodstawa: currency;
    fTabelaPodstawZwaloryzowanych: PodstawaZwaloryzowanaCurr;   //sama waloryzacja
    fTabelaWaloryzacji: PodstawaZwaloryzowanaStr;
    //cała tabela z rokiem,waloryzacja , podstawa
    constructor Create;
    procedure Clear;
    //constructor Create(podstawa,wysluga:currency);

    function wyliczPodstawe(Apodstawa, Adodatek15: currency): currency;
    function wyliczPodstaweStr(Apodstawa, Adodatek15: currency): string;
    procedure waloryzujPodstawe(AodRoku: string);
    function wypiszPodstaweStr(): string;
    function ZnajdzWaloryzacjewRoku(ARok: string): WaloryzacjaWRoku;

    function WyliczWaloryzacje(podstawa:Currency;ARok: string = '2022'): PodstawyZwaloryzowaneStr;
    //function WaloryzujPodstaweTabela(podstawa:Currency;ARok: string = '2022'):TabelaWaloryzacjiPodstawyLata;
    function WaloryzujPodstaweTabela(ARok: string; podstawa: Currency): TabelaWaloryzacjiPodstawyLata;

  end;


implementation


constructor Tpodstawa.Create();
begin
  wyczysc;
end;

procedure Tpodstawa.Clear;
begin
  wyczysc();
end;


procedure Tpodstawa.wylicz(Apodstawa: currency; Adodatek15: currency = 0);
var
  trzynastka: integer;

begin
  fPodstawa := 0;
  trzynastka := 0;

  if Apodstawa > 0 then
  begin
    trzynastka := Round((Apodstawa / 12) * 100);
    Apodstawa := Apodstawa * 100 + trzynastka;
    fPodstawa := Round(Apodstawa + (Adodatek15 * 100)) / 100;
  end;

end;

function Tpodstawa.wyliczPodstawe(Apodstawa, Adodatek15: currency): currency;
begin
  wylicz(Apodstawa, Adodatek15);
  Result := fPodstawa;
end;

function Tpodstawa.wyliczPodstaweStr(Apodstawa, Adodatek15: currency): string;
begin
  wylicz(Apodstawa, Adodatek15);
  Result := CurrToStr(fPodstawa);
end;

procedure Tpodstawa.waloryzujPodstawe(AodRoku: string);  // waloryzacja dla roku
begin

  //  SetLength(fTabelaPodstawZwaloryzowanych, n, 2);  //n ilosc rekordow ,3 -rok,waloryzacja,podstawaZwaloryzowana

  fTabelaWaloryzacji := Default(PodstawaZwaloryzowanaStr);
  fTabelaPodstawZwaloryzowanych := null; // wyliczenia podstawy
end;



function Tpodstawa.wypiszPodstaweStr(): string;
begin
  Result := CurrToStr(fPodstawa);
end;

// procedure Tpodstawa.wyliczWysluge(lata,miesiace:integer);

// var
//  procenty: currency;

// begin
//   self.lat:=lata;
//   self.miesiecy:=miesiace;


//   if lata < 15
//  then   procenty := 0
//  else
//      begin
//      procenty := lata - 15;
//      procenty := 40 + (procenty * 2.6);
//      procenty +=  miesiace * (2.6 /12);
//      if procenty > 75 then procenty := 75;
//      end;

//  wysluga := procenty;

// end;

// function Tpodstawa.wypiszWysluge: currency;
//begin
// Result:= wysluga;
//end;


// function Tpodstawa.wyliczWysluge(lata,miesiace:integer): currency;
// begin
//  wyliczWysluge(lata,miesiace);
//  Result:= wysluga;
// end;




procedure Tpodstawa.wyczysc;
begin
  fPodstawa := 0;
  fTabelaPodstawZwaloryzowanych := Default(PodstawaZwaloryzowanaCurr);
  fTabelaWaloryzacji := Default(PodstawaZwaloryzowanaStr);

end;

function Tpodstawa.ZnajdzWaloryzacjewRoku(ARok: string): WaloryzacjaWRoku;

var
  wiersz: integer;

begin
  for wiersz := Low(TABELA_WALORYZACJI) to High(TABELA_WALORYZACJI) do
    if TABELA_WALORYZACJI[wiersz, KOLUMNA_ROK] = ARok then
    begin
      Result := TABELA_WALORYZACJI[wiersz];
      //exit;
    end
    else
      Result := Default(WaloryzacjaWRoku);    //pusty wynik

end;

function Tpodstawa.WaloryzujPodstaweTabela(ARok: string; podstawa: Currency): TabelaWaloryzacjiPodstawyLata;


begin
  // znajdz waloryzacje , waloryzuj, wypisz dane do tablicy

  SetLength(Result,1);
 // Result := ZnajdzWaloryzacjewRoku(ARok)+'';


end;

function Tpodstawa.WyliczWaloryzacje(podstawa:Currency;ARok: string = '2022'): PodstawyZwaloryzowaneStr;
var
  i: Integer;
  aktualnyRok: Integer;
  startRok: Integer;
  waloryzacjaProcent: Currency;
  nowaPodstawa: Currency;
  wynik: array of array of string;
begin
  aktualnyRok := 2024; // Przyjmujemy rok bieżący, można zamienić na aktualny
  startRok := StrToInt(ARok);

  nowaPodstawa := podstawa;
  SetLength(wynik, aktualnyRok - startRok + 1,3);


  // Znalezienie indeksu startowego w tabeli
  for i := 0 to High(TABELA_WALORYZACJI) do
    if StrToInt(TABELA_WALORYZACJI[i][KOLUMNA_ROK]) = startRok then
    begin
      startRok := i;
      Break;
    end;

  // Obliczanie waloryzacji dla każdego roku
  for i := startRok to High(TABELA_WALORYZACJI) do
  begin
    waloryzacjaProcent := StrTocurr(TABELA_WALORYZACJI[i][KOLUMNA_WALORYZACJA]) / 100;
    nowaPodstawa := nowaPodstawa * waloryzacjaProcent;

    //wynik[i - startRok] := '(' + TABELA_WALORYZACJI[i][KOLUMNA_ROK] + ', ' +
    //                       TABELA_WALORYZACJI[i][KOLUMNA_WALORYZACJA] + ', ' +
    //                       FormatFloat('0.00', nowaPodstawa)  + ')';

     //wynik[i - startRok] := Format('(''%s'', ''%s'', ''%.2f'')',
     //                                  [TABELA_WALORYZACJI[i][KOLUMNA_ROK],
     //                                   TABELA_WALORYZACJI[i][KOLUMNA_WALORYZACJA],
     //                                   nowaPodstawa]);

    //SetLength(wynik[i - startRok], 3);
    wynik[i - startRok][0] := TABELA_WALORYZACJI[i][KOLUMNA_ROK];
    wynik[i - startRok][1] := TABELA_WALORYZACJI[i][KOLUMNA_WALORYZACJA];
    wynik[i - startRok][2] := FormatFloat('0.00', nowaPodstawa);

    if StrToInt(TABELA_WALORYZACJI[i][KOLUMNA_ROK]) = aktualnyRok then
      Break;
  end;

  Result := wynik;
end;

end.
