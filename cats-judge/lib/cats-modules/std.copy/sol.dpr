{$APPTYPE CONSOLE}
{$LONGSTRINGS ON}

var s : string;

begin
   assign(input,'input.txt'); reset(input);
   assign(output,'output.txt'); rewrite(output);


   readln(s); writeln(s);


   close(input); close(output);
end.
