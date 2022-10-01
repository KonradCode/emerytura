unit Unit2;

{$mode objfpc}{$H+}

interface
//function    TForm1.wyliczEmerytureStare : boolean ;
uses
  Classes, SysUtils;

implementation

//  monolityczne wylicznie   stare
function   wyliczEmerytureStare : boolean ;
var

  bruttoPensja     :single;
  procenty         :single;
  procentyMiesiac  :single;
  trzynastka       :single;
  podstawaWylicz   :single;
  bruttoEmerytura  :single;
  podatek_Kwota     :single;
  skladka_Zdrowotna :single;
  nettoEmerytura   :single;

  wolnaKwota:single;




begin
//
//
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
//   Result       :=true;
end;
end.

