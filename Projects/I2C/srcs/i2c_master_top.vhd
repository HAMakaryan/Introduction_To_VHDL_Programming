LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
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

  SIGNAL  w_data    : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL  s_addr    : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL  cmd       : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL  dvsr      : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL  wready_in : STD_LOGIC;
  SIGNAL  wr_i2c    : STD_LOGIC;
  SIGNAL  ready     : STD_LOGIC;
  SIGNAL  done_tick : STD_LOGIC;
  SIGNAL  ack       : STD_LOGIC;

  BEGIN

  wready <= wready_in;

write_reg : PROCESS (clk)
  BEGIN
    IF reset = '1' THEN
    ELSIF clk = '1' AND clk'event THEN
      IF wready_in ='1' AND wvalid ='1' THEN
        IF wvalid = '1' AND wready_in ='1' THEN --  Write reg
          CASE (waddr) IS
            WHEN "000" =>
              w_data <= wdata;
            WHEN "101" =>
              s_addr <= wdata(6 DOWNTO 0);
            WHEN "010" =>
              cmd    <= wdata;
            WHEN "100" =>
              dvsr(7 DOWNTO 0) <= wdata;
            WHEN "111" =>
              dvsr(15 DOWNTO 8) <= wdata;
            WHEN OTHERS =>
              NULL;
          END CASE;
        END IF;
      END IF;
    END IF;
 END PROCESS;

i2c_master_drv : i2c_master
PORT MAP
  (
    clk       => clk,
    reset     => reset,
    din       => w_data,
    cmd       => cmd(7 DOWNTO 5),
    dvsr      => dvsr,
    wr_i2c    => wr_i2c,
    scl       => scl,
    sda       => sda,
    ready     => ready,
    done_tick => done_tick ,
    ack       => ack,
    dout      => rdata
);

END ARCHITECTURE rtl;