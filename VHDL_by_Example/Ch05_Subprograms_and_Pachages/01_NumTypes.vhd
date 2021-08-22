USE LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

PACKAGE num_types IS
TYPE log8 IS ARRAY(0 TO 7) OF std_logic; --line 1
END num_types;



USE LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.num_types.ALL;

ENTITY convert IS
PORT(I1 : IN log8; --line 2
O1 : OUT INTEGER); --line 3
END convert;
ARCHITECTURE behave OF convert IS
FUNCTION vector_to_int(S : log8) --line 4
RETURN INTEGER is --line 5
VARIABLE result : INTEGER := 0; --line 6
BEGIN
FOR i IN 0 TO 7 LOOP --line 7
result := result * 2; --line 8
IF S(i) = ‘1’ THEN --line 9
result := result + 1; --line 10
END IF;
END LOOP;
RETURN result; --line 11
END vector_to_int;
BEGIN
O1 <= vector_to_int(I1); --line 12
END behave;

