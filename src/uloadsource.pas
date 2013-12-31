unit uloadsource;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uerrconst;

function LoadFileToList(ASourceFileHandle: Integer; AOutList: TList):Integer;

implementation

function LoadFileToList(ASourceFileHandle: Integer; AOutList: TList):Integer;
begin
  Result:=SLoadFileToListOK;
end;

end.

