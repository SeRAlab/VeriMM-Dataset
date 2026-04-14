module top_module(x, y, int_s1, int_s0, s1, s0, cout);input [7:0]x;
	input [7:0]y;
	input [4:0]int_s0;
	input [4:0]int_s1;
	output s1;
	output s0;
	output [5:0]cout;

	wire [7:0]xnor_out;
	wire [12:0]sum_in_0;
	wire [5:0]sum_out_0;
	
	
	assign xnor_out = x ~^ y;
	assign sum_in_0 = {int_s0, xnor_out[7:0]};
	
	
	assign {s0, sum_out_0[5:0]} = sum_in_0[11:6] + sum_in_0[5:0] + sum_in_0[12];

	
  wire [5:0]sum_in_s1;
  wire [3:0]sum_out_s1;

  assign sum_in_s1 = {int_s1, s0};
	assign {s1, sum_out_s1} = {1'b0,sum_in_s1[2:0]} + {1'b0,sum_in_s1[5:3]};

  assign cout = {sum_out_s1[2:0], sum_out_0[4], sum_out_0[2],sum_out_0[0]};endmodule