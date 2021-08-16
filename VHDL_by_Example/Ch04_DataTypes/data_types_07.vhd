-- Chapter_4_Data_Types

-------------------------- ACCESS TYPES --------------------------

--  Only variables can be declared as access types.
--    Two predefined functions are automatically available to manipulate the
--  object NEW and DEALLOCATE.
--    Function NEW allocates memory of the size of the object in bytes and
--  returns the access value.
--    Function DEALLOCATE takes in the access value and returns the memory
--  back to the system.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY access_types_1 is
END ENTITY;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ARCHITECTURE example_1 OF access_types_1 IS
SIGNAL X  : STD_LOGIC;
BEGIN

PROCESS(X)
  TYPE fifo_element_t IS ARRAY(0 TO 3) OF std_logic;  --line 1
  TYPE fifo_el_access IS ACCESS fifo_element_t;       --line 2
  VARIABLE fifo_ptr : fifo_el_access := NULL;         --line 3
  VARIABLE temp_ptr : fifo_el_access := NULL;         --line 4
BEGIN
  temp_ptr := new fifo_element_t;         --Ok line 5
  temp_ptr.ALL := ('0', '1', '0', '1');   --Ok line 6
  temp_ptr.ALL := ('0', '0', '0', '0');   --Ok line 7
  temp_ptr.ALL(0) := '0';                 --Ok line 8
  fifo_ptr := temp_ptr;                   --Ok line 9
  fifo_ptr.ALL := temp_ptr.ALL;           --Ok line 10
END PROCESS;

END ARCHITECTURE;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE stack_types IS

  TYPE data_type IS ARRAY(0 TO 7) OF std_logic;   --line 1
  TYPE element_rec; --incomplete type             --line 2
  TYPE element_ptr IS ACCESS element_rec;         --line 3

  TYPE element_rec IS                             --line 4
  RECORD                                          --line 5
    data  : data_type;                            --line 6
    nxt   : element_ptr;                          --line 7
  END RECORD;                                     --line 8

END stack_types;



LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.stack_types.ALL;

ENTITY stack IS
  PORT(
    din   : IN  data_type;
    clk   : IN  std_logic;
    dout  : OUT data_type;
    r_wb  : IN  std_logic
  );
END stack;

ARCHITECTURE stack OF stack IS
BEGIN
  PROCESS(clk)
    VARIABLE list_head  : element_ptr := NULL; --line 9
    VARIABLE temp_elem  : element_ptr := NULL; --line 10
    VARIABLE last_clk   : std_logic   := 'U';  --line 11
  BEGIN
    IF (clk = '1') AND (last_clk = '0') THEN  --line 12
      IF (r_wb = '0') THEN                    --line 13

        temp_elem       := NEW element_rec;   --line 14
        temp_elem.data  := din;               --line 15
        temp_elem.nxt   := list_head;         --line 16
        list_head       := temp_elem;         --line 17



        --read mode                           --line 18
      ELSIF (r_wb = '1') THEN
        dout            <= list_head.data;    --line 19
        temp_elem       := list_head;         --line 20
        list_head       := temp_elem.nxt;     --line 21
        DEALLOCATE (temp_elem);               --line 22
      ELSE
        ASSERT FALSE
          REPORT "read/write unknown while clock active"
          SEVERITY WARNING;                   --line 23
      END IF;
    END IF;
    last_clk := clk;                          --line 24
  END PROCESS;

END stack;





