--  STD_LOGIC                   Package IEEE.std_logic_1164
--  std_logic values
    --    'X' Unknown
    --    '0' Logic 0
    --    '1' Logic 1
    --    'Z' High Impedance
    --    'W' Weak Unknown
    --    'L' Weak Low
    --    'H' Weak High
    --    '-' Don't Care

--  STD_LOGIC_VECTOR            Package IEEE.std_logic_1164
--    If an I/O port has data type of std_logic_vector,
--    it means that the I/O port has a number of std_logic values.

--  STD_ULOGIC                  Package IEEE.std_logic_1164
--  std_ulogic values
    --    'U' Uninitialized
    --    'X' Unknown
    --    '0' Logic 0
    --    '1' Logic 1
    --    'Z' High Impedance
    --    'W' Weak Unknown
    --    'L' Weak Low
    --    'H' Weak High
    --    '-' Don't Care

--  STD_ULOGIC_VECTOR         Package IEEE.std_logic_1164
--    If an I/O port has data type of std_ulogic_vector,
--    it means that the I/O port has a number of std_ulogic values.

--  BIT                         Standard package
--  bit values
    --    '0' Logic 0
    --    '1' Logic 1

--  BIT_VECTOR                  Standard package
--    If an I/O port has data type of bit_vector, it means
--    that the I/O port has a number of bit values.

--  INTEGER, NATURAL, POSITIVE  Standard package

--  UNSIGNED, SIGNED            Packages NUMERIC_STD and STD_LOGIC_ARITH




LIBRARY IEEE;
USE     IEEE.STD_LOGIC_1164.ALL;

ENTITY FourBit_Circuit IS
PORT(
  inp1  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
  inp2  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
  outp1 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
  outp2 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
);
END ENTITY;

LIBRARY IEEE;
USE     IEEE.STD_LOGIC_1164.ALL;
ENTITY FourBit_Circuit IS
PORT(
  inp1  : IN  STD_ULOGIC_VECTOR(3 DOWNTO 0);
  inp2  : IN  STD_ULOGIC_VECTOR(3 DOWNTO 0);
  outp1 : OUT STD_ULOGIC_VECTOR(4 DOWNTO 0);
  outp2 : OUT STD_ULOGIC_VECTOR(4 DOWNTO 0)
);
END ENTITY;

ENTITY FourBit_Circuit IS
PORT(
  inp1  : IN  BIT_VECTOR(3 DOWNTO 0);
  inp2  : IN  BIT_VECTOR(3 DOWNTO 0);
  outp1 : OUT BIT_VECTOR(4 DOWNTO 0);
  outp2 : OUT BIT_VECTOR(4 DOWNTO 0)
);
END ENTITY;

ENTITY FourBit_Circuit IS
PORT(
  inp1  : in  INTEGER RANGE 0 TO 15;
  inp2  : IN  INTEGER RANGE 0 TO 15;
  outp1 : OUT INTEGER RANGE 0 TO 31;
  outp2 : OUT INTEGER RANGE 0 TO 31
);
END ENTITY;

ENTITY FourBit_Circuit IS
PORT(
  inp1  : IN  INTEGER RANGE - 8 TO  7;
  inp2  : IN  INTEGER RANGE - 8 TO  7;
  outp1 : OUT INTEGER RANGE -16 TO 15;
  outp2 : OUT INTEGER RANGE -16 TO 15
);
END ENTITY;

ENTITY FourBit_Circuit IS
PORT(
  inp1  : IN  NATURAL RANGE 0 TO 15;
  inp2  : IN  NATURAL RANGE 0 TO 15;
  outp1 : OUT NATURAL RANGE 0 TO 31;
  outp2 : OUT NATURAL RANGE 0 TO 31
);
END ENTITY;

ENTITY FourBit_Circuit IS
PORT(
  inp1  : IN  POSITIVE RANGE 1 TO 15;
  inp2  : IN  POSITIVE RANGE 1 TO 15;
  outp1 : OUT POSITIVE RANGE 1 TO 31;
  outp2 : OUT POSITIVE RANGE 1 TO 31
);
END ENTITY;


LIBRARY IEEE;
USE IEEE.NUMERIC_STD.ALL;
ENTITY FourBit_Circuit IS
port(
  inp1  : IN  UNSIGNED (3 DOWNTO 0);
  inp2  : IN  UNSIGNED (3 DOWNTO 0);
  outp1 : OUT UNSIGNED (4 DOWNTO 0);
  outp2 : OUT UNSIGNED (4 DOWNTO 0)
);
END ENTITY;

LIBRARY IEEE;
USE     IEEE.NUMERIC_STD.ALL;
ENTITY FourBit_Circuit IS
port(
  inp1  : IN  SIGNED (3 DOWNTO 0);
  inp2  : IN  SIGNED (3 DOWNTO 0);
  outp1 : OUT SIGNED (4 DOWNTO 0);
  outp2 : OUT SIGNED (4 DOWNTO 0)
);
END ENTITY;

LIBRARY IEEE;
USE     IEEE.STD_LOGIC_1164.ALL;
ENTITY Electronic_Circuit IS
port(
  inp1  : IN      STD_LOGIC_VECTOR(3 DOWNTO 0);
  inp2  : IN      STD_LOGIC_VECTOR(3 DOWNTO 0);
  outp1 : INOUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
  outp2 : OUT     STD_LOGIC_VECTOR(4 DOWNTO 0);
  outp3 : BUFFER  STD_LOGIC_VECTOR(4 DOWNTO 0)
);
END ENTITY;




