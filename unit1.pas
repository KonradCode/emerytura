unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Menus,
  StdCtrls, ExtCtrls, Grids, DateTimePicker, podstawa, podatki
  , emerytura, wysluga;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonOblicz: TButton;
    ButtonObliczWaloryzacje: TButton;
    ButtonWaloryzacja: TButton;
    ButtonWyliczWysluge: TButton;
    ButtonWyczysc: TButton;
    CheckBox32Lata: TCheckBox;
    EditEmeryturaBrutto: TEdit;
    EditEmeryturaBruttoRok: TEdit;
    GroupBox5: TGroupBox;
    Label19: TLabel;
    Label21: TLabel;
    ComboBoxPodatekRok: TComboBox;
    EditEmeryturaNetto: TEdit;
    EditEmeryturaPodstawa: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label2: TLabel;
    Label15plus: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    PageControl1: TPageControl;
    EditPensjaBrutto: TEdit;
    EditKwota15plus: TEdit;
    EditPodwyzkaBrutto: TEdit;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    StringGridWaloryzacja: TStringGrid;
    StringGridPrzyszleEmerytury: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet5: TTabSheet;
    Timer1: TTimer;
    DateTimeWaloryzacja: TDateTimePicker;
    EditWaloryzacjaPodstawa: TEdit;
    EditWaloryzacjaWysluga: TEdit;
    EditWysluga: TEdit;
    EditWyslugaProcent: TEdit;
    procedure ButtonObliczWaloryzacjeClick(Sender: TObject);
    procedure ButtonWaloryzacjaClick(Sender: TObject);
    procedure ButtonOblicz1Click(Sender: TObject);
    procedure ButtonObliczClick(Sender: TObject);
    procedure ButtonWyliczWyslugeClick(Sender: TObject);
    procedure ButtonWyczyscClick(Sender: TObject);
    procedure CheckBox32LataChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure EditWyslugaProcentChange(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure ComboBoxPodatekRokChange(Sender: TObject);
  private
    //const ;  { #todo -oja : Wtrowadzic stałe zamiast cyfr }


    procedure wypiszWaloryzacje;
    procedure WyczyscDaneWejsciowe;
    procedure WyczyscObliczeniaWyswietlane;
    procedure WyczyscObliczeniaWykonane;
    procedure WyczyscWszystkieDane;
    procedure WyczyscPrzyszleEmerytury;
    procedure WyczyscWaloryzacje;
    procedure WyczyscPodatek;
    procedure ObliczEmeryture;
    procedure ObliczPrzyszleEmerytury;
    function ObliczEmerytureNetto: currency;
    function ObliczEmerytureNetto(emeryturaBrutto, emeryturaBruttoRok: currency): currency;
    // funkcja dla przyszlych wyliczen
    function SprawdzWymaganeDane: boolean;
    function SprawdzWyliczeniaBrutto: boolean;
    function SumujDochoody(): currency;
    procedure SzacujWaloryzacje;




  public
    // zeby bylo widoczne w innych modulach
    fProcenty: currency;
    fEmeryturaBrutto, fEmeryturaBruttoRok: currency;  // czy to potrzebne


    fPodstawa: Tpodstawa;
    FWysluga: TwyslugaGTP;

    FEmerytura: TEmerytura;
    FPodatek: TPodatek;



  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses Unit2, unit3;

{ TForm1 }

function TForm1.SprawdzWymaganeDane: boolean;
var
  KomunikatyBledow: string;
begin
  KomunikatyBledow := '';

  // Sprawdzamy pole EditPensjaBrutto
  if StrToCurr(EditPensjaBrutto.Text) <= 0 then
    KomunikatyBledow := KomunikatyBledow +
      'Wartość w polu "Pensja Brutto" musi być większa od 0.'#13;

  // Sprawdzamy pole EditPodwyzkaBrutto
  if StrToCurr(EditPodwyzkaBrutto.Text) < 0 then
    KomunikatyBledow := KomunikatyBledow +
      'Wartość w polu "Podwyżka Brutto" nie może być mniejsza niż 0.'#13;

  // Sprawdzamy pole EditKwota15plus
  if StrToCurr(EditKwota15plus.Text) < 0 then
    KomunikatyBledow := KomunikatyBledow +
      'Wartość w polu "Kwota 15+" nie może być mniejsza niż 0.'#13;

  // Sprawdzamy pole EditWysluga
  if (StrToCurr(EditWysluga.Text) < 0) or (StrToCurr(EditWysluga.Text) > 80) then
    KomunikatyBledow := KomunikatyBledow +
      'Wartość w polu "Wysługa" musi mieścić sie między 0 a 80.'#13;

  // Sprawdzamy, czy były błędy
  if KomunikatyBledow <> '' then
  begin
    ShowMessage('Wystąpiły następujące błędy:'#13 + KomunikatyBledow);
    Result := False;
  end
  else
    Result := True;
end;

function TForm1.SprawdzWyliczeniaBrutto: boolean;
var
  KomunikatyBledow: string = '';
begin
  if fEmeryturaBrutto < 0 then
    KomunikatyBledow := KomunikatyBledow + 'Błąd w "Emerytura Brutto".'#13;

  if fEmeryturaBruttoRok < 0 then
    KomunikatyBledow := KomunikatyBledow +
      'Błąd w "Emerytura Brutto w skali roku".'#13;


  if KomunikatyBledow <> '' then
  begin
    ShowMessage('Wystąpiły następujące błędy:'#13 + KomunikatyBledow);
    Result := False;
  end
  else
    Result := True;

end;



function TForm1.SumujDochoody(): currency;

var
  dochody, pensja, podwyzka, dodatek15: currency;
begin
  dochody := 0;
  pensja := 0;
  podwyzka := 0;
  dodatek15 := 0;
  pensja := StrToCurr(EditPensjaBrutto.Text);
  podwyzka := StrToCurr(EditPodwyzkaBrutto.Text);
  // dodatek15 := StrToCurr(EditKwota15plus.Text);

  if CheckBox32Lata.Enabled then dochody := pensja + podwyzka + dodatek15
  else
    dochody := pensja + podwyzka;

  Result := dochody;
end;

procedure TForm1.SzacujWaloryzacje;

var

  podstawa, wysluga, emeryturaBrutto, emeryturaBruttoRok, emeryturaNetto,
  naleznosciMiesiac: currency;
  rok: string;
  waloryzacje: array of array of string;
  i, rekordBiezacy: integer;
begin
  // odczyt danych
  try
    podstawa := StrTocurr(EditwaloryzacjaPodstawa.Text);
    wysluga := StrTocurr(EditwaloryzacjaWysluga.Text);
    rok := FormatDateTime('yyyy', DateTimeWaloryzacja.Date);
  except
    ShowMessage('Wprowadzono błędne dane ! ' + LineEnding +
      ' Podstawa emerytury lub procent emerytury błedne!');
    Exit;
  end;

  //czyszczenie danych wyswietlanych
  StringGridWaloryzacja.RowCount := 1;

  waloryzacje := fPodstawa.WyliczWaloryzacje(podstawa, rok);

  for i := Low(waloryzacje) to High(waloryzacje) do
  begin

    podstawa := strtocurr(waloryzacje[i][2]);
    emeryturaBrutto := FEmerytura.WyliczEmerytureBrutto(podstawa, wysluga);
    emeryturaBruttoRok := FEmerytura.WypiszEmerytureBruttoRok;

    naleznosciMiesiac := FPodatek.ObliczNaleznosciMiesiacGPT(
      emeryturaBrutto, emeryturaBruttoRok, rok);
    emeryturaNetto := emeryturaBrutto - naleznosciMiesiac;
    rekordBiezacy := StringGridWaloryzacja.RowCount;


    StringGridWaloryzacja.InsertRowWithValues(rekordBiezacy, waloryzacje[i]);
    StringGridWaloryzacja.Cells[3, rekordBiezacy] := CurrToStr(emeryturaBrutto);
    StringGridWaloryzacja.Cells[4, rekordBiezacy] := CurrToStr(emeryturaNetto);
    StringGridWaloryzacja.Cells[5, rekordBiezacy] := CurrToStr(emeryturaBruttoRok);
  end;

end;

procedure TForm1.WyczyscDaneWejsciowe;
begin
  //czyszczenie
  EditPensjaBrutto.Text := '0';
  EditPodwyzkaBrutto.Text := '0';
  EditKwota15plus.Text := '0';
  CheckBox32Lata.Enabled := False;
  ObliczanieWyslugiForm.EditLata.Text := '0';
  ObliczanieWyslugiForm.EditMiesiace.Text := '0';
end;

procedure TForm1.WyczyscObliczeniaWyswietlane;
begin
  //wyliczenia
  EditEmeryturaPodstawa.Text := '0';
  EditWysluga.Text := '0';
  EditWyslugaProcent.Text := '0';
  EditEmeryturaBrutto.Text := '0';
  EditEmeryturaBruttoRok.Text := '0';
  EditEmeryturaNetto.Text := '0';
  //ComboBoxPodatekRok;
end;

procedure TForm1.WyczyscObliczeniaWykonane;
begin
  // czyszczenie pol
  fEmeryturaBrutto := 0;
  fEmeryturaBruttoRok := 0;
  fProcenty := 0;


  // czyszczenie obiektow
  fPodstawa.Clear();
  fWysluga.Clear();
  fEmerytura.Clear;
  fPodatek.Clear;
end;

procedure TForm1.WyczyscWszystkieDane;
begin
  // wyczyśc wszystkie dane
  WyczyscDaneWejsciowe;
  WyczyscObliczeniaWyswietlane;
  WyczyscObliczeniaWykonane;
  WyczyscPrzyszleEmerytury;
  WyczyscWaloryzacje;

end;

procedure TForm1.WyczyscPrzyszleEmerytury;
var
  wiersz, ostatniWiersz: integer;
begin

  ostatniWiersz := StringGridPrzyszleEmerytury.RowCount - 1;
  for wiersz := 1 to ostatniWiersz do
  begin

    StringGridPrzyszleEmerytury.Cells[1, wiersz] := '';
    StringGridPrzyszleEmerytury.Cells[2, wiersz] := '';
    StringGridPrzyszleEmerytury.Cells[3, wiersz] := '';
    StringGridPrzyszleEmerytury.Cells[4, wiersz] := '';

  end;
end;

procedure TForm1.WyczyscWaloryzacje;
begin
    StringGridWaloryzacja.RowCount := 1;
    EditWaloryzacjaPodstawa.Clear;
    EditWaloryzacjaWysluga.Clear;
    DateTimeWaloryzacja.Date:=Now;
end;

procedure TForm1.WyczyscPodatek;
begin
  ComboBoxPodatekRok.Clear;
end;


procedure TForm1.ButtonWyliczWyslugeClick(Sender: TObject);
begin
  ObliczanieWyslugiForm.Show;
end;

procedure TForm1.ButtonWyczyscClick(Sender: TObject);
begin
  WyczyscWszystkieDane;
end;


procedure TForm1.CheckBox32LataChange(Sender: TObject);
begin
  if CheckBox32Lata.Checked then
  begin
    Label15plus.Enabled := True;
    EditKwota15plus.Enabled := True;
  end
  else
  begin
    Label15plus.Enabled := False;
    EditKwota15plus.Enabled := False;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // tworzenie objektów

  FPodatek := TPodatek.Create; // podatek
  fPodstawa := Tpodstawa.Create;
  FWysluga := TwyslugaGTP.Create;
  FEmerytura := TEmerytura.Create;

  // waloryzacjaEmeryturyObj:=Twaloryzacje.Create;
  // uruchamianie dzialań przy starcie aplikacji
  // wypiszWaloryzacje;

end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.EditWyslugaProcentChange(Sender: TObject);
begin

end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  Form3.Show;
end;

procedure TForm1.ComboBoxPodatekRokChange(Sender: TObject);
begin
  //przy zmianie powinno zmieniac wyliczenia
  EditEmeryturaNetto.Text := CurrToStr(ObliczEmerytureNetto);
end;

procedure TForm1.wypiszWaloryzacje;       // czy potrzebne do zmiany
var
  i: integer;

begin
  StringGridWaloryzacja.RowCount := 1;
  for i := Low(fPodstawa.TABELA_WALORYZACJI) to High(fPodstawa.TABELA_WALORYZACJI) do
    StringGridWaloryzacja.InsertRowWithValues(StringGridWaloryzacja.RowCount,
      fPodstawa.TABELA_WALORYZACJI[i]);

end;

procedure TForm1.ButtonOblicz1Click(Sender: TObject);
begin

end;

procedure TForm1.ButtonWaloryzacjaClick(Sender: TObject);
begin
  PageControl1.TabIndex := 2;
  EditWaloryzacjaPodstawa.Text := EditEmeryturaPodstawa.Text;
  EditWaloryzacjaWysluga.Text := EditWyslugaProcent.Text;
  DateTimewaloryzacja.Date := Now;
end;

procedure TForm1.ButtonObliczWaloryzacjeClick(Sender: TObject);
begin
  SzacujWaloryzacje;
end;

procedure TForm1.ButtonObliczClick(Sender: TObject);

begin

  ObliczEmeryture;
  ObliczPrzyszleEmerytury;

end;

procedure TForm1.ObliczEmeryture;

var
  podstawa, dochody: currency;
begin
  //WyczyscObliczeniaWykonane;
  if not SprawdzWymaganeDane then exit;

  dochody := StrToCurr(EditPensjaBrutto.Text);
  dochody := dochody + StrToCurr(EditPodwyzkaBrutto.Text);

  FWysluga.UstawWyslugeStr(EditWysluga.Text);


  // obliczenia
  if CheckBox32Lata.Enabled then
  begin
    podstawa := fPodstawa.wyliczPodstawe(dochody, StrToCurr(EditKwota15plus.Text));
  end
  else
  begin
    podstawa := fPodstawa.wyliczPodstawe(dochody, 0);
  end;
  //podstawa:= fPodstawa.wyliczPodstawe(SumujDochoody,);  //nie sumuje sie dodatku do trzynastki




  fEmeryturaBrutto := FEmerytura.WyliczEmerytureBrutto(podstawa, FWysluga.wypisz);
  fEmeryturaBruttoRok := FEmerytura.WypiszEmerytureBruttoRok;


  //wyswietlanie
  EditEmeryturaPodstawa.Text := CurrToStr(podstawa);
  EditWyslugaProcent.Text := EditWysluga.Text;
  EditEmeryturaBrutto.Text := CurrToStr(femeryturaBrutto);
  EditEmeryturaBruttoRok.Text := CurrToStr(femeryturaBruttoRok);
  EditEmeryturaNetto.Text := CurrToStr(ObliczEmerytureNetto);

end;

procedure TForm1.ObliczPrzyszleEmerytury;

var
  podstawa, procenty, emeryturaBrutto, emeryturaBruttoRok, emeryturaNetto: currency;
  wiersz, ostatniWiersz: integer;
begin

  WyczyscPrzyszleEmerytury;

  ostatniWiersz := StringGridPrzyszleEmerytury.RowCount - 1;
  for wiersz := 1 to ostatniWiersz do
  begin
    procenty := FWysluga.WypiszWyslugeZaRok(wiersz - 1);
    // wiersz  o w stringgird to kolumna
    podstawa := fPodstawa.fPodstawa;
    emeryturaBrutto := FEmerytura.WyliczEmerytureBrutto(podstawa, procenty);
    emeryturaBruttoRok := emeryturaBrutto * 12;
    emeryturaNetto := ObliczEmerytureNetto(emeryturaBrutto, emeryturaBruttoRok);


    StringGridPrzyszleEmerytury.Cells[1, wiersz] := CurrToStr(procenty);
    StringGridPrzyszleEmerytury.Cells[2, wiersz] := CurrToStr(emeryturaNetto);
    StringGridPrzyszleEmerytury.Cells[3, wiersz] := CurrToStr(emeryturaBrutto);
    StringGridPrzyszleEmerytury.Cells[4, wiersz] := CurrToStr(emeryturaBruttoRok);

  end;

end;

function TForm1.ObliczEmerytureNetto: currency;

var
  naleznosciMiesiac, emeryturaNetto: currency;
begin
  //SprawdzWyliczeniaBrutto;
  naleznosciMiesiac := FPodatek.ObliczNaleznosciMiesiacGPT(
    fEmeryturaBrutto, fEmeryturaBruttoRok, ComboBoxPodatekRok.Text);
  //naleznosciMiesiac:=FPodatek.ObliczNaleznosciMiesiac(emeryturaBrutto,emeryturaBruttoRok);
  emeryturaNetto := fEmeryturaBrutto - naleznosciMiesiac;
  Result := emeryturaNetto;
end;

function TForm1.ObliczEmerytureNetto(
  emeryturaBrutto, emeryturaBruttoRok: currency): currency;

var
  naleznosciMiesiac, emeryturaNetto: currency;
begin
  naleznosciMiesiac := FPodatek.ObliczNaleznosciMiesiacGPT(
    emeryturaBrutto, emeryturaBruttoRok, ComboBoxPodatekRok.Text);
  emeryturaNetto := emeryturaBrutto - naleznosciMiesiac;
  Result := emeryturaNetto;
end;




end.
