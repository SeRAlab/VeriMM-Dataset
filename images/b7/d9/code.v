module top_module(
	input [5:0] op,
	output reg [6:0] main_control,
	output reg [1:0] alu_op
    );always @* begin
		case(op)
			6'b000000: {main_control,alu_op}=9'b110000010;
			6'b100011: {main_control,alu_op}=9'b101001000;
			6'b101011: {main_control,alu_op}=9'b001010000;
			6'b000100: {main_control,alu_op}=9'b000100001;
			6'b001000: {main_control,alu_op}=9'b101000000;
			6'b000010: {main_control,alu_op}=9'b000000100;
			default: {main_control,alu_op}=9'b0;
		endcase
	end
endmodule