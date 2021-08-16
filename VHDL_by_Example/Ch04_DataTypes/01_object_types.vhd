-- Object Types

--  A VHDL object consists of one of the following:

--SIGNAL , which represents interconnection wires that connect component
--instantiation ports together.
--
--VARIABLE, which is used for local storage of temporary data, visible
--only inside a process.
--
--CONSTANT, which names specific values.

----------------------- SIGNAL -----------------------
    --- SIGNAL signal_name : signal_type [:= initial_value];


-- Following is an example of signal declarations:


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

PACKAGE sigdecl IS
  TYPE    bus_type IS ARRAY(0 TO 7) OF STD_LOGIC;
  SIGNAL  vcc     : STD_LOGIC := '1';
  SIGNAL  ground  : STD_LOGIC := '0';

  FUNCTION magic_function( a : IN bus_type)
    RETURN bus_type;
END sigdecl;

PACKAGE BODY sigdecl IS
  FUNCTION magic_function( a : IN bus_type)
    RETURN bus_type IS
  BEGIN
    RETURN a;
  END magic_function;
END sigdecl;


USE WORK.sigdecl.ALL;
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY board_design is
PORT(
  data_in   : IN  bus_type;
  data_out  : OUT bus_type
);
  SIGNAL sys_clk : std_logic := '1';
END board_design;

ARCHITECTURE data_flow OF board_design IS
  SIGNAL int_bus : bus_type;
  CONSTANT disconnect_value : bus_type :=
          ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X');
BEGIN

  int_bus   <= data_in  WHEN sys_clk = '1'
                      ELSE int_bus;

  data_out  <= magic_function(int_bus) WHEN sys_clk = '0'
                                       ELSE disconnect_value;
  sys_clk <= NOT(sys_clk) after 50 ns;

END data_flow;

----Variables

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY and5 IS
PORT (
  a, b, c, d, e : IN  STD_LOGIC;
  q             : OUT STD_LOGIC);
END and5;

ARCHITECTURE and5 OF and5 IS
BEGIN
PROCESS(a, b, c, d, e)
  VARIABLE state : std_logic;
  VARIABLE delay : time;
BEGIN
  state := a AND b AND c AND d AND e;
  IF state = '1' THEN
    delay := 4.5 ns;
  ELSIF state = '0' THEN
    delay := 3 ns;
  ELSE
    delay := 4 ns;
  END IF;
    q <= state AFTER delay;
END PROCESS;
END and5;



--Variables are inherently more efficient because assignments happen
--immediately, while signals must be scheduled to occur.
--
--Variables take less memory, while signals need more information
--to allow for scheduling and signal attributes.
--
--Using a signal would have required a WAIT statement to synchronize
--the signal assignment to the same execution iteration as the usage.

-- Constants
-- CONSTANT PI: REAL := 3.1414;
-- CONSTANT constant_name {,constant_name} : type_name[:= value];


