REM               *****************************************
REM               ***           Dice - Atoms 2.0 (safe) ***
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
     DIM sides(5)         'number of sides on parent-/(1-4)daughter-dice (1/probability of decay; sides one is not the
                           'number of sides on the Daughter1 die, but on the parent die)
     DIM throws           'number of throws
     DIM x                'transcription of counter2
     DIM throw            'counter for the current throw
     DIM dicethrow        'resulting value of a dicethrow
     DIM parents          'number of remaining parents
     DIM daughters(5)     'number of atoms that have become a daughter (1/2/3/4/5) of yet
     DIM daughternumber   'number of different kinds of daughter atoms (1,2,3,4,or 5)


CLS
RANDOMIZE TIMER     'initializes the random-number-generator
  
REM ask for starting data
     COLOR 15, 0
     PRINT , "*****************************************"
     PRINT , "***           Dice - Atoms 2.0 (safe) ***"
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
     PRINT
     IF columns > 40 THEN GOTO 30       'checks if column is valid
     LET parents = rows * columns
60   PRINT "Please insert how many different kind of daughters there are between "
     PRINT "the parent state and the final daughter state (max. 4)": INPUT daughternumber
     PRINT
     IF daughternumber < 0 OR daughternumber > 4 THEN GOTO 60         'checks if daughternumber valid
     LET daughternumber = daughternumber + 1                          'also the final daughter must be included in the daughternumber
    
70   PRINT "Please insert the number of sides on a parent die (= 1/(probability of decay)": INPUT sides(1)
     PRINT
     FOR counter = 2 TO daughternumber
     PRINT "Please insert the number of sides on a D"; : PRINT counter - 1; : PRINT " die (1/probability of decay)": INPUT sides(counter)
     PRINT
     NEXT counter
50   PRINT "Please insert the number of throws :   ": INPUT throws
     PRINT

