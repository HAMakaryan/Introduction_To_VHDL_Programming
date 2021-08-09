--GenLabel : for parameter in number - range generate
--[ declarative part
--begin ]
-- VHDL Statements
--end generate [ GenLabel ];


Lab_1 : FOR indx IN 0 TO 3 GENERATE
  y(indx) <= x(indx) XOR x(indx + 1);
END GENERATE;

y(0) <= x(0) XOR x(1);
y(1) <= x(1) XOR x(2);
y(2) <= x(2) XOR x(3);
y(3) <= x(3) XOR x(4);

--Let x and y be an 8-bit vectors. We can reverse the content of vector x
--using the following VHDL statement:

reverse : FOR indx IN 0 TO 7 GENERATE
  y(indx) <= x(7 - indx);
END GENERATE;


ENTITY reverse_vector IS
PORT(
  x_vec : IN  BIT_VECTOR(7 DOWNTO 0);
  y_rvec: OUT BIT_VECTOR(7 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE logic_flow OF reverse_vector IS
BEGIN

reverse: FOR indx IN 0 TO 7 GENERATE
  y_rvec(indx) <= x_vec(7-indx);
END GENERATE;

END ARCHITECTURE;


-- Parity Generator
ENTITY parity_bit_generator IS
PORT(
  x_vec: IN  BIT_VECTOR(15 DOWNTO 0);
  p_bit: OUT BIT
);
END ENTITY;

ARCHITECTURE logic_flow OF parity_bit_generator IS
  SIGNAL parr_vec: BIT_VECTOR(15 DOWNTO 0);
BEGIN

parr_vec(0)<= x_vec(0);

parity: FOR indx IN 1 TO 15 GENERATE
  parr_vec(indx)<= parr_vec(indx-1) XOR x_vec(indx);
END GENERATE;

p_bit<= parr_vec(15);

END ARCHITECTURE;


---- Conditional Generate

--GenLabel : if condition generate
--[ declarative part
--begin ]
-- VHDL Statements
--end generate [ GenLabel ];


--Example 2.11 Write a VHDL statement that checks a constant positive integer and
--detects whether it is an even or odd integer.

ENTITY even_odd_detector IS
PORT(
  EvenFlag: OUT BIT
);
END ENTITY;

ARCHITECTURE logic_flow OF even_odd_detector IS
  CONSTANT number: POSITIVE:=10001; -- 31-bit positive integer
BEGIN

EvenDetector: IF ((number MOD 2)=0) GENERATE
  EvenFlag <= 1;
END GENERATE;

OddDetector: IF ((number MOD 2)=1) GENERATE
  EvenFlag <= 0;
END GENERATE;

END ARCHITECTURE;

--2.3 Examples for Combinational Circuits Implemented in VHDL
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY multiplexer_2x1 IS

PORT(
  x, y, s : IN STD_LOGIC;
  f       : OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE logic_flow OF multiplexer_2x1 IS
BEGIN
  f <= (NOT s AND x) OR (s AND y);
END ARCHITECTURE;

----------Using the when
ARCHITECTURE logic_flow OF multiplexer_2x1 IS
BEGIN
  f <= x WHEN s='0' ELSE
       y;
END ARCHITECTURE;


ARCHITECTURE logic_flow OF multiplexer_2x1 IS
BEGIN
f <= '1' WHEN (x='0' AND y='1' AND s='1') ELSE
     '1' WHEN (x='1' AND y='0' AND s='0') ELSE
     '1' WHEN (x='1' AND y='1' AND s='0') ELSE
     '1' WHEN (x='1' AND y='1' AND s='1') ELSE
     '0';
END ARCHITECTURE;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY multiplexer_2x1 IS
PORT(
  xys: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
  f  : OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE logic_flow OF multiplexer_2x1 IS
BEGIN

f <= '1' WHEN (xys="011") ELSE
     '1' WHEN (xys="100") ELSE
     '1' WHEN (xys="110") ELSE
     '1' WHEN (xys="111") ELSE
     '0';

END ARCHITECTURE;

-- Using the select statement

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY multiplexer_2x1 IS
PORT(
  x, y, s: IN  STD_LOGIC;
  f      : OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE logic_flow OF multiplexer_2x1 IS
BEGIN
  WITH (s) SELECT
    f <= x WHEN '0',
         y WHEN OTHERS;
END ARCHITECTURE;

----------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_circuit IS
PORT(
  x, y, z: IN  STD_LOGIC;
  f      : OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE logic_flow OF mux_circuit IS
BEGIN

  f<=(x AND NOT y) OR (x AND NOT z) OR (y AND z);

END ARCHITECTURE;












