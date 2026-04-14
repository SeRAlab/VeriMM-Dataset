module sequential_module (
	input clock,
	input rst,
	input load,
	input data,
	output reg q);always @(posedge clock or posedge rst)
	if (rst)
		q <= 0;
	else if (load)
		q <= data;
	else
		q <= q;
endmodule