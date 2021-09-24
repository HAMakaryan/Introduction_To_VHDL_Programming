LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--USE IEEE.NUMERIC_STD.ALL;
--USE IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY i2c_master_top IS
PORT
  (
    clk       : IN    STD_LOGIC;  -- 100 MHz
    reset     : IN    STD_LOGIC;
    wdata     : IN    STD_LOGIC_VECTOR (7 DOWNTO 0);
    waddr     : IN    STD_LOGIC_VECTOR (2 DOWNTO 0);
    wvalid    : IN    STD_LOGIC;
    wready    : OUT   STD_LOGIC;
    rdata     : OUT   STD_LOGIC_VECTOR (7 DOWNTO 0);
    rvalid    : OUT   STD_LOGIC;
    rready    : IN    STD_LOGIC;
    nack      : OUT   STD_LOGIC;
    scl       : OUT   STD_LOGIC;  -- 10 kHz
    sda       : INOUT STD_LOGIC
    );

END ENTITY i2c_master_top;


ARCHITECTURE rtl of i2c_master_top IS

COMPONENT i2c_master
PORT
  (
    clk       : IN    STD_LOGIC;  -- 100 MHz
    reset     : IN    STD_LOGIC;
    din       : IN    STD_LOGIC_VECTOR ( 7 DOWNTO 0);
    cmd       : IN    STD_LOGIC_VECTOR ( 2 DOWNTO 0);
    dvsr      : IN    STD_LOGIC_VECTOR (15 DOWNTO 0);
    wr_i2c    : IN    STD_LOGIC;
    scl       : OUT   STD_LOGIC;  -- 10 kHz
    sda       : INOUT STD_LOGIC;
    ready     : OUT   STD_LOGIC;
    done_tick : OUT   STD_LOGIC;
    ack       : OUT   STD_LOGIC;
    dout      : OUT   STD_LOGIC_VECTOR ( 7 DOWNTO 0)
);
END COMPONENT;


COMPONENT fifo IS
GENERIC(
  ADDR_WIDTH : integer := 2;
  DATA_WIDTH : integer := 8
);
PORT(
  clk     : IN STD_LOGIC;
  reset   : IN STD_LOGIC;
  rd      : IN STD_LOGIC;
  wr      : IN STD_LOGIC;
  w_data  : IN STD_LOGIC_VECTOR ( DATA_WIDTH - 1 DOWNTO 0);
  empty   : OUT STD_LOGIC;
  full    : OUT STD_LOGIC;
  r_data  : OUT STD_LOGIC_VECTOR ( DATA_WIDTH - 1 DOWNTO 0)
);
END COMPONENT;



  CONSTANT START_CMD    : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
  CONSTANT WR_CMD       : STD_LOGIC_VECTOR (2 DOWNTO 0) := "001";
  CONSTANT RD_CMD       : STD_LOGIC_VECTOR (2 DOWNTO 0) := "010";
  CONSTANT STOP_CMD     : STD_LOGIC_VECTOR (2 DOWNTO 0) := "011";
  CONSTANT RESTART_CMD  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "100";
  CONSTANT AC           : STD_LOGIC := '0';
  CONSTANT NAC          : STD_LOGIC := '1';
  TYPE fsm_type IS (
    IDLE, I2C_WR1, I2C_WR2, I2C_READ1, I2C_READ2, I2C_STOP,
    I2C_START, REQUEST, RESPONSE
  );
  SIGNAL  fsm       : fsm_type;
  SIGNAL  s_addr    : STD_LOGIC_VECTOR ( 6 DOWNTO 0);
  SIGNAL  cmd       : STD_LOGIC_VECTOR ( 7 DOWNTO 0);
  SIGNAL  dvsr      : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL  din       : STD_LOGIC_VECTOR ( 7 DOWNTO 0);
  SIGNAL  i2c_din   : STD_LOGIC_VECTOR ( 7 DOWNTO 0);
  SIGNAL  i2c_cmd   : STD_LOGIC_VECTOR ( 2 DOWNTO 0);
  SIGNAL  byte_cnt  : STD_LOGIC_VECTOR ( 4 DOWNTO 0);
  SIGNAL  wready_in : STD_LOGIC;
  SIGNAL  wr_i2c    : STD_LOGIC;
  SIGNAL  ready     : STD_LOGIC;
  SIGNAL  done_tick : STD_LOGIC;
  SIGNAL  ack_in    : STD_LOGIC;
  SIGNAL  wr_i2c_com : STD_LOGIC;

  SIGNAL  w_fifo_rd      : STD_LOGIC;
  SIGNAL  w_fifo_wr      : STD_LOGIC;
  SIGNAL  w_fifo_w_data  : STD_LOGIC_VECTOR ( 7 DOWNTO 0);
  SIGNAL  w_fifo_empty   : STD_LOGIC;
  SIGNAL  w_fifo_full    : STD_LOGIC;
  SIGNAL  w_fifo_r_data  : STD_LOGIC_VECTOR ( 7 DOWNTO 0);

  SIGNAL  r_fifo_rd      : STD_LOGIC;
  SIGNAL  r_fifo_wr      : STD_LOGIC;
  SIGNAL  r_fifo_w_data  : STD_LOGIC_VECTOR ( 7 DOWNTO 0);
  SIGNAL  r_fifo_empty   : STD_LOGIC;
  SIGNAL  r_fifo_full    : STD_LOGIC;
  SIGNAL  r_fifo_r_data  : STD_LOGIC_VECTOR ( 7 DOWNTO 0);




  BEGIN

