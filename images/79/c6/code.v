module top_module(c0, c1, c2, c3, hex);input c0;
	input c1;
	input c2;
	input c3;

	output [6:0] hex;

	assign hex[0] = (~c3 & c2 & ~c1 & ~c0) | (c3 & ~c2 & c1 & c0) | (~c3 & ~c2 & ~c1 & c0) | (c3 & c2 & ~c1 & c0);
	assign hex[1] = (c3 & c2 & ~c0) | (c2 & c1 & ~c0) | (c3 & c2 & c1) | (c3 & c1 & c0) | (~c3 & c2 & ~c1 & c0);
	assign hex[2] = (c3 & c2 & ~c0) | (c3 & c2 & c1) | (~c3 & ~c2 & c1 & ~c0);
	assign hex[3] = (~c3 & ~c2 & ~c1 & c0) | (c2 & c1 & c0) | (c3 & ~c2 & c1 & ~c0) | (~c3 & c2 & ~c1 & ~c0);
	assign hex[4] = (~c3 & c0) | (~c2 & ~c1 & c0) | (~c3 & c2 & ~c1);
	assign hex[5] = (~c3 & ~c2 & c1) | (~c3 & ~c2 & c0) | (~c3 & c1 & c0) | (c3 & c2 & ~c1 & c0);
	assign hex[6] = (~c3 & ~c2 & ~c1) | (c3 & c2 & ~c1 & ~c0) | (~c3 & c2 & c1 & c0);endmodule