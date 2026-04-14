module top_module(inp, outp);input [3:0] inp;
	output reg outp;

	always @(inp)
       	begin
		outp <= (inp[0] & inp[1]) |
			(inp[2] & inp[3]) |
			(inp[1] & ~inp[2] & inp[3]) |
			(~inp[0] & inp[1] & inp[2]) |
			(inp[0] & ~inp[1] & inp[3]) |
			(inp[0] & inp[2] & ~inp[3]);
	end
	endmodule