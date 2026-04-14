module top_module(w,s,f);input [1:0]w;
input s;

output reg f;

always @(w or s)

	case(s)
		1'b0: f=w[0];
		1'b1: f=w[1];
	endcase
endmodule