{$APPTYPE CONSOLE}
{$LONGSTRINGS ON}
uses SysUtils;

var fin,fout,fans : text;
    i: integer;
    s1,s2 : string;
    f1,f2 : boolean;

procedure Ex(s : string; ec: integer; ln: integer = -1);
begin
   write(s);
   if ln >= 0 then write(' in pos ', ln);
   try
     close(fin); close(fout); close(fans);
   except
   end;
   halt(ec);
end;

function GNLN(var f : text; var s : string; c : integer) : boolean;
var st : longint;
    ch : char;
begin
   result := false; st := 0; s := '';
   while not eof(f) do begin
      ch := #0;
      read(f,ch);
      if not (ch in ['0'..'9', ' ', '-', #13, #10]) then begin
         if c = 1 then Ex('PE: bad chars in out', 2);
         if c = 2 then Ex('IE: bad chars in ans', 3);
      end;
      case st of
         0 : begin
            if (ch = '0') then st := 1;
            if (ch > '0') and (ch <= '9') or (ch = '-') then st := 2;
         end;
         1 : begin
            if (ch > '0') and (ch <= '9')  or (ch = '-') then st := 2;
            if ((ch < '0') or (ch > '9')) and (ch <> '-') then break;
         end;
         2 : begin
            if ((ch < '0') or (ch > '9')) and (ch <> '-') then break;
         end;
      end;
      if st = 2 then if ch in ['0'..'9', '-'] then
      begin
        s := s + ch;
        if (length(s) <> 1) and (s[length(s)] = '-') then
          Ex('PE: bad chars in out', 2);
      end;
   end;
   if st = 1 then begin st := 2; s := '0'; end;
   if st = 2 then result := true;
end;

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
      while (true) do begin
         inc(i);
         f1 := GNLN(fout, s1, 1); f2 := GNLN(fans, s2, 2);
         if (not f1) and (not f2) then break;
         if f1 and not f2 then Ex('Extra numbers', 2);
         if not f1 and f2 then Ex('Too few numbers', 2);
         if (s1 <> s2) then Ex('WA', 1, i);
      end;
   except
      Ex('PE', 2, i);
   end;
   Ex('', 0);
end.

