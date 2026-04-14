module top_module(ALUop,FieldFunc,ALUConInput);input [1:0]ALUop;
input [5:0]FieldFunc;
output reg [3:0]ALUConInput;

always@(ALUop,FieldFunc)
	case(ALUop)
		2'b00:ALUConInput=4'b0010;
		2'b01:ALUConInput=4'b0110;
		
		2'b10: case(FieldFunc)
					6'b100000:ALUConInput=4'b0010;
					6'b100010:ALUConInput=4'b0110;
					6'b100100:ALUConInput=4'b0000;
					6'b100101:ALUConInput=4'b0001;
					6'b101010:ALUConInput=4'b0111;
			   endcase
	
	endcase

endmodule