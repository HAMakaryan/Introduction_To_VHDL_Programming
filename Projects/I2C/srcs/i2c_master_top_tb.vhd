LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY i2c_master_top_tb IS

END i2c_master_top_tb;

ARCHITECTURE bhv OF i2c_master_top_tb IS

COMPONENT i2c_master_top IS
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
END COMPONENT;

CONSTANT START_CMD    : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
CONSTANT WR_CMD       : STD_LOGIC_VECTOR (2 DOWNTO 0) := "001";
CONSTANT RD_CMD       : STD_LOGIC_VECTOR (2 DOWNTO 0) := "010";
CONSTANT STOP_CMD     : STD_LOGIC_VECTOR (2 DOWNTO 0) := "011";
CONSTANT RESTART_CMD  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "100";
CONSTANT AC           : STD_LOGIC := '0';
CONSTANT NAC          : STD_LOGIC := '1';

CONSTANT DATA         : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
CONSTANT SLV_ADDR     : STD_LOGIC_VECTOR (2 DOWNTO 0) := "001";
CONSTANT COMMAND      : STD_LOGIC_VECTOR (2 DOWNTO 0) := "111";
CONSTANT DVSR_L       : STD_LOGIC_VECTOR (2 DOWNTO 0) := "010";
CONSTANT DVSR_H       : STD_LOGIC_VECTOR (2 DOWNTO 0) := "011";


SIGNAL  clk       : STD_LOGIC;  -- 100 MHz
SIGNAL  reset     : STD_LOGIC;
SIGNAL  wdata     : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL  waddr     : STD_LOGIC_VECTOR (2 DOWNTO 0);
SIGNAL  wvalid    : STD_LOGIC;
SIGNAL  wready    : STD_LOGIC;
SIGNAL  rdata     : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL  rvalid    : STD_LOGIC;
SIGNAL  rready    : STD_LOGIC;
SIGNAL  nack      : STD_LOGIC;
SIGNAL  scl       : STD_LOGIC;  -- 10 kHz
SIGNAL  sda       : STD_LOGIC;

SIGNAL end_of_test: STD_LOGIC;

BEGIN


scl <= 'H';
sda <= 'H';

clk <= '0' WHEN clk = 'U' OR end_of_test = '1'
          ELSE  NOT clk AFTER 5 ns;

reset <= '1', '0' AFTER 36 ns;


PROCESS (scl, reset)
  VARIABLE scl_count : INTEGER := 0;
BEGIN
  IF reset = '1' THEN
    sda       <= 'Z';
    scl_count := 0;
  ELSIF FALLING_EDGE(scl) THEN
    sda       <= 'Z';
    scl_count := scl_count + 1;
    IF
      scl_count =  9 OR
      scl_count = 18 OR
      scl_count = 27 OR
      scl_count = 36 OR
      scl_count = 46
    THEN
      sda <= '0';
    END IF;
  END IF;
END PROCESS;



PROCESS
BEGIN
  wdata   <= (OTHERS => '0');
  waddr   <= (OTHERS => '0');
  wvalid  <= '0';
  rready  <= '0';
  end_of_test <= '0';
  WAIT UNTIL reset = '0';
  FOR i IN 1 to 10 LOOP
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
  END LOOP;
  waddr   <= "001"; -- Slave Address
  wdata   <= "01010101";
  wvalid  <= '1';
  WAIT UNTIL clk = '1';
  WHILE (wready = '0') LOOP
    WAIT UNTIL clk = '1';
  END LOOP;
  -- 1000 =  "00000011_11101000"
  waddr   <= "010"; -- dvsr( 7 DOWNTO 0)
  wdata   <= "00001000";
  WAIT UNTIL clk = '1';
  WHILE (wready = '0') LOOP
    WAIT UNTIL clk = '1';
  END LOOP;
  waddr   <= "011"; -- dvsr(15 DOWNTO 8)
  wdata   <= "00000000";
  WAIT UNTIL clk = '1';
  WHILE (wready = '0') LOOP
    WAIT UNTIL clk = '1';
  END LOOP;
  waddr   <= "111"; -- cmd
  wdata   <= WR_CMD & "00011";
  WAIT UNTIL clk = '1';
  WHILE (wready = '0') LOOP
    WAIT UNTIL clk = '1';
  END LOOP;
  wvalid  <= '0';
  WAIT UNTIL clk = '1';
-- DATA
  waddr   <= DATA;
  wdata   <= "01010101";
  wvalid  <= '1';
  WAIT UNTIL clk = '1';
  WHILE (wready = '0') LOOP
    WAIT UNTIL clk = '1';
  END LOOP;
  wvalid  <= '0';
  WAIT UNTIL clk = '1';
-- DATA
  waddr   <= DATA;
  wdata   <= "10101010";
  wvalid  <= '1';
  WAIT UNTIL clk = '1';
  WHILE (wready = '0') LOOP
    WAIT UNTIL clk = '1';
  END LOOP;
  wvalid  <= '0';
  WAIT UNTIL clk = '1';
-- DATA
  waddr   <= DATA;
  wdata   <= "00001111";
  wvalid  <= '1';
  WAIT UNTIL clk = '1';
  WHILE (wready = '0') LOOP
    WAIT UNTIL clk = '1';
  END LOOP;
  wvalid  <= '0';
  WAIT UNTIL clk = '1';
  FOR i IN 1 to 10 LOOP
    WAIT UNTIL clk = '1';
  END LOOP;

  waddr   <= "111"; -- cmd
  wdata   <= RD_CMD & "01000";
  wvalid  <= '1';
  WAIT UNTIL clk = '1';
  WHILE (wready = '0') LOOP
    WAIT UNTIL clk = '1';
  END LOOP;
  wvalid  <= '0';
  WAIT UNTIL clk = '1';
  WAIT UNTIL wready = '1';
  wvalid  <= '0';


  WAIT FOR 10 us;
  end_of_test <= '1';
  WAIT;
END PROCESS;

DUT : i2c_master_top
PORT MAP (
    clk     =>  clk,
    reset   =>  reset,
    wdata   =>  wdata,
    waddr   =>  waddr,
    wvalid  =>  wvalid,
    wready  =>  wready,
    rdata   =>  rdata,
    rvalid  =>  rvalid,
    rready  =>  rready,
    nack    =>  nack,
    scl     =>  scl,
    sda     =>  sda
);

END ARCHITECTURE bhv;


