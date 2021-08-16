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


-------------------------- Composite Types --------------------------

--    Array types are groups of elements of the same type, while record types
--  allow the grouping of elements of different types. Arrays are useful for
--  modeling linear structures such as RAMs and ROMs, while records are useful
--  for modeling data packets, instructions, and so on.

--    Composite types are another tool in the VHDL toolbox that allow very
--  abstract modeling of hardware. For instance, a single array type can
--  represent the storage required for a ROM.


--  ARRAY TYPES

  TYPE data_bus IS ARRAY(0 TO 31) OF BIT;

  VARIABLE X: data_bus;
  VARIABLE Y: BIT;

  Y := X (0); --line 1
  Y := X(15); --line 2

PACKAGE array_example IS
  TYPE data_bus   IS ARRAY(0 TO 31) OF BIT;
  TYPE small_bus  IS ARRAY(0 TO  7) OF BIT;
END array_example;

USE WORK.array_example.ALL;
ENTITY extract IS
  PORT (
    data      : IN  data_bus;
    start     : IN  INTEGER;
    data_out  : OUT small_bus
  );
END extract;

ARCHITECTURE test OF extract IS
BEGIN

  PROCESS(data, start)
  BEGIN
    FOR i IN 0 TO 7 LOOP
      data_out(i) <= data(i + start);
    END LOOP;
  END PROCESS;

END test;


--- In the next example, the base type of the array is another array:

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

PACKAGE memory IS
  CONSTANT width    : INTEGER := 3;
  CONSTANT memsize  : INTEGER := 7;
  TYPE data_out IS ARRAY(0 TO width)    OF std_logic;
  TYPE mem_data IS ARRAY(0 TO memsize)  OF data_out;
END memory;


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.memory.ALL;

ENTITY rom IS
  PORT(
    addr  : IN  INTEGER;
    data  : OUT data_out;
    cs    : IN  STD_LOGIC
  );
END rom;

ARCHITECTURE basic OF rom IS

  CONSTANT z_state : data_out := ('Z', 'Z', 'Z', 'Z');
  CONSTANT x_state : data_out := ('X', 'X', 'X', 'X');
  CONSTANT rom_data : mem_data := (
    ( '0', '0', '0', '0'),
    ( '0', '0', '0', '1'),
    ( '0', '0', '1', '0'),
    ( '0', '0', '1', '1'),
    ( '0', '1', '0', '0'),
    ( '0', '1', '0', '1'),
    ( '0', '1', '1', '0'),
    ( '0', '1', '1', '1')
  );

BEGIN
  ASSERT addr <= memsize
    REPORT "addr out of range"
    SEVERITY ERROR;

  data <= rom_data(addr)  AFTER 10 ns WHEN cs = '1' ELSE
          z_state         AFTER 20 ns WHEN cs = '0' ELSE
          x_state         AFTER 10 ns;

END basic;


assertion_statement ::= [ label : ] assertion ;
  assertion ::=
    assert condition
      [ report    expression ]
      [ severity  expression ]

type SEVERITY_LEVEL is (NOTE, WARNING, ERROR, FAILURE);


--    A single value can be returned from the array of arrays by using the
--  following syntax:

bit_value := rom_data(addr) (bit_index);


-------------- AGGREGATE
PROCESS(X)
TYPE bitvec IS ARRAY(0 TO 3) OF BIT;

VARIABLE Y : bitvec;
BEGIN
Y := ('1', '0', '1', '0');
Y := ('1', '0', OTHERS => '0');
----------------
----------------
----------------
END PROCESS;


------------  MULTIDIMENSIONAL ARRAYS
--    The constant rom_data in the rom example was represented using an
--  array of arrays. Following is another method for representing the data
--  with a multidimensional array:

TYPE mem_data_md IS ARRAY(0 TO memsize, 0 TO width) OF std_logic;

CONSTANT rom_data_md : mem_data := (
    ( '0', '0', '0', '0'),
    ( '0', '0', '0', '1'),
    ( '0', '0', '1', '0'),
    ( '0', '0', '1', '1'),
    ( '0', '1', '0', '0'),
    ( '0', '1', '0', '1'),
    ( '0', '1', '1', '0'),
    ( '0', '1', '1', '1')
  );

--  In the following example, a single element of the array is accessed:
  X := rom_data_md(3, 3);


------------  UNCONSTRAINED ARRAY TYPES

TYPE BIT_VECTOR IS ARRAY(NATURAL RANGE <>) OF BIT;

--    unconstrained shift-right function
PACKAGE mypack IS
  SUBTYPE   eightbit    IS BIT_VECTOR(0 TO 7);
  SUBTYPE   fourbit     IS BIT_VECTOR(0 TO 3);
  FUNCTION  shift_right(val : BIT_VECTOR)
  RETURN BIT_VECTOR;
END mypack;

PACKAGE BODY mypack IS
  FUNCTION shift_right(val : BIT_VECTOR) RETURN BIT_VECTOR IS
    VARIABLE result : BIT_VECTOR(0 TO (val'LENGTH -1) );
BEGIN
  result := val;
  IF (val'LENGTH > 1) THEN
    FOR i IN 0 TO (val'LENGTH -2) LOOP
      result(i) := result(i + 1);
    END LOOP;
    result(val'LENGTH -1) := 0;
  ELSE
    result(0) := 0;
  END IF;
  RETURN result;
  END shift_right;
END mypack;




------------  RECORD TYPESRECORD TYPES

TYPE optype IS ( add, sub, mpy, div, jmp );

TYPE instruction IS
RECORD
  opcode  : optype;
  src     : INTEGER;
  dst     : INTEGER;
END RECORD;


PROCESS(X)
  VARIABLE inst     : instruction;
  VARIABLE source   : INTEGER;
  VARIABLE dest     : INTEGER;
  VARIABLE operator : optype;
BEGIN
  source    := inst.src;        --Ok line 1
  dest      := inst.src;        --Ok line 2
  source    := inst.opcode;     --error line 3
  operator  := inst.opcode;     --Ok line 4
  inst.src  := dest;            --Ok line 5
  inst.dst  := dest;            --Ok line 6
  inst      := (add, dest, 2);  --Ok line 7
  inst      := (source);        --error line 8
END PROCESS;

--    More complex field types
--    A record for a data packet is shown here:

TYPE word IS ARRAY(0 TO 3) OF std_logic;

TYPE t_word_array IS ARRAY(0 TO 15) OF word;

TYPE addr_type IS
RECORD
  source  : INTEGER;
  key     : INTEGER;
END RECORD;

TYPE data_packet IS
RECORD
  addr      : addr_type;
  data      : t_word_array;
  checksum  : INTEGER;
  parity    : BOOLEAN;
END RECORD;

--    The following example shows how a variable of type data_packet
--  would be accessed:

PROCESS(X)
  VARIABLE packet : data_packet;
BEGIN
  packet.addr.key     := 5;                   --Ok line 1
  packet.addr         := (10, 20);            --Ok line 2
  packet.data(0)      := ('0', '0', '0', '0');--Ok line 3
  packet.data(10)(4)  := '1';                 --ERROR line 4
  packet.data(10)(0)  := '1';                 --Ok line 5
END PROCESS;


