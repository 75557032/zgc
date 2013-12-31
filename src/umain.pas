unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uerrconst, uloadsource;

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
  LOutList: TStringList;
begin
  Result := SMakeOK;
  LSourceList := TList.Create;
  try
    Result := LoadSource(ASourceFileName, LSourceList);
    if Result <> SLoadSourceOK then
    begin
      Exit;
    end;
    Result := PrecompiledSource(LSourceList);
    if Result <> SPrecompiledSourceOK then
    begin
      Exit;
    end;
    Result := BuildGrammarTree(LSourceList);
    if Result <> SBuildGrammarTreeOK then
    begin
      Exit;
    end;
    LOutList := TStringList.Create;
    try
      Result := CompileToLLVM(LSourceList, LOutList);
      if Result <> SCompileToLLVMOK then
      begin
        Exit;
      end;
      Result := WriteOutFile(AOutFileName, LOutList);
      if Result <> SWriteOutFileOK then
      begin
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
      Result:=LoadFileToList(LSourceFileHandle,AOutList);
      if Result <> SLoadFileToListOK then
      begin
        Exit;
      end;
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

