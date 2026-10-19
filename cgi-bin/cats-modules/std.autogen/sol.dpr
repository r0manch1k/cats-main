{$APPTYPE CONSOLE}

begin
   assignFile(input, 'input.txt'); reset(input);
   assignFile(output, 'output.txt'); rewrite(output);
   closeFile(input); closeFile(output);
end.
