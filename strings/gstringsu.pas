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

  URLGramota                      = 'http://gramota.ru/slovari/dic/?word=%s&all=x';
  URLWiki                         = 'https://ru.m.wikipedia.org/w/index.php?search=%s';
  URLBigEnc                       = 'https://bigenc.ru/search?q=%s';
  URLYandex                       = 'https://yandex.ru/search/?text=%s';

  GramotaBlockStart               = '</form>';
  GramotaBlockEnd                 = '<div class="clear"></div>';

  ClipboardIsEmptyRu              = 'Буфер обмена пуст!';
  strExceptionThreadURLIsEmptyRu  = 'Пустая ссылка!';

implementation

end.

