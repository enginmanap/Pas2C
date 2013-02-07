var
 s,i,a,p:longint;
function f (x : longint) : integer; 
var a, b: integer; 
begin
  a:=0;
  b:=0;
  while(x>0) do
  begin    
    if x mod 2 = 0 then
    a:=a+1
    else
    b:=b+1;
    x:=x div 10;
  end;
  if a = 0 then  f:=1;
  if b = 0 then f:=2;
  if (a>0) and (b>0) then  f:=3;   
end; 
 begin
 p:=0;s:=0;
 for i:=1000 to 100000 do begin
 a:=f(i);
 if a = 1 then s:=s+1;
 if a = 3 then p:=p+1; 
 end;
 writeln(s);
 writeln(p);
 end.
