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
    nack      : OUT   STD_LOGIC
    );

END ENTITY i2c_master_top;

ARCHITECTURE rtl of i2c_master_top IS
  SIGNAL  w_data : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL  s_addr : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL  cmd    : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL  dvsr   : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL  wready_in : STD_LOGIC;

  BEGIN

  wready <= wready_in;

write_reg : PROCESS (clk)
  BEGIN
    if reset = '1' then
    elsif clk = '1' and clk'event
      if wready_in ='1' and wvalid ='1' then
        case (waddr) is
          when "000" =>
            w_data <= wdata;
          when "001" =>
            s_addr <= wdata(6 DOWNTO 0);
          when "010" =>
            cmd    <= wdata;
          when "011" =>
            dvsr(7 DOWNTO 0) <= wdata;
          when "100"
            dvsr(15 DOWNTO 8) <= wdata;
      end if;
    end if;

 END PROCESS;
END ARCHITECTURE rtl;