unit podatki;

{$mode ObjFPC}{$H+}


interface

uses
  Classes, SysUtils;

type

  { TPodatek }
  TPodatek = class

  private

  const

    ROK_DOMYSLNY = '2022';
    MIESIECY_W_ROKU = 12;
    KOLUMNA_ROK = 0;
    KOLUMNA_KWOTA_WOLNA = 1;
    KOLUMNA_ZDROWOTNA = 2;
    KOLUMNA_ZDROWOTNA_ODLICZNA = 3;
    KOLUMNA_PODATEK_PROG_1 = 4;
    KOLUMNA_PROG_KWOTA = 5;
    KOLUMNA_PODATEK_PROG_2 = 6;
    PODATEK_ROK_START = 0;
    PODATEK_ROK_STOP = 6;

    PODATKI_TABELA: array[0..4, PODATEK_ROK_START..PODATEK_ROK_STOP] of string = (
      //Rok | Kwota zmniejszajaca podatek | Składka | Składka |  Stawka 1 | Próg 2  | Stawka 2
      //    | (PLN)       | zdrow.  | odlicz. | (%)      | (PLN)   | (%)
      ('2009', '556,02', '9', '7,75', '18', '85528', '32'),
      ('2019', '548,30', '9', '7,75', '17,75', '85528', '32'),
      ('2020', '525,12', '9', '7,75', '17', '85528', '32'),
      ('2021', '525,12', '9', '7,75', '17', '85528', '32'),
      ('2022', '3600', '9', '0', '12', '120000', '32'));    // kwota obnizajaca podatek



  type
    PodatekWRoku = array [PODATEK_ROK_START..PODATEK_ROK_STOP] of string;
    PodatekWLatach = array [0..4, PODATEK_ROK_START..PODATEK_ROK_STOP] of string;




  var
    fWybranyPodatek: PodatekWRoku;
    fCalaSkladkaZdrowotna: currency;   // Cała składka zdrowotna  ??
    fOdliczalnaSkladkaZdrowotna: currency; // Odliczalna część składki zdrowotnej  ??
    fKwotaPodatku, fKwotaPodatkuProg1, fKwotaPodatkuProg2: currency;
    // Obliczona kwota podatku . Prog1 - przy uzyciu progu 1,Prog2 - przy uzyciu progu2
    fkwotaObnizajacaPodatekRok: currency; // ??




    procedure Wyczysc;

    procedure UstawPodatek(ARok: string = ROK_DOMYSLNY);

    procedure ObliczCalaSkladkeZdrowotna(ABrutto: currency);
    procedure ObliczOdliczalnaSkladkeZdrowotna(ABrutto: currency);

    procedure UstawKwoteWolna;

  public
    constructor Create;
    procedure Clear;

    function UstalPodatekStary(ARok: string = ROK_DOMYSLNY): PodatekWRoku;
    //stara wersja do usuniecia po sprawdzeniu nowej
    function UstalPodatek(ARok: string = ROK_DOMYSLNY): PodatekWRoku;

    function PodajProcentProgu_1(ARok: string): integer;
    function PodajProcentProgu_2(ARok: string): integer;
    function ObliczSkladkeZdrowotna(ABrutto: currency;
      AskladkaProcent: currency): currency;

    function ObliczNaleznosciMiesiacGPT(ABrutto, ABruttoRok: currency;
      ARok: string = ROK_DOMYSLNY): currency;
    function ObliczNaleznosciRokGPT(ABruttoRok: currency; ARok: string): currency;
    // do sprawdzenia jak dziala



    function ObliczPodatekProg_1(podstawaOpodatkowania, kwotaWolna: currency;
      pierwszyProgProcent: integer): currency; //do przeanalizowania
    function ObliczNaleznosciMiesiac(ABrutto, ABruttoRok: currency;
      ARok: string = ROK_DOMYSLNY): currency; //do przeanalizowania
    // function podatkiWLatch: PodatekWLatach; //do przeanalizowania



  end;




implementation
//   TPodatek Class

procedure TPodatek.Wyczysc;
begin
  FWybranyPodatek := Default(PodatekWRoku);
  fCalaSkladkaZdrowotna := 0;
  fOdliczalnaSkladkaZdrowotna := 0;
  fKwotaPodatku := 0;
  fKwotaPodatkuProg1 := 0;
  fKwotaPodatkuProg2 := 0;
  fkwotaObnizajacaPodatekRok := 0;

end;

constructor TPodatek.Create;
begin
  wyczysc;

end;

procedure TPodatek.Clear;
begin
  Wyczysc;
end;

procedure TPodatek.UstawPodatek(ARok: string);    // moze byc podfunkcja ustal podatek

begin
  FWybranyPodatek := UstalPodatek(ARok);
end;


