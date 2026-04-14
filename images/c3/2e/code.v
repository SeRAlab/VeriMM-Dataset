module calculator(operand1, operand2, operator, result);

	input [7:0] operand1, operand2;
	input [1:0] operator;
	output [15:0] result;

	reg [15:0] temp_result;

	always @ (*)
	begin
		case (operator)
			2'b00: temp_result = operand1 + operand2; // addition
			2'b01: temp_result = operand1 - operand2; // subtraction
			2'b10: temp_result = operand1 * operand2; // multiplication
			2'b11: temp_result = operand1 / operand2; // division
		endcase
	end

	assign result = temp_result;

endmodule