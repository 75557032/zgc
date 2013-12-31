unit uerrconst;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  SMakeOK=0;
  SLoadSourceOK=1;
  SPrecompiledSourceOK=2;
  SBuildGrammarTreeOK=3;
  SCompileToLLVMOK=4;
  SWriteOutFileOK=5;
  SLoadFileToListOK=6;


  SErrNoFindSource=-1;

implementation

end.

