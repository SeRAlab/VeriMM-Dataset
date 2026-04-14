module top_module(funct, ALUOp, ALUcontrol);input [5:0] funct;
input [1:0] ALUOp;
output [2:0] ALUcontrol;

reg [2:0] ALUcontrol;

always @(funct or ALUOp)
begin
	case(ALUOp)
		2'b00: ALUcontrol	= 3'b010;
		2'b01: ALUcontrol	= 3'b110;
		2'b10:
		begin
		case(funct)
			6'b100000: ALUcontrol	= 3'b010;
			6'b100010: ALUcontrol	= 3'b110;
			6'b100100: ALUcontrol	= 3'b000;
			6'b100101: ALUcontrol	= 3'b001;
			6'b101010: ALUcontrol	= 3'b111;
		endcase
		end
	endcase
end

endmodule