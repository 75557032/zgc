unit ubasetype;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  PointerCount=8096;
  StrCount=512;

type
  TListType=(lt_Block,lt_Line);
  PZGCList=^TZGCList;
  TZGCList=Record
    ListType:TListType;
    List:Pointer;
    Count:Integer;
  end;
  PPointerList=^TPointerList;
  TPointerList=array[0..PointerCount-1] of Pointer;
  PStrList=^TStrList;
  TStrList=array[0..StrCount-1] of string;

function CreateBlockList:PZGCList;
function CreateLineList:PZGCList;
procedure DisBlockList(AZGCList:PZGCList);
procedure DisLineList(AZGCList:PZGCList);
function AddPointerToList(APointer:Pointer;AList:PZGCList):Integer;
function AddStrToList(AStr:string;AList:PZGCList):Integer;

implementation

{*************************************************************************
创建一个块List，并返回指针
*************************************************************************}
function CreateBlockList:PZGCList;
var
  LTemp:PPointerList;
begin
  New(Result);
  New(LTemp);
  Result^.Count:=0;
  Result^.ListType:=lt_Block;
  Result^.List:=LTemp;
end;

{*************************************************************************
创建一个行List，并返回指针
*************************************************************************}
function CreateLineList:PZGCList;
var
  LTemp:PStrList;
begin
  New(Result);
  New(LTemp);
  Result^.Count:=0;
  Result^.ListType:=lt_Line;
  Result^.List:=LTemp;
end;

{*************************************************************************
释放一个块List
*************************************************************************}
procedure DisBlockList(AZGCList:PZGCList);
begin
  Dispose(PPointerList(AZGCList^.List));
  Dispose(AZGCList);
end;

{*************************************************************************
释放一个行List
*************************************************************************}
procedure DisLineList(AZGCList:PZGCList);
begin
  Dispose(PStrList(AZGCList^.List));
  Dispose(AZGCList);
end;

{*************************************************************************
增加一个指针进块List
*************************************************************************}
function AddPointerToList(APointer: Pointer; AList: PZGCList): Integer;
begin
  Result:=AList^.Count;
  AList^.Count:=Result+1;
  PPointerList(AList^.List)^[Result]:=APointer;
end;

{*************************************************************************
增加一个str进行List
*************************************************************************}
function AddStrToList(AStr: string; AList: PZGCList): Integer;
begin
  Result:=AList^.Count;
  AList^.Count:=Result+1;
  PStrList(AList^.List)^[Result]:=AStr;
end;

end.

