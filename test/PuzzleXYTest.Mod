MODULE PuzzleXYTest;  (** PuzzleXYTest.Run: the board maker, its two pictures, tiles slid and scrambled; needs the desktop's display *)

IMPORT Texts, Objects, Gadgets, Attributes, Out, LayLa, PuzzleXY, PuzzleLayLaP;

VAR fails, checks: LONGINT; panel: Objects.Object;

PROCEDURE Check(what: ARRAY OF CHAR; ok: BOOLEAN);
BEGIN
  INC(checks);
  IF ~ok THEN INC(fails); Out.String("FAIL "); Out.String(what); Out.Ln END
END Check;

PROCEDURE Int(name: ARRAY OF CHAR): LONGINT;
VAR i: LONGINT;
BEGIN Attributes.GetInt(Gadgets.FindObj(panel, name), "Value", i); RETURN i
END Int;

(* the values of the nine tiles, row by row, "." for the free one *)
PROCEDURE Board(VAR s: ARRAY OF CHAR);
VAR row, col, i: INTEGER; name, val: ARRAY 8 OF CHAR;
BEGIN
  i := 0;
  FOR row := 1 TO 3 DO
    FOR col := 1 TO 3 DO
      name := "1.1"; name[0] := CHR(ORD("0") + row); name[2] := CHR(ORD("0") + col);
      Attributes.GetString(Gadgets.FindObj(panel, name), "Value", val);
      IF val[0] # 0X THEN s[i] := val[0] ELSE s[i] := "." END; INC(i)
    END
  END;
  s[i] := 0X
END Board;

PROCEDURE Click(name: ARRAY OF CHAR);
BEGIN Gadgets.context := panel; Gadgets.executorObj := Gadgets.FindObj(panel, name); PuzzleXY.Play
END Click;

PROCEDURE Tile(VAR W: Texts.Writer; me, n: ARRAY OF CHAR);
BEGIN
  Texts.WriteString(W, '(NEW ButtonField.New (w=40 h=40) (ATTR Name="'); Texts.WriteString(W, me);
  Texts.WriteString(W, '" Value="'); Texts.WriteString(W, n); Texts.WriteString(W, '" Cmd="PuzzleXY.Play"))')
END Tile;

PROCEDURE Has(s: ARRAY OF CHAR; c: CHAR): BOOLEAN;
VAR i: INTEGER;
BEGIN
  i := 0; WHILE (s[i] # 0X) & (s[i] # c) DO INC(i) END;
  RETURN s[i] = c
END Has;

PROCEDURE Run*;
VAR T: Texts.Text; W: Texts.Writer; s, free: ARRAY 16 OF CHAR; i, n: INTEGER; ok: BOOLEAN;
BEGIN
  fails := 0; checks := 0;
  NEW(T); Texts.Open(T, "PuzzleLayLaP.Desc"); panel := LayLa.ParseText(T, 0);
  Check("PuzzleLayLaP.Desc", (panel # NIL) & (Gadgets.FindObj(panel, "PictName") # NIL));
  IF panel = NIL THEN RETURN END;
  Gadgets.context := panel; PuzzleLayLaP.LoadPict;
  Check("Egypt.Pict loaded", (Int("ow") > 0) & (Int("oh") > 0));
  Check("a board of 5 by 5 tiles of 60 pixels", (Int("pw") = 300) & (Int("ph") = 300));
  Attributes.SetString(Gadgets.FindObj(panel, "PictName"), "Value", "l038102.jpg");
  Gadgets.context := panel; PuzzleLayLaP.LoadPict;
  Check("l038102.jpg loaded", (Int("ow") > 0) & (Int("oh") > 0));
  (* a board of 3 by 3 tiles, as the board maker writes them *)
  Texts.OpenWriter(W);
  Texts.WriteString(W, '(TABLE Panel (border=8 dist=0 cols=3) (LINKS Model=(NEW String (ATTR Name="Free" Value="3.3")))');
  Tile(W, "1.1", "1"); Tile(W, "1.2", "2"); Tile(W, "1.3", "3"); Tile(W, "2.1", "4"); Tile(W, "2.2", "5");
  Tile(W, "2.3", "6"); Tile(W, "3.1", "7"); Tile(W, "3.2", "8"); Tile(W, "3.3", ""); Texts.Write(W, ")");
  NEW(T); Texts.Open(T, ""); Texts.Append(T, W.buf); panel := LayLa.ParseText(T, 0);
  Board(s); Check("a board of 3 by 3", (panel # NIL) & (s = "12345678."));
  Click("3.1"); Board(s); Check("two tiles slid right", s = "123456.78");
  Click("1.1"); Board(s); Check("two tiles slid down", s = ".23156478");
  Click("2.2"); Board(s); Check("a tile not in line stays", s = ".23156478");
  Gadgets.context := panel; PuzzleXY.Scramble; Board(s);
  Attributes.GetString(Gadgets.FindObj(panel, "Free"), "Value", free);
  ok := TRUE; n := 0;
  FOR i := 0 TO 8 DO
    IF s[i] = "." THEN INC(n); ok := ok & (free[0] = CHR(ORD("1") + i DIV 3)) & (free[2] = CHR(ORD("1") + i MOD 3)) END
  END;
  FOR i := 1 TO 8 DO ok := ok & Has(s, CHR(ORD("0") + i)) END;
  Check("scrambled: eight tiles and the free place", ok & (n = 1));
  Out.String("PuzzleXYTest: "); Out.Int(checks, 0); Out.String(" checks, "); Out.Int(fails, 0); Out.String(" failed"); Out.Ln
END Run;

END PuzzleXYTest.
