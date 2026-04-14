module top_module(x, y, s0, s1, cout);input [19:0]x;
	input [19:0]y;
	output s0;
	output s1;
	output [4:0]cout;
	
	wire[19:0]xnor_out;
	wire [9:0]sum_out;
	
	
	assign xnor_out = x ~^ y;
  assign {s0, sum_out} = xnor_out[9:0] + xnor_out[19:10];

	
  assign {s1, cout} = sum_out[4:0] + sum_out[9:5];endmodule