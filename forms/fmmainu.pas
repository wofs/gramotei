unit FmMainU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, LCLIntf, Menus,
  Clipbrd, HtmlView, LazUTF8, wGetU,
  FmAboutU, TGramoteiU, gTypesU, HTMLUn2, HtmlGlobals;

type

  { TFmMain }

  TFmMain = class(TForm)
    edSearch: TEdit;
    HtmlViewer: THtmlViewer;
    mEditorYandex: TMenuItem;
    mHTMLYandex: TMenuItem;
    mHTMLCopy: TMenuItem;
    mEditorCopy: TMenuItem;
    mEditorPaste: TMenuItem;
    mEditorPasteSearch: TMenuItem;
    mEditorWiki: TMenuItem;
    mHTMLWiki: TMenuItem;
    mmGetHelp: TMenuItem;
    mShow: TMenuItem;
    mHTMLSearch: TMenuItem;
    mmAbout: TMenuItem;
    mmHelp: TMenuItem;
    mmGetWord: TMenuItem;
    mmActions: TMenuItem;
    mmFile: TMenuItem;
    mmExit: TMenuItem;
    mMainMenu: TMainMenu;
    mExit: TMenuItem;
    mGetWord: TMenuItem;
    pBottom: TPanel;
    pCenter: TPanel;
    mTray: TPopupMenu;
    mHTML: TPopupMenu;
    mEditor: TPopupMenu;
    TrayIcon: TTrayIcon;
    procedure edSearchKeyPress(Sender: TObject; var Key: char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mEditorCopyClick(Sender: TObject);
    procedure mEditorPasteClick(Sender: TObject);
    procedure mEditorPasteSearchClick(Sender: TObject);
    procedure mEditorWikiClick(Sender: TObject);
    procedure mEditorYandexClick(Sender: TObject);
    procedure mHTMLCopyClick(Sender: TObject);
    procedure mExitClick(Sender: TObject);
    procedure mGetWordClick(Sender: TObject);
    procedure mHTMLYandexClick(Sender: TObject);
    procedure mmAboutClick(Sender: TObject);
    procedure mmGetHelpClick(Sender: TObject);
    procedure mHTMLWikiClick(Sender: TObject);
    procedure mHTMLSearchClick(Sender: TObject);
    procedure mShowClick(Sender: TObject);
  private
    fGramotei: TGramotei;

    procedure DoEndRequest(Sender: TGramotei; aKeyWord, aResult: string; aResultType: TResultType);
    procedure GetHelp;
    procedure GetWord(aKeyWord: string; aSearchEngine: TSearchEngine);
    procedure OpenWiki(aKeyWord: string);
    procedure OpenYandex(aKeyWord: string);
    procedure Request(aKeyWord: string; aSearchEngine: TSearchEngine);
  private
    wGet: TwGet;
    ToExit: boolean;
    procedure ShowBallon;
  public

  end;

var
  FmMain: TFmMain;

implementation

{$R *.lfm}

{ TFmMain }

procedure TFmMain.FormCreate(Sender: TObject);
begin
  fGramotei:= TGramotei.Create;
  fGramotei.onEndRequest:= @DoEndRequest;
  ToExit:= false;
  GetHelp;
end;

procedure TFmMain.Request(aKeyWord: string; aSearchEngine: TSearchEngine);
begin
  fGramotei.Request(aKeyWord, aSearchEngine);
end;

procedure TFmMain.GetHelp;
begin
  HtmlViewer.LoadFromFile(fGramotei.HelpLink);
end;

procedure TFmMain.GetWord(aKeyWord:string; aSearchEngine: TSearchEngine);
begin
  Request(aKeyWord, aSearchEngine);
end;

procedure TFmMain.DoEndRequest(Sender: TGramotei; aKeyWord, aResult: string; aResultType: TResultType);
begin
  case aResultType of
    rtHTML  : HtmlViewer.Text:= aResult;
    rtURL   : OpenURL(aResult);
  end;
end;

procedure TFmMain.edSearchKeyPress(Sender: TObject; var Key: char);
var
  fSearchText: TCaption;
begin
  if Key = #13 then
  begin
    fSearchText:= edSearch.Text;
    if UTF8Length(fSearchText)>0 then
      Request(fSearchText, seGramota)
    else
      GetHelp;
  end;
end;

procedure TFmMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:= ToExit;
  Application.Minimize;
  FmMain.Hide;
end;

procedure TFmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fGramotei);
  if TrayIcon.ShowIcon then TrayIcon.ShowIcon:= false;
end;

procedure TFmMain.mEditorCopyClick(Sender: TObject);
begin
  Clipboard.AsText:= edSearch.Text;
end;

procedure TFmMain.mEditorPasteClick(Sender: TObject);
begin
  edSearch.Text:= Clipboard.AsText;
end;

procedure TFmMain.mEditorPasteSearchClick(Sender: TObject);
begin
  edSearch.Text:= Clipboard.AsText;
  Request(Clipboard.AsText, seGramota);
end;

procedure TFmMain.mEditorWikiClick(Sender: TObject);
begin
  OpenWiki(edSearch.Text);;
end;

procedure TFmMain.mEditorYandexClick(Sender: TObject);
begin
  OpenYandex(edSearch.Text);
end;

procedure TFmMain.mHTMLCopyClick(Sender: TObject);
begin
  Clipboard.AsText:= HtmlViewer.SelText;
end;

procedure TFmMain.mExitClick(Sender: TObject);
begin
  ToExit:= true;
  Close();
end;

procedure TFmMain.mGetWordClick(Sender: TObject);
begin
  if UTF8Length(Clipboard.AsText)>0 then
  begin
    Request(Clipboard.AsText, seGramota);
    edSearch.Text:=Clipboard.AsText;
    ShowBallon;
  end else
  ShowMessage('Буфер обмена пуст!');

   self.ShowOnTop;
end;

procedure TFmMain.mHTMLYandexClick(Sender: TObject);
begin
  OpenYandex(HtmlViewer.SelText);
end;

procedure TFmMain.mmAboutClick(Sender: TObject);
begin
   FmAbout.ShowModal;
end;

procedure TFmMain.mmGetHelpClick(Sender: TObject);
begin
  GetHelp;
  edSearch.Clear;
end;

procedure TFmMain.mHTMLWikiClick(Sender: TObject);
begin
  OpenWiki(HtmlViewer.SelText);
end;

procedure TFmMain.OpenWiki(aKeyWord: string);
begin
  Request(aKeyWord, seWiki);
end;

procedure TFmMain.OpenYandex(aKeyWord: string);
begin
  Request(aKeyWord, seYandex);
end;

procedure TFmMain.mHTMLSearchClick(Sender: TObject);
var
  aText: String;
begin
  aText:= HtmlViewer.SelText;
  Request(aText, seGramota);
  edSearch.Text:= aText;
end;

procedure TFmMain.mShowClick(Sender: TObject);
begin
    if FmMain.Showing then
  begin
    Application.Minimize;
    FmMain.Hide;
  end
  else
  begin
     FmMain.WindowState:= wsNormal;
     FmMain.Show;
     Application.Restore;
  end;
end;

procedure TFmMain.ShowBallon;
var
  aPos: TPoint;
begin
  if not self.Visible then
  begin
    FmMain.WindowState:= wsNormal;
    self.Visible:= true;
    Application.Restore;
    aPos:= Mouse.CursorPos;
    self.Top:= aPos.y-self.Height-50;
    self.Left:= aPos.x-self.Width;
  end;
end;

end.

