module top_module( IN0, IN1, CTRL, OUT1 );input [3:0] IN0; 
  input [3:0] IN1; 
  output [3:0] OUT1; 
  input CTRL; 
  assign OUT1[3] = IN0[3]; 
  assign OUT1[2] = IN0[2]; 
  assign OUT1[1] = IN0[1]; 
  assign OUT1[0] = IN0[0]; 
 endmodule