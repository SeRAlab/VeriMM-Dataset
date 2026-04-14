module top_module(data_0, data_1, data_2, data_3, condition, data_out);parameter WIDTH = 32;

	input  [WIDTH-1:0] data_0;
	input  [WIDTH-1:0] data_1;
	input  [WIDTH-1:0] data_2;
	input  [WIDTH-1:0] data_3;
	input  [1:0] condition;
	output [WIDTH-1:0] data_out;

	assign data_out = ({WIDTH{condition==2'd0}} & data_0)
					| ({WIDTH{condition==2'd1}} & data_1)
					| ({WIDTH{condition==2'd2}} & data_2)
					| ({WIDTH{condition==2'd3}} & data_3);
endmodule