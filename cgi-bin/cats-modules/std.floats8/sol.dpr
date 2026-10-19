{$APPTYPE CONSOLE}
{$LONGSTRINGS ON}

var s : string;

begin
   assign(input,'input.txt'); reset(input);
   assign(output,'output.txt'); rewrite(output);

   while not eof do begin
      readln(s); writeln(s);
   end;

   close(input); close(output);
end.
