unit gStringsU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

resourcestring
  TemplateDirectory               = 'templates';
  HelpDirectory                   = 'help';

  HelpFileName                    = 'help.html';
  TemplateFilename                = 'result.html';


  WikiURL                         = 'https://ru.m.wikipedia.org/w/index.php?search=%s';
  BigEncURL                       = 'https://bigenc.ru/search?q=%s';
  YandexURL                       = 'https://yandex.ru/search/?text=%s';

  GramotaURL                      = 'http://gramota.ru/slovari/dic/?lop=x&bts=x&word=%s';
  GramotaServerRoot               = 'http://gramota.ru/';
  GramotaBlockStart               = '</form>';
  GramotaBlockEnd                 = '<div class="clear"></div>';

  SynonymsURL                     = 'https://scanwordbase.ru/synonyms-search.php?search_words=%s';
  SynonymsSrvRoot                 = 'https://scanwordbase.ru';
  SynonymsBlockStart              = '<table class="table table-striped">';
  SynonymsBlockEnd                = '<h4>';

  MorphologyURL                 = 'http://www.morfologija.ru/словоформа/%s';
  MorphologySrvRoot             = 'http://www.morfologija.ru/';
  MorphologyBlockStart          = '<div id="printMe">';
  MorphologyBlockEnd            = '<div id="bottom">';

  InterpretationURL             = 'https://kartaslov.ru/значение-слова/%s';
  InterpretationSrvRoot         = 'https://kartaslov.ru/';
  InterpretationBlockStart      = '<div class="v2-dict-entry">';
  InterpretationBlockEnd        = '<div class="v2-p-mob-inarticle-block">';

  ClipboardIsEmptyRu              = 'Буфер обмена пуст!';
  strExceptionThreadURLIsEmptyRu  = 'Пустая ссылка!';

implementation

end.

