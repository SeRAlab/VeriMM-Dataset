module top_module(input [3:0] cond,input [7:0] ccr,output condition);wire C,V,Z,N; 
 assign C = ccr[0]; 
 assign V = ccr[1]; 
 assign Z = ccr[2]; 
 assign N = ccr[3]; 
 assign condition = (cond == 4'b0000) ? 1'b1 : 
  (cond == 4'b0001) ? 1'b0 : 
  (cond == 4'b0010) ? ~C & ~Z : 
  (cond == 4'b0011) ? C | Z : 
  (cond == 4'b0100) ? ~C : 
  (cond == 4'b0101) ? C : 
  (cond == 4'b0110) ? ~Z : 
  (cond == 4'b0111) ? Z : 
  (cond == 4'b1000) ? ~V : 
  (cond == 4'b1001) ? V : 
  (cond == 4'b1010) ? ~N : 
  (cond == 4'b1011) ? N : 
  (cond == 4'b1100) ? (N & V) | (~N & ~V) : 
  (cond == 4'b1101) ? (N & ~V) | (~N & V) : 
  (cond == 4'b1110) ? (N & V & ~Z) | (~N & ~V & ~Z) : 
  (cond == 4'b1111) ? (Z) | (N & ~V) | (~N & V) : 
  1'b0; 
 endmodule