REM write header in outputfile
     PRINT #1, "*****************************************"
     PRINT #1, "***           Dice - Atoms 2.0 (safe) ***"
     PRINT #1, "*** A Simulation of Radioactive Decay ***"
     PRINT #1, "*****************************************"
     PRINT #1, ""
     PRINT #1, "written by Michael Goerz; 6/2/2000; Freeware"
     PRINT #1, "": PRINT #1, ""
     PRINT #1, "Date and Time of Experiment:   "; : PRINT #1, DATE$; : PRINT #1, " ;  "; : PRINT #1, TIME$
     PRINT #1, "Number of Parents:   "; : PRINT #1, columns * rows
     PRINT #1, "Number of Daughters Between Parent State and Final Daughter State:   "; : PRINT #1, daughternumber - 1
     IF daughternumber = 1 THEN
          PRINT #1, "Number of Sides on a Parent Die:   "; : PRINT #1, sides(1)
     END IF
     IF daughternumber = 2 THEN
          PRINT #1, "Number of Sides on a Parent Die:   "; : PRINT #1, sides(1)
          PRINT #1, "Number of Sides on a D1 Die:   "; : PRINT #1, sides(2)
     END IF
     IF daughternumber = 3 THEN
          PRINT #1, "Number of Sides on a Parent Die:   "; : PRINT #1, sides(1)
          PRINT #1, "Number of Sides on a D1 Die:   "; : PRINT #1, sides(2)
          PRINT #1, "Number of Sides on a D2 Die:   "; : PRINT #1, sides(3)
     END IF
     IF daughternumber = 4 THEN
          PRINT #1, "Number of Sides on a Parent Die:   "; : PRINT #1, sides(1)
          PRINT #1, "Number of Sides on a D1 Die:   "; : PRINT #1, sides(2)
          PRINT #1, "Number of Sides on a D2 Die:   "; : PRINT #1, sides(3)
          PRINT #1, "Number of Sides on a D3 Die:   "; : PRINT #1, sides(4)
     END IF
     IF daughternumber = 5 THEN
          PRINT #1, "Number of Sides on a Parent Die:   "; : PRINT #1, sides(1)
          PRINT #1, "Number of Sides on a D1 Die:   "; : PRINT #1, sides(2)
          PRINT #1, "Number of Sides on a D2 Die:   "; : PRINT #1, sides(3)
          PRINT #1, "Number of Sides on a D3 Die:   "; : PRINT #1, sides(4)
          PRINT #1, "Number of Sides on a D4 Die:   "; : PRINT #1, sides(5)
     END IF
     PRINT #1, "Number of Throws:   "; : PRINT #1, throws
     PRINT #1, "": PRINT #1, ""
     IF daughternumber = 1 THEN
          PRINT #1, "Throw", : PRINT #1, "Parents", : PRINT #1, "Df"
          PRINT #1, " 0", : PRINT #1, columns * rows, : PRINT #1, " 0"
     END IF
     IF daughternumber = 2 THEN
          PRINT #1, "Throw", : PRINT #1, "Parents", : PRINT #1, "D1", : PRINT #1, "Df"
          PRINT #1, " 0", : PRINT #1, columns * rows, : PRINT #1, " 0", : PRINT #1, " 0"; ""
     END IF
     IF daughternumber = 3 THEN
          PRINT #1, "Throw", : PRINT #1, "Parents", : PRINT #1, "D1",
          PRINT #1, "D2", : PRINT #1, "Df"
          PRINT #1, " 0", : PRINT #1, columns * rows, : PRINT #1, " 0",
          PRINT #1, " 0", : PRINT #1, " 0"
     END IF
     IF daughternumber = 4 THEN
          PRINT #1, "Throw", : PRINT #1, "Parents", : PRINT #1, "D1",
          PRINT #1, "D2", : PRINT #1, "D3", : PRINT #1, "Df"
          PRINT #1, " 0", : PRINT #1, columns * rows, : PRINT #1, " 0",
          PRINT #1, " 0", : PRINT #1, " 0", : PRINT #1, " 0"
     END IF
     IF daughternumber = 5 THEN
          PRINT #1, "Throw", : PRINT #1, "Parents", : PRINT #1, "D1",
          PRINT #1, "D2", : PRINT #1, "D3", : PRINT #1, "D4", : PRINT #1, "Df"
          PRINT #1, " 0", : PRINT #1, columns * rows, : PRINT #1, " 0",
          PRINT #1, " 0", : PRINT #1, " 0", : PRINT #1, " 0", : PRINT #1, " 0"
     END IF
     


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
                    LET x = counter2                'counter2 must be transcribed to x, because calculations need to be done with the
                                                    'counter2 value in order to get the real column, but counter2 itself may not be changed
                    LET x = (x * 2) - 1             'calculates the column-screen-value for the next die
                    LOCATE counter, x
               REM check state of dice
                    IF SCREEN(counter, x) = 220 THEN   'atom is parent
                         IF daughternumber > 1 THEN    'throw the dice to change atom to D1
                              GOSUB 2000
                         END IF
                         IF daughternumber = 1 THEN    'throw the dice to change atom to Df
                              GOSUB 7000
                         END IF
                         GOTO 100
                    END IF
                    IF SCREEN(counter, x) = 15 AND SCREEN(counter, x, 1) = 126 THEN 'atom is D1
                         IF daughternumber > 2 THEN    'throw the dice to change atom to D2
                              GOSUB 3000
                         END IF
                         IF daughternumber = 2 THEN    'throw the dice to change atom to Df
                              GOSUB 8000
                         END IF
                         GOTO 100
                    END IF
                    IF SCREEN(counter, x) = 15 AND SCREEN(counter, x, 1) = 122 THEN 'atom is D2
                         IF daughternumber > 3 THEN    'throw the dice to change atom to D3
                              GOSUB 4000
                         END IF
                         IF daughternumber = 3 THEN    'throw the dice to change atom to Df
                              GOSUB 9000
                         END IF
                         GOTO 100
                    END IF
                    IF SCREEN(counter, x) = 15 AND SCREEN(counter, x, 1) = 113 THEN 'atom is D3
                         IF daughternumber > 4 THEN    'throw the dice to change atom to D4
                              GOSUB 5000
                         END IF
                         IF daughternumber = 4 THEN    'throw the dice to change atom to Df
                              GOSUB 10000
                         END IF
                         GOTO 100
                    END IF
                    IF SCREEN(counter, x) = 15 AND SCREEN(counter, x, 1) = 117 THEN 'atom is D4
                         GOSUB 6000  'throw the dice to change atom to Df
                    END IF