procedure TPodatek.UstawKwoteWolna;
begin
  fkwotaObnizajacaPodatekRok := StrToCurr(FWybranyPodatek[KOLUMNA_KWOTA_WOLNA]);
end;


function TPodatek.UstalPodatekStary(ARok: string): PodatekWRoku;
  //stara wersja do usuniecia po sprawdzeniu nowej

var
  wiersz: integer;
begin
  for wiersz := Low(PODATKI_TABELA) to High(PODATKI_TABELA) do
    if PODATKI_TABELA[wiersz, KOLUMNA_ROK] = Arok then
    begin
      Result := PODATKI_TABELA[wiersz];
    end;
end;

function TPodatek.UstalPodatek(ARok: string): PodatekWRoku;
var
  wiersz, rok, znalezionyRok: integer;

begin
  rok := StrToInt(ARok);
  znalezionyRok := -1;

  // Sprawdzanie tabeli w poszukiwaniu dokładnego roku
  for wiersz := Low(PODATKI_TABELA) to High(PODATKI_TABELA) do
  begin
    if PODATKI_TABELA[wiersz][KOLUMNA_ROK] = ARok then
    begin
      znalezionyRok := wiersz;
      Break;
    end
    else if StrToInt(PODATKI_TABELA[wiersz][KOLUMNA_ROK]) < rok then
      znalezionyRok := wiersz; // Zapisujemy najbliższy wcześniejszy rok
  end;



  // Jeśli znaleziono rok lub najbliższy wcześniejszy
  if znalezionyRok <> -1 then Result := PODATKI_TABELA[znalezionyRok];
end;


procedure TPodatek.ObliczCalaSkladkeZdrowotna(ABrutto: currency);
begin
  // Obliczamy pełną składkę zdrowotną (9% dochodu)
  FCalaSkladkaZdrowotna := Round(
    (ABrutto * StrToCurr(FWybranyPodatek[KOLUMNA_ZDROWOTNA])));
  FCalaSkladkaZdrowotna := FCalaSkladkaZdrowotna / 100;
  // składka zdrowotna
end;

procedure TPodatek.ObliczOdliczalnaSkladkeZdrowotna(ABrutto: currency);
begin
  // Składka zdrowotna odliczalna (7,75%) obowiązuje tylko w latach 2016-2021
  FOdliczalnaSkladkaZdrowotna :=
    Round((ABrutto * StrToCurr(FWybranyPodatek[KOLUMNA_ZDROWOTNA_ODLICZNA])));
  FOdliczalnaSkladkaZdrowotna := FOdliczalnaSkladkaZdrowotna / 100;
  // składka odliczalna
end;

function TPodatek.ObliczSkladkeZdrowotna(ABrutto: currency;
  AskladkaProcent: currency): currency;
begin
  Result := Round(ABrutto * AskladkaProcent) / 100;
end;

function TPodatek.ObliczPodatekProg_1(podstawaOpodatkowania, kwotaWolna: currency;
  pierwszyProgProcent: integer): currency;
begin
  Result := Round((podstawaOpodatkowania * pierwszyProgProcent) / 100 - kwotaWolna);
end;



function TPodatek.PodajProcentProgu_1(ARok: string): integer;
begin
  // wybranyPodatek[0]= '' nie znalazle innego sposoby na sprawdzenie
  if FWybranyPodatek[KOLUMNA_ROK] = EmptyStr then UstawPodatek(Arok);
  Result := StrToInt(FWybranyPodatek[KOLUMNA_PODATEK_PROG_1]);
  // cos tu nie gra z podatkiem
end;

function TPodatek.PodajProcentProgu_2(ARok: string): integer;
begin
  if FWybranyPodatek[KOLUMNA_ROK] = EmptyStr then UstawPodatek(Arok);
  Result := StrToInt(FWybranyPodatek[KOLUMNA_PODATEK_PROG_2]);
end;

//######################## dziala ########################
// Naleznosci  Miesiac  z obliczeniami progów
function TPodatek.ObliczNaleznosciMiesiac(ABrutto, ABruttoRok: currency;
  ARok: string): currency;

var
  pierwszyProgProcent, drugiProgProcent, kwotaProgu: integer;
  podstawaOpodatkowania, kwotaNaleznosci, kwotaWolna, kwotaProguMiesiac,
  skladkaZdrowotnaOdliczalna, skladkaZdrowotnaOdliczalnaProcent,
  skladkaZdrowotna, skladkaZdrowotnaProcent: currency;
  ustalonyPodatek: PodatekWRoku;

