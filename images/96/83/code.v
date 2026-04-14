module top_module(data_0, data_1, data_2, data_3,
	data_4, data_5, data_6, data_7, condition, data_out);parameter WIDTH = 32;

	input  [WIDTH-1:0] data_0;
	input  [WIDTH-1:0] data_1;
	input  [WIDTH-1:0] data_2;
	input  [WIDTH-1:0] data_3;
	input  [WIDTH-1:0] data_4;
	input  [WIDTH-1:0] data_5;
	input  [WIDTH-1:0] data_6;
	input  [WIDTH-1:0] data_7;
	input  [2:0] condition;
	output [WIDTH-1:0] data_out;

	assign data_out = ({WIDTH{condition==3'd0}} & data_0)
					| ({WIDTH{condition==3'd1}} & data_1)
					| ({WIDTH{condition==3'd2}} & data_2)
					| ({WIDTH{condition==3'd3}} & data_3)
					| ({WIDTH{condition==3'd4}} & data_4)
					| ({WIDTH{condition==3'd5}} & data_5)
					| ({WIDTH{condition==3'd6}} & data_6)
					| ({WIDTH{condition==3'd7}} & data_7);
endmodule