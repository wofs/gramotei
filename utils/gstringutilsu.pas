unit gStringUtilsU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazUTF8;

  // Возвращает адрес для запроса
  function CompileURL(aKeyWord, aURL: string): string;
  //Возвращает интересующий блок из HTML страницы
  function GetBlock(aSourceText, aStartText, aEndText: string; IncludedStartText: boolean): string;
  // Возвращает полный путь файлу aFileName, лежащему в дирректории aDirectory
  function GetFullPath(aAppPath, aDirectory, aFileName:string): string;
  // Очищает HTMl атрибут по имени
  function HTMLClearAttribute(aAttrName, aSourceText: string):string;
  // Содержит ли URL корень сайла
  function HTMLContainsServerRoot(aURL:string):Boolean;

implementation

function CompileURL(aKeyWord, aURL: string): string;
var
  aTmp: String;
begin
  aTmp:= UTF8StringReplace(aKeyWord,#32,'%20',[rfReplaceAll]);
  aTmp:= UTF8LowerCase(aTmp);
  Result:= Format(aURL,[aTmp]);
end;

function GetBlock(aSourceText, aStartText, aEndText: string; IncludedStartText: boolean): string;
var
  aPosStart, aPosEnd, aCountStart: PtrInt;
begin
  aCountStart:= 0;
  if not IncludedStartText then
    aCountStart:= UTF8Length(aStartText);

  aPosStart:= UTF8Pos(aStartText, aSourceText, 1);
  aPosEnd:= UTF8Pos(aEndText, aSourceText,aPosStart);
  Result:= UTF8Copy(aSourceText, aPosStart + aCountStart, aPosEnd - aPosStart-aCountStart);
end;

function GetFullPath(aAppPath, aDirectory, aFileName: string): string;
begin
  Result:= aAppPath+aDirectory+DirectorySeparator+aFileName;
end;

function HTMLClearAttribute(aAttrName, aSourceText: string):string;
const
  uAttrEnd = '>';
var
  aCountStart, aPosStart, aPosEnd: PtrInt;
begin
  aCountStart:= UTF8Length(aAttrName);
  aPosStart:= UTF8Pos(aAttrName, UTF8LowerCase(aSourceText), 1);
  aPosEnd:= UTF8Pos(uAttrEnd, aSourceText,aPosStart);
  Result:= UTF8Copy(aSourceText, aPosStart, aPosEnd - aPosStart);

  Result:= UTF8StringReplace(aSourceText, Result,'',[rfIgnoreCase])
end;

function HTMLContainsServerRoot(aURL:string):Boolean;
const
  uHTTP = 'http://';
  uHTTPS = 'https://';
begin
  Result:= (UTF8Pos(uHTTP,aURL)>0) or (UTF8Pos(uHTTPS,aURL)>0);
end;

end.

