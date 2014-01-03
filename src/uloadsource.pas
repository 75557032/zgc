unit uloadsource;

{$mode objfpc}{$H+}

interface

uses
  Classes,SysUtils, uerrconst, ubasetype;

function LoadFileToList(ASourceFileHandle: Integer; AOutList: PZGCList):Integer;

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
  Result:=(AChar='2') or (AChar=#10);
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
function LoadFileToList(ASourceFileHandle: Integer; AOutList: PZGCList):Integer;
var
  LBuf:array[0..BufCount-1] of Char;
  LReadCount,LReadIndex,i:Integer;
  LTempList:PZGCList;
  LTempStr:string;
begin
  LReadIndex:=0;
  LTempStr:='';
  LTempList:=CreateLineList;
  AddPointerToList(LTempList,AOutList);
  repeat
    FileSeek(ASourceFileHandle,LReadIndex*BufCount,soFromBeginning);
    LReadCount:=FileRead(ASourceFileHandle,LBuf,BufCount);
    for i:=0 to LReadCount-1 do
    begin
      if IsUnUseChar(LBuf[i]) then
      begin
        Continue;
      end;
      if CheckWordEof(LBuf[i]) then
      begin
        AddStrToList(LTempStr,LTempList);
        LTempStr:='';
      end
      else
      begin
        LTempStr:=LTempStr+LBuf[i];
      end;
      if CheckLineEof(LBuf[i]) then
      begin
        LTempList:=CreateLineList;
        AddPointerToList(LTempList,AOutList);
      end;
    end;
    LReadIndex:=LReadIndex+1;
  until CheckReadEof(LReadCount);
  AddStrToList(LTempStr,LTempList);
  Result:=SLoadFileToListOK;
end;

end.

