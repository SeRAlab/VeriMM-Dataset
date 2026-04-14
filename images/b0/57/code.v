module top_module(output [6:0] s, input [3:0] a, input [3:0] b, input[3:0]c);assign s[0:0] = ~a;
	assign s[1:1] = a | b;
	assign s[2:2] = ~(a | b);
	assign s[3:3] = a & b;
	assign s[4:4] = ~(a & b);
	assign s[5:5] = a ^ b;
	assign s[6:6] = ~(a ^ b);endmodule