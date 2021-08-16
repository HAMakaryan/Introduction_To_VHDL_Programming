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

--                  PHYSICAL TYPES
--  Physical types are used to represent physical quantities such as distance,
--    current, time, and so on. A physical type provides for a base unit, and
--    successive units are then defined in terms of this unit. The smallest unit
--    representable is one base unit; the largest is determined by the range
--    specified in the physical type declaration.

TYPE current IS RANGE 0 to 1000000000
UNITS
  na;             --  nano amps
  ua  = 1000 na;  --  micro amps
  ma  = 1000 ua;  --  milli amps
  a   = 1000 ma;  --  amps
END UNITS;

--    PREDEFINED PHYSICAL TYPES
--  The only predefined physical type in VHDL is the physical type TIME.
--  This type is shown here:

TYPE TIME IS RANGE <implementation defined>
UNITS
  fs;               --femtosecond
  ps  = 1000  fs;   --picosecond
  ns  = 1000  ps;   --nanosecond
  us  = 1000  ns;   --microsecond
  ms  = 1000  us;   --millisecond
  sec = 1000  ms;   --second
  min = 60    sec;  --minute
  hr  = 60    min;  --hour
END UNITS;

--  Following is an example using a physical type:

PACKAGE example IS
  TYPE current IS RANGE 0 TO 1000000000
  UNITS
    na;            --nano amps
    ua  = 1000 na; --micro amps
    ma  = 1000 ua; --milli amps
    a   = 1000 ma; --amps
  END UNITS;
  TYPE load_factor IS (small, med, big );
END example;

USE WORK.example.ALL;

ENTITY delay_calc IS
  PORT (
    out_current : OUT current;
    load        : IN  load_factor;
    delay       : OUT time
  );
END delay_calc;

ARCHITECTURE delay_calc OF delay_calc IS
BEGIN
  delay <=  10 ns WHEN (load = small) ELSE
            20 ns WHEN (load = med)   ELSE
            30 ns WHEN (load = big)   ELSE
            10 ns;

  out_current <= 100  ua WHEN (load = small)ELSE
                 1    ma WHEN (load = med)  ELSE
                 10   ma WHEN (load = big)  ELSE
                 100  ua;
END delay_calc;


