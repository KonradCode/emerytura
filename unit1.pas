unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Menus, ExtCtrls, ValEdit,  Grids, DateTimePicker;

//   ExtDlgs, Types
type
   emeryturaPrzyszla = array[0..1] of Currency ; // brutto,netto
  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ComboBox1: TComboBox;
    Label18: TLabel;
    RadioGroup1: TRadioGroup;
    StringGrid2: TStringGrid;
    TabSheet5: TTabSheet;
    Timer1: TTimer;
    waloryzacjaDateTime: TDateTimePicker;
    emeryturaBruttoRokEdit: TEdit;
    emeryturaPodstawaEdit: TEdit;
    emeryturaBruttoEdit: TEdit;
    emeryturaNettoEdit: TEdit;
    Label13: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    SaveDialog1: TSaveDialog;
    wyslugaProcentEdit: TEdit;
    waloryzacjaPodstawaEdit: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    kwotaWolnaEdit: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lataEdit: TEdit;
    miesiaceEdit: TEdit;
    PageControl1: TPageControl;
    pensjaBruttoEdit: TEdit;
    podatekEdit: TEdit;
    podwyzkaBruttoEdit: TEdit;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    StringGrid1: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    waloryzacjaWyslugaEdit: TEdit;
    wyslugaEdit: TEdit;
    zdrowotnaEdit: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure RadioGroup1SelectionChanged(Sender: TObject);
  private
    komunikatBledu: string;

    lataSluzby,miesiaceSluzby: integer;
    pensjaBrutto,podwyzkaBrutto,podstawaEmerytury,podatekKwotaWolnaMiesiac,wyslugaProcent : currency;
    { TODO : doprowdzic aby zmienne byly niepotrzebne }
    skladkaZdrowotna,skladkaZdrowotnaProcent,podatekProcent,podatekKwota,podatekKwotaWolnaRok: currency;
    emeryturaBrutto,emeryturaNetto,emeryturaWaloryzcja: currency;

    emeryturaWaloryzcjaData: TDate;



    function sprawdzDane: boolean;
    function zapiszDane: boolean;
    procedure wyczyscDane;

    function wyliczProcent: currency;
    function wyliczProcent(lat: integer): currency;


    function wyliczPodstawe: currency;
    function wyliczEmerytureBruto: currency;
    function wyliczEmerytureBruto(procenty: single): currency;

    function wyliczPodatek: integer;
    function wyliczSkladkeZdrowotna: currency;
    function wyliczEmerytureNetto: currency;

    procedure wyliczEmeryture;

    procedure wypiszPrzyszleEmerytury;

    function wyliczPrzyszlaEmeryture(procenty: single): currency;
    function wyliczPrzyszleEmerytury(procenty: currency): emeryturaPrzyszla;


    function  szacujWaloryzacje: boolean;
    procedure szacujWaloryzacje(podstawa,wysluga:Currency);
    procedure wypiszWaloryzacje;

    function czytajWaloryzacje: boolean;

    procedure StatusKey(SBar: TStatusBar);


  public
    const
    waloryzacjaTabela: array[0..14,0..3] of String = (
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

   const podatkiTabela :array [0..6,0..4] of String = (
   ('2016','18','556,02','9','7,75'),
   ('2017','18','556,02','9','7,75'),
   ('2018','18','556,02','9','7,75'),
   ('2019','17,75','548,30','9','7,75'),
   ('2020','17','525,12','9','7,75'),
   ('2021','17','556,02','9','7,75'),
   ('2022','12','30000','9','0')
   );  // 0..6 (2016-2022) 0..4 (rok,podatek,kwota wolna,skaldkaZdrowotna,skaldkaZdrowotnaOdliczna
   function podatkiTabelaZnajdz(rok:string):integer;
   //const podatkiTabela :array [0..6,0..4] of Currency = (
   //(2016,18,556.02,9,7.75),
   //(2017,18,556.02,9,7.75),
   //(2018,18,556.02,9,7.75),
   //(2019,17.75,548.30,9,7.75),
   //(2020,17,525.12,9,7.75),
   //(2021,17,556.02,9,7.75),
   //(2022,12,30000,9,0)    // do sprawdzenia
   //);  // 0..6 (2016-2022) 0..4 (rok,podatek,kwota wolna,skaldkaZdrowotna,skaldkaZdrowotnaOdliczna
   //
   //

  end;

var
  Form1: TForm1;

implementation

uses unit2,unit3,VersionSupport,Windows,strutils;

{$R *.lfm}

{ TForm1 }




function TForm1.wyliczProcent: currency;
var
  procenty, procentyMiesiac: single;


begin

  procenty := 0;
  procentyMiesiac := 0;

  try
  procenty := strtoFloat(lataEdit.Text);
  except
   ShowMessage('Wprowadzono błędne dane ! ' + LineEnding + 'Liczba lat nieprawidłowa');
  end;

  try
  procentyMiesiac := strtoFloat(miesiaceEdit.Text);
  except
   ShowMessage('Wprowadzono błędne dane ! ' + LineEnding + 'Liczba miesięcy nieprawidłowa');
  end;

  if   procentyMiesiac > 11  then
       begin
         procentyMiesiac:=0;
         miesiaceEdit.Text:='0';
         ShowMessage('Wprowadzono błędne dane ! ' + LineEnding + 'Liczba miesięcy nieprawidłowa');

       end;

  if procenty < 15 then   procenty := 0

  else
      begin
      procentyMiesiac := procentyMiesiac * (2.6 / 12);
      procenty := procenty - 15;
      procenty := 40 + (procenty * 2.6) + procentyMiesiac;
      if procenty > 75 then  procenty := 75;

      end;

  Result := Round(procenty*100) / 100 ;
end;

function TForm1.wyliczProcent(lat: integer): currency;

var
  procenty: single;

begin

  procenty := 0;
  procenty := strtoFloat(lataEdit.Text) + lat;

  if procenty < 15 then
  begin
    procenty := 0;
  end
  else
  begin
    procenty := procenty - 15;
    procenty := 40 + (procenty * 2.6);
    if procenty > 75 then
      procenty := 75;
  end;

  Result := procenty;
end;


function TForm1.wyliczPodstawe: currency;
var
  pensja: single;
  trzynastka: integer;
begin
  pensja := 0;
  trzynastka := 0;


  pensja := strtoFloat(pensjaBruttoEdit.Text) +
    strtoFloat(podwyzkaBruttoEdit.Text);
  trzynastka := Round((pensja / 12) * 100);

  pensja := pensja * 100 + trzynastka;         //do sprawdzenia i przerobienia

  Result := Round(pensja) / 100;

end;

function TForm1.wyliczEmerytureBruto: currency;
var
  obliczenia: integer;

begin
  obliczenia := Round(podstawaEmerytury * wyslugaProcent);

  Result := obliczenia / 100;

end;

function TForm1.wyliczEmerytureBruto(procenty: single): currency;
var
  obliczenia: integer;

begin

  obliczenia := Round(podstawaEmerytury * procenty);

  Result := obliczenia / 100;

end;


function TForm1.wyliczPodatek: integer;
var
  kwotaWolna, kwotaPodatku: single;
   podatek:integer;
begin
  podatek:= StrToInt(podatekEdit.Text);
  kwotaWolna := (StrToInt(kwotaWolnaEdit.Text) * podatek ) / 1200;
  kwotaPodatku := emeryturaBrutto * podatek/ 100;
  Result := Round(kwotaPodatku - kwotaWolna);

end;

function TForm1.wyliczSkladkeZdrowotna: currency;
var
  obliczenia: integer;
begin
  obliczenia := Round(emeryturaBrutto * StrToInt(zdrowotnaEdit.Text));
  Result := obliczenia / 100;
end;

function TForm1.wyliczEmerytureNetto: currency;
begin

  if emeryturaBrutto = 0 then
    Result := 0
  else
    Result := emeryturaBrutto - podatekKwota - skladkaZdrowotna;
end;

//procedure TForm1.wyliczEmeryture;
//
//var   kwotaWolna: Currency;
//begin
//
//
//
//
//  podstawaEmerytury := wyliczPodstawe;
//
//
//  wyslugaProcent := wyliczProcent;
//  emeryturaBrutto := wyliczEmerytureBruto;
//
//  kwotaWolna  :=  Round (podatekKwotaWolnaRok   * podatekProcent);
//  podatekKwotaWolnaMiesiac  :=  kwotaWolna DIV 1200;
//  podatekKwota := wyliczPodatek;
//
//  skladkaZdrowotna := wyliczSkladkeZdrowotna;
//
//  emeryturaNetto := wyliczEmerytureNetto;
//
//  //if  emeryturaBrutto > 0 then
//  wyslugaProcentEdit.Text:=FloatToStr(wyslugaProcent);
//  emeryturaPodstawaEdit.Text:=FloatToStr(podstawaEmerytury);
//  emeryturaBruttoEdit.Text := FloatToStr(emeryturaBrutto);
//  emeryturaNettoEdit.Text := FloatToStr(emeryturaNetto);
//
//end;

procedure TForm1.wyliczEmeryture;

begin

  podstawaEmerytury      := unit2.wyliczPodstawe(pensjaBrutto,podwyzkaBrutto);    // wywolanie zakrytej funkcji
    if RadioGroup1.ItemIndex = 0 then  wyslugaProcent         := unit2.wyliczProcent(lataSluzby,miesiaceSluzby)
  else  ;
  emeryturaBrutto        := unit2.wyliczEmerytureBruto(podstawaEmerytury,wyslugaProcent);
  podatekKwotaWolnaMiesiac:=unit2.wyliczKwoteWolna(podatekProcent,podatekKwotaWolnaRok);   // zastanowic sie

  podatekKwota           := unit2.wyliczPodatek(emeryturaBrutto,podatekProcent,podatekKwotaWolnaMiesiac);
  skladkaZdrowotna       := unit2.wyliczSkladkeZdrowotna(emeryturaBrutto,skladkaZdrowotnaProcent);

  emeryturaNetto                := wyliczEmerytureNetto;
  wyslugaProcentEdit.Text       :=FloatToStr(wyslugaProcent);
  emeryturaPodstawaEdit.Text    :=FloatToStr(podstawaEmerytury);
  emeryturaBruttoEdit.Text      := FloatToStr(emeryturaBrutto);
  if (emeryturaBrutto*12) > 120000 then emeryturaBruttoRokEdit.Font.Color:= clRed
     else emeryturaBruttoRokEdit.Font.Color:=clBlack;
  emeryturaBruttoRokEdit.Text   := FloatToStr(emeryturaBrutto*12);
  emeryturaNettoEdit.Text       := FloatToStr(emeryturaNetto);


end;

function TForm1.wyliczPrzyszlaEmeryture(procenty: single): currency;

var
  skladka, podatek, brutto, netto: currency;

begin
  skladka := 0;
  podatek := 0;
  brutto := 0;
  netto := 0;

  brutto := wyliczEmerytureBruto(procenty);

  if brutto = 0 then netto := 0
  else
  begin
    skladka := Round(brutto * skladkaZdrowotnaProcent);
    skladka := skladka / 100;

    podatek := Round(brutto * podatekProcent);
    podatek := podatek / 100;
    podatek := Round(podatek - podatekKwotaWolnaMiesiac);
    // do poprawy

    netto := brutto - podatek - skladka;
  end;
  Result := netto;

end;

function TForm1.wyliczPrzyszleEmerytury(procenty: currency): emeryturaPrzyszla;   // czy podstawa

var
  skladka, podatek, brutto, netto: currency;
begin
  skladka := 0;
  podatek := 0;
  brutto := 0;
  netto := 0;


  brutto := Round(podstawaEmerytury * procenty);    //       podstawaEmerytury  - z glownych ustawien
  brutto := brutto / 100;

  if brutto = 0 then netto := 0
  else
                begin
                  skladka := Round(brutto * skladkaZdrowotnaProcent);     { TODO : rozne wersje opodatowania }
                  skladka := skladka / 100;

                  podatek := Round(brutto * podatekProcent);
                  podatek := podatek / 100;
                  podatek := Round(podatek - podatekKwotaWolnaMiesiac);

                  netto := brutto - podatek - skladka;
                end;

  //Result[0] := CurrToStr(procenty);
  Result[0] := brutto;
  Result[1] := netto;


  end;




procedure TForm1.wypiszPrzyszleEmerytury;
 var   wiersz, ostatniWiersz,licznik: integer;
   emerytura :  emeryturaPrzyszla  ;
   procenty:Currency;
 begin
  ostatniWiersz:=stringgrid2.RowCount-1;

  for wiersz:=0 to ostatniWiersz  do begin

                                     StringGrid2.Cells[1,wiersz] :=  '';
                                     StringGrid2.Cells[2,wiersz] :=  '';
                                     StringGrid2.Cells[3,wiersz] :=  '';
                                     StringGrid2.Cells[4,wiersz] :=  '';

                                     end;
   procenty := wyslugaProcent;

  for  licznik := 1 to 15 do
       begin
            if procenty = 0 then procenty := wyliczProcent(licznik)
            else
                begin
                  procenty := 2.6 + procenty;    // prog procentowy
                  if procenty > 75 then  procenty := 75;
                end;
       emerytura := wyliczPrzyszleEmerytury(procenty);

       StringGrid2.Cells[1,licznik] :=  CurrToStr(procenty);
       StringGrid2.Cells[2,licznik] :=  CurrToStr(emerytura[1]);
       StringGrid2.Cells[3,licznik] :=  CurrToStr(emerytura[0]);
       StringGrid2.Cells[4,licznik] :=  CurrToStr(emerytura[0] *12);
       end;




end;
function TForm1.sprawdzDane: boolean;
begin
  //przerobic ta funkcje
  if pensjaBruttoEdit.Text = '' then
  begin
    Result := False;
    komunikatBledu := 'Kwota pensji Brutto nieprawidłowa';
  end
  else if podwyzkaBruttoEdit.Text = '' then
  begin
    Result := False;
    komunikatBledu := 'Kwota podwyżki nieprawidłowa';
  end
  else if lataEdit.Text = '' then
  begin
    Result := False;
    komunikatBledu := 'Liczba lat nieprawidłowa';
  end
  else if miesiaceEdit.Text = '' then
  begin
    Result := False;
    komunikatBledu := 'Liczba miesięcy nieprawidłowa';
  end
  else
    Result := True;

end;

function TForm1.zapiszDane: boolean;   // do przemyslenia
begin
  Result := True;
  try
// do Brutto
  pensjaBrutto              :=StrToCurr(pensjaBruttoEdit.Text);
  podwyzkaBrutto            :=StrToCurr(podwyzkaBruttoEdit.text);

  if RadioGroup1.ItemIndex = 0    // sprawdzenie
     then begin
          lataSluzby                :=StrToInt(lataEdit.Text);
          miesiaceSluzby            :=StrToInt(miesiaceEdit.Text);
          end
   else begin
       wyslugaProcent               :=StrToInt(wyslugaEdit.Text);

   end;
//  do netto
  podatekProcent            :=StrToInt(podatekEdit.Text);
  skladkaZdrowotnaProcent   :=StrToInt(zdrowotnaEdit.Text);
  podatekKwotaWolnaRok      :=StrToInt(kwotaWolnaEdit.Text);

  except
  ShowMessage('Wprowadzono błędne dane ! ' + LineEnding + '');   { TODO : jak doprecyzowac }
  Result := False;
  end;


end;

procedure TForm1.wyczyscDane ;
begin
  podatekProcent             := 0;
  skladkaZdrowotnaProcent    := 0;
  podatekKwotaWolnaRok       := 0;
  podatekKwotaWolnaMiesiac   := 0;
  wyslugaProcent             := 0;
  podstawaEmerytury          := 0;
  podatekKwota               := 0;
  skladkaZdrowotna           := 0;
  emeryturaBrutto            := 0;
  emeryturaNetto             := 0;

end;




function TForm1.szacujWaloryzacje : Boolean   ;

var wiersz,ostatniWiersz  :integer;
   waloryzacja:currency;
begin
  ostatniWiersz:=stringgrid1.RowCount-1;
  for wiersz:=0 to ostatniWiersz  do StringGrid1.Cells[2,wiersz] :=  '';


  if czytajWaloryzacje
     then
         begin
           for wiersz:=StringGrid1.Cols[0].IndexOf(FormatDateTime('yyyy',emeryturaWaloryzcjaData)) to  ostatniWiersz do
           begin
                try
                waloryzacja:= StrToCurr( StringGrid1.Cells[1,wiersz]);
                except
                 ShowMessage('Wprowadzono błędne dane ! ' + LineEnding + 'Zły procent waloryzacji !');
                end;

           emeryturaWaloryzcja:= Round(emeryturaWaloryzcja*waloryzacja);
           emeryturaWaloryzcja:= emeryturaWaloryzcja /100 ;
           StringGrid1.Cells[2,wiersz] :=  CurrToStr(emeryturaWaloryzcja);
           end;





         result:=true;
         end
  else result:=false;
 ;
end;
procedure  TForm1.szacujWaloryzacje (podstawa,wysluga:Currency);

var wiersz,ostatniWiersz,indexRok  :integer;
   waloryzacjaRok : string;
   waloryzacja,waloryzacjaWysluga,waloryzcjaPodstawa,
   waloryzacjaEmerytura,waloryzacjaBrutto,
   waloryzacjaPodatek,waloryzacjaPodatekProcent,waloryzacjaKwotaWolnaRok, waloryzacjaKwotaWolnaMiesiac,
   waloryzacjaSkladka,waloryzacjaSkladkaOdliczana:currency;
begin

  waloryzacjaSkladkaOdliczana:=0;

  ostatniWiersz:=stringgrid1.RowCount-1;
  for wiersz:=0 to ostatniWiersz  do begin
                                     StringGrid1.Cells[2,wiersz] :=  '';
                                     StringGrid1.Cells[3,wiersz] :=  '';
                                     StringGrid1.Cells[4,wiersz] :=  '';
                                     StringGrid1.Cells[5,wiersz] :=  '';
                                     end;

  waloryzcjaPodstawa:= podstawa;
  waloryzacjaWysluga:= wysluga;

  if czytajWaloryzacje
     then
         begin
           for wiersz:=StringGrid1.Cols[0].IndexOf(FormatDateTime('yyyy',emeryturaWaloryzcjaData)) to  ostatniWiersz do
           begin
                try
                waloryzacja:= StrToCurr( StringGrid1.Cells[1,wiersz]);
                except
                 ShowMessage('Wprowadzono błędne dane ! ' + LineEnding + 'Zły procent waloryzacji !');
                end;

               waloryzcjaPodstawa          := Round(waloryzcjaPodstawa*waloryzacja);
               waloryzcjaPodstawa          := waloryzcjaPodstawa /100 ;
               StringGrid1.Cells[2,wiersz] := CurrToStr(waloryzcjaPodstawa);
               waloryzacjaBrutto           := unit2.wyliczEmerytureBruto(waloryzcjaPodstawa,waloryzacjaWysluga);
               StringGrid1.Cells[4,wiersz] := CurrToStr(waloryzacjaBrutto);

           // koloryzowanie brutto powyzej 120 000
               if (waloryzacjaBrutto*12) > 120000 then StringGrid1.Columns.Items[5].Font.Color := clRed
               else StringGrid1.Columns.Items[5].Font.Color:=clBlack;
               StringGrid1.Cells[5,wiersz] :=  CurrToStr(waloryzacjaBrutto*12);
           //StringGrid1.Columns.Items[5].Font.Color:=clBlack;
           waloryzacjaRok:= StringGrid1.Cells[0,wiersz];

           if podatkiTabelaZnajdz(waloryzacjaRok) >=0 then indexRok :=  podatkiTabelaZnajdz(waloryzacjaRok)
                 else indexRok := 6; // index domyslny dla 2022

           case  waloryzacjaRok  of

                 '2016','2017','2018','2019','2020','2021':
                                begin
                                waloryzacjaPodatekProcent:=StrToCurr(podatkiTabela[indexRok,1]);
                                waloryzacjaKwotaWolnaRok:=StrToCurr(podatkiTabela[indexRok,2]);
                                waloryzacjaKwotaWolnaMiesiac:= wyliczKwoteWolna(waloryzacjaPodatekProcent,waloryzacjaKwotaWolnaRok);

                                waloryzacjaSkladka   :=unit2.wyliczSkladkeZdrowotna(waloryzacjaBrutto,StrToCurr(form1.podatkiTabela[indexRok,3]));
                                waloryzacjaSkladkaOdliczana:=unit2.wyliczSkladkeZdrowotnaOdejmowana(waloryzacjaBrutto,StrToCurr(form1.podatkiTabela[indexRok,4]));
                                waloryzacjaPodatek   :=unit2.wyliczPodatek(waloryzacjaBrutto,waloryzacjaPodatekProcent,waloryzacjaKwotaWolnaMiesiac,waloryzacjaSkladkaOdliczana);

                                waloryzacjaEmerytura :=unit2.wyliczEmerytureNetto(waloryzacjaBrutto,waloryzacjaPodatek,waloryzacjaSkladka);

                               end;

                 '2022':        begin
                                waloryzacjaPodatekProcent:=StrToCurr(podatkiTabela[indexRok,1]);
                                waloryzacjaKwotaWolnaRok:=StrToCurr(podatkiTabela[indexRok,2]);
                                waloryzacjaKwotaWolnaMiesiac:= wyliczKwoteWolna(waloryzacjaPodatekProcent,waloryzacjaKwotaWolnaRok);
                                waloryzacjaPodatek:=unit2.wyliczPodatek(waloryzacjaBrutto,waloryzacjaPodatekProcent,waloryzacjaKwotaWolnaMiesiac);

                                waloryzacjaSkladka   :=unit2.wyliczSkladkeZdrowotna(waloryzacjaBrutto,StrToCurr(form1.podatkiTabela[indexRok,3]));
                                waloryzacjaEmerytura:=unit2.wyliczEmerytureNetto(waloryzacjaBrutto,waloryzacjaPodatek,waloryzacjaSkladka);
                                end;
                 else
                       begin
                                waloryzacjaPodatekProcent:=StrToCurr(podatkiTabela[indexRok,1]);
                                waloryzacjaKwotaWolnaRok:=StrToCurr(podatkiTabela[indexRok,2]);
                                waloryzacjaKwotaWolnaMiesiac:= wyliczKwoteWolna(waloryzacjaPodatekProcent,waloryzacjaKwotaWolnaRok);
                                waloryzacjaPodatek:=unit2.wyliczPodatek(waloryzacjaBrutto,waloryzacjaPodatekProcent,waloryzacjaKwotaWolnaMiesiac);

                                waloryzacjaSkladka   :=unit2.wyliczSkladkeZdrowotna(waloryzacjaBrutto,StrToCurr(form1.podatkiTabela[indexRok,3]));
                                waloryzacjaEmerytura:=unit2.wyliczEmerytureNetto(waloryzacjaBrutto,waloryzacjaPodatek,waloryzacjaSkladka);
                       //waloryzacjaPodatek:=unit2.wyliczPodatek(waloryzacjaBrutto,podatekProcent,podatekKwotaWolnaMiesiac);
                       //waloryzacjaSkladka:=unit2.wyliczSkladkeZdrowotna(waloryzacjaBrutto,skladkaZdrowotnaProcent);
                       //waloryzacjaEmerytura:=unit2.wyliczEmerytureNetto(waloryzacjaBrutto,waloryzacjaPodatek,waloryzacjaSkladka);
                       end;
                 end;
               StringGrid1.Cells[3,wiersz] :=  CurrToStr(waloryzacjaEmerytura);

           end;

         end
  else ;   // zastanowic sie
 ;
end;

procedure TForm1.wypiszWaloryzacje ;
var
  i :integer;
  begin
       StringGrid1.RowCount:=1;
      for i:= Low(waloryzacjaTabela) to High(waloryzacjaTabela) do  StringGrid1.InsertRowWithValues(StringGrid1.RowCount,waloryzacjaTabela[i]);
    end;

 function TForm1.czytajWaloryzacje: boolean;

   begin
     try
       emeryturaWaloryzcjaData:=waloryzacjaDateTime.DateTime;
       emeryturaWaloryzcja:= StrTocurr( waloryzacjaPodstawaEdit.text );
     except
       ShowMessage('Wprowadzono błędne dane ! ' + LineEnding + 'Zła kwota emerytury netto !');
     end;


     if emeryturaWaloryzcja > 0 then  Result:=true else Result:=False;

   end;



 function TForm1.podatkiTabelaZnajdz(rok:string):integer;

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


 procedure TForm1.StatusKey(SBar: TStatusBar);
var
  time : string;
begin
  if Odd(GetKeyState(VK_INSERT)) then
    SBar.Panels[2].Text := 'Ins'
  else
    SBar.Panels[2].Text := '';
  if Odd(GetKeyState(VK_CAPITAL)) then
    SBar.Panels[3].Text := 'Caps'
  else
    SBar.Panels[3].Text := '';
  if Odd(GetKeyState(VK_NUMLOCK)) then
    SBar.Panels[4].Text := 'Num'
  else
    SBar.Panels[4].Text := '';

  time := DateTimeToStr(Now);
  SBar.Panels[5].Text := Copy(time, 1, RPos(':',time)-1);
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
  if sprawdzDane then
  begin
    wyczyscDane;
    zapiszDane;
    wyliczEmeryture;
    wypiszPrzyszleEmerytury; //
  end

  else
    ShowMessage('Wprowadzono błędne dane ! ' + LineEnding + komunikatBledu);
end;

procedure TForm1.Button2Click(Sender: TObject);
var waloryzacjaPodstawa,waloryzacjaProcent:Currency;
begin
 // szacujWaloryzacje;
   try
    waloryzacjaPodstawa:=StrTocurr(waloryzacjaPodstawaEdit.Text);
    waloryzacjaProcent:= StrTocurr(waloryzacjaWyslugaEdit.Text)
   except
   ShowMessage('Wprowadzono błędne dane ! ' +LineEnding+ ' Podstawa emerytury lub procent emerytury błedne!');
   end;

  szacujWaloryzacje(waloryzacjaPodstawa,waloryzacjaProcent);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  PageControl1.TabIndex := 2;
  waloryzacjaPodstawaEdit.Text:=emeryturaPodstawaEdit.Text;
  waloryzacjaWyslugaEdit.Text:=wyslugaProcentEdit.Text;
  waloryzacjaDateTime.Date:=Now;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PageControl1.TabIndex := 0;
  StatusBar1.Panels.Items[0].Text:='Emerytura wersja: '+GetFileVersion;
  //ustawWaloryzacje;
  wypiszWaloryzacje;
  StatusKey(StatusBar1);
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
   StatusKey(StatusBar1);
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
     SaveDialog1.FileName:='waloryzacja.csv';
     if SaveDialog1.Execute then  StringGrid1.SaveToCSVFile(SaveDialog1.Filename,';',true)
     else  ShowMessage('Nie wybrano pliku!');
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
      SaveDialog1.FileName:='emerytury.csv';
     if SaveDialog1.Execute then StringGrid2.SaveToCSVFile(SaveDialog1.Filename,';',true)
     else  ShowMessage('Nie wybrano pliku!');
end;

procedure TForm1.RadioGroup1SelectionChanged(Sender: TObject);
begin
    if  RadioGroup1.ItemIndex = 0
       then begin
            lataEdit.Enabled:=true;
            miesiaceEdit.Enabled:=true;
            wyslugaEdit.Enabled:=false;
            end
       else begin
            lataEdit.Enabled:=false;
            miesiaceEdit.Enabled:=false;
            wyslugaEdit.Enabled:=true;
            end  ;
end;

end.
