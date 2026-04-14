module top_module(output o,input a,input b,input c);parameter [7:0] INIT = 8'h0; 
  parameter EQN = "(A)"; 
  wire [3:0] s2 = c ? INIT[ 7:4] : INIT[3:0]; 
  wire [1:0] s1 = b ? s2[ 3:2] : s2[1:0]; 
  assign o = a ? s1[1] : s1[0]; 
 endmodule