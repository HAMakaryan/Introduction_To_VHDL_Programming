-----------Inertial Delay Model
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY buf IS
PORT (
  a : IN std_logic;
  b : OUT std_logic
);
END buf;

ARCHITECTURE buf OF buf IS
BEGIN
  b <= a AFTER 20 ns;
END buf;
-----------Transport Delay Model
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY delay_line IS
PORT (
  a : IN std_logic;
  b : OUT std_logic
);
END delay_line;

ARCHITECTURE delay_line OF delay_line IS
BEGIN
  b <= TRANSPORT a AFTER 20 ns;
END delay_line;

-----process

PROCESS(sensitivity list)
    --declaration part of the process
BEGIN
    --body part of the process
END PROCESS;


library ieee;
use ieee.std_logic_1164.all;

ENTITY D_FlipFlop IS
PORT(
  d   : IN  STD_LOGIC;
  clk : IN  STD_LOGIC;
  qa  : OUT STD_LOGIC;
  qb  : OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE logic_flow OF D_FlipFlop IS
BEGIN

PROCESS(clk)
BEGIN
  IF (clk'event AND clk='1') THEN
    qa <= d;
    qb <= NOT d;
  END IF;
END PROCESS;

END ARCHITECTURE;

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY nand2 IS
PORT(
  a, b  : IN std_logic;
  c     : OUT std_logic);
END nand2;

ARCHITECTURE nand2 OF nand2 IS
BEGIN

PROCESS( a, b )
  VARIABLE temp : std_logic;
BEGIN
  temp := NOT (a and b);
  IF (temp = '1') THEN
    c <= temp AFTER 6 ns;
  ELSIF (temp = '0') THEN
    c <= temp AFTER 5 ns;
  ELSE
    c <= temp AFTER 6 ns;
  END IF;
END PROCESS;

END nand2;

----  Incorrect Mux Example
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY mux IS
PORT (
  i0, i1, i2, i3, a, b : IN std_logic;
  q : OUT std_logic
);
END mux;

ARCHITECTURE wrong of mux IS
  SIGNAL muxval : INTEGER;
BEGIN

PROCESS ( i0, i1, i2, i3, a, b )
BEGIN
  muxval <= 0;
  IF (a = '1') THEN
    muxval <= muxval + 1;
  END IF;
    IF (b = '1') THEN
  muxval <= muxval + 2;
  END IF;
  CASE muxval IS
    WHEN 0 =>
      q <= I0 AFTER 10 ns;
    WHEN 1 =>
      q <= I1 AFTER 10 ns;
    WHEN 2 =>
      q <= I2 AFTER 10 ns;
    WHEN 3 =>
      q <= I3 AFTER 10 ns;
    WHEN OTHERS =>
    NULL;
  END CASE;
END PROCESS;

END wrong;


-- Correct Mux Example
LIBRARY IEEE;
USE IEEE.std_logic_1164ALL;
ENTITY mux IS
PORT (
  i0, i1, i2, i3, a, b  : IN  std_logic;
  q                     : OUT std_logic
);
END mux;

ARCHITECTURE better OF mux IS
BEGIN
  PROCESS ( i0, i1, i2, i3, a, b )
    VARIABLE muxval : INTEGER;
  BEGIN
    muxval := 0;
    IF (a = '1') THEN
      muxval := muxval + 1;
    END IF;
    IF (b = '1') THEN
      muxval := muxval + 2;
    END IF;
    CASE muxval IS
      WHEN 0 =>
        q <= I0 AFTER 10 ns;
      WHEN 1 =>
        q <= I1 AFTER 10 ns;
      WHEN 2 =>
        q <= I2 AFTER 10 ns;
      WHEN 3 =>
        q <= I3 AFTER 10 ns;
      WHEN OTHERS =>
        NULL;
    END CASE;
    END PROCESS;
END better;
-----------