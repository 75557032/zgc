unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uerrconst;

var
  gGlobalParameters: string;

function GetSourceFile: string;
function GetOutFile: string;
function MakeMain(const ASourceFileName, AOutFileName: string): integer;
procedure EchoMakeResult(AResult: integer);

implementation

function GetSourceFile: string;
begin
  Result := 'C:\xx.txt';
end;

function GetOutFile: string;
begin
  Result := 'C:\xx.ll';
end;

function MakeMain(const ASourceFileName, AOutFileName: string): integer;
var
  LSourceFileHandle, LOutFileHandle, LReadCount: integer;
  ss:Array[0..500] of Char;
begin
  if FileExists(ASourceFileName) then
  begin
    LSourceFileHandle := FileOpen(ASourceFileName, fmOpenRead);
    LOutFileHandle := FileCreate(AOutFileName);
    try
      LReadCount:=FileRead(LSourceFileHandle,ss,500);
      FileWrite(LOutFileHandle,ss,LReadCount);
    finally
      FileClose(LOutFileHandle);
      FileClose(LSourceFileHandle);
    end;
    Result := SMakeOK;
  end
  else
  begin
    Result := SErrNoFindSource;
  end;
end;

procedure EchoMakeResult(AResult: integer);
begin
  WriteLn(AResult);
end;

end.

