module top_module(input [3:0] opcode,output  [2:0]ALUControl,output RegWrite,RegDst,ALUSrc,Branch,
MemWrite,MemtoReg
    );reg [8:0] combin;
assign {RegWrite,RegDst,ALUSrc,ALUControl,Branch,MemWrite,MemtoReg} = combin ;	 
	 always @(opcode)
	     case(opcode)
		    4'b0000: combin=9'b0_0000_0000;   
          4'b0001: combin=9'b1_1000_1000;   
          4'b0010: combin=9'b1_1001_0000;   
          4'b0011: combin=9'b1_1001_1000;   
          4'b0100: combin=9'b1_1001_0000;   
          4'b0101: combin=9'b1_0110_1000;   
          4'b0110: combin=9'b1_0111_0000;   
          4'b0111: combin=9'b1_0100_1000;   
          4'b1000: combin=9'b1_0101_0000;   
          4'b1001: combin=9'b1_0100_1001;   
          4'b1010: combin=9'b0_0100_1010;   
			 4'b1011: combin=9'b1_0100_1001;   
			 4'b1100: combin=9'b0_0100_1010;   
			 4'b1101: combin=9'b0_0001_0100;   
			 default: combin=9'b0_0000_0000;   
			 
		endcase
endmodule