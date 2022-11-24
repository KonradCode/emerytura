program emerytura;

{$mode objfpc}{$H+}


uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, Unit1, Unit3, VersionSupport,
  Unit2, emerytura.newobj, emerytura.tobject
  { you can add units after this };

{$R *.res}


begin

  
{$if declared(UseHeapTrace)}
GlobalSkipIfNoLeaks := True; // wylacza info o wyciekach pamieci gdy ich nie ma
{$endIf}

  RequireDerivedFormResource:=True;
  Application.Title:='Emerytura';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.