wr_i2c_com <= wr_i2c AND ready;
  wready  <= wready_in;

ACKNOWLEDGE : PROCESS (clk)
BEGIN
  IF reset = '1' THEN
    nack <= '0';
  ELSIF clk = '1' AND clk'event THEN
    IF done_tick = '1' THEN
      nack <= ack_in;
    END IF;
  END IF;
END PROCESS;

FSMD : PROCESS (clk)
BEGIN
  IF reset = '1' THEN
    fsm       <= IDLE;
    wr_i2c    <= '0';
    wready_in <= '0';
    rvalid    <= '0';
    i2c_cmd   <= (OTHERS => '0');
    byte_cnt  <= (OTHERS => '0');
    s_addr    <= (OTHERS => '0');
    din       <= (OTHERS => '0');
    cmd       <= (OTHERS => '0');
    dvsr      <= (OTHERS => '0');
  ELSIF clk = '1' AND clk'event THEN
    wready_in <= '0';
    rvalid    <= '0';
    wr_i2c    <= '0';
    i2c_cmd   <= cmd(7 DOWNTO 5);

    CASE (fsm) IS
      WHEN IDLE =>
        wready_in <=  '1';
        IF wvalid = '1' THEN --  Write reg
          CASE (waddr) IS
            WHEN "000" =>
              din <= wdata;
            WHEN "001" =>
              s_addr <= wdata(6 DOWNTO 0);
            WHEN "111" =>
              cmd <= wdata;
              IF wdata(7 DOWNTO 5) = WR_CMD OR
                 wdata(7 DOWNTO 5) = RD_CMD THEN
                fsm <= I2C_START;
              END IF;
            WHEN "010" =>
              dvsr( 7 DOWNTO 0) <= wdata;
            WHEN "011" =>
              dvsr(15 DOWNTO 8) <= wdata;
            WHEN OTHERS =>
              NULL;
          END CASE;
        END IF;
      WHEN I2C_START =>
        IF ready = '1' THEN
          wr_i2c  <= '1';
          i2c_cmd <= START_CMD;
          IF wr_i2c = '1' THEN
            wr_i2c <= '0';
            fsm     <= REQUEST;
          END IF;
        END IF;
      WHEN REQUEST =>
        IF ready = '1' THEN
          wr_i2c    <= '1';
          i2c_cmd   <= WR_CMD;
          byte_cnt  <= cmd (4 DOWNTO 0);
          IF wr_i2c = '1' THEN
            wr_i2c <= '0';
            fsm    <= RESPONSE;
          END IF;
        END IF;
      WHEN RESPONSE =>
        IF ready = '1' THEN
          IF ack_in /= AC OR cmd(5 DOWNTO 0) = "00000" THEN
            fsm <= I2C_STOP;
          ELSIF cmd(6) = '0' THEN
            fsm <= I2C_WR1;
          ELSE
            fsm       <= I2C_READ1;
            i2c_cmd   <= RD_CMD;
            IF byte_cnt = "00000" THEN
              fsm       <= I2C_STOP;
            ELSE
            END IF;
          END IF;
        END IF;
      WHEN I2C_READ1 =>
        IF ready = '1' THEN
          wr_i2c    <= '1';
          IF wr_i2c = '1' THEN
            wr_i2c    <= '0';
            byte_cnt  <= byte_cnt - 1;
            fsm       <= I2C_READ2;
          END IF;
          IF byte_cnt = "00000" THEN
            fsm       <= I2C_STOP;
            wr_i2c    <= '0';
          END IF;
        END IF;
      WHEN I2C_READ2 =>
        IF ready = '1' THEN
          rvalid    <= '1';
          wr_i2c    <= '1';
          IF wr_i2c = '1' THEN
            wr_i2c    <= '0';
            byte_cnt  <= byte_cnt - 1;
          END IF;
          IF byte_cnt = "00000" THEN
            fsm       <= I2C_STOP;
            wr_i2c    <= '0';
            byte_cnt  <= byte_cnt - 1;
          END IF;
        END IF;
      WHEN I2C_STOP =>
        IF ready = '1' THEN
          wr_i2c    <= '1';
          i2c_cmd   <= STOP_CMD;
          IF wr_i2c = '1' THEN
            wr_i2c    <= '0';
            fsm       <= IDLE;
          END IF;
        END IF;
      WHEN I2C_WR1 =>
        IF ready = '1' THEN
          IF ack_in /= AC OR byte_cnt = "00000" THEN
            fsm <= I2C_STOP;
          ELSIF wvalid = '1' AND waddr = "000" THEN
            wready_in <=  '1';
            fsm       <= I2C_WR2;
            din       <= wdata;
          END IF;
        END IF;
      WHEN I2C_WR2 =>
        i2c_cmd <= WR_CMD;
        wr_i2c  <= '1';
        IF wr_i2c = '1' THEN
          wr_i2c    <= '0';
          byte_cnt  <= byte_cnt-1;
          fsm       <= I2C_WR1;
        END IF;
      WHEN OTHERS =>
        NULL;
    END CASE;
  END IF;
