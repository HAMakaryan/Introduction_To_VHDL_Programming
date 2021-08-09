--
--  <signal_object> <=  <statement> WHEN <condition> ELSE
--                      <statement> WHEN <condition> ELSE
--                      ....................
--                      <statement> WHEN <condition> ELSE
--                      <statement>;
--
--  WITH <condition> SELECT
--  <signal_object> <=  <statement> WHEN <condition>,
--                      <statement> WHEN <condition>,
--                      ....................
--                      <statement> WHEN OTHERS;
--
---------------------------------------------------------
-- F(x,y,z) = x'*y' + y'*z
--
-- f <= (((NOT x) and (NOT y)) OR ((NOT y ) and z ));
--

ENTITy f_function IS
PORT(
  x : IN  BIT;
  y : IN  BIT;
  z : IN  BIT;
  f : OUT BIT
);
END ENTITY;

ARCHITECTURE logic_flow OF f_function IS

  SIGNAL concat : bit_vector(2 downto 0);

BEGIN
  f <= (((NOT x) AND (NOT y)) OR ((NOT y ) AND z ));

--x   y   z   f(x,y,z)
--0   0   0     1
--0   0   1     1
--0   1   0     0
--0   1   1     0
--1   0   0     0
--1   0   1     1
--1   1   0     0
--1   1   1     0


-- With WHEN statement, it can be implemented as


  f <= '1' WHEN (x = '0' AND y = '0' AND z = '0') ELSE
       '1' WHEN (x = '0' AND y = '0' AND z = '1') ELSE
       '1' WHEN (x = '1' AND y = '0' AND z = '1') ELSE
       '0';

  f <= '1' WHEN (x = '0' AND y = '0' AND z = '0') OR
                (x = '0' AND y = '0' AND z = '1') OR
                (x = '1' AND y = '0' AND z = '1') ELSE
       '0';

-- With SELECT statement, it can be implemented as
concat <= (x & y & z);

-- WITH (x & y & z) SELECT
WITH concat SELECT
  f <= '1' WHEN "000",
       '1' WHEN "001",
       '1' WHEN "101",
       '0' WHEN OTHERS;

END ARCHITECTURE;



ENTITY fx_function IS
PORT(
  x: IN   INTEGER;
  y: OUT  INTEGER RANGE 0 TO 4
);
END ENTITY;

ARCHITECTURE logic_flow OF fx_function IS
BEGIN
--        |2 if x = 1 or x = 2
--  Fx =  |4 if 3<= x<= 6
--        |0 otherwise:


WITH x SELECT
      y <= 2 WHEN 1 |  2,
           4 WHEN 3 TO 6,
           0 WHEN OTHERS;


END ARCHITECTURE;



