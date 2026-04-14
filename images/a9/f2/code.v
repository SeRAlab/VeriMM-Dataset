module top_module(
	input [7:0] a,
	input [7:0] b,
	input [1:0] op,
	input clock,
	output reg [15:0] result
);always @ (posedge clock) begin
	case (op)
		2'b00: result <= a + b;
		2'b01: result <= a - b;
		2'b10: result <= a * b;
		2'b11: result <= a / b;
	endcase
end

endmodule