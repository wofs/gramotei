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

  GramotaURL                      = 'http://gramota.ru/slovari/dic/?word=%s&all=x';
  GramotaServerRoot               = 'http://gramota.ru/';
  GramotaBlockStart               = '</form>';
  GramotaBlockEnd                 = '<div class="clear"></div>';

  SynonimsURL                 = 'https://scanwordbase.ru/synonyms-search.php?search_words=%s';
  SynonimsSrvRoot             = 'https://scanwordbase.ru';
  SynonimsBlockStart          = '<table class="table table-striped">';
  SynonimsBlockEnd            = '<h4>';

  ClipboardIsEmptyRu              = 'Буфер обмена пуст!';
  strExceptionThreadURLIsEmptyRu  = 'Пустая ссылка!';

implementation

end.