100          NEXT counter2
          NEXT counter
         
          REM write results of throw on the screen and in the output-file
          GOSUB 1000
          IF daughternumber = 1 THEN
               COLOR 15, 0: LOCATE 22, 1: PRINT "#"
               LOCATE 22, 6: PRINT "P"
               LOCATE 22, 12: PRINT "Df"
               COLOR 15, 0: LOCATE 23, 1: PRINT throw
               LOCATE 23, 6: PRINT parents
               LOCATE 23, 12: PRINT daughters(5)
               COLOR 7, 0: LOCATE 23, 50: PRINT " press <CTRL> for next throw"
               SLEEP 60            'wait for CTRL key
               PRINT #1, throw,
               PRINT #1, parents,
               PRINT #1, daughters(5)
          END IF
          IF daughternumber = 2 THEN
               COLOR 15, 0: LOCATE 22, 1: PRINT "#"
               LOCATE 22, 6: PRINT "P"
               LOCATE 22, 12: PRINT "D1"
               LOCATE 22, 18: PRINT "Df"
               COLOR 15, 0: LOCATE 23, 1: PRINT throw
               LOCATE 23, 6: PRINT parents
               LOCATE 23, 12: PRINT daughters(1)
               LOCATE 23, 18: PRINT daughters(5)
               COLOR 7, 0: LOCATE 23, 50: PRINT " press <CTRL> for next throw"
               SLEEP 60            'wait for CTRL key
               PRINT #1, throw,
               PRINT #1, parents,
               PRINT #1, daughters(1),
               PRINT #1, daughters(5)
          END IF
          IF daughternumber = 3 THEN
               COLOR 15, 0: LOCATE 22, 1: PRINT "#"
               LOCATE 22, 6: PRINT "P"
               LOCATE 22, 12: PRINT "D1"
               LOCATE 22, 18: PRINT "D2"
               LOCATE 22, 24: PRINT "Df"
               COLOR 15, 0: LOCATE 23, 1: PRINT throw
               LOCATE 23, 6: PRINT parents
               LOCATE 23, 12: PRINT daughters(1)
               LOCATE 23, 18: PRINT daughters(2)
               LOCATE 23, 24: PRINT daughters(5)
               COLOR 7, 0: LOCATE 23, 50: PRINT " press <CTRL> for next throw"
               SLEEP 60            'wait for CTRL key
               PRINT #1, throw,
               PRINT #1, parents,
               PRINT #1, daughters(1),
               PRINT #1, daughters(2),
               PRINT #1, daughters(5)
          END IF
          IF daughternumber = 4 THEN
               COLOR 15, 0: LOCATE 22, 1: PRINT "#"
               LOCATE 22, 6: PRINT "P"
               LOCATE 22, 12: PRINT "D1"
               LOCATE 22, 18: PRINT "D2"
               LOCATE 22, 24: PRINT "D3"
               LOCATE 22, 30: PRINT "Df"
               COLOR 15, 0: LOCATE 23, 1: PRINT throw
               LOCATE 23, 6: PRINT parents
               LOCATE 23, 12: PRINT daughters(1)
               LOCATE 23, 18: PRINT daughters(2)
               LOCATE 23, 24: PRINT daughters(3)
               LOCATE 23, 30: PRINT daughters(5)
               COLOR 7, 0: LOCATE 23, 50: PRINT " press <CTRL> for next throw"
               SLEEP 60            'wait for CTRL key
               PRINT #1, throw,
               PRINT #1, parents,
               PRINT #1, daughters(1),
               PRINT #1, daughters(2),
               PRINT #1, daughters(3),
               PRINT #1, daughters(5)

          END IF
          IF daughternumber = 5 THEN
               COLOR 15, 0: LOCATE 22, 1: PRINT "#"
               LOCATE 22, 6: PRINT "P"
               LOCATE 22, 12: PRINT "D1"
               LOCATE 22, 18: PRINT "D2"
               LOCATE 22, 24: PRINT "D3"
               LOCATE 22, 30: PRINT "D4"
               LOCATE 22, 36: PRINT "Df"
               COLOR 15, 0: LOCATE 23, 1: PRINT throw
               LOCATE 23, 6: PRINT parents
               LOCATE 23, 12: PRINT daughters(1)
               LOCATE 23, 18: PRINT daughters(2)
               LOCATE 23, 24: PRINT daughters(3)
               LOCATE 23, 30: PRINT daughters(4)
               LOCATE 23, 36: PRINT daughters(5)
               COLOR 7, 0: LOCATE 23, 50: PRINT " press <CTRL> for next throw"
               SLEEP 60            'wait for CTRL key
               PRINT #1, throw,
               PRINT #1, parents,
               PRINT #1, daughters(1),
               PRINT #1, daughters(2),
               PRINT #1, daughters(3),
               PRINT #1, daughters(4),
               PRINT #1, daughters(5)
          END IF
         
         
     NEXT throw



