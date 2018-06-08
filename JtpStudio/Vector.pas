unit Vector;

interface

uses
  Windows;


//  Вектор в трёхмерном пространстве. w не используется.
type TVector = record
     x, y, z, w :  single;
     procedure VSet( x_, y_, z_ : single );
     class operator Add( A, B: TVector ) : TVector;
     class operator Subtract( A, B: TVector ) : TVector;
     class operator Multiply( V: TVector; Value: single ) : TVector;
     class operator Divide( V: TVector; Value: single ) : TVector;
     function Length() : single;
end;
type PVector = ^TVector;


//  Векторные функции
function  VecNormalize( V: TVector ) : TVector;                    //  Нормализует вектор.
function  VecLength( V: TVector ) : single;                        //  Вычисляет длину вектора.
function  VecLengthNormalize( var V: TVector ) : single;           //  Вычисляет длину вектора и нормализует его.
function  VecDot( V1, V2 : TVector ) : single;                     //  Скалярное произведение.
function  VecLerp( V1, V2 : TVector;  F: single ) : TVector;       //  Интерполяция между 2х веторов.



//  Цвет.
type TColor = record
     r, g, b, a :  single;
     procedure VSet( r_, g_, b_, a_ : single );
end;
type PColor = ^TColor;



implementation


procedure TVector.VSet( x_, y_, z_ : single );
begin
  x := x_;    y := y_;    z := z_;
end;



class operator TVector.Add( A, B: TVector): TVector;
begin
  Result.x := A.x + B.x;
  Result.y := A.y + B.y;
  Result.z := A.z + B.z;
end;



class operator TVector.Subtract( A, B: TVector): TVector;
begin
  Result.x := A.x - B.x;
  Result.y := A.y - B.y;
  Result.z := A.z - B.z;
end;



class operator TVector.Multiply( V: TVector; Value: single ) : TVector;
begin
  Result.x := V.x * Value;
  Result.y := V.y * Value;
  Result.z := V.z * Value;
end;



class operator TVector.Divide( V: TVector; Value: single ) : TVector;
begin
  Result.x := V.x / Value;
  Result.y := V.y / Value;
  Result.z := V.z / Value;
end;



function TVector.Length() : single;                          //  Вычисляет длину вектора.
begin
  Length := Sqrt( x*x + y*y + z*z );
end;



function  VecNormalize( V: TVector ) : TVector;              //  Нормализует вектор.
var Len: single;
begin
    Len := Sqrt( V.x*V.x + V.y*V.y + V.z*V.z );
    VecNormalize.x := V.x / Len;
    VecNormalize.y := V.y / Len;
    VecNormalize.z := V.z / Len;
end;



function  VecLength( V: TVector ) : single;                 //  Вычисляет длину вектора.
begin
    VecLength := Sqrt( V.x*V.x + V.y*V.y + V.z*V.z );
end;



function  VecLengthNormalize( var V: TVector ) : single;     //  Вычисляет длину вектора и нормализует его.
var Len: single;
begin
    Len := Sqrt( V.x*V.x + V.y*V.y + V.z*V.z );
    if( Len < 0.00001 ) then
      Len := 0
    else begin
      V.x := V.x / Len;
      V.y := V.y / Len;
      V.z := V.z / Len;
    end;

    VecLengthNormalize := Len;
end;



function  VecDot( V1, V2 : TVector ) : single;               //  Скалярное произведение.
begin
    VecDot := V1.x*V2.x + V1.y*V2.y + V1.z*V2.z;
end;



function  VecLerp( V1, V2 : TVector;  F: single ) : TVector; //  Интерполяция между 2х веторов.
begin
    VecLerp.x := V1.x + (V2.x-V1.x)*F;
    VecLerp.y := V1.y + (V2.y-V1.y)*F;
    VecLerp.z := V1.z + (V2.z-V1.z)*F;
end;





procedure TColor.VSet( r_, g_, b_, a_ : single );
begin
  r := r_;    g := g_;    b := b_;    a := a_;
end;



end.
