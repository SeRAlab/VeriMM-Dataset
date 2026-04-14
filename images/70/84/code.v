module top_module(
    input wire [1:0] alu_op , 
    input wire [5:0] instruction_5_0 , 
    output wire [3:0] alu_out  
    );reg [3:0] alu_output = 'b0;

assign alu_out = alu_output;

always @(*) 
begin
	case(alu_op)
		2'b00: alu_output = 'b0010; 
		2'b01: alu_output = 'b0110;
		2'b10:	
		begin
		case(instruction_5_0)
				6'b100_000:
					alu_output = 'b0010;
				6'b100_010:
					alu_output = 'b0110;
				6'b100_100:
					alu_output = 'b0000;
				6'b100_101:
					alu_output = 'b0001;
				6'b100_111:
					alu_output = 'b1100;
				6'b101_010:
					alu_output = 'b0111;
				default: ;
			endcase
		end	
		2'b11: alu_output = 'b0110;
		default: ;
	endcase
end

endmodule