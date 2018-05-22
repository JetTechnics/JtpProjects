unit TypesJTP;

interface

uses
  Windows;


//  �������� ���������� ������, ������� ������ �� ������.
const  FLT_UNDEF    : single  = 3.402823466e+38;
//const  COLOR_UNDEF  : dword   = $CCCCCCCC;
const  INT_UNDEF    : integer = $CCCCCCCC;


const  JTP_RELATIVE : dword = $00010000; //  ���� ��������������� ��������� (��������, ������������ � �.�.)
const  JTP_ABSOLUTE : dword = $00000000; //  ���� ������������ ��������� (��������, ������������ � �.�.)


//  ���� ��������. ����� �������� � ������� ������ ��������: �������, ���������� � �.�.
const ANIM_POS        : dword = $00000001;
const ANIM_ORIENT     : dword = $00000002;
const ANIM_TARGET			: dword = $00000004;  // �����, ���� ������� ������ (������ ��� ������).
const ANIM_SIZE       : dword = $00000008;
const ANIM_COLOR_RGB  : dword = $00000010;
const ANIM_COLOR_A    : dword = $00000020;

//  ���� ������ ������ ��������.
const ANIM_LINEAR		  : dword = 1;    //  ������ �������
const ANIM_SINUSOID	  : dword = 2;    //  ������ �����, ������ ����
const ANIM_PARABOLIC  : dword = 3;    //  ������ ����� (���������)
const ANIM_INV_PARAB  : dword = 4;    //  ������ ���� (����������)


//    ���� ��������.
const JTP_OBJ_CAMERA    : integer = 3;
const JTP_OBJ_LIGHT     : integer = 18;
const JTP_OBJ_GEOMETRY  : integer = 20;


//  ������������ ��������.
const  JTP_OK                 : UInt64 = $0000000000000000;  //  �������.

const  JTP_UNDEF_SCENE        : UInt64 = $0000000080000000;  //  �� ������� �����.
const  JTP_UNDEF_UNIT         : UInt64 = $0000000040000000;  //  �� ������ ������ (����) �����.
const  JTP_UNDEF_ANIMATION    : UInt64 = $0000000020000000;  //  �� ������� ��������.
const  JTP_UNDEF_UNIT_GROUP   : UInt64 = $0000000010000000;  //  �� ������� ������ ������.
const  JTP_UNDEF_SCENARIO     : UInt64 = $0000000008000000;  //  �� ������ ��������.
const  JTP_UNDEF_TEXTURE      : UInt64 = $0000000004000000;  //  �� ������� ��������.
const  JTP_UNDEF_MESH         : UInt64 = $0000000002000000;  //  �� ������ ���.
const  JTP_UNDEF_SURF_ELEMENT : UInt64 = $0000000001000000;  //  ������������ ������ �������� ��� ��������.

const  JTP_FILE_NOT_FOUND			: UInt64 = $0000000000000001;  //  ���� �� ������.
const  JTP_FILE_INVALID_DATA	: UInt64 = $0000000000000002;  //  ����������� ������ � �����.
const  JTP_LIMIT					    : UInt64 = $0000000000000004;  //  ������������.
const  JTP_MEMORY				    	: UInt64 = $0000000000000008;  //  ������ ��������� ������.
const  JTP_INVALID_DATA			  : UInt64 = $0000000000000010;  //  ���������� ������.
const  JTP_LATER					    : UInt64 = $0000000000000020;  //  �������� ��������� �����.
const  JTP_INTERNAL_ERROR			: UInt64 = $0000000000000040;  //  ���������� ������ API, SDK � �.�.
const  JTP_TIMEOUT				    : UInt64 = $0000000000000080;  //  ����� �������� �����.
const  JTP_NOT_FOUND				  : UInt64 = $0000000000000100;  //  ������ �� �������.
const  JTP_UNINITIALIZED			: UInt64 = $0000000000000200;  //  ������ �� ����������������.
const  JTP_ALREADY				    : UInt64 = $0000000000000400;  //  ������ ��� ����������������.
const  JTP_INVALID_PARAMS			: UInt64 = $0000000000000800;  //  ������������ ������� ���������.
const  JTP_STILL          		: UInt64 = $0000000000001000;  //  ���-�� ��� ��������.







//  ������������� ������ �� 64 ��������.
type Str64 = record
     text : array[0..63] of AnsiChar;
end;
type PStr64 = ^Str64;


//  ������������� ������ �� 128 ��������.
type Str128 = record
     text : array[0..127] of AnsiChar;
end;
type PStr128 = ^Str128;


//  ������������� ������ �� 256 ��������.
type Str256 = record
     text : array[0..255] of AnsiChar;
end;
type PStr256 = ^Str256;


//  ������������� ������ �� 512 ��������.
type Str512 = record
     text : array[0..511] of AnsiChar;
end;
type PStr512 = ^Str512;


//  ������������� ������ �� 1024 ��������.
type Str1024 = record
     text : array[0..1023] of AnsiChar;
end;
type PStr1024 = ^Str1024;


//  ��� �������, ��������, �������� � �.�.
type TName = Str64;
type PName = PStr64;


//  ���� � �����.
type TPath = Str256;
type PPath = PStr256;


//  ������������� �� ������
type TRect = record
  x1, y1, x2, y2 : integer;
end;




implementation



end.
