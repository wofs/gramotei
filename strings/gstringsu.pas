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
  URLMultitran                    = 'https://www.multitran.com/m.exe?l1=2&l2=2&s=%s';
  URLWiki                         = 'https://ru.m.wikipedia.org/w/index.php?search=%s';
  URLBigEnc                       = 'https://bigenc.ru/search?q=%s';
  URLYandex                       = 'https://yandex.ru/search/?text=%s';

  GramotaServerRoot               = 'http://gramota.ru/';
  GramotaBlockStart               = '</form>';
  GramotaBlockEnd                 = '<div class="clear"></div>';

  MultitranServerRoot             = 'https://www.multitran.com/';
  MultitranBlockStart             = '</form>';
  MultitranBlockEnd               = '<!--<p';

  ClipboardIsEmptyRu              = 'Буфер обмена пуст!';
  strExceptionThreadURLIsEmptyRu  = 'Пустая ссылка!';

implementation

end.

