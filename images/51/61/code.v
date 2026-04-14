module top_module(O, I0, I1, I2, I3, I4, I5);parameter INIT = 64'h0000000000000000; 
  input I0, I1, I2, I3, I4, I5; 
  output O; 
  reg O; 
  reg tmp; 
  always @( I5 or I4 or I3 or I2 or I1 or I0 ) begin 
  tmp = I0 ^ I1 ^ I2 ^ I3 ^ I4 ^ I5; 
  if ( tmp == 0 || tmp == 1) 
  O = INIT[{I5, I4, I3, I2, I1, I0}]; 
  end 
 endmodule