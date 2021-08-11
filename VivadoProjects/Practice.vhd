library ieee;
use ieee.std_logic_1164.all;

entity  Practice_1 is
  port(in1,in2,in3,in4: in  std_logic;
    out1,out2,out3: out std_logic
    );
   end;

architecture Practice_1_logic of Practice_1 is
  begin
    out1 <= in1 and in2 and in3 and in4;
    out2 <= in1 or in2 or in3 or in4;
    out3 <= in1 xor in2 xor in3 xor in4;
end architecture;