END PROCESS;


i2c_din   <= s_addr & cmd (6) WHEN fsm = REQUEST AND ready = '1' ELSE
                   "00000000" WHEN  i2c_cmd = RD_CMD  AND byte_cnt = "00001" ELSE
                   "00000001" WHEN  i2c_cmd = RD_CMD  AND byte_cnt = "00000" ELSE
                  w_fifo_r_data;

i2c_master_drv : i2c_master
PORT MAP
  (
    clk       => clk,
    reset     => reset,
    din       => i2c_din,
    cmd       => i2c_cmd,
    dvsr      => dvsr,
    wr_i2c    => wr_i2c_com,
    scl       => scl,
    sda       => sda,
    ready     => ready,
    done_tick => done_tick,
    ack       => ack_in,
    dout      => rdata
);


wr_fifo : fifo
GENERIC MAP(
  ADDR_WIDTH  => 4,
  DATA_WIDTH  => 8
)
PORT MAP (
  clk     => clk,
  reset   => reset,
  rd      => w_fifo_rd,
  wr      => w_fifo_wr,
  w_data  => w_fifo_w_data,
  empty   => w_fifo_empty,
  full    => w_fifo_full,
  r_data  => w_fifo_r_data
);



rd_fifo : fifo
GENERIC MAP(
  ADDR_WIDTH  => 4,
  DATA_WIDTH  => 8
)
PORT MAP (
  clk     => clk,
  reset   => reset,
  rd      => r_fifo_rd,
  wr      => r_fifo_wr,
  w_data  => r_fifo_w_data,
  empty   => r_fifo_empty,
  full    => r_fifo_full,
  r_data  => r_fifo_r_data
);



END ARCHITECTURE rtl;

