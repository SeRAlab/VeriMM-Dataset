module top_module(x, y, int_s0, s0, cout);input [7:0]x;
  input [7:0]y;
  input [5:0]int_s0;
  output s0;
  output [6:0]cout;

  wire [7:0]xnor_out;
	
  assign xnor_out = x ~^ y;

  wire [13:0]int_add;

  assign int_add = {xnor_out,int_s0};

  assign {s0, cout}  = int_add[6:0] + int_add[13:7];endmodule