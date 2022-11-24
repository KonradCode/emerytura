unit emerytura.tobject;

{$mode objfpc}{$H+}

interface





uses
  Classes, SysUtils;

type
Emerytura = class(TObject)

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
  //podatki: array of podatkiRecord ;

  var podstawa:Currency;


  function podatkiTabelaZnajdz(rok:string):integer;
  public
  constructor Create;
  constructor Create(pensja,podwyzka,wysluga:Currency);
  constructor Create(pensja,podwyzka,lata,miesiace:Currency);

  end;

  Waloryzacja  = class(TObject)    { Waloryzacja }

  private
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

  public

  end;






implementation


constructor Emerytura.create;

begin


end;

constructor Emerytura.Create(pensja,podwyzka,wysluga:Currency);

begin


end;
constructor Emerytura.Create(pensja,podwyzka,lata,miesiace:Currency);
begin

end;

function Emerytura.podatkiTabelaZnajdz(rok:string):integer;

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


end.

