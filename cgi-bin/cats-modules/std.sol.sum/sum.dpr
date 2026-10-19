var
  f: TextFile;
  a, b: Integer;
begin
  AssignFile(f, 'input.txt'); Reset(f);
  Read(f, a, b);
  CloseFile(f);
  AssignFile(f, 'output.txt'); Rewrite(f);
  Write(f, a + b);
  CloseFile(f);
end.
