module top_module(
		
		
		input [31:0]Op1,
		input [31:0]Op2,
		input [2:0]S_Op,
		
		output reg ZF,
		output reg[31:0]R_Op
);always @*

begin 
	
	case (S_Op)
		
		3'b000: 
			R_Op = Op1 + Op2;
		
		3'b001: 
			R_Op = Op1 - Op2;
		
		3'b010: 
			R_Op = Op1 * Op2;
		
		3'b011: 
			R_Op = Op1 / Op2;

		3'b100: 
			R_Op = Op1 | Op2;
		
		3'b101: 
			R_Op = Op1 & Op2;
		
		3'b110: 
			R_Op = (Op1<Op2) ? 32'b1:32'b0;

		3'b111: 
			R_Op = Op1 << 0;
		
		default:
			R_Op = 32'bx;
	
	endcase

	
	ZF <= (R_Op) ? 0:1;

end 

endmodule