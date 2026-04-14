module top_module(B,S,D);input [3:0] B;
	input [1:0] S;
	output reg [3:0] D;
	
	always @ (*)
		case(S)
			0: D = B;
			1: D = ~B;
			2: D = 4'b0000;
			3: D = 4'b1111;
			endcase
	endmodule