begin
  ustalonyPodatek := UstalPodatek(ARok);


  kwotaWolna := StrToCurr(ustalonyPodatek[KOLUMNA_KWOTA_WOLNA]);
  // kwota wolna

  skladkaZdrowotnaProcent := StrToCurr(ustalonyPodatek[KOLUMNA_ZDROWOTNA]);
  skladkaZdrowotnaOdliczalnaProcent :=
    StrToCurr(ustalonyPodatek[KOLUMNA_ZDROWOTNA_ODLICZNA]);
  pierwszyProgProcent := StrToInt(ustalonyPodatek[KOLUMNA_PODATEK_PROG_1]);
  kwotaProgu := StrToInt(ustalonyPodatek[KOLUMNA_PROG_KWOTA]);
  drugiProgProcent := StrToInt(ustalonyPodatek[KOLUMNA_PODATEK_PROG_2]);


  // Obliczamy podstawę opodatkowania, odejmując kwotę wolną od dochodu
  // kwotaWolna:= (kwotaWolna * pierwszyProgProcent) ; //wyliczenie kwoty wolnej od podadatku
  kwotaWolna := kwotaWolna / MIESIECY_W_ROKU; // kwota wolna dla 1 miesiaca

  podstawaOpodatkowania := Round(ABrutto);   // zaokraglenie na potrzeby podatkowe




  // Obliczamy podatek w zależności od dochodu po uwzględnieniu kwoty wolnej od podatku
  kwotaProguMiesiac := kwotaProgu / MIESIECY_W_ROKU;
  if ABruttoRok <= kwotaProgu then
  begin
    kwotaNaleznosci := (podstawaOpodatkowania * pierwszyProgProcent) - kwotaWolna;
    kwotaNaleznosci := Round(kwotaNaleznosci / 100);// zaorkąglenie
  end
  else
  begin
    //kwotaNaleznosci := (kwotaProguMiesiac * pierwszyProgProcent) /
    //100 + ((podstawaOpodatkowania - kwotaProguMiesiac) * drugiProgProcent) / 100;

    kwotaNaleznosci := (kwotaProguMiesiac * pierwszyProgProcent) +
      ((podstawaOpodatkowania - kwotaProguMiesiac) * drugiProgProcent);
    kwotaNaleznosci := kwotaNaleznosci - kwotaWolna;
    kwotaNaleznosci := Round(kwotaNaleznosci / 100); // zaorkąglenie

  end;

  if kwotaNaleznosci < 0 then
  begin
    Result := 0;
    exit;
  end;
  // Jeśli dochód jest niższy niż kwota wolna, podstawa wynosi 0



  if (skladkaZdrowotnaOdliczalnaProcent <> 0) then
  begin
    skladkaZdrowotnaOdliczalna := Round(ABrutto * skladkaZdrowotnaOdliczalnaProcent);
    skladkaZdrowotnaOdliczalna := skladkaZdrowotnaOdliczalna / 100;
  end
  else
    skladkaZdrowotnaOdliczalna := 0;

  kwotaNaleznosci := kwotaNaleznosci - skladkaZdrowotnaOdliczalna;
  // odliczenie składki zdrowotnej jesli odliczna

  skladkaZdrowotna := Round(ABrutto * skladkaZdrowotnaProcent);
  skladkaZdrowotna := skladkaZdrowotna / 100;

  kwotaNaleznosci := kwotaNaleznosci + skladkaZdrowotna;

  if kwotaNaleznosci < 0 then
    kwotaNaleznosci := 0;  // Podatek nie może być ujemny

  Result := kwotaNaleznosci;
  //Result := Round(kwotaNaleznosci);

end;

//###############################################################


// ############# Zaproponowane przez GPT -- działa poprawnie
function TPodatek.ObliczNaleznosciMiesiacGPT(ABrutto, ABruttoRok: currency;
  ARok: string): currency;
var
  pierwszyProgProcent, drugiProgProcent: currency;
  kwotaProgu, podstawaOpodatkowania, kwotaNaleznosci, kwotaWolna,
  kwotaProguMiesiac, skladkaZdrowotnaOdliczalna, skladkaZdrowotna: currency;
  ustalonyPodatek: PodatekWRoku;
