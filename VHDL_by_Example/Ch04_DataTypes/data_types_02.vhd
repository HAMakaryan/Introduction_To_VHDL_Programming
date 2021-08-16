--  A VHDL object consists of one of the following:
--     Signal,   which represents interconnection wires that connect component instantiation ports together.
--     Variable, which is used for local storage of temporary data, visible only inside a process.
--     Constant, which names specific values.

-------------------------- VARIABLES --------------------------
--          VARIABLE variable_name {, variable_name} : variable_type[:= value];

--  Variables can be declared in the process declaration and subprogram declaration sections only



LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY and5 IS
PORT (
  a : IN  STD_LOGIC;
  b : IN  STD_LOGIC;
  c : IN  STD_LOGIC;
  d : IN  STD_LOGIC;
  e : IN  STD_LOGIC;
  q : OUT STD_LOGIC
);
END and5;

ARCHITECTURE and5 OF and5 IS
BEGIN

  PROCESS(a, b, c, d, e)
    VARIABLE STATE : STD_LOGIC;
    VARIABLE delay : TIME;
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


---- Both of these values cannot be static data because their values depend on
  --  the values of inputs a, b, c, d, and e. Signals could have been used to
  --  store the data, but there are several reasons why a signal was not used:

----  Variables are inherently more efficient because assignments happen
--      immediately, while signals must be scheduled to occur.

----  Variables take less memory, while signals need more information to
--      allow for scheduling and signal attributes.

----  Using a signal would have required a WAIT statement to synchronize
--      the signal assignment to the same execution iteration as the usage.




-------------------------- CONSTANT --------------------------
  --  CONSTANT constant_name {,constant_name} : type_name[:= value];

  --  The value specification is optional, because VHDL also supports deferred
  --    constants. These are constants declared in a package declaration whose
  --    value is specified in a package body.

  --  CONSTANT PI: REAL := 3.1414;


---------  A constant has the same scoping rules as signals.

----  A constant declared in a package can be global if the package is
--      used by a number of entities.

----  A constant in an entity declaration section can be referenced by
--      any architecture of that entity.

----  A constant in an architecture can be used by any statement inside
--      the architecture, including a process statement.

----  A constant declared in a process declaration can be used only in a process.

