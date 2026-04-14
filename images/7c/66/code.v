module top_module(x, y, s1, s0, cout);input [23:0]x;
  input [23:0]y;
  output s1;
  output s0;
  output [5:0]cout;

  wire [23:0]xnor_out;
  wire [11:0]sum_out;

  wire [2:0]sum_out_2; 

  
  
  assign xnor_out = x ~^ y;
 
  assign {s0, sum_out} = xnor_out[12+:12] + xnor_out[0+:12]; 
	assign s1 = s0;
  assign cout = {sum_out[10], sum_out[8], sum_out[6], sum_out[4], sum_out[2], sum_out[0]};endmodule