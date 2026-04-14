module top_module(x, y, s1, s0, cin, cout);input [7:0]x;
	input [7:0]y;
  input cin;
	output s1;
	output s0;
	output [1:0]cout;

	wire [7:0]xnor_out;
	wire [3:0]sum_out;
	
	assign xnor_out = x ~^ y;
	
	assign {s0, sum_out} = xnor_out[0+:4] + xnor_out[4+:4] + cin;
  assign s1 = s0;
  assign cout = {sum_out[2], sum_out[0]};endmodule