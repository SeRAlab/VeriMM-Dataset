module top_module(a,b,s,f);input [3:0]a;
	input [3:0]b;
	input s;
	output reg [3:0]f;
	
	
	always@(a, b, s)
		case(s)
			0 : f[3:0] <= a[3:0];
			1 : f[3:0] <= b[3:0];
		endcase
	
	
endmodule