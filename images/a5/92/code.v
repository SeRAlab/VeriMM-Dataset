module top_module(
	input wire a, b, c,
	output reg y
	);always @(a, b, c)
	begin
		y = a;
		y = y & b;
		y = y & c;
	end
endmodule