unit Unit2;

{$mode objfpc}{$H+}

interface
//function    TForm1.wyliczEmerytureStare : boolean ;
uses
  Classes, SysUtils;

implementation
//przyjmując do wyliczenia podaną kwotę uposażenia oraz procent wysługi
//tj.:
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

