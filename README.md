# gadgets-games-puzzlexy

PuzzleXY for the gadgets of [polpo](https://github.com/polpo-system/polpo): the sliding puzzle of
15, on boards of any width and height, with numbers or a picture on the tiles. A board maker cuts
a picture into tiles and makes the board.

```
portia.Install gadgets-games-puzzlexy
```

## Playing

    PuzzleLayLaP.GUI        the board maker

In the board maker set the picture (Egypt.Pict and l038102.jpg come with the game), the number of
tiles across and down and the size of a tile, then Create board. On the board Scramble mixes the
tiles; a middle click on a tile in the row or the column of the free place slides it there, with
the tiles between; Flip Tiles shows the numbers or the picture. `tools/PuzzleXY.Tool` has the
details.

## What is here

    src/PuzzleXY.Mod              the game, for boards of any size
    src/PuzzleLayLaP.Mod          the board maker: writes the LayLa description of a board
    share/PuzzleLayLaP.Desc       the board maker's own panel, in LayLa
    share/Egypt.Pict, share/l038102.jpg   the pictures
    tools/PuzzleXY.Tool
    test/PuzzleXYTest.Mod

PuzzleXY is by André Fischer, one of his examples in the documentation of ETH Native Oberon 2.3.7
(docu/). The first commit has the files as they are there, the second the sources as plain text.
The tiles are ButtonField gadgets with Rembrandt pictures as their look. The package needs
gadgets-layla, gadgets-buttonfield, gadgets-rembrandt and jpeg (for l038102.jpg).

One change: PuzzleLayLaP calls SetParams before declaring it, which the x86 compiler takes and the
others do not; a forward declaration lets it compile with all eight of polpo's compilers.

The source of PuzzleXY ends with two boards of 4 by 4 written by hand; the game no longer works
with them (one has plain buttons, the other names commands the module does not have), so the board
maker is the way to a board.

## Tests

    PuzzleXYTest.Run    9 checks: the board maker made and both pictures loaded into it, tiles of a
                        board of 3 by 3 slid and scrambled; it needs the desktop's display

The license is GPL-3 (`LICENSE`); the code comes from ETH Oberon, whose license (`LICENSE.ETH`)
asks to keep its copyright notice and conditions, which `LICENSE.ETH` does.
