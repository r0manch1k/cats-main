{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  fin,fout,fans: TextFile;
  
procedure Ex(const s: string; ec: integer; ln: integer = -1);
begin
   write(s);
   if ln >= 0 then write(' in pos ', ln);
   try
     close(fin); close(fout); close(fans);
   except
   end;
   halt(ec);
end;

var
   s1, s2: Int64;
   i: integer;
   wa: string;

begin
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
         read(fout, s1); read(fans, s2);
         if s1 <> s2 then begin
            wa := IntToStr(s1) + ' instead of ' + IntToStr(s2);
            Ex(wa, 1, i);
         end;
      end;
      if not SeekEof(fout) then Ex('Extra numbers', 2);
      if not SeekEof(fans) then Ex('Too few numbers', 2);
   except
      Ex('PE', 2, i);
   end;
   Ex('', 0);
end.
