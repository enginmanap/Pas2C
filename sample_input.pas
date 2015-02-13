Program v1;
const n=5;
var m: array[1..8,1..8] of integer; i,j,b,c: integer; f: boolean; max: array[1..n]of integer;
begin
writeln('Для введения массива введите 1, для случайного генерирования введите другое число');
readln(b);
if b=1 then 
begin
for j:=1 to n do
for i:=1 to n do
readln(m[i,j]);
end
else
begin
for j:=1 to n do
for i:=1 to n do
m[i,j]:=random(0,99);
end;

for j:=1 to n do
begin
write('|');
for i:=1 to n do
begin
write(m[i,j]:2);write(' ');
end;
write('|');
writeln;
writeln;
end;
writeln;
repeat
f:=false; 
  for i:=1 to n-1 do  
  begin
    if m[i,i]>m[i+1,i+1] then 
    begin
      f:=true; 
      c:=m[i,i];m[i,i]:=m[i+1,i+1];m[i+1,i+1]:=c; 
    end;
  end;
until not f; 

for i:=1 to n-2 do
begin
repeat
f:=false; 
  for j:=1+i to n-1 do  
  begin
    if m[i,j]>m[i,j+1] then 
    begin
      f:=true; 
      c:=m[i,j];m[i,j]:=m[i,j+1];m[i,j+1]:=c; 
    end;
  end;
until not f; 
end;


for j:=1 to n do
begin
write('|');
for i:=1 to n do
begin
write(m[i,j]:2);write(' ');
end;
write('|');
writeln;
writeln;
end;

for i:=1 to n do
max[i]:=m[i,n];
max[n-1]:=0;
repeat
f:=false; 
  for i:=1 to n-1 do  
  begin
    if max[i]>max[i+1] then 
    begin
      f:=true; 
      c:=max[i];max[i]:=max[i+1];max[i+1]:=c; 
    end;
  end;
until not f; 
writeln(max[n]);

end.
