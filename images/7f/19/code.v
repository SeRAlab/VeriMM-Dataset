module top_module(funct, ALUOp, ALUcontrol);input [5:0] funct;
input [1:0] ALUOp;
output [2:0] ALUcontrol;

reg [2:0] ALUcontrol;

always @(funct or ALUOp)
begin
	case(ALUOp)
		2'b00: // Addition
			ALUcontrol = 3'b000;
		2'b01: // Bitwise AND
			ALUcontrol = 3'b001;
		2'b10: // Other operations based on funct
			begin
				case(funct)
					6'b100000: // Addition
						ALUcontrol = 3'b000;
					6'b100010: // Subtraction
						ALUcontrol = 3'b001;
					6'b100100: // Bitwise AND
						ALUcontrol = 3'b010;
					6'b100101: // Bitwise OR
						ALUcontrol = 3'b011;
					6'b100110: // Bitwise XOR
						ALUcontrol = 3'b100;
					6'b000000: // Shift left
						ALUcontrol = 3'b101;
					6'b000010: // Shift right
						ALUcontrol = 3'b110;
					6'b101010: // Set on less than (slt)
						ALUcontrol = 3'b111;
					default:
						ALUcontrol = 3'b000; // Default to addition
				endcase
			end
		default:
			ALUcontrol = 3'b000; // Default to addition
	endcase
end

endmodule