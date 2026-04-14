module top_module(i_data0,o_data0);input [31:0] i_data0; 
  output [31:0] 
  o_data0; 
  wire [31:0] 
  w1, 
  w8, 
  w7, 
  w14, 
  w13, 
  w6656, 
  w6649, 
  w13298; 
  assign w1 = i_data0; 
  assign w13 = w14 - w1; 
  assign w13298 = w6649 << 1; 
  assign w14 = w7 << 1; 
  assign w6649 = w6656 - w7; 
  assign w6656 = w13 << 9; 
  assign w7 = w8 - w1; 
  assign w8 = w1 << 3; 
  assign o_data0 = w13298; 
 endmodule