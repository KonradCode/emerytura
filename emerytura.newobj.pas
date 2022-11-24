unit emerytura.newobj;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;


type

  TEmerytura = class

  private
  const podatkiTabela :array [0..6,0..4] of String = (
                 ('2016','18','556,02','9','7,75'),
                 ('2017','18','556,02','9','7,75'),
                 ('2018','18','556,02','9','7,75'),
                 ('2019','17,75','548,30','9','7,75'),
                 ('2020','17','525,12','9','7,75'),
                 ('2021','17','556,02','9','7,75'),
                 ('2022','12','30000','9','0')
                 );
 const waloryzacjaTabela: array[0..14,0..3] of String = (
       ('2016','100,24','',''),
       ('2017','100,44','',''),
       ('2018','102,98','',''),
       ('2019','102,86','',''),
       ('2020','103,56','',''),
       ('2021','104,24','',''),
       ('2022','107,00','',''),
       ('2023','113,80','',''),
       ('2024','100,00','',''),
       ('2025','100,00','',''),
       ('2026','100,00','',''),
       ('2027','100,00','',''),
       ('2028','100,00','',''),
       ('2029','100,00','',''),
       ('2030','100,00','','')
     );


  var
  podstawaEmerytury,wyslugaProcent,
  emeryturaBrutto,emeryturaNetto,
  skladkaZdrowotna,podatekKwota,
  skladkaZdrowotnaProcent,skladkaZdrowotnaOdliczna,podatekProcent,podatekKwotaWolnaRok
  :Currency;


  function podatkiTabelaZnajdz(rok:string):integer;
  public
  constructor Create;
  constructor Create(pensja,podwyzka,wysluga:Currency);
  constructor Create(pensja,podwyzka:Currency;lata,miesiace:integer);

  destructor Destroy; override;

  function wyliczPodstawe(pensja,podwyzka:Currency): currency;
  function wyliczProcent(lata,miesiace: integer): currency;
  function wyliczEmerytureBruto(podstawa,procenty: currency): currency;
  end;


implementation

//############################ konstruktory  destruktor klasy
destructor TEmerytura.Destroy;
begin

  inherited;
end;

constructor TEmerytura.Create;
begin
    podstawaEmerytury :=0;
    wyslugaProcent    :=0;
    emeryturaBrutto   :=0;
end;


constructor TEmerytura.Create(pensja,podwyzka,wysluga:Currency);

begin
    podstawaEmerytury :=wyliczPodstawe(pensja,podwyzka);
    wyslugaProcent    :=wysluga;
    emeryturaBrutto   :=wyliczEmerytureBruto(podstawaEmerytury,wyslugaProcent);

end;
constructor TEmerytura.Create(pensja,podwyzka:Currency;lata,miesiace:integer);
begin
     podstawaEmerytury :=wyliczPodstawe(pensja,podwyzka);
     wyslugaProcent    :=wyliczProcent(lata,miesiace);
end;
//######################################### funkcje klasy
function TEmerytura.podatkiTabelaZnajdz(rok:string):integer;        // wyzukaj w tabeli podatkiTabela

var wiersz : integer ;
begin
     for wiersz:= Low(podatkiTabela) to High(podatkiTabela) do
         if  podatkiTabela[wiersz,0] = rok then
            begin
            Result:=wiersz;
            exit;
            end
      else Result:=-1;

 end;

function TEmerytura.wyliczPodstawe(pensja, podwyzka: Currency): currency;
var
  trzynastka: currency;
begin


  pensja := pensja + podwyzka;
  trzynastka := Round((pensja / 12) * 100);
  pensja := Round(pensja * 100 + trzynastka);
  Result :=pensja / 100;

 end;


function TEmerytura.wyliczProcent(lata,miesiace: integer): currency;

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


function TEmerytura.wyliczEmerytureBruto(podstawa,procenty: currency): currency;
var obliczenia: integer;

begin
    if (podstawa = 0) or (procenty = 0) then Result := 0
  else begin
       obliczenia := Round(podstawa * procenty);
       Result := obliczenia / 100;
       end;
  end;


end.

