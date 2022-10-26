unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

//function    TForm1.wyliczEmerytureStare : boolean ;
function wyliczPodstawe(pensja,podwyzka:Currency): currency;      // unit2.wyliczPodstawe
function wyliczProcent(lata,miesiace: integer): currency;
function wyliczEmerytureBruto(podstawa,procenty: currency): currency;
function wyliczPodatek (emeryturaBrutto,podatekProcent,kwotaWolnaRok:Currency): integer;
function wyliczPodatek (emeryturaBrutto,podatekProcent,kwotaWolnaMiesieczna:Currency): Currency;
function wyliczPodatek (emeryturaBrutto,podatekProcent,kwotaWolnaMiesieczna,skladkaZdrowotnaOdliczna:Currency): Currency;
function wyliczKwoteWolna (podatekProcent,kwotaWolnaRok:Currency): currency;
function wyliczSkladkeZdrowotna(emeryturaBrutto,skladka:Currency): currency;
function wyliczSkladkeZdrowotnaOdejmowana(emeryturaBrutto,skladka:Currency): currency;
function wyliczEmerytureNetto(emeryturaBrutto,podatek,skladka:Currency): currency;
function waloryzacjaPodstawa (podstawa,procent:currency): currency;



implementation
//7589,00  zł brutto wraz z miesięczną równowartością 1/12 nagrody rocznej
//stanowiącej kwotę 632,42zł  (7589,00 : 12), podstawa wymiaru emerytury
//wynosiła będzie - kwotę 8 221,42 (7589,00+632,42)

//Zatem, przyszła emerytura policyjna ustalona będzie w kwocie brutto:
//6 166,07 zł  (8221,42x 75%)

//Wg stanu prawnego obowiązującego w dniu dzisiejszym kwotę emerytury do
//wypłaty oblicza się taj poniżej:

//emerytura brutto 6 166,00 x 12% - 300,00 (kwota wolna od podatku) =
//440,00 (do obliczenia zaliczki na podatekEdit kwoty zaokrągla się do pełnych
//złotych)
//emerytura brutto 6 166,07 x 9% = 554,95 składka zdrowotna
//emerytura brutto 6 166,07 - 440,-554,95 = 5 171,12 kwota emerytury do
//wypłaty

 // 2021 17%/9%/525,12

// kwota wolna = 525,12  / 12 =  43,76 zl/m-c
//Przyjmując do wyliczenia podaną miesięczną emeryturę brutto w kwocie
//6166 przed 31.12.2021 r. kwota emerytury do wypłaty obliczana była jak
//poniżej:
//6166,00 x 7,75% = 477,87 (część składki zdrowotnej odliczanej od
//podatku)
//6166,00 x 17% -43,76 (kwota wolna od podatku) - 477,87 (część składki
//zdrowotnej odliczanej od podatku) = 527,00 zaliczka na podatek
//6166,00 x 9% = 554,94(składka zdrowotna )
//6166,00 - 527,00 (zaliczka na podatek) - 554,94 (składka zdrowotna) =
//5084,06 kwota emerytury do wypłaty

// 2020   17%   /9% 7,75/525,12
// 2019   17,75%/9% 7,75/548,30
// 2018   18%   /9% 7,75/556,02
// 2017   18%   /9% 7,75/556,02
// 2016   18%   /9% 7,75/556,02


function wyliczPodstawe (pensja,podwyzka:currency): currency;
var
  trzynastka: currency;
begin


  pensja := pensja + podwyzka;
  trzynastka := Round((pensja / 12) * 100);
  pensja := Round(pensja * 100 + trzynastka);
  Result :=pensja / 100;

 end;




function wyliczProcent(lata,miesiace: integer): currency;

var
  procenty: currency;

begin

  if lata < 15
  then   procenty := 0
  else
      begin
      procenty := lata - 15;
      procenty := 40 + (procenty * 2.6);
      procenty +=  miesiace * (2.6 /12);
      if procenty > 75 then procenty := 75;
      end;

  Result := procenty;
end;

function wyliczEmerytureBruto(podstawa,procenty: currency): currency;
var obliczenia: integer;

begin
    if (podstawa = 0) or (procenty = 0) then Result := 0
  else begin
       obliczenia := Round(podstawa * procenty);
       Result := obliczenia / 100;
       end;
  end;

function wyliczKwoteWolna (podatekProcent,kwotaWolnaRok:Currency): currency;
 var
    kwotaWolnaMiesiaac: Currency;

begin

  if (podatekProcent = 0 ) or (kwotaWolnaRok=0 ) then Result := 0  else
    begin
        kwotaWolnaMiesiaac  :=  Round ( kwotaWolnaRok  * podatekProcent);
        Result              :=  kwotaWolnaMiesiaac DIV 1200;     // dzielenie na 12 miesiecy i 100%

    end;
end;

function wyliczPodatek (emeryturaBrutto,podatekProcent,kwotaWolnaRok:Currency): integer;

var
    kwotaPodatku,kwotaWolnaWyliczona: Currency;

