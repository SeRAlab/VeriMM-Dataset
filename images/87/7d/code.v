module top_module(y, x);input [8:0] x;
	output [8:0] y;
	reg [8:0] y;
	always @ (x)
	begin
		y[0] = x[2] ^ x[7];
		y[1] = x[3] ^ x[8];
		y[2] = x[4];
		y[3] = x[5];
		y[4] = x[2] ^ x[6] ^ x[7];
		y[5] = x[3] ^ x[7] ^ x[8];
		y[6] = x[4] ^ x[8];
		y[7] = x[0] ^ x[5];
		y[8] = x[1] ^ x[6];
	end
endmodule