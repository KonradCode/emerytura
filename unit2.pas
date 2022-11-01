unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type waloryzacjaWyliczenia = array[0..3] of string ;


//function    TForm1.wyliczEmerytureStare : boolean ;
function wyliczPodstawe(pensja,podwyzka:Currency): currency;      // unit2.wyliczPodstawe
function wyliczProcent(lata,miesiace: integer): currency;
function wyliczEmerytureBruto(podstawa,procenty: currency): currency;
{ TODO : Do przejzenia i optymalizacji }
function wyliczPodatekzRoku (emeryturaBrutto,podatekProcent,kwotaWolnaRok:Currency): integer;
function wyliczPodatek (emeryturaBrutto,podatekProcent,kwotaWolnaMiesieczna:Currency): Currency;
function wyliczPodatek (emeryturaBrutto,podatekProcent,kwotaWolnaMiesieczna,skladkaZdrowotnaOdliczna:Currency): Currency;

function wyliczKwoteWolna (podatekProcent,kwotaWolnaRok:Currency): currency;

function wyliczSkladkeZdrowotna(emeryturaBrutto,skladka:Currency): currency;
function wyliczSkladkeZdrowotnaOdejmowana(emeryturaBrutto,skladka:Currency): currency;
function wyliczEmerytureNetto(emeryturaBrutto,podatek,skladka:Currency): currency;
function waloryzacjaPodstawa (podstawa,procent:currency): currency;

function walozyzacjaWylicz(podstawa,wysluga:Currency): waloryzacjaWyliczenia;

implementation



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

function wyliczPodatekzRoku (emeryturaBrutto,podatekProcent,kwotaWolnaRok:Currency): integer;

var
    kwotaPodatku,kwotaWolnaWyliczona: Currency;

begin

  if emeryturaBrutto = 0  then Result := 0
  else begin
        kwotaWolnaWyliczona  :=  Round (podatekProcent   * kwotaWolnaRok);
        kwotaWolnaWyliczona  :=  kwotaWolnaWyliczona DIV 1200;  // dzielenie na 12 miesiecy i 100%
        kwotaPodatku         :=  emeryturaBrutto * podatekProcent / 100;
        Result               :=  Round(kwotaPodatku - kwotaWolnaWyliczona);
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
function   wyliczEmerytureMonolit : boolean ;
var

  bruttoPensja     :single    =0;
  procenty         :single    =0;
  procentyMiesiac  :single    =0;
  trzynastka       :single    =0;
  podstawaWylicz   :single    =0;
  bruttoEmerytura  :single    =0;
  podatek_Kwota     :single   =0;
  skladka_Zdrowotna :single   =0;
  nettoEmerytura   :single    =0;

  wolnaKwota:single           =0;




begin

   //bruttoPensja  := strtoFloat(pensjaBruttoEdit.Text) + strtoFloat(podwyzkaBruttoEdit.text);
     trzynastka    := bruttoPensja / 12;
     podstawaWylicz:= bruttoPensja + trzynastka  ;
     //self.podstawaEmerytury :=podstawaWylicz;
 //wyliczenie procentow
 //    40 % - 15
 //    2,6  - 1


  procenty         := 0;
  procentyMiesiac  := 0;
  //procenty:=strtoFloat (lataEdit.Text );
  //procentyMiesiac := strtoFloat (miesiaceEdit.Text);
  if   procenty < 15 then
   begin
   Result       :=false;
   procenty     :=0;
   end
  else
    begin
    procentyMiesiac :=   procentyMiesiac * (2.6 / 12);
    procenty:= procenty - 15;
    procenty:= 40 + procentyMiesiac + (procenty * 2.6) ;
    if  procenty > 75 then   procenty :=   75 ;

    end;
//    emerytura brutto
      //wyslugaProcent:=procenty;
      //bruttoEmerytura:=   podstawaEmerytury * procenty / 100;

   //emeryturaBruttoEdit.Text:=FloatToStr(bruttoEmerytura);

//    emerytura Netto
     //wolnaKwota:= strtoInt (kwotaWolnaEdit.Text) / 12;
     //podatekKwota:= bruttoEmerytura * strtoInt(podatekEdit.text)/100;
     //podatekKwota:=   podatekKwota -  wolnaKwota;

     //skladkaZdrowotna:= bruttoEmerytura * strtoInt (zdrowotnaEdit.text)/100;

     //nettoEmerytura:=bruttoEmerytura - podatekKwota - skladkaZdrowotna;

     //emeryturaNettoEdit.Text:=FloatToStr (nettoEmerytura);

   Result       :=true;
end;


function walozyzacjaWylicz(podstawa,wysluga:Currency): waloryzacjaWyliczenia;
begin
  Result[0]:='';
  //
end;

end.

