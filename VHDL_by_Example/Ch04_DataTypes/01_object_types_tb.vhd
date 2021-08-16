USE WORK.sigdecl.ALL;
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY object_types_tb IS
END;

ARCHITECTURE bhv OF object_types_tb IS

COMPONENT board_design IS
  PORT(
    data_in   : IN  bus_type;
    data_out  : OUT bus_type
  );
END COMPONENT;

SIGNAL  Tx :  bus_type;
SIGNAL  Rx :  bus_type;

BEGIN

DUT: board_design
PORT MAP (
  data_in   => Tx,
  data_out  => Rx
);

PROCESS
BEGIN
  Tx <= ((0) => '1', OTHERS => '0');
  WAIT FOR 13 NS;
  Tx <= ((1) => '1', OTHERS => '0');
  WAIT FOR 13 NS;
  Tx <= ((2) => '1', OTHERS => '0');
  WAIT FOR 13 NS;
  Tx <= ((3) => '1', OTHERS => '0');
  WAIT FOR 13 NS;
  Tx <= ((4) => '1', OTHERS => '0');
  WAIT FOR 13 NS;
  Tx <= ((5) => '1', OTHERS => '0');
  WAIT FOR 13 NS;
  Tx <= ((6) => '1', OTHERS => '0');
  WAIT FOR 13 NS;
  Tx <= ((7) => '1', OTHERS => '0');
  WAIT FOR 131 NS;

  Tx <= ((0) => '1', OTHERS => '0');
  WAIT FOR 13 NS;
  Tx <= ((1) => '1', OTHERS => '0');
  WAIT FOR 13 NS;
  Tx <= ((2) => '1', OTHERS => '0');
  WAIT FOR 13 NS;
  Tx <= ((3) => '1', OTHERS => '0');
  WAIT FOR 13 NS;
  Tx <= ((4) => '1', OTHERS => '0');
  WAIT FOR 13 NS;
  Tx <= ((5) => '1', OTHERS => '0');
  WAIT FOR 13 NS;
  Tx <= ((6) => '1', OTHERS => '0');
  WAIT FOR 13 NS;
  Tx <= ((7) => '1', OTHERS => '0');
  WAIT FOR 131 NS;

END PROCESS;



END bhv;
