module top_module (
	input [3:0] m, 
	input [3:0] n, 
	input [3:0] q,
	input [1:0] p, 
	output reg [3:0] o);always @(*) 
		case (p)
			0: o = q;
			1: o = n;
			2: o = m;
			3: o = m + n;
		endcase
	
endmodule