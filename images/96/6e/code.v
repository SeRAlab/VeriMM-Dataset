module alu(
	input clk,
	input reset,
	input [31:0] operand1,
	input [31:0] operand2,
	input [1:0] control,
	output reg [31:0] result);always @(posedge clk)
	if (reset)
		result <= 32'b0;
	else begin
		case (control)
			2'b00: result <= operand1 + operand2;
			2'b01: result <= operand1 - operand2;
			2'b10: result <= operand1 & operand2;
			default: result <= 32'b0;
		endcase
	end

endmodule