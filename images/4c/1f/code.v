module top_module(ssOut, nIn);output reg [27:0] ssOut;
	input nIn;
	
	always @(nIn)
		case (nIn)
			1'h1: ssOut = {7'b0111111, 7'b0010001, 7'b0000110, 7'b0010010};
			1'h0: ssOut = {7'b0111111, 7'b0111111, 7'b0101011, 7'b0100011};
			default: ssOut = 7'b0111111;
		endcase
endmodule