module top_module(
a, b, sel, data_out
);input wire[63:0] a;
	input wire[63:0] b;
	input sel;
	output reg[63:0] data_out;

	always @(sel or a or b)
	begin
		if(sel == 0)
			data_out = a;
		else
			data_out = b;
	end
endmodule