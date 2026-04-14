module top_module(input [3:0] CTL, 
			  input [31:0] A, 
			  input [31:0] B, 
			  output reg [31:0] OUT, 
			  output ZERO
			  );assign ZERO=(0==OUT);
	
	always @(*)
		begin
			case(CTL)
				4'b0000: OUT = A & B;			
				4'b0001: OUT = A | B;			
				4'b0010: OUT = A + B;			
				4'b0110: OUT = A - B;			
				4'b0111: OUT = (A < B) ? 1:0;	
				4'b1100: OUT = ~(A | B);		
				4'b1101: OUT = ~(A & B);		
				default: OUT = 0;
			endcase
		end
endmodule