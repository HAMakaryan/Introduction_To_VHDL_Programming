--ARCHITECTURE architecture_name OF entity_name [IS]
--    Declarations
--BEGIN
--    Statements
--END [architecture] [architecture_name];

ARCHITECTURE my_arc OF Electronic_Circuit IS
BEGIN
END ARCHITECTURE;


ARCHITECTURE my_arc OF Electronic_Circuit IS
BEGIN
END ARCHITECTURE my_arc;

ARCHITECTURE my_arc OF Electronic_Circuit IS
BEGIN
END;

ENTITY example_1_5 IS
PORT(
  a , b , c : IN  BIT;
  f1, f2    : OUT BIT
);
END ENTITY;

ARCHITECTURE example_arc OF example_1_5 IS
BEGIN
  f1<= (a AND (NOT b)) or c;
  f2<= a AND b AND (NOT(c));
END example_arc;


--  PR 1.54 Program 1.54
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY logic_circuit IS
PORT(
  x: IN   STD_LOGIC;
  y: IN   STD_LOGIC;
  z: IN   STD_LOGIC;
  f: OUT  STD_LOGIC
);
END logic_circuit;

ARCHITECTURE logic_flow OF logic_circuit IS
  signal g, h: std_logic;
begin
  g <=  x       and y;
  h <=  not(y)  and z;
  f <=  g       or  h;
end logic_flow;


