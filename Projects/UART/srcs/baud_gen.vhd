LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY baud_gen IS
PORT(
  clk     : IN  STD_LOGIC ;
  reset   : IN  STD_LOGIC ;
  dvsr    : IN  STD_LOGIC_VECTOR (10 DOWNTO 0);
  tick    : OUT STD_LOGIC
);
END ENTITY baud_gen;


ARCHITECTURE arch OF baud_gen IS
CONSTANT N    : INTEGER   := 11;
SIGNAL r_reg  : UNSIGNED (N-1 downto 0);
SIGNAL r_next : UNSIGNED (N-1 downto 0);
BEGIN
--  register
PROCESS(clk, reset)
BEGIN
  IF ( reset = '1') THEN
    r_reg <= (OTHERS => '0');
  ELSIF (clk'EVENT AND clk = '1') THEN
    r_reg <= r_next;
  END IF;
END PROCESS;

--  next-state logic
r_next <= (OTHERS => '0') WHEN r_reg = UNSIGNED(dvsr) ELSE r_reg + 1;

--  output logic
tick <= '1' WHEN r_reg = 1 ELSE '0'; -- not use 0 because of reset

END arch;