begin
  ustalonyPodatek := UstalPodatek(ARok);

  // Przypisanie wartości z tabeli podatków
  kwotaWolna := StrToCurr(ustalonyPodatek[KOLUMNA_KWOTA_WOLNA]);
  pierwszyProgProcent := StrToCurr(ustalonyPodatek[KOLUMNA_PODATEK_PROG_1]);
  drugiProgProcent := StrToCurr(ustalonyPodatek[KOLUMNA_PODATEK_PROG_2]);
  kwotaProgu := StrToCurr(ustalonyPodatek[KOLUMNA_PROG_KWOTA]);

  // Składki zdrowotne
  skladkaZdrowotna := Round(ABrutto *
    StrToCurr(ustalonyPodatek[KOLUMNA_ZDROWOTNA])) / 100;
  skladkaZdrowotnaOdliczalna :=
    Round(ABrutto * StrToCurr(ustalonyPodatek[KOLUMNA_ZDROWOTNA_ODLICZNA])) / 100;

  // Przeliczenie kwoty wolnej na miesiące
  kwotaWolna := kwotaWolna / MIESIECY_W_ROKU;

  // Obliczamy podstawę opodatkowania
  podstawaOpodatkowania := Round(ABrutto);

  // Obliczamy próg dla jednego miesiąca
  kwotaProguMiesiac := kwotaProgu / MIESIECY_W_ROKU;

  // Obliczenia zależne od progu dochodowego
  if ABruttoRok <= kwotaProgu then
    kwotaNaleznosci := Round((podstawaOpodatkowania * pierwszyProgProcent) /
      100 - kwotaWolna)
  else
    kwotaNaleznosci := Round(((kwotaProguMiesiac * pierwszyProgProcent) / 100) +
      ((podstawaOpodatkowania - kwotaProguMiesiac) * drugiProgProcent) /
      100 - kwotaWolna);

  // Korekta należności o składkę zdrowotną (odliczalna)
  kwotaNaleznosci := kwotaNaleznosci - skladkaZdrowotnaOdliczalna;

  // Dodanie składki zdrowotnej (nieodliczalna)
  kwotaNaleznosci := kwotaNaleznosci + skladkaZdrowotna;

  // Podatek nie może być ujemny
  if kwotaNaleznosci < 0 then
    kwotaNaleznosci := 0;

  Result := kwotaNaleznosci;
  //Result := Round(kwotaNaleznosci);
end;
// ############# Zaproponowane przez GPT ####################


// ############# Zaproponowane przez GPT -- działa poprawnie
function TPodatek.ObliczNaleznosciRokGPT(ABruttoRok: currency; ARok: string): currency;
var
  pierwszyProgProcent, drugiProgProcent: integer;
  kwotaProgu, podstawaOpodatkowania, kwotaNaleznosci, kwotaWolna,
  skladkaZdrowotnaOdliczalna, skladkaZdrowotna: currency;
  ustalonyPodatek: PodatekWRoku;
begin
  ustalonyPodatek := UstalPodatek(ARok);

  // Przypisanie wartości z tabeli podatków
  kwotaWolna := StrToCurr(ustalonyPodatek[KOLUMNA_KWOTA_WOLNA]);
  pierwszyProgProcent := StrToInt(ustalonyPodatek[KOLUMNA_PODATEK_PROG_1]);
  drugiProgProcent := StrToInt(ustalonyPodatek[KOLUMNA_PODATEK_PROG_2]);
  kwotaProgu := StrToCurr(ustalonyPodatek[KOLUMNA_PROG_KWOTA]);

  // Składki zdrowotne
  skladkaZdrowotna := Round(ABruttoRok *
    StrToCurr(ustalonyPodatek[KOLUMNA_ZDROWOTNA])) / 100;
  skladkaZdrowotnaOdliczalna :=
    Round(ABruttoRok * StrToCurr(ustalonyPodatek[KOLUMNA_ZDROWOTNA_ODLICZNA])) / 100;


  // Obliczamy podstawę opodatkowania
  podstawaOpodatkowania := Round(ABruttoRok);  //- kwotaWolna);
  if podstawaOpodatkowania <= 0 then
  begin
    Result := 0;
    exit;
  end;


  // Obliczenia zależne od progu dochodowego -- do poprawy
  if ABruttoRok <= kwotaProgu then
    kwotaNaleznosci := Round(((podstawaOpodatkowania * pierwszyProgProcent) -
      kwotaWolna) / 100)
  //kwotaNaleznosci := Round((podstawaOpodatkowania * pierwszyProgProcent) / 100 - kwotaWolna )
  else
    //   kwotaNaleznosci := Round(((kwotaProgu * pierwszyProgProcent) / 100) +  //
    kwotaNaleznosci := Round(((kwotaProgu * pierwszyProgProcent) - kwotaWolna) +
      ((podstawaOpodatkowania - kwotaProgu) * drugiProgProcent) / 100); //!!!

  // Korekta należności o składkę zdrowotną (odliczalna)
  kwotaNaleznosci := kwotaNaleznosci - skladkaZdrowotnaOdliczalna;

  // Dodanie składki zdrowotnej (nieodliczalna)
  kwotaNaleznosci := kwotaNaleznosci + skladkaZdrowotna;

  // Podatek nie może być ujemny
  if kwotaNaleznosci < 0 then kwotaNaleznosci := 0;

  Result := kwotaNaleznosci;
  //Result := Round(kwotaNaleznosci);
end;
// ############# Zaproponowane przez GPT ####################




end.
