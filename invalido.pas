{ Algoritmo de Euclides para calcular el maximo comun divisor de dos numeros enteros
}

{ version recursiva }
PROGRAM euclides(input, output);

FUNCTION mcd_recursivo(u, v : integer) : integer;
BEGIN
  IF u mod v <> 0 THEN
    mcd_recursivo := mcd_recursivo(v, u mod v)
  ELSE
    mcd_recursivo := v

{ version iterativa }
function mcd_iterativo(u, v : integer) : integer;
var t : integer;
begin
  while v <> 0 do
  begin
    t := u;
    u := v;
    v := t mod v
  end;
  mcd_iterativo := abs(u)
end;

{ Programa principal }
BEGIN
  readln(a, b);
  writeln(mcd_recursivo(a,b));
  writeln(mcd_iterativo(a,b))
END.
