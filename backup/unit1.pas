unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Menus, ExtCtrls, ValEdit, ExtDlgs, Grids, DateTimePicker, Types;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    DateTimePicker1: TDateTimePicker;
    emeryturaPodstawaEdit: TEdit;
    emeryturaBruttoEdit: TEdit;
    emeryturaNettoEdit: TEdit;
    emeryturaSzacunek: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    kwotaWolnaEdit: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lataEdit: TEdit;
    Memo1: TMemo;
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
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    ValueListEditor1: TValueListEditor;
    zdrowotnaEdit: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure StatusBar1CreatePanelClass(Sender: TStatusBar;
      var PanelClass: TStatusPanelClass);
    procedure TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private
    komunikatBledu: string;

    podatekProcent, skladkaZdrowotnaProcent: integer;
    wyslugaProcent: single;
    podstawaEmerytury, podatekKwotaWolna: currency;
    podatekKwota, skladkaZdrowotna, emeryturaBrutto, emeryturaNetto: currency;

    function sprawdzDane: boolean;
    function zapiszDane: boolean;
    function wyczyscDane: boolean;

    function wyliczProcent: single;
    function wyliczProcent(lat: integer): single;


    function wyliczPodstawe: currency;
    function wyliczEmerytureBruto: currency;
    function wyliczEmerytureBruto(procenty: single): currency;

    function wyliczPodatek: integer;
    function wyliczSkladkeZdrowotna: currency;
    function wyliczEmerytureNetto: currency;

    function wyliczEmeryture: boolean;

    function wyliczPrzyszleEmerytury: boolean;
    function wyliczPrzyszlaEmeryture(procenty: single): currency;

    function szacujWaloryzacje: boolean;

  public


  end;

var
  Form1: TForm1;

implementation

uses unit3,VersionSupport;

{$R *.lfm}

{ TForm1 }




function TForm1.wyliczProcent: single;
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
  Result := procenty;
end;

function TForm1.wyliczProcent(lat: integer): single;

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

begin

  kwotaWolna := StrToInt(kwotaWolnaEdit.Text) / 12;
  kwotaPodatku := emeryturaBrutto * StrToInt(podatekEdit.Text) / 100;
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

function TForm1.wyliczEmeryture: boolean;

var
  podatek, zdrowotna: currency;

begin

  podstawaEmerytury := wyliczPodstawe;
  emeryturaBrutto := wyliczEmerytureBruto;
  podatekKwota := wyliczPodatek;
  skladkaZdrowotna := wyliczSkladkeZdrowotna;

  emeryturaNetto := wyliczEmerytureNetto;

  if  emeryturaBrutto > 0 then  emeryturaPodstawaEdit.Text:=FloatToStr(podstawaEmerytury);
  emeryturaBruttoEdit.Text := FloatToStr(emeryturaBrutto);
  emeryturaNettoEdit.Text := FloatToStr(emeryturaNetto);
  with Memo1.Lines do
  begin
    Clear;
    Add('Wyliczona podstawaa : ' + FloatToStr(podstawaEmerytury) + LineEnding);
    Add('Wyliczony procent : ' + FloatToStr(wyslugaProcent) + LineEnding);
    Add('Emerytura Brutto : ' + FloatToStr(emeryturaBrutto) + LineEnding);
    Add('Wyliczony podatek : ' + FloatToStr(podatek) + LineEnding);
    Add('Wyliczona skłądka zdrowotna : ' + FloatToStr(zdrowotna) + LineEnding);
    Add('Emerytura Netto : ' + FloatToStr(emeryturaNetto) + LineEnding);
  end;

  Result := True;
end;

function TForm1.wyliczPrzyszlaEmeryture(procenty: single): currency;

var //obliczenia :integer;
  skladka, podatek, brutto, netto: currency;