END
           


REM Subfunctions

1000 REM clear text field
     COLOR 15, 0
     LOCATE 22, 1: PRINT "                                                                            "
     LOCATE 23, 1: PRINT "                                                                            "
     GOSUB 11000
     RETURN
2000 REM change parent to D1
     LET dicethrow = INT((RND * sides(1)) + 1)
     IF dicethrow = 1 THEN                        'atom decays
          COLOR 14, 7: PRINT CHR$(15): COLOR 15, 0
          LET parents = parents - 1
          LET daughters(1) = daughters(1) + 1
          COLOR 15, 0
     END IF
     RETURN
3000 REM change D1 to D2
     LET dicethrow = INT((RND * sides(2)) + 1)
     IF dicethrow = 1 THEN                        'atom decays
          COLOR 10, 7: PRINT CHR$(15): COLOR 15, 0
          LET daughters(1) = daughters(1) - 1
          LET daughters(2) = daughters(2) + 1
          COLOR 15, 0
     END IF
     RETURN
4000 REM change D2 to D3
     LET dicethrow = INT((RND * sides(3)) + 1)
     IF dicethrow = 1 THEN                        'atom decays
          COLOR 1, 7: PRINT CHR$(15): COLOR 15, 0
          LET daughters(2) = daughters(2) - 1
          LET daughters(3) = daughters(3) + 1
          COLOR 15, 0
     END IF
     RETURN
5000 REM change D3 to D4
     LET dicethrow = INT((RND * sides(4)) + 1)
     IF dicethrow = 1 THEN                        'atom decays
          COLOR 5, 7: PRINT CHR$(15): COLOR 15, 0
          LET daughters(3) = daughters(3) - 1
          LET daughters(4) = daughters(4) + 1
          COLOR 15, 0
     END IF
     RETURN
6000 REM change D4 to Df
     LET dicethrow = INT((RND * sides(5)) + 1)
     IF dicethrow = 1 THEN                        'atom decays
          COLOR 4, 7: PRINT CHR$(42): COLOR 15, 0
          LET daughters(4) = daughters(4) - 1
          LET daughters(5) = daughters(5) + 1
          COLOR 15, 0
     END IF
     RETURN
7000 REM change parent to Df
     LET dicethrow = INT((RND * sides(1)) + 1)
     IF dicethrow = 1 THEN                        'atom decays
          COLOR 4, 7: PRINT CHR$(42): COLOR 15, 0
          LET parents = parents - 1
          LET daughters(5) = daughters(5) + 1
          COLOR 15, 0
     END IF
     RETURN
8000 REM change D1 to Df
     LET dicethrow = INT((RND * sides(2)) + 1)
     IF dicethrow = 1 THEN                        'atom decays
          COLOR 4, 7: PRINT CHR$(42): COLOR 15, 0
          LET daughters(1) = daughters(1) - 1
          LET daughters(5) = daughters(5) + 1
          COLOR 15, 0
     END IF
     RETURN
