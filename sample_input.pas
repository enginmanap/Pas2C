program testprogram;
const
    const1 = 5;
    const2 = 7;
var
    variable1 : integer;
    variable2, variable3,variable15 : integer;
begin

    variable2 := 40 / 3;
    begin
	variable1 := variable2 + 5 * 40;
    end;

    writeln('hello world!');
    writeln('first variable is:', variable1, ', and second variable is:', variable2, 'const1 is:', const1);
    writeln('We can print this way too!');
    write('first variable is:', variable1);
    writeln(', and second variable is:', variable2);
end.
