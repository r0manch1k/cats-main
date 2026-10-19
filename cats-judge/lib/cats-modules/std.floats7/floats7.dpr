{$APPTYPE CONSOLE}
uses
  SysUtils;

var
  fin,fout,fans: TextFile;

const osn = 7;
      eps = 1e-7;

procedure Ex(const s: string; ec: integer; ln: integer = -1);
begin
   write(s);
   if ln >= 0 then write(' @ ', ln);
   try
     close(fin); close(fout); close(fans);
   except
   end;
   halt(ec);
end;

var
   s1, s2: double;
   i: integer;
   wa: string;

begin
   wa := '%%0.%df <> %%0.%df'; wa := format(wa, [osn, osn]);
   try
      assign(fin,paramstr(1)); reset(fin);
   except on e: Exception do
      Ex('Error opening input: ' + e.Message, 3);
   end;
   try
      assign(fans,paramstr(3)); reset(fans);   
   except on e: Exception do
      Ex('Error opening answer: ' + e.Message, 3);
   end;
   try
      assign(fout,paramstr(2)); reset(fout);
   except on e: Exception do
      Ex('Can''t open output: ' + e.Message, 2);
   end;
   i := 0;
   try
      while (not SeekEof(fout)) and (not SeekEof(fans)) do begin
         inc(i);
         read(fout,s1); read(fans,s2);
         if abs(s1 - s2) > eps then begin
            Ex(format(wa, [s1, s2]), 1, i);
         end;
      end;
      if not SeekEof(fout) then Ex('Extra lines', 2);
      if not SeekEof(fans) then Ex('Too few lines', 2);
   except
      Ex('PE', 2);
   end;
   Ex('', 0);
end.
