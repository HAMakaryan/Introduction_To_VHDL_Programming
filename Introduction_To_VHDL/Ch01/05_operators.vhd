--    VHDL Operators
--The operators provided by VHDL can be classified in the following
--main categories.
--      Assignment    Operators
--      Logical       Operators
--      Relational    Operators
--      Arithmetic    Operators
--      Concatenation Operator



--7.2 Operators (IEEE Std 1076™-2002)
--logical_operator        ::=   and | or  | nand  | nor | xor | xnor
--relational_operator     ::=   =   | /=  | <     | <=  | >   | >=
--shift_operator          ::=   sll | srl | sla   | sra | rol | ror
--adding_operator         ::=   +   | –   | &
--sign                    ::=   +   | –
--multiplying_operator    ::=   *   | /   | mod   | rem
--miscellaneous_operator  ::=   **  | abs | not



LIBRARY IEEE;
USE     IEEE.STD_LOGIC_1164.ALL;

ENTITY operators IS
END;

ARCHITECTURE assignment OF operators IS
  -- Assignment Operators  :=, <=, =>
  SIGNAL my_signal    : INTEGER :=10;                     -- Initial value assignment
  SIGNAL my_bit_vec   : BIT_VECTOR(4 DOWNTO 0) := "10011";-- Initial value assignment
  SIGNAL x_vec        : STD_LOGIC_VECTOR(5 DOWNTO 1) := (4|3=> '1', OTHERS=> '0');
  SIGNAL my_integer   : INTEGER;
BEGIN

  my_signal  <= 30;       -- Value assignment
  my_bit_vec <= "01100";  -- Value assignment

   PROCESS
    VARIABLE  my_signal : INTEGER := 10; -- Initial value assignment
    VARIABLE  x_vec_var : STD_LOGIC_VECTOR(0 TO 10) := (1|3|5 => '1', 2=> 'Z', OTHERS => '0');
  BEGIN
    my_signal :=  40; -- Value assignment
    x_vec     <= (4|3=> '1', OTHERS=> '0');
    my_integer <=  10 mod  3;
    WAIT FOR 10 ns;
    my_integer <= (-10) mod  3;
    WAIT FOR 10 ns;
    my_integer <=  10 mod (-3);
    WAIT FOR 10 ns;
    my_integer <= (-10) mod (-3);
    WAIT FOR 10 ns;

    my_integer <=  10 rem  3;
    WAIT FOR 10 ns;
    my_integer <= (-10) rem  3;
    WAIT FOR 10 ns;
    my_integer <=  10 rem (-3);
    WAIT FOR 10 ns;
    my_integer <= (-10) rem (-3);
    WAIT FOR 10 ns;




--    my_integer <=  10 mod -3;
--    WAIT FOR 10 ns;
--    my_integer <= -10 mod -3;
    WAIT FOR 10 ns;

    WAIT;
  END PROCESS;





END ARCHITECTURE;

