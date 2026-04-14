module top_module(ALUOp,FuncCode,ALUctl);input [3:0] FuncCode;
    input [1:0] ALUOp;
    output reg [3:0] ALUctl;
	 
	 always @(FuncCode,ALUOp)
	 begin
		case(FuncCode)
		
			4'b0000: ALUctl = 4'b0010;
			4'b0010: ALUctl = 4'b0110;
			4'b0100: ALUctl = 4'b0000;
			4'b0101: ALUctl = 4'b0001;
			4'b1010: ALUctl = 4'b0111;
			
		endcase
	end
endmodule