LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY uart_rx is
GENERIC (
  DBIT    : integer := 8; -- # data bits
  SB_TICK : integer := 16 -- # ticks for stop bits
);
PORT(
  clk           : IN  STD_LOGIC;
  reset         : IN  STD_LOGIC;
  rx            : IN  STD_LOGIC;
  s_tick        : IN  STD_LOGIC;
  rx_done_tick  : OUT STD_LOGIC;
  dout          : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
);

END uart_rx;

ARCHITECTURE arch OF uart_rx IS
TYPE    state_type IS (idle, start, data, stop);
SIGNAL  state_reg       : state_type;
SIGNAL  state_next      : state_type;
SIGNAL  s_reg , s_next  : UNSIGNED (4 DOWNTO 0);
SIGNAL  n_reg , n_next  : UNSIGNED (2 DOWNTO 0);
SIGNAL  b_reg , b_next  : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL  sync1_reg       : STD_LOGIC;
SIGNAL  sync2_reg       : STD_LOGIC;
SIGNAL  sync_rx         : STD_LOGIC;

BEGIN

-- synchronizati on for rx
process(clk , reset)
begin
  IF reset = '1' then
    sync1_reg <= '0';
    sync2_reg <= '0';
  ELSIF (clk ' EVENT AND clk = '1') THEN
    sync1_reg <= rx;
    sync2_reg <= sync1_reg;
  END IF;
END PROCESS;

sync_rx <= sync2_reg;

-- FSMD state & data registers
process(clk, reset)
begin
  IF reset = '1' then
    state_reg <= idle;
    s_reg     <= (others => '0');
    n_reg     <= (others => '0');
    b_reg     <= (others => '0');
  ELSIF (clk ' event and clk = '1') then
    state_reg <= state_next;
    s_reg     <= s_next;
    n_reg     <= n_next;
    b_reg     <= b_next;
  end IF;
end process;

-- next-state logic & data path
process(state_reg, s_reg, n_reg, b_reg, s_tick, sync_rx)
begin
  state_next    <= state_reg;
  s_next        <= s_reg;
  n_next        <= n_reg;
  b_next        <= b_reg;
  rx_done_tick  <= '0';
  CASE state_reg IS
    WHEN idle =>
      IF sync_rx = '0' THEN
        state_next <= start;
        s_next <= (OTHERS => '0');
      END IF;
    WHEN start =>
    IF (s_tick = '1') THEN
      IF s_reg = 7 THEN
        state_next <= data;
        s_next <= (OTHERS => '0');
        n_next <= (OTHERS => '0');
      ELSE
        s_next <= s_reg + 1;
      END IF;
    END IF;
    WHEN data =>
      IF (s_tick = '1') THEN
        IF s_reg = 15 THEN
          s_next <= (others => '0');
          b_next <= sync_rx & b_reg (7 downto 1);
          IF n_reg = (DBIT - 1) THEN
            state_next <= stop;
          ELSE
            n_next <= n_reg + 1;
          END IF;
        ELSE
          s_next <= s_reg + 1;
        END IF;
      end IF;
    WHEN stop =>
      IF (s_tick = '1') THEN
        IF s_reg = (SB_TICK - 1) then
          state_next    <= idle;
          rx_done_tick  <= '1';
        ELSE
          s_next <= s_reg + 1;
        END IF;
      END IF;
  END CASE;
END PROCESS;

dout <= b_reg;

END arch;



