program gramotei;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, FmMainU, FmAboutU, TGramoteiU, gStringsU, gTypesU, gStringUtilsU;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFmMain, FmMain);
  Application.CreateForm(TFmAbout, FmAbout);
  Application.Run;
end.

