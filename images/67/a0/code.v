module top_module (
	input clk,
	input in,
	output reg y);reg [2:0] shift_reg;

always @(posedge clk) begin
	shift_reg <= {shift_reg[1:0], in};
	y <= (shift_reg == 3'b101);
end

endmodule