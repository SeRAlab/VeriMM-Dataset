module top_module(
    input [7:0] op_A,
    input [7:0] op_B,
    input [2:0] ctrl,
    output reg [7:0] alu_res,
    output zero,
    output ov
    );always @ * begin
		case (ctrl) 
			3'b000: alu_res = op_A + op_B;
			3'b001: alu_res = op_A - op_B;
			3'b010: alu_res = op_A + 1;
			3'b011: alu_res = op_A;
			3'b100: alu_res = op_A & op_B;
			3'b101: alu_res = op_A | op_B;
			3'b110: alu_res = op_A ^ op_B;
			3'b111: alu_res = ~op_A;
			default: alu_res = 0;
		endcase
	 end

		assign zero = (alu_res == 0);
endmodule