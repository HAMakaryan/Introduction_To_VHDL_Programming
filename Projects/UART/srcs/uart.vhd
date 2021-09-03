LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY UART IS
GENERIC (
  DBIT    : INTEGER := 8;   -- # data bits
  SB_TICK : INTEGER := 16;  -- # ticks for stop bits, 16 per bit
  FIFO_W  : INTEGER := 4    -- # FIFO addr b i t s (depth : 2^FIFO W)
);
PORT(
  clk         : IN  STD_LOGIC;
  reset       : IN  STD_LOGIC;
  rd_uart     : IN  STD_LOGIC;
  wr_uart     : IN  STD_LOGIC;
  dvsr        : IN  STD_LOGIC_VECTOR (10 DOWNTO 0);
  rx          : IN  STD_LOGIC;
  w_data      : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
  tx_full     : OUT STD_LOGIC;
  rx_empty    : OUT STD_LOGIC;
  r_data      : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
  tx          : OUT STD_LOGIC
);
END uart;

ARCHITECTURE str_arch OF uart IS

SIGNAL tick               : STD_LOGIC;
SIGNAL rx_done_tick       : STD_LOGIC;
SIGNAL tx_fifo_out        : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL rx_data_out        : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL tx_empty           : STD_LOGIC;
SIGNAL tx_fifo_not_empty  : STD_LOGIC;
SIGNAL tx_done_tick       : STD_LOGIC;

BEGIN

baud_gen_unit : ENTITY work.baud_gen (arch)
PORT MAP(
    clk   => clk,
    reset => reset,
    dvsr  => dvsr,
    tick  => tick
);

uart_rx_unit : ENTITY work.uart_rx (arch)
GENERIC MAP(
  DBIT    => DBIT,
  SB_TICK => SB_TICK
)
PORT MAP(
  clk           => clk,
  reset         => reset,
  rx            => rx,
  s_tick        => tick,
  rx_done_tick  => rx_done_tick,
  dout          => rx_data_out
);

uart_tx_unit : ENTITY work.uart_tx (arch)
GENERIC MAP(
  DBIT => DBIT,
  SB_TICK => SB_TICK
)
PORT MAP(
  clk           => clk,
  reset         => reset,
  tx_start      => tx_fifo_not_empty,
  s_tick        => tick,
  din           => tx_fifo_out,
  tx_done_tick  => tx_done_tick,
  tx            => tx
);

fifo_rx_unit : ENTITY work.fifo (reg_file_arch)
GENERIC MAP(
  DATA_WIDTH => DBIT,
  ADDR_WIDTH => FIFO_W
)
PORT MAP(
  clk     => clk,
  reset   => reset,
  rd      => rd_uart,
  wr      => rx_done_tick,
  w_data  => rx_data_out,
  empty   => rx_empty,
  full    => open,
  r_data  => r_data
);

fifo_tx_unit : ENTITY work.fifo (reg_file_arch)
GENERIC MAP(
  DATA_WIDTH => DBIT,
  ADDR_WIDTH => FIFO_W
)
PORT MAP(
  clk     => clk,
  reset   => reset,
  rd      => tx_done_tick,
  wr      => wr_uart,
  w_data  => w_data,
  empty   => tx_empty,
  full    => tx_full,
  r_data  => tx_fifo_out
);

tx_fifo_not_empty <= NOT tx_empty;

END str_arch;
