program testprogram;
const
    const1 = 5;
    const2 = 7;
var
    variable_1 : integer;
    variable2, variable3,variable15 : integer;
begin
    writeln('Hello world!');
    write('Please enter a number :');
    read(variable_1);
    writeln('the number is :',variable_1);
    writeln('Enter two more:');
    readln(variable2, variable3);
    variable15 := variable2 / variable3;
    begin
	variable_1 := variable2 + variable15;
    end;

    writeln(variable2, ' + ', variable2, ' / ', variable3);
    write('is ');
    writeln(variable_1);
end.
