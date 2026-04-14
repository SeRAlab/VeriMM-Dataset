module top_module(In, Out);parameter				Parity =				0,
							Width =					8;
	

	
	
	
	input	[Width-1:0]		In;
	output reg				Out;
	

	
	
	
	always @ (In) begin
		case (Parity)
			1: Out =								~^In;
			2: Out =								^In;
			3: Out =								1;
			4: Out =								0;
			default: Out =							1'b0;
		endcase
	end
	
endmodule