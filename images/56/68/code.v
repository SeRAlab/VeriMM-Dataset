module top_module(x, y, s0, cout);input [7:0]x;
  input [7:0]y;
  output s0;
  output [3:0]cout;

  wire [7:0]xnor_out;
	
  assign xnor_out = x ~^ y;
  assign {s0, cout}  = xnor_out[3:0] + xnor_out[7:4];endmodule