begin

  if emeryturaBrutto = 0  then Result := 0
  else begin
        kwotaWolnaWyliczona  :=  Round (podatekProcent   * kwotaWolnaRok);
        kwotaWolnaWyliczona  :=  kwotaWolnaWyliczona DIV 1200;     // dzielenie na 12 miesiecy i 100%
        kwotaPodatku := emeryturaBrutto * podatekProcent / 100;
        Result := Round(kwotaPodatku - kwotaWolnaWyliczona);
       end;
end;

function wyliczPodatek (emeryturaBrutto,podatekProcent,kwotaWolnaMiesieczna:Currency): Currency;

var
    kwotaPodatku: Currency;

begin

  if emeryturaBrutto = 0 then Result := 0  else
    begin
        kwotaPodatku := emeryturaBrutto * podatekProcent / 100;
        Result := Round(kwotaPodatku - kwotaWolnaMiesieczna);
    end;
end;

function wyliczPodatek (emeryturaBrutto,podatekProcent,kwotaWolnaMiesieczna,skladkaZdrowotnaOdliczna:Currency): Currency;
 var
    kwotaPodatku: Currency;

begin

  if emeryturaBrutto = 0 then Result := 0  else
    begin
        kwotaPodatku := emeryturaBrutto * podatekProcent / 100;
        Result := Round(kwotaPodatku - kwotaWolnaMiesieczna - skladkaZdrowotnaOdliczna);
    end;
end;



function wyliczSkladkeZdrowotna(emeryturaBrutto,skladka:Currency): currency;

var
  obliczenia: integer;
begin
    if emeryturaBrutto = 0 then Result := 0
    else begin
         obliczenia := Round(emeryturaBrutto * skladka);
         Result := obliczenia / 100;
         end;
end;


function wyliczSkladkeZdrowotnaOdejmowana(emeryturaBrutto,skladka:Currency): currency;
var
  obliczenia: integer;
begin
    if emeryturaBrutto = 0 then Result := 0
    else begin
         obliczenia := Round(emeryturaBrutto * skladka);
         Result := obliczenia / 100;
         end;
end;

function wyliczEmerytureNetto(emeryturaBrutto,podatek,skladka:Currency): currency;
begin

  if emeryturaBrutto = 0 then
    Result := 0
  else
    Result := emeryturaBrutto - podatek - skladka;
end;

 function waloryzacjaPodstawa (podstawa,procent:currency): currency;
var
  podstawaInt: Integer;
begin


  podstawaInt := Round(podstawa * procent);
  Result :=podstawaInt / 100;

 end;



//  monolityczne wylicznie   stare
function   wyliczEmerytureStare : boolean ;
//var

  //bruttoPensja     :single;
  //procenty         :single;
  //procentyMiesiac  :single;
  //trzynastka       :single;
  //podstawaWylicz   :single;
  //bruttoEmerytura  :single;
  //podatek_Kwota     :single;
  //skladka_Zdrowotna :single;
  //nettoEmerytura   :single;
  //
  //wolnaKwota:single;




begin

//   bruttoPensja  := strtoFloat(pensjaBruttoEdit.Text) + strtoFloat(podwyzkaBruttoEdit.text);
//     trzynastka    := bruttoPensja / 12;
//     podstawaWylicz:= bruttoPensja + trzynastka  ;
//     //self.podstawaEmerytury :=podstawaWylicz;
// wyliczenie procentow
////    40 % - 15
////    2,6  - 1
//
//
//  procenty         := 0;
//  procentyMiesiac  := 0;
//  procenty:=strtoFloat (lataEdit.Text );
//  procentyMiesiac := strtoFloat (miesiaceEdit.Text);
//  if   procenty < 15 then
//   begin
//   Result       :=false;
//   procenty     :=0;
//   end
//  else
//    begin
//     procentyMiesiac :=   procentyMiesiac * (2.6 / 12);
//    procenty:= procenty - 15;
//    procenty:= 40 + procentyMiesiac + (procenty * 2.6) ;
//    if  procenty > 75 then   procenty :=   75 ;
//
//    end;
////    emerytura brutto
//      wyslugaProcent:=procenty;
//      bruttoEmerytura:=   podstawaEmerytury * procenty / 100;
//
//   emeryturaBruttoEdit.Text:=FloatToStr(bruttoEmerytura);
//
////    emerytura Netto
//     wolnaKwota:= strtoInt (kwotaWolnaEdit.Text) / 12;
//     podatekKwota:= bruttoEmerytura * strtoInt(podatekEdit.text)/100;
//     podatekKwota:=   podatekKwota -  wolnaKwota;
//
//     skladkaZdrowotna:= bruttoEmerytura * strtoInt (zdrowotnaEdit.text)/100;
//
//     nettoEmerytura:=bruttoEmerytura - podatekKwota - skladkaZdrowotna;
//
//     emeryturaNettoEdit.Text:=FloatToStr (nettoEmerytura);
//
   Result       :=true;
end;
end.

