module top_module(F,SEG);input [2:0] F;
	output reg [6:0] SEG;
	
	parameter [6:0] cero 	= 7'b0000001;
	parameter [6:0] cuatro 	= 7'b1001100;
	parameter [6:0] guion 	= 7'b1111110;
	
	always @(F)
		begin
			case(F)
				0: 		SEG = cero;
				1: 		SEG = cuatro;
				default: SEG = guion;
			endcase
		end
	endmodule