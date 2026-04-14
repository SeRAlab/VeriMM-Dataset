module top_module(
	input x,
	input y,
	input c,
	output reg p,
	output reg g,
	output reg z
    );always @( * )
	begin
		g = x & y;
		p = x ^ y;
		z = x ^ y ^ c;
	end

endmodule