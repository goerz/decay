REM               *****************************************
REM               ***           Dice - Atoms (safe)     ***
REM               *** A Simulation of Radioactive Decay ***
REM               *****************************************
REM
REM              written by Michael Goerz; 6/2/2000; Freeware
          

REM list of variables
     DIM counter          'counter variable in for-next-loops
     DIM counter2         '2nd counter variable in for-next loops
     DIM rows             'number of rows for the dice field (rows * columns = number of dice)
     DIM columns          'number of columns for the dice field (rows * columns = number of dice)
     DIM file$            'path and name of file in which the data is recorded
     DIM sides            'number of sides on one die
     DIM throws           'number of throws
     DIM x                'transcription of counter2
     DIM throw            'counter for the current throw
     DIM dicethrow        'resulting value of a dicethrow
     DIM parents          'number of remaining parents
     DIM daughters        'number of atoms that have become daughters yet


CLS
RANDOMIZE TIMER     'initializes the random-number-generator

REM ask for starting data
     COLOR 15, 0
     PRINT , "*****************************************"
     PRINT , "***           Dice - Atoms (safe)     ***"
     PRINT , "*** A Simulation of Radioactive Decay ***"
     PRINT , "*****************************************"
     PRINT , ""
     PRINT , "written by Michael Goerz; 6/2/2000; Freeware"
     PRINT , "": PRINT , ""
10   PRINT "Please insert the full path of the file in which the data is to be stored "
     INPUT file$
     LET file$ = UCASE$(file$)
     IF LEFT$(file$, 11) <> "A:\REPORTS\" THEN
          PRINT "You are not allowed to save in the specified path!!!"
          GOTO 10
     END IF
     OPEN file$ FOR OUTPUT AS #1
     PRINT
20   PRINT "Please insert number of rows  (max. 20) :  "; : INPUT rows
     IF rows > 20 THEN GOTO 20          'checks if row is valid
     PRINT
30   PRINT "Please insert number of columns (max. 40) :  "; : INPUT columns
     IF columns > 40 THEN GOTO 30       'checks if column is valid
     LET parents = rows * columns
     LET daughter = 0
     PRINT
40   PRINT "Please insert the number of sides on a die (= 1/(probability of decay)": INPUT sides
     PRINT
50   PRINT "Please insert the number of throws :   ": INPUT throws
     PRINT

REM write header in outputfile
     PRINT #1, "*****************************************"
     PRINT #1, "***           Dice - Atoms (safe)     ***"
     PRINT #1, "*** A Simulation of Radioactive Decay ***"
     PRINT #1, "*****************************************"
     PRINT #1, ""
     PRINT #1, "written by Michael Goerz; 6/2/2000; Freeware"
     PRINT #1, "": PRINT #1, ""
     PRINT #1, "Date and Time of Experiment:   "; : PRINT #1, DATE$; : PRINT #1, " ;  "; : PRINT #1, TIME$
     PRINT #1, "Number of Dice:   "; : PRINT #1, columns * rows
     PRINT #1, "Number of Sides on a Die:   "; : PRINT #1, sides
     PRINT #1, "Number of Throws:   "; : PRINT #1, throws
     PRINT #1, "": PRINT #1, ""
     PRINT #1, "Throw", : PRINT #1, "Parents", : PRINT #1, "Daughters"
     PRINT #1, " 0", : PRINT #1, columns * rows, : PRINT #1, " 0"

REM draw dice field
     CLS
     LOCATE 1, 1
     COLOR 9, 7
     FOR counter = 1 TO rows                        'number of rows
          FOR counter2 = 1 TO columns               'number of columns
               PRINT CHR$(220); : PRINT " ";        '220 is the ASCII-code for the sumbol of a parent atom
          NEXT counter2
          PRINT
     NEXT counter

REM draw separation line
     LOCATE 21, 1
     COLOR 15, 0
     FOR counter = 1 TO 80
          PRINT CHR$(205);
     NEXT counter
   
REM start throwing the dice
     LOCATE 1, 1
     COLOR 9, 7
     FOR throw = 1 TO throws
          LOCATE 1, 1
          COLOR 9, 7
          FOR counter = 1 TO rows                        'number of rows
               FOR counter2 = 1 TO columns               'number of columns
                    LET x = counter2                'counter2 must be transcibed to x, because calculations need to be done with the
                                                    'counter2 value in order to get the real column, but counter2 itself may not be changed
                    LET x = (x * 2) - 1             'calculates the column-screen-value for the next die
                    LOCATE counter, x
                    IF SCREEN(counter, x) = 42 THEN GOTO 100     'atom is already daughter
                    LET dicethrow = INT((RND * sides) + 1)
                    IF dicethrow = 1 THEN                        'atom becomes daughter
                         COLOR 4, 7: PRINT "*": COLOR 15, 0
                         LET parents = parents - 1
                         LET daughters = daughters + 1
                         COLOR 15, 0
                    END IF
100            NEXT counter2
          NEXT counter
          REM document results of throw on the screen and in the output-file
          GOSUB 1000
          COLOR 15, 0: LOCATE 22, 1: PRINT "throw", : PRINT "parents", : PRINT "daughters"
          COLOR 15, 0: LOCATE 23, 2: PRINT throw, : PRINT parents, : PRINT daughters, : COLOR 7, 0: LOCATE 23, 50: PRINT " press <CTRL> for next throw"
          SLEEP 60            'wait for CTRL key
          PRINT #1, throw, : PRINT #1, parents, : PRINT #1, daughters
          COLOR 15, 0
     NEXT throw



END
           


REM Subfunctions

1000 REM clear text field
     COLOR 15, 0
     LOCATE 22, 1: PRINT "                                                                            "
     LOCATE 23, 1: PRINT "                                                                            "
     RETURN

