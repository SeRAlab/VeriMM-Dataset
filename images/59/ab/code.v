module top_module(output F, input I0, I1, I2);parameter [7:0] INIT = 0; 
  wire [ 3: 0] s2 = I2 ? INIT[ 7: 4] : INIT[ 3: 0]; 
  wire [ 1: 0] s1 = I1 ? s2[ 3: 2] : s2[ 1: 0]; 
  assign F = I0 ? s1[1] : s1[0]; 
 endmodule