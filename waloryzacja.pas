unit waloryzacja;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  waloryzacjaWRoku = array [0..1] of string;
  tabelaWalotyzacjiWLatach = array[0..14, 0..1] of string;



 {TWaloryzacje}     // właczyc do emerytury
  Twaloryzacje = class

  private


  public

  const
    fTabelaWaloryzacji: tabelaWalotyzacjiWLatach = (  { #todo : DO skrócenia tabela }
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


    function znajdzWaloryzacje(ARok: string): waloryzacjaWRoku;
    //   function wypiszWaloryzacjeWLatach : tabelaWalotyzacjiWLatach;

  end;

implementation


 //  Twaloryzacje Class
function Twaloryzacje.znajdzWaloryzacje(ARok: string): waloryzacjaWRoku;

var
  wiersz: integer;

begin
  for wiersz := Low(fTabelaWaloryzacji) to High(fTabelaWaloryzacji) do
    if fTabelaWaloryzacji[wiersz, 0] = ARok then
    begin
      Result := fTabelaWaloryzacji[wiersz];
      //exit;
    end
    else
      Result := Default(waloryzacjaWRoku);    //pusty wynik

end;

//function Twaloryzacje.wypiszWaloryzacjeWLatach : tabelaWalotyzacjiWLatach;
// begin
// Result:= Tabela;
// end;
end.

