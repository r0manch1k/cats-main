{$APPTYPE CONSOLE}

var i: integer;

begin
  for i := 1 to ParamCount-1 do
    write(ParamStr(i), #32);
  write(ParamStr(ParamCount));
end.