-- Chapter_4_Data_Types

-------------------------- DATA TYPES --------------------------

--  Type Declaration
--    Name Of The Type
--    Range Of The Type

----  Type declarations are allowed in
--      package declaration sections
--      entity declaration sections
--      architecture declaration sections
--      subprogram declaration sections
--      process declaration sections.

----  TYPE type_name IS type_mark;
--      A type_mark construct encompasses a wide range of methods for specifying
--      a type.
--      It can be anything from an enumeration of all of the values
--      of a type to a complex record structure.


-------------------------- Scalar Types --------------------------
--    Scalar types describe objects that can hold, at most, one value at a time.
--    Referencing the name of the object references the entire object.

----  Scalar types encompass these four classes of types:
--      Integer types
--      Real types
--      Enumerated types
--      Physical types

--  INTEGER TYPES
--The VHDL LRM does not specify a maximum range for integers,
--but does specify the minimum range: from -2,147,483,647 to +2,147,483,647.

ARCHITECTURE test OF test IS
BEGIN

  PROCESS(X)
    VARIABLE a : INTEGER;
  BEGIN
    a :=  1; --Ok 1
    a := -1; --Ok 2
    a := 1.0; --ERROR - noninteger assignment to an integer variable
  END PROCESS;

END test;

--  REAL TYPES
--The minimum range of real numbers is also specified by the Standard
--package in the Standard Library, and is
--      from -1.0E38 to +1.0E38
--  These numbers are represented by the following notation:
--    +(-) number.number[E +(-) number]
ARCHITECTURE test OF test IS
  SIGNAL a : REAL;
BEGIN
  a <= 1.0;     --Ok 1
  a <= 1;       --error 2
  a <= -1.0E10; --Ok 3
  a <= 1.5E-20; --Ok 4
  a <= 5.3 ns;  --error 5
END test;
-- All real numbers have a decimal point to distinguish them from integer values.




