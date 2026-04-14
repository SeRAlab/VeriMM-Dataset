module top_module(x, y, s0, cout);input [19:0]x;
  input [19:0]y;
  output s0;
  output [9:0]cout;

  wire [19:0]xnor_out;
	
  
  assign xnor_out = x ~^ y;
  assign {s0, cout} = xnor_out[9:0] + xnor_out[19:10];endmodule