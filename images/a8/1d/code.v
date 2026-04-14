module top_module (
	input [3:0] u, 
	input [3:0] v, 
	input [1:0] w, 
	output reg [3:0] y);always @(*) 
		case (w)
			0: y = 0;
			1: y = v;
			2: y = u;
			3: y = u & v;
		endcase
	
endmodule