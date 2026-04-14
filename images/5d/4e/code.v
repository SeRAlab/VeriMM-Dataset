module alu #(
	parameter WIDTH = 8
)(
	input [WIDTH-1:0] A,
	input [WIDTH-1:0] B,
	input [1:0] ctrl,
	output reg [WIDTH-1:0] result,
	output reg carry_out
);

always @(*) begin
	case (ctrl)
		2'b00: {carry_out, result} = A + B; // ADD
		2'b01: {carry_out, result} = A - B; // SUB
		2'b10: result = A & B; // AND
		2'b11: result = A | B; // OR
		default: result = 0;
	endcase
end

endmodule