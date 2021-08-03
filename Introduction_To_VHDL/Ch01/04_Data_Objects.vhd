--OBJECT TYPES
--  A VHDL object consists of one of the following:
--SIGNAL, which represents interconnection wires that connect
  --component instantiation ports together.
--VARIABLE, which is used for local storage of temporary data,
  --visible only inside a process.
--CONSTANT, which names specific values

--object_declaration ::=  constant_declaration
--                      | signal_declaration
--                      | variable_declaration
--                      | file_declaration

-- Bachus-Naur format(BNF)
--    constant_declaration ::=
--    CONSTANT identifier_list : subtype_indication [ := expression ] ;

----------------------------------------------------
----------------------------------------------------
LIBRARY IEEE;
USE     IEEE.STD_LOGIC_1164.ALL;

ENTITY object_types IS
END ENTITY;
----------------------------------------------------
ARCHITECTURE constant_object OF object_types IS

  CONSTANT my_constant  : INTEGER   :=32 ;
  CONSTANT my_flag      : STD_LOGIC :='1';
  CONSTANT my_vector    : STD_LOGIC_VECTOR(3 DOWNTO 0):= "1010";

BEGIN

END ARCHITECTURE constant_object;
----------------------------------------------------
----------------------------------------------------
ARCHITECTURE signal_object OF object_types IS

  SIGNAL my_number: INTEGER;
  SIGNAL my_bit   : BIT:='1';
  SIGNAL my_vector: STD_LOGIC_VECTOR(3 DOWNTO 0):= "1010";

BEGIN

END ARCHITECTURE signal_object;
----------------------------------------------------
----------------------------------------------------
ARCHITECTURE variable_object OF object_types IS


BEGIN

  PROCESS
    VARIABLE  my_number : NATURAL;
    VARIABLE  my_logic  : STD_LOGIC:='1';
    VARIABLE  my_vector : STD_LOGIC_VECTOR(3 DOWNTO 0):= "1110";
  BEGIN
    WAIT;
  END PROCESS;


END ARCHITECTURE variable_object;



