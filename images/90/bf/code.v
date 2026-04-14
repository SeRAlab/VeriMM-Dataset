module top_module (
	input [3:0] m, 
	input [3:0] n, 
	input [1:0] ctrl, 
	output reg [3:0] out);always @(*) 
		case (ctrl)
			0: out = m ^ n;
			1: out = m & n;
			2: out = m | n;
		endcase
	
endmodule