9000 REM change D2 to Df
     LET dicethrow = INT((RND * sides(3)) + 1)
     IF dicethrow = 1 THEN                        'atom decays
          COLOR 4, 7: PRINT CHR$(42): COLOR 15, 0
          LET daughters(2) = daughters(2) - 1
          LET daughters(5) = daughters(5) + 1
          COLOR 15, 0
     END IF
     RETURN
10000 REM change D3 to Df
     LET dicethrow = INT((RND * sides(4)) + 1)
     IF dicethrow = 1 THEN                        'atom decays
          COLOR 4, 7: PRINT CHR$(42): COLOR 15, 0
          LET daughters(3) = daughters(3) - 1
          LET daughters(5) = daughters(5) + 1
          COLOR 15, 0
     END IF
     RETURN
11000 REM print information about what color/symbol represents what state
     LOCATE 22, 51
     IF daughternumber = 1 THEN
          COLOR 15, 7: PRINT " ";
          COLOR 9, 7: PRINT CHR$(220); : COLOR 15, 7: PRINT " "; : PRINT CHR$(16); : PRINT " ";     'Parent
          COLOR 4, 7: PRINT CHR$(42)                                                                 'Df
     END IF
     IF daughternumber = 2 THEN
          COLOR 15, 7: PRINT " ";
          COLOR 9, 7: PRINT CHR$(220); : COLOR 15, 7: PRINT " "; : PRINT CHR$(16); : PRINT " ";     'Parent
          COLOR 14, 7: PRINT CHR$(15); : COLOR 15, 7: PRINT " "; : PRINT CHR$(16); : PRINT " ";      'D1
          COLOR 4, 7: PRINT CHR$(42)                                                                 'Df
     END IF
     IF daughternumber = 3 THEN
          COLOR 15, 7: PRINT " ";
          COLOR 9, 7: PRINT CHR$(220); : COLOR 15, 7: PRINT " "; : PRINT CHR$(16); : PRINT " ";     'Parent
          COLOR 14, 7: PRINT CHR$(15); : COLOR 15, 7: PRINT " "; : PRINT CHR$(16); : PRINT " ";      'D1
          COLOR 10, 7: PRINT CHR$(15); : COLOR 15, 7: PRINT " "; : PRINT CHR$(16); : PRINT " ";      'D2
          COLOR 4, 7: PRINT CHR$(42)                                                                 'Df
     END IF
     IF daughternumber = 4 THEN
          COLOR 15, 7: PRINT " ";
          COLOR 9, 7: PRINT CHR$(220); : COLOR 15, 7: PRINT " "; : PRINT CHR$(16); : PRINT " ";     'Parent
          COLOR 14, 7: PRINT CHR$(15); : COLOR 15, 7: PRINT " "; : PRINT CHR$(16); : PRINT " ";      'D1
          COLOR 10, 7: PRINT CHR$(15); : COLOR 15, 7: PRINT " "; : PRINT CHR$(16); : PRINT " ";      'D2
          COLOR 1, 7: PRINT CHR$(15); : COLOR 15, 7: PRINT " "; : PRINT CHR$(16); : PRINT " ";       'D3
          COLOR 4, 7: PRINT CHR$(42)                                                                 'Df
     END IF
     IF daughternumber = 5 THEN
          COLOR 15, 7: PRINT " ";
          COLOR 9, 7: PRINT CHR$(220); : COLOR 15, 7: PRINT " "; : PRINT CHR$(16); : PRINT " ";     'Parent
          COLOR 14, 7: PRINT CHR$(15); : COLOR 15, 7: PRINT " "; : PRINT CHR$(16); : PRINT " ";      'D1
          COLOR 10, 7: PRINT CHR$(15); : COLOR 15, 7: PRINT " "; : PRINT CHR$(16); : PRINT " ";      'D2
          COLOR 1, 7: PRINT CHR$(15); : COLOR 15, 7: PRINT " "; : PRINT CHR$(16); : PRINT " ";       'D3
          COLOR 5, 7: PRINT CHR$(15); : COLOR 15, 7: PRINT " "; : PRINT CHR$(16); : PRINT " ";       'D4
          COLOR 4, 7: PRINT CHR$(42)                                                                 'Df
     END IF
     RETURN

