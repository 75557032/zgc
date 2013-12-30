unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uerrconst, useparateline;

var
  gGlobalParameters: string;

function GetSourceFile: string;
function GetOutFile: string;
function MakeMain(const ASourceFileName, AOutFileName: string): integer;
procedure EchoMakeResult(AResult: integer);
function LoadSource(ASourceFileName: string; AOutList: TList): integer;
function PrecompiledSource(ASourceList: TList): integer;
function BuildGrammarTree(ASourceList: TList): integer;
function CompileToLLVM(ASourceList: TList; AOutList: TStringList): integer;
function WriteOutFile(AOutFileName: string; AWriteList: TStringList): integer;

implementation

{*************************************************************************
返回源文件路径
*************************************************************************}
function GetSourceFile: string;
begin
  Result := 'C:\xx.txt';
end;

{*************************************************************************
返回输出文件路径
*************************************************************************}
function GetOutFile: string;
begin
  Result := 'C:\xx.ll';
end;

{*************************************************************************
编译主函数
*************************************************************************}
function MakeMain(const ASourceFileName, AOutFileName: string): integer;
var
  LSourceList: TList;
  LErrID: integer;
  LOutList: TStringList;
begin
  Result := SMakeOK;
  LSourceList := TList.Create;
  try
    LErrID := LoadSource(ASourceFileName, LSourceList);
    if LErrID <> SLoadSourceOK then
    begin
      Result := LErrID;
      Exit;
    end;
    LErrID := PrecompiledSource(LSourceList);
    if LErrID <> SPrecompiledSourceOK then
    begin
      Result := LErrID;
      Exit;
    end;
    LErrID := BuildGrammarTree(LSourceList);
    if LErrID <> SBuildGrammarTreeOK then
    begin
      Result := LErrID;
      Exit;
    end;
    LOutList := TStringList.Create;
    try
      LErrID := CompileToLLVM(LSourceList, LOutList);
      if LErrID <> SCompileToLLVMOK then
      begin
        Result := LErrID;
        Exit;
      end;
      LErrID := WriteOutFile(AOutFileName, LOutList);
      if LErrID <> SWriteOutFileOK then
      begin
        Result := LErrID;
        Exit;
      end;
    finally
      LOutList.Free;
    end;
  finally
    LSourceList.Free;
  end;
end;

{*************************************************************************
输出编译结果
*************************************************************************}
procedure EchoMakeResult(AResult: integer);
begin
  WriteLn(AResult);
end;

{*************************************************************************
加载源文件，完成分句，分词
*************************************************************************}
function LoadSource(ASourceFileName: string; AOutList: TList): integer;
var
  LSourceFileHandle: integer;
begin
  if FileExists(ASourceFileName) then
  begin
    LSourceFileHandle := FileOpen(ASourceFileName, fmOpenRead);
    try
      //分词
    finally
      FileClose(LSourceFileHandle);
    end;
    Result := SLoadSourceOK;
  end
  else
  begin
    Result := SErrNoFindSource;
  end;
end;

{*************************************************************************
预编译，连接头文件，替换宏定义，删除注释
*************************************************************************}
function PrecompiledSource(ASourceList: TList): integer;
begin
  Result := SPrecompiledSourceOK;
end;

{*************************************************************************
构建语法树，提取变量表，类型表，函数表，单元表
*************************************************************************}
function BuildGrammarTree(ASourceList: TList): integer;
begin
  Result := SBuildGrammarTreeOK;
end;

{*************************************************************************
翻译至LLVM
*************************************************************************}
function CompileToLLVM(ASourceList: TList; AOutList: TStringList): integer;
begin
  Result := SCompileToLLVMOK;
end;

{*************************************************************************
写入目标文件
*************************************************************************}
function WriteOutFile(AOutFileName: string; AWriteList: TStringList): integer;
begin
  Result := SWriteOutFileOK;
end;

end.

