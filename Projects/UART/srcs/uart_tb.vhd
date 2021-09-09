LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY uart_tb IS
END ENTITY uart_tb;

ARCHITECTURE bhv OF uart_tb IS

SIGNAL  clk       : STD_LOGIC;
SIGNAL  reset     : STD_LOGIC;
SIGNAL  rd_uart   : STD_LOGIC;
SIGNAL  wr_uart   : STD_LOGIC;
SIGNAL  dvsr      : STD_LOGIC_VECTOR (10 DOWNTO 0);
SIGNAL  rx        : STD_LOGIC;
SIGNAL  w_data    : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL  tx_full   : STD_LOGIC;
SIGNAL  rx_empty  : STD_LOGIC;
SIGNAL  r_data    : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL  tx        : STD_LOGIC;

SIGNAL  end_of_test : STD_LOGIC;

BEGIN


clk <=  '0' WHEN clk = 'U' OR end_of_test = '1' ELSE
        NOT clk AFTER 5 ns;


rd_uart <=  '1' WHEN rx_empty = '0' ELSE
            '0';

rx <= tx;

PROCESS
BEGIN
  dvsr        <=  "00001000000";
  end_of_test <= '0';
  reset       <= '1';
  WAIT FOR  38 ns;
  reset       <= '0';
  FOR i IN 1 TO 10 LOOP
    WAIT UNTIL rising_edge(clk);
  END LOOP;
  w_data  <= "10101010";
  wr_uart <= '1';
  WAIT UNTIL rising_edge(clk);
  w_data  <= "01010101";
  WAIT UNTIL rising_edge(clk);
  w_data  <= "00001111";
  WAIT UNTIL rising_edge(clk);
  w_data  <= "11110000";
  WAIT UNTIL rising_edge(clk);
  wr_uart <= '0';




  WAIT FOR  1 ms;
  end_of_test <= '1';
  WAIT;
END PROCESS;




DUT : ENTITY work.uart(str_arch)
GENERIC MAP (
  DBIT      => 8,
  SB_TICK   => 16,
  FIFO_W    => 4
)
PORT MAP(
  clk       => clk,
  reset     => reset,
  rd_uart   => rd_uart,
  wr_uart   => wr_uart,
  dvsr      => dvsr,
  rx        => rx,
  w_data    => w_data,
  tx_full   => tx_full,
  rx_empty  => rx_empty,
  r_data    => r_data,
  tx        => tx
);


END ARCHITECTURE bhv;

