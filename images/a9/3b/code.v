module top_module(
    input i, 
	 input [31:0] SrcA, SrcB, 
	 input [3:0] af, 
	 
	 output reg[31:0] alures, 


	 output reg ovfalu 
);always @(*) begin
	case (af[3:0])
		4'b0000, 4'b0001 : alures[31:0] <= SrcA + SrcB;
		4'b0010, 4'b0011 : alures[31:0] <= SrcA - SrcB;
		4'b0100 : alures[31:0] <= SrcA & SrcB;
		4'b0101 : alures[31:0] <= SrcA | SrcB;
		4'b0110 : alures[31:0] <= SrcA ^ SrcB;
		4'b0111: alures[31:0] <= i ? SrcB[31:0] << 16 : ~(SrcA[31:0] | SrcB[31:0]);
		4'b1010: alures[31:0] <= {{31{1'b0}}, SrcA < SrcB};
		4'b1011: alures[31:0] <= {{31{1'b0}}, $signed(SrcA) < $signed(SrcB)};
		default : alures[31:0] <= 0;
	endcase
end

endmodule