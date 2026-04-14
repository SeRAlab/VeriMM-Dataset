module top_module(Y, S, A, B);input wire [31:0] A,B;
	input wire S;

	
	output reg [31:0] Y;


	
	always @ (S,A,B)

	case(S)
		1'b0:	Y=A;
		1'b1:	Y=B;

	endcase 

endmodule