begin
  skladka := 0;
  podatek := 0;
  brutto := 0;
  netto := 0;

  brutto := wyliczEmerytureBruto(procenty);

  if brutto = 0 then
    netto := 0

  else
  begin
    skladka := Round(brutto * skladkaZdrowotnaProcent);
    skladka := skladka / 100;

    podatek := Round(brutto * podatekProcent);
    podatek := podatek / 100;
    podatek := Round(podatek - podatekKwotaWolna);
    // do poprawy

    netto := brutto - podatek - skladka;
  end;
  Result := netto;

end;

function TForm1.wyliczPrzyszleEmerytury: boolean;

var
  licznik, pozycja, koniec: integer;
  procenty: single;
  emerytura: currency;
  obrobka: string;

  //  liczy dla kwot emerytury netto
begin
  procenty := wyslugaProcent;    // zaokraglenia procentow

  for  licznik := 1 to 15 do
  begin
    if procenty = 0 then
      procenty := wyliczProcent(licznik)
    else
    begin
      procenty := 2.6 + procenty;    // prog procentowy
      if procenty > 75 then
        procenty := 75;
    end;


    emerytura := wyliczPrzyszlaEmeryture(procenty);

    obrobka := ValueListEditor1.Strings[licznik - 1];
    pozycja := pos('=', obrobka) + 1;
    koniec := obrobka.Length;
    Delete(obrobka, pozycja, koniec);

    ValueListEditor1.Strings[licznik - 1] := obrobka + CurrToStr(emerytura);
    //     problem przy wypisywaniu przyszlych emerytur ponownie

  end;


  Result := True;
end;


function TForm1.sprawdzDane: boolean;
begin

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

function TForm1.zapiszDane: boolean;
begin
  podatekProcent := StrToInt(podatekEdit.Text);
  skladkaZdrowotnaProcent := StrToInt(zdrowotnaEdit.Text);
  podatekKwotaWolna := StrToInt(kwotaWolnaEdit.Text) / 12;

  wyslugaProcent := wyliczProcent;

  Result := True;
end;

function TForm1.wyczyscDane: boolean;
begin
  podatekProcent := 0;
  skladkaZdrowotnaProcent := 0;
  podatekKwotaWolna := 0;
  wyslugaProcent := 0;
  podstawaEmerytury := 0;
  podatekKwotaWolna := 0;
  podatekKwota := 0;
  skladkaZdrowotna := 0;
  emeryturaBrutto := 0;
  emeryturaNetto := 0;


  Result := True;
end;




function TForm1.szacujWaloryzacje : Boolean   ;

var
  i,ile :integer;


// 2016;100,24;
//2017;100,44;
//2018;102,98;
//2019;102,86;
//2020;103,56;
//2021;107,00;
//2022;113,80;
begin
  ile := 2;






  StringGrid1.RowCount:=1;
  for i:= 0 to ile do  StringGrid1.InsertRowWithValues(StringGrid1.RowCount,['2016','100.24','0']);





  //StringGrid1.InsertRowWithValues();
 //with StringGrid1 do
 //
 //begin
 //  InsertRowWithValues(RowCount,tabela);
 //end
 //

 //          StringGrid1.RowCount := 1;
 //for i := 0 to 6  do
 //      with StringGrid1 do
 //
 //           begin
 //
 //             InsertRowWithValues(RowCount,wiersz);
 //           end

 result:=true;
end;








procedure TForm1.Button1Click(Sender: TObject);
begin
  if sprawdzDane then
  begin
    wyczyscDane;
    zapiszDane;
    wyliczEmeryture;
    wyliczPrzyszleEmerytury;

  end

  else
    ShowMessage('Wprowadzono błędne dane ! ' + LineEnding + komunikatBledu);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   szacujWaloryzacje;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PageControl1.TabIndex := 0;
  StatusBar1.Panels.Items[0].Text:='Emerytura wersja: '+GetFileVersion;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.StatusBar1CreatePanelClass(Sender: TStatusBar;
  var PanelClass: TStatusPanelClass);
begin

end;

procedure TForm1.TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

end.
