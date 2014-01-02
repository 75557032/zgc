unit uloadsource;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uerrconst;

function LoadFileToList(ASourceFileHandle: Integer; AOutList: TList):Integer;

implementation

const
  BufCount=1024;

{*************************************************************************
是否到达文件结尾
*************************************************************************}
function CheckReadEof(AReadCount:Integer):Boolean;
begin
  Result:=AReadCount<>BufCount;
end;

{*************************************************************************
是否到达行结尾
*************************************************************************}
function CheckLineEof(AChar:Char):Boolean;
begin
  Result:=AChar=#10;
end;

{*************************************************************************
是否为分词标记到达文件结尾
*************************************************************************}
function CheckWordEof(AChar:Char):Boolean;
begin
  Result:=AChar='2';
end;

{*************************************************************************
该字符是否应该忽略，此处不识别注释
*************************************************************************}
function IsUnUseChar(AChar:Char):Boolean;
begin
  Result:=AChar=#13;
end;

{*************************************************************************
加载文件到List，完成分行，分词
*************************************************************************}
function LoadFileToList(ASourceFileHandle: Integer; AOutList: TList):Integer;
var
  LBuf:array[0..BufCount-1] of Char;
  LReadCount,LReadIndex,i:Integer;
  LTempList:TStringList;
  LTempStr:string;
begin
  LReadIndex:=0;
  LTempStr:='';
  LTempList:=TStringList.Create;
  AOutList.Add(LTempList);
  repeat
    FileSeek(ASourceFileHandle,LReadIndex*BufCount,soFromBeginning);
    LReadCount:=FileRead(ASourceFileHandle,LBuf,BufCount);
    for i:=0 to LReadCount-1 do
    begin
      if CheckLineEof(LBuf[i]) then
      begin
        LTempList:=TStringList.Create;
        AOutList.Add(LTempList);
        Continue;
      end;
      if IsUnUseChar(LBuf[i]) then
      begin
        Continue;
      end;
      if CheckWordEof(LBuf[i]) then
      begin
        LTempList.Add(LTempStr);
        LTempStr:='';
      end
      else
      begin
        LTempStr:=LTempStr+LBuf[i];
      end;
    end;
    LTempList.Add(LTempStr);
    LReadIndex:=LReadIndex+1;
  until CheckReadEof(LReadCount);
  Result:=SLoadFileToListOK;
end;

end.

