module top_module(output reg[7:0] Y, input [1:0]S, input[7:0] A,B,C,D);always @ (S)

	case(S)
		2'b00:	Y=A;
		2'b01:	Y=B;
		2'b10:	Y=C;
		2'b11:	Y=D;
	endcase 

endmodule