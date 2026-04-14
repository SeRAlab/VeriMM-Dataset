module debounce (
	input clk,
	input button,
	output reg debounced);reg [1:0] shift_reg;

always @(posedge clk) begin
	shift_reg <= {shift_reg[0], button};
	if (shift_reg == 2'b11)
		debounced <= 1;
	else
		debounced <= 0;
end

endmodule