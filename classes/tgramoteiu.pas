unit TGramoteiU;

{$mode objfpc}{$H+}
{$ModeSwitch nestedprocvars}

interface

uses
  Classes, SysUtils, gStringsU, wGetU, gTypesU, gStringUtilsU, LazUTF8, LConvEncoding;

type
  TGramotei = class;

  TRequestEvent = procedure(Sender: TGramotei; aKeyWord, aResult:string; aResultType:TResultType) of object;

  { TGramotei }
  // Грамотей. Базовый класс
  TGramotei = class (TObject)
    private
      fKeyWord: String;
       fonEndRequest: TRequestEvent;
       fonStartRequest: TNotifyEvent;
       fCurrentPath: string;
       fSearchEngine: TSearchEngine;
       fCurrentURL: string;
       fwGet: TwGet;

       // Процедура обработки результатов выполнения запроса из сети интернет
       function ClearLink(aSourceText: string): string;
       // Выборка данных из сети. Запускается как параллельная процедура.
       procedure DataFromURL(aURL: string; aCodePage: TCodePages);

       // Возвращает блок строк с информацией
       function GetReplyBlock(aSourceText: string): string;
       //Шаблонизатор. Вставляет aSourceText в файл шаблона.
       function GetTemplatedText(aSourceText: string; const ClearLinks: boolean=false): string;
       // Возвращает ссылку на шаблог
       function GetTemplateLink: string;
       //Возвращает ссылку на справку
       function GetHelpLink: string;

       // Обертка для onEndRequest
       procedure DoEndRequest(aKeyWord, aResult: string; aResultType: TResultType);
       // Обертка для onStartRequest
       procedure DoStartRequest;
    protected
    public
       constructor Create;
       destructor Destroy; override;

       // Процедура запроса значения слова
       procedure Request(aKeyWord: string; aSearchEngine: TSearchEngine);

       // Вызывается после окончания выполнения параллельной процедуры
       procedure DoDataFromURLEnd(aResult: string);

       // Ссылка на файл справки
       property HelpLink:string read GetHelpLink;

       // Событие, происходящее до начала выполнения запроса
       property onStartRequest: TNotifyEvent read fonStartRequest;
       // Событие, происходящее по окончании выполнения запроса
       property onEndRequest: TRequestEvent read fonEndRequest write fonEndRequest;
  end;

implementation

{ TGramotei }

function TGramotei.GetHelpLink: string;
begin
  Result:= GetFullPath(fCurrentPath, HelpDirectory, HelpFileName);
end;

function TGramotei.GetTemplateLink: string;
begin
  Result:= GetFullPath(fCurrentPath, TemplateDirectory, TemplateFilename);
end;

constructor TGramotei.Create;
begin
  inherited Create;
  fCurrentPath:= SysToUTF8(ExtractFilePath(ParamStr(0)));
  fwGet:= TwGet.Create(nil);
end;

destructor TGramotei.Destroy;
begin
  fwGet.Destroy;
  inherited Destroy;
end;

procedure TGramotei.Request(aKeyWord: string; aSearchEngine: TSearchEngine);
begin
  try
    fKeyWord:= aKeyWord;
    fSearchEngine:= aSearchEngine;

    if UTF8Length(fKeyWord) = 0 then exit;

    DoStartRequest;

    case aSearchEngine of
      seGramota        : begin
        fCurrentURL:= CompileURL(fKeyWord, GramotaURL);
        DataFromURL(fCurrentURL, cp1251);
      end;
      sePromtOne      : begin
        fCurrentURL:= CompileURL(fKeyWord, SynonimsURL);
        DataFromURL(fCurrentURL, cpUTF8);
      end;
      seWiki           : DoEndRequest(aKeyWord, CompileURL(fKeyWord, WikiURL), rtURL);
      seBigEnc         : DoEndRequest(aKeyWord, CompileURL(fKeyWord, BigEncURL), rtURL);
      seYandex         : DoEndRequest(aKeyWord, CompileURL(fKeyWord, BigEncURL), rtURL);
    end;
  except
    raise;
  end;
end;

function TGramotei.GetReplyBlock(aSourceText:string):string;
begin
  case fSearchEngine of
    seGramota: Result:= GetBlock(aSourceText, GramotaBlockStart, GramotaBlockEnd, false);
    sePromtOne: Result:= GetBlock(aSourceText, SynonimsBlockStart, SynonimsBlockEnd, true);
    else
      Result:= aSourceText;
  end;
end;

function TGramotei.ClearLink(aSourceText: string): string;
begin
  Result:= HTMLClearAttribute('href', aSourceText);
end;

procedure TGramotei.DoDataFromURLEnd(aResult: string);
var
  aResultText: String;
begin
  try
    // Беру фрагмент
    aResultText:= GetReplyBlock(aResult);

    case fSearchEngine of
      // Шаблонизирую без очистки ссылок
      sePromtOne: aResultText:= GetTemplatedText(aResultText, false);
      else
        // Шаблонизирую и очищаю ссылки
        aResultText:= GetTemplatedText(aResultText, true);
    end;

    DoEndRequest(fKeyWord, aResultText, rtHTML);
  except
    raise;
  end;
end;

function TGramotei.GetTemplatedText(aSourceText:string; const ClearLinks:boolean = false):string;
var
  aTemplate: TStringList;
  aCurrentString: String;
  i: Integer;
begin
  aTemplate:= TStringList.Create;
  try
    if ClearLinks then
    begin
      aTemplate.CommaText:= aSourceText;

      for i:=0 to aTemplate.Count-1 do
          begin
            aCurrentString:= aTemplate.Strings[i];
            aTemplate.Strings[i]:= ClearLink(aCurrentString);
          end;
      aSourceText:= aTemplate.Text;
    end;
    aTemplate.Clear;
    aTemplate.LoadFromFile(GetTemplateLink);
    Result:= Format(aTemplate.Text,[fKeyWord, aSourceText, fCurrentURL]);
    aTemplate.Text:= Result;
    aTemplate.SaveToFile('1.html');
  finally
    FreeAndNil(aTemplate);
  end;

end;

procedure TGramotei.DoEndRequest(aKeyWord, aResult:string; aResultType:TResultType);
begin
  if Assigned(onEndRequest) then onEndRequest(self, aKeyWord, aResult, aResultType);
end;

procedure TGramotei.DoStartRequest;
begin
  if Assigned(onStartRequest) then onStartRequest(self);
end;

procedure TGramotei.DataFromURL(aURL: string; aCodePage: TCodePages);
var
  aResult: String;
begin
  try
    // Получил страницу из сети
    if UTF8Length(aURL) = 0 then
      raise  Exception.Create(strExceptionThreadURLIsEmptyRu);

    //aResult:= fwGet.PostForm(aURL,'');
    aResult:= fwGet.Get(aURL);

    case aCodePage of
      cp1251: aResult:= CP1251ToUTF8(aResult);
    end;

    DoDataFromURLEnd(aResult);
  except
    raise;
  end;
end;


end.

