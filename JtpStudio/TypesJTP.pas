unit TypesJTP;

interface

uses
  Windows;


type JtpRes = UInt64;

//  Значения параметров движка, которые ничего не меняют.
const  FLT_UNDEF    : single  = 3.402823466e+38;
//const  COLOR_UNDEF  : dword   = $CCCCCCCC;
const  INT_UNDEF    : integer = $CCCCCCCC;


const  JTP_RELATIVE : dword = $00010000; //  флаг относительности координат (анимации, клонирования и т.д.)
const  JTP_ABSOLUTE : dword = $00000000; //  флаг абсолютности координат (анимации, клонирования и т.д.)


//  Коды анимаций. Какое свойство у объекта меняет анимация: позицию, ориентацию и т.д.
const ANIM_POS        : dword = $00000001;
const ANIM_ORIENT     : dword = $00000002;
const ANIM_TARGET			: dword = $00000004;  // точка, куда смотрит камера (только для камеры).
const ANIM_SIZE       : dword = $00000008;
const ANIM_COLOR_RGB  : dword = $00000010;
const ANIM_COLOR_A    : dword = $00000020;

//  Коды мягких ключей анимаций.
const ANIM_LINEAR		  : dword = 1;    //  просто линейно
const ANIM_SINUSOID	  : dword = 2;    //  мягкий старт, мягкий стоп
const ANIM_PARABOLIC  : dword = 3;    //  мягкий старт (ускорение)
const ANIM_INV_PARAB  : dword = 4;    //  мягкий стоп (замедление)


//    Типы объектов.
const JTP_OBJ_CAMERA    : integer = 3;
const JTP_OBJ_LIGHT     : integer = 18;
const JTP_OBJ_GEOMETRY  : integer = 1001;


//  Возвращаемые значения.
const  JTP_OK                 : JtpRes = $0000000000000000;  //  Успешно.

const  JTP_UNDEF_SCENE        : JtpRes = $0000000080000000;  //  Не найдена сцена.
const  JTP_UNDEF_UNIT         : JtpRes = $0000000040000000;  //  Не найден объект (юнит) сцены.
const  JTP_UNDEF_ANIMATION    : JtpRes = $0000000020000000;  //  Не найдена анимация.
const  JTP_UNDEF_UNIT_GROUP   : JtpRes = $0000000010000000;  //  Не найдена группа юнитов.
const  JTP_UNDEF_SCENARIO     : JtpRes = $0000000008000000;  //  Не найден сценарий.
const  JTP_UNDEF_TEXTURE      : JtpRes = $0000000004000000;  //  Не найдена текстура.
const  JTP_UNDEF_MESH         : JtpRes = $0000000002000000;  //  Не найден меш.
const  JTP_UNDEF_SURF_ELEMENT : JtpRes = $0000000001000000;  //  Неправильный индекс елемента или текстуры.

const  JTP_FILE_NOT_FOUND			: JtpRes = $0000000000000001;  //  Файл не найден.
const  JTP_FILE_INVALID_DATA	: JtpRes = $0000000000000002;  //  Неизвестные данные в файле.
const  JTP_LIMIT					    : JtpRes = $0000000000000004;  //  Переполнение.
const  JTP_MEMORY				    	: JtpRes = $0000000000000008;  //  Ошибка выделения памяти.
const  JTP_INVALID_DATA			  : JtpRes = $0000000000000010;  //  Невалидные данные.
const  JTP_LATER					    : JtpRes = $0000000000000020;  //  Операция произойдёт позже.
const  JTP_INTERNAL_ERROR			: JtpRes = $0000000000000040;  //  Внутренняя ошибка API, SDK и т.д.
const  JTP_TIMEOUT				    : JtpRes = $0000000000000080;  //  Время ожидания вышло.
const  JTP_NOT_FOUND				  : JtpRes = $0000000000000100;  //  Данные не найдены.
const  JTP_UNINITIALIZED			: JtpRes = $0000000000000200;  //  Данные ещё не инициализированы.
const  JTP_ALREADY				    : JtpRes = $0000000000000400;  //  Данные уже инициализированы.
const  JTP_INVALID_PARAMS			: JtpRes = $0000000000000800;  //  Неправильные входные параметры.
const  JTP_STILL          		: JtpRes = $0000000000001000;  //  Что-то ещё работает.
const  JTP_BOUND          		: JtpRes = $0000000000002000;  //  Выход за пределы массива, памяти и т.д.
const  JTP_OVERFLOW        		: JtpRes = $0000000000004000;  //  Переполнение.
const  JTP_EQUIVALENT      		: JtpRes = $0000000000008000;  //  Найдены данные с таким же именем.







//  Фиксированная строка на 64 символов.
type Str64 = record
     text : array[0..63] of AnsiChar;
end;
type PStr64 = ^Str64;


//  Фиксированная строка на 128 символов.
type Str128 = record
     text : array[0..127] of AnsiChar;
end;
type PStr128 = ^Str128;


//  Фиксированная строка на 256 символов.
type Str256 = record
     text : array[0..255] of AnsiChar;
end;
type PStr256 = ^Str256;


//  Фиксированная строка на 512 символов.
type Str512 = record
     text : array[0..511] of AnsiChar;
end;
type PStr512 = ^Str512;


//  Фиксированная строка на 1024 символов.
type Str1024 = record
     text : array[0..1023] of AnsiChar;
end;
type PStr1024 = ^Str1024;


//  Имя объекта, анимации, текстуры и т.д.
type TName = Str64;
type PName = PStr64;


//  Путь к файлу.
type TPath = Str256;
type PPath = PStr256;


//  Прямоугольник на экране
type TJTPRect = record
  x1, y1, x2, y2 : integer;
end;

//  Точка на экране.
type TJTPPoint = record
  x, y : integer;

  class operator Add( A, B: TJTPPoint ) : TJTPPoint;
  class operator Subtract( A, B: TJTPPoint ) : TJTPPoint;
end;

implementation

class operator TJTPPoint.Add( A, B: TJTPPoint): TJTPPoint;
begin
  Result.x := A.x + B.x;
  Result.y := A.y + B.y;
end;



class operator TJTPPoint.Subtract( A, B: TJTPPoint): TJTPPoint;
begin
  Result.x := A.x - B.x;
  Result.y := A.y - B.y;
end;

end.
