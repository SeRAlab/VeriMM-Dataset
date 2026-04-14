module sequential_module (
	input clock,
	input rst,
	input in,
	output reg out);always @(posedge clock or posedge rst)
	if (rst)
		out <= 0;
	else
		out <= in;
endmodule