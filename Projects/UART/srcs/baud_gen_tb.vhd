LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY baud_gen_tb IS
END ENTITY baud_gen_tb;




ARCHITECTURE bhv OF baud_gen_tb IS
COMPONENT baud_gen IS
PORT(
  clk     : IN  STD_LOGIC ;
  reset   : IN  STD_LOGIC ;
  dvsr    : IN  STD_LOGIC_VECTOR (10 DOWNTO 0);
  tick    : OUT STD_LOGIC
);
END COMPONENT;

SIGNAL clk          : STD_LOGIC ;
SIGNAL reset        : STD_LOGIC ;
SIGNAL dvsr         : STD_LOGIC_VECTOR (10 DOWNTO 0);
SIGNAL tick         : STD_LOGIC;
SIGNAL end_of_test  : STD_LOGIC;

BEGIN

clk   <= '0' WHEN clk = 'U' OR end_of_test = '1'
          ELSE NOT clk AFTER 5 ns;

reset <= '1', '0' AFTER 36 ns;

dvsr  <= STD_LOGIC_VECTOR(TO_UNSIGNED (650, 11));

DUT : baud_gen
PORT MAP(
  clk   => clk,
  reset => reset,
  dvsr  => dvsr,
  tick  => tick
);

PROCESS
BEGIN
  end_of_test <= '0';
  WAIT FOR 2 ms;
  end_of_test <= '1';
  WAIT;
END PROCESS;


END ARCHITECTURE bhv;
