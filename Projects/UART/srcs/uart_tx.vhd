LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY uart_tx IS
GENERIC (
  DBIT    : integer := 8; --  # data bits
  SB_TICK : integer := 16 --  # tiks for stop bits
);
PORT(
  clk, reset    : IN  STD_LOGIC;
  tx_start      : IN  STD_LOGIC;
  s_tick        : IN  STD_LOGIC;
  din           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
  tx_done_tick  : OUT STD_LOGIC;
  tx            : OUT STD_LOGIC
);
END uart_tx;

ARCHITECTURE arch OF uart_tx IS

TYPE    state_type IS (idle, start, data, stop);
SIGNAL  state_reg       : state_type;
SIGNAL  state_next      : state_type;
SIGNAL  s_reg, s_next   : UNSIGNED (4 DOWNTO 0);
SIGNAL  n_reg, n_next   : UNSIGNED (2 DOWNTO 0);
SIGNAL  b_reg, b_next   : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL  tx_reg, tx_next : STD_LOGIC;

BEGIN
--  FSMD state & data registers
process(clk, reset)
begin
  IF reset = '1' THEN
    state_reg <= idle;
    s_reg   <= (others => '0');
    n_reg   <= (others => '0');
    b_reg   <= (others => '0');
    tx_reg  <= '1';
  ELSIF (clk'event AND clk = '1') THEN
    state_reg <= state_next;
    s_reg   <= s_next;
    n_reg   <= n_next;
    b_reg   <= b_next;
    tx_reg  <= tx_next;
  END IF;
END PROCESS;

--  next-state logi c & data path
PROCESS(state_reg, s_reg, n_reg,b_reg, s_tick,tx_reg, tx_start, din)
BEGIN
  state_next    <= state_reg;
  s_next        <= s_reg;
  n_next        <= n_reg;
  b_next        <= b_reg;
  tx_next       <= tx_reg;
  tx_done_tick  <= '0';
  CASE state_reg IS
    WHEN idle =>
      tx_next <= '1';
      IF tx_start = '1' THEN
        state_next  <= start;
        s_next      <= (OTHERS => '0');
        b_next      <= din;
      end if;
    WHEN start =>
    tx_next <= '0';
    IF (s_tick = '1') THEN
      IF s_reg = 15 THEN
        state_next <= data;
        s_next     <= (OTHERS => '0');
        n_next     <= (OTHERS => '0');
      ELSE
        s_next <= s_reg + 1;
      END IF;
    END IF;
    WHEN data =>
      tx_next <= b_reg(0);
      IF (s_tick = '1') THEN
        IF s_reg = 15 THEN
          s_next <= (OTHERS => '0');
          b_next <= '0' & b_reg (7 DOWNTO 1);
          IF n_reg = (DBIT - 1) THEN
            state_next <= stop;
          ELSE
            n_next <= n_reg + 1;
          END IF;
        ELSE
          s_next <= s_reg + 1;
        END IF;
      END IF;
    WHEN stop =>
      tx_next <= '1';
      IF (s_tick = '1') THEN
        IF s_reg = (SB_TICK - 1) THEN
          state_next <= idle;
          tx_done_tick <= '1';
        ELSE
          s_next <= s_reg + 1;
        END IF;
      END IF;
  END CASE;
END PROCESS;

tx <= tx_reg;

END arch;

