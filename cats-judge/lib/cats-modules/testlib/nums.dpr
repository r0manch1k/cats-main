uses
  SysUtils, testlib;
var
  i, a, o: Integer;
begin
  i := 1;
  while not ans.SeekEof do begin
    a := ans.ReadInteger;
    o := ouf.ReadInteger;
    if a <> o then
      Quit(_WA, Format('%d <> %d @%d', [a, o, i]));
    Inc(i);
  end;
  if not ouf.SeekEof then
    Quit(_PE, 'Extra characters in output');
  Quit(_OK, '');
end.
