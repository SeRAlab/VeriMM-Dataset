module top_module(
   output reg [3:0]Anodos,
	input [1:0]Sel_Anodos
	 );always @(Sel_Anodos)begin
		case(Sel_Anodos)
			2'b00: Anodos<=4'b1110;
			2'b01: Anodos<=4'b1101;
			2'b10: Anodos<=4'b1011;
			2'b11: Anodos<=4'b0111;
		endcase

	end	
endmodule