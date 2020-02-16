unit gTypesU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
TSearchEngine  = (seGramota, seSynonyms, seMorphology, seInterpretation, seQuote, seWiki, seYandex, seBigEnc);
TResultType    = (rtHTML, rtURL);
TCodePages     = (cpUTF8, cp1251);
implementation

end.

