-- Chapter_4_Data_Types

-------------------------- FILE TYPES --------------------------

READ    (file, data)  Procedure
  --  Procedure READ reads an object from the file and returns the object in argument data.
WRITE   (file, data)  Procedure
  --  Procedure WRITE writes argument data to the file specified by the file argument.
ENDFILE (file)        Function,   returns boolean
  --  function ENDFILE returns true when the file is currently at the end-of-file mark.

--    FILE TYPE DECLARATION
  TYPE Integer_File IS FILE OF INTEGER;

--    FILE OBJECT DECLARATION
--  A file object makes use of a file type and declares an object of type FILE.
--  The file mode can be IN or OUT.

FILE myfile : Integer_File IS IN "/doug/test/examples/data_file";


----    FILE TYPE EXAMPLES

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY rom IS
PORT(
    addr  : IN  INTEGER;
    cs    : IN  STD_LOGIC;
    data  : OUT INTEGER);
END rom;

ARCHITECTURE rom OF rom IS
BEGIN
  PROCESS(addr, cs)
    VARIABLE rom_init     : BOOLEAN := FALSE; --line 1
    TYPE rom_data_file_t IS FILE OF INTEGER;  --line 2
    FILE rom_data_file    : rom_data_file_t IS IN "/doug/dlp/test1.dat"; --line 3
    TYPE dtype IS ARRAY(0 TO 63) OF INTEGER;
    VARIABLE rom_data     : dtype;            --line 4
    VARIABLE i            : INTEGER := 0;     --line 5
  BEGIN
    IF (rom_init = false) THEN                --line 6
      WHILE NOT ENDFILE(rom_data_file) AND (i < 64) LOOP          --line 7
        READ(rom_data_file, rom_data(i)); --line 8
        i := i + 1;                       --line 9
      END LOOP;
      rom_init := true; --line 10
    END IF;
    IF (cs = '1') THEN --line 11
      data <= rom_data(addr); --line 12
    ELSE
      data <= -1; --line 13
    END IF;
  END PROCESS;
END rom;


----      SUBTYPES

TYPE    INTEGER IS     -2147483647 TO +2147483647;
SUBTYPE NATURAL IS INTEGER RANGE 0 TO +2147483647;

--    So why would a designer want to create a subtype?
--    There are two main reasons for doing so:

----  1.  To add constraints for selected signal assignment statements or
--      case statements.

---   2.  To create a resolved subtype. (Resolved types are discussed along
--      with resolution functions in Chapter 5.)


PACKAGE mux_types IS
  SUBTYPE eightval IS INTEGER RANGE 0 TO 7; --line 1
END mux_types;

USE WORK.mux_types.ALL;
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY mux8 IS
  PORT(
    I0  : IN  std_logic;
    I1  : IN  std_logic;
    I2  : IN  std_logic;
    I3  : IN  std_logic;
    I4  : IN  std_logic;
    I5  : IN  std_logic;
    I6  : IN  std_logic;
    I7  : IN  std_logic;
    sel : IN  eightval; --line 2
    q   : OUT std_logic
  );
END mux8;


ARCHITECTURE mux8 OF mux8 IS
BEGIN
WITH sel SELECT --line 3
Q <= I0 AFTER 10 ns WHEN 0, --line 4
     I1 AFTER 10 ns WHEN 1, --line 5
     I2 AFTER 10 ns WHEN 2, --line 6
     I3 AFTER 10 ns WHEN 3, --line 7
     I4 AFTER 10 ns WHEN 4, --line 8
     I5 AFTER 10 ns WHEN 5, --line 9
     I6 AFTER 10 ns WHEN 6, --line 10
     I7 AFTER 10 ns WHEN 7; --line 11
END mux8;




