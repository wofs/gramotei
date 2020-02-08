unit FmAboutU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fileinfo, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFmAbout }

  TFmAbout = class(TForm)
    TextAbout: TStaticText;
    TextVersion: TStaticText;
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FmAbout: TFmAbout;

implementation

{$R *.lfm}

function GetVersion: string;
var
  version: string;
  Info: TVersionInfo;
begin
  Info := TVersionInfo.Create;
  Info.Load(HINSTANCE);
  //[0] = Major version, [1] = Minor ver, [2] = Revision, [3] = Build Number
  version := IntToStr(Info.FixedInfo.FileVersion[0]) + '.' + IntToStr(
    Info.FixedInfo.FileVersion[1]) + '.' + IntToStr(Info.FixedInfo.FileVersion[2]) +
    '.' + IntToStr(Info.FixedInfo.FileVersion[3]);
  Result := version;
  Info.Free;
end;

{ TFmAbout }

procedure TFmAbout.FormShow(Sender: TObject);
begin
   TextVersion.Caption:= Format('Версия: %s',[GetVersion]);
end;

end.

