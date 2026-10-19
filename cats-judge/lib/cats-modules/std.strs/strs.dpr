{$APPTYPE CONSOLE}
uses
  SysUtils;

var
  fin,fout,fans: TextFile;
  
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
   s1, s2: String;
   i: integer;
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
      while (not eof(fout)) and (not eof(fans)) do begin
         inc(i);
         readln(fout,s1); readln(fans,s2);
         if s1 <> s2 then begin
            Ex('WA', 1, i);
         end;
      end;
      if not eof(fout) then Ex('Extra lines', 2);
      if not eof(fans) then Ex('Too few lines', 2);
   except
      Ex('PE', 2, i);
   end;
   Ex('', 0);
end.
