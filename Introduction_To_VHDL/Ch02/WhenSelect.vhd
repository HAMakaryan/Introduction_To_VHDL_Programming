
  <signal_object> <=  <statement> WHEN <condition> ELSE
                      <statement> WHEN <condition> ELSE
                      ....................
                      <statement> WHEN <condition> ELSE
                      <statement>;
  
  WITH <condition> SELECT
  <signal_object> <=  <statement> WHEN <condition>,
                      <statement> WHEN <condition>,
                      ....................
                      <statement> WHEN OTHERS;

-------------------------------------------------------
 F(x,y,z) = x'*y' + y'*z
 
 f <= (((NOT x) and (NOT y)) OR ((NOT y ) and z )); 




