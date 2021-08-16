-- Chapter_4_Data_Types

--  C:\questasim64_10.4c\vhdl_src\std\standard.vhd

--  A VHDL object consists of one of the following:
--     Signal,   which represents interconnection wires that connect component instantiation ports together.
--     Variable, which is used for local storage of temporary data, visible only inside a process.
--     Constant, which names specific values.

-------------------------- SIGNAL --------------------------
--          SIGNAL signal_name {, signal_name} : signal_type [:= initial_value];
--  Signals can be declared in entity declaration sections, architecture declarations,
--    and package declarations. Signals in package declarations are also referred
--    to as global signals because they can be shared among entities.



LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE sigdecl IS

  TYPE bus_type IS ARRAY(0 to 7) OF std_logic;
  SIGNAL VCC    : STD_LOGIC := '1';
  SIGNAL ground : STD_LOGIC := '0';

  FUNCTION magic_function( a : IN bus_type) RETURN bus_type;

END sigdecl;

-------------------------- board_design --------------------------
--  USE work.sigdecl.vcc;
--  USE work.sigdecl.ground;
-- OR
USE WORK.sigdecl.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY board_design is
PORT(
  data_in   : IN  bus_type;
  data_out  : OUT bus_type
);

SIGNAL sys_clk : std_logic := '1';

END board_design;


ARCHITECTURE data_flow OF board_design IS

  SIGNAL int_bus : bus_type;
  CONSTANT disconnect_value : bus_type := ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X');


    TYPE fourval IS ( 'k', kaka, juju, llll );


BEGIN

  int_bus   <=  data_in WHEN sys_clk = '1' ELSE
                int_bus;

  data_out  <=  magic_function(int_bus) WHEN sys_clk = '0' ELSE
                disconnect_value;

  sys_clk   <= NOT  (sys_clk) after 50 ns;

END data_flow;


-------SIGNALS GLOBAL TO ENTITIES
--    sys_clk
-------ARCHITECTURE LOCAL SIGNALS
--    int_bus



