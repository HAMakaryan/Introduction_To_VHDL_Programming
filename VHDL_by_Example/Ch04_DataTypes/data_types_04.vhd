-- Chapter_4_Data_Types

-------------------------- DATA TYPES --------------------------

--  Type Declaration
--    Name Of The Type
--    Range Of The Type

----  Type declarations are allowed in
--      package declaration sections
--      entity declaration sections
--      architecture declaration sections
--      subprogram declaration sections
--      process declaration sections.

----  TYPE type_name IS type_mark;
--      A type_mark construct encompasses a wide range of methods for specifying
--      a type.
--      It can be anything from an enumeration of all of the values
--      of a type to a complex record structure.


-------------------------- Scalar Types --------------------------
--    Scalar types describe objects that can hold, at most, one value at a time.
--    Referencing the name of the object references the entire object.

----  Scalar types encompass these four classes of types:
--      Integer types
--      Real types
--      Enumerated types
--      Physical types

--                  ENUMERATED TYPES
--  All of the values of an enumerated type are user-defined.
--    These values can be identifiers or single-character literals.

TYPE fourval IS ( 'X', '0', '1', 'Z' );
--  Character literals are needed for values '1' and '0' to separate
--    these values from the integer values 1 and 0.

TYPE color IS ( red, yellow, blue, green, orange );
--  All identifiers of the type must be unique.

-- A typical use for an enumerated type would be representing all
--    of the instructions for a microprocessor as an enumerated type.
TYPE instruction IS ( add, sub, lda, ldb, sta, stb, outa, xfr );

--  The model that uses this type might look like this:
PACKAGE instr IS
  TYPE instruction IS ( add, sub, lda, ldb, sta, stb, outa, xfr );
END instr;

USE WORK.instr.ALL;

ENTITY mp IS
  PORT (
    instr     : IN    instruction;
    addr      : IN    INTEGER;
    data      : INOUT INTEGER
  );
END mp;


ARCHITECTURE mp OF mp IS
BEGIN
  PROCESS(instr)
    TYPE regtype IS ARRAY(0 TO 255) OF INTEGER;
    VARIABLE b    : INTEGER;
    VARIABLE a    : INTEGER;
    VARIABLE reg  : regtype;
  BEGIN
    --select instruction to
    CASE instr is --execute
      WHEN lda =>
        a := data;      --load a accumulator
      WHEN ldb =>
        b := data;      --load b accumulator
      WHEN add =>
        a := a + b;     --add accumulators
      WHEN sub =>
        a := a - b;      --subtract accumulators
      WHEN sta =>
        reg(addr) := a; --put a accum in reg array
      WHEN stb =>
        reg(addr) := b; --put b accum in reg array
      WHEN outa =>
        data <= a;      --output a accum
      WHEN xfr =>       --transfer b to a
        a := b;
    END CASE;
  END PROCESS;
END mp;


--  Another common example using enumerated types is a state machine.

ENTITY traffic_light IS
  PORT(
    sensor        : IN  std_logic;
    clock         : IN  std_logic;
    red_light     : OUT std_logic;
    green_light   : OUT std_logic;
    yellow_light  : OUT std_logic
  );
END traffic_light;

ARCHITECTURE simple OF traffic_light IS

  TYPE    t_state is (red, green, yellow);
  SIGNAL  present_state : t_state;
  SIGNAL  next_state    : t_state;

BEGIN

  PROCESS(present_state, sensor)
  BEGIN
    CASE present_state IS
      WHEN green =>
        next_state    <= yellow;
        red_light     <= '0';
        green_light   <= '1';
        yellow_light  <= '0';
      WHEN red =>
        red_light     <= '1';
        green_light   <= '0';
        yellow_light  <= '0';
        IF (sensor = '1') THEN
          next_state  <= green;
        ELSE
          next_state  <= red;
        END IF;
      WHEN yellow =>
        red_light     <= '0';
        green_light   <= '0';
        yellow_light  <= '1';
        next_state    <= red;
    END CASE;
  END PROCESS;

  PROCESS
  BEGIN
    WAIT UNTIL clock'EVENT and clock = '1';
    present_state <= next_state;
  END PROCESS;

END simple;



