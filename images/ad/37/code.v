module top_module(a, b);input a;
	output reg b;
	always @(*)
	begin
		b = a;
	end
endmodule