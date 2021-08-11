library ieee;
use ieee.std_logic_1164.all;

entity Practice_1_tB is
end;

architecture Practice_1_TB_logic of Practice_1_TB is
  component Practice_1 is
    port(in1,in2,in3,in4: in  std_logic;
    out1,out2,out3: out std_logic
    );
   end component;
   signal in1,in2,in3,in4 : std_logic;
   signal out1,out2,out3 : std_logic;
begin
    pm: Practice_1 port map (
    in1=>in1,
    in2=>in2,
    in3=>in3,
    in4=>in4,
    out1=>out1,
    out2=>out2,
    out3=>out3
   );

   proc: process
   begin
     in1 <= '0';
     in2 <= '0';
     in3 <= '0';
     in4 <= '0';
     wait for 20 ns;
     in1 <= '1';
     in2 <= '0';
     in3 <= '1';
     in4 <= '0';
     wait for 20 ns;
     in1 <= '1';
     in2 <= '1';
     in3 <= '1';
     in4 <= '1';
     wait;
   end process;

end;