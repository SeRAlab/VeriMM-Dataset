module binary_counter (
	input clk,
	input reset,
	input enable,
	output [1:0] count
);reg [1:0] count_reg;

always @(posedge clk) begin
	if (reset)
		count_reg <= 2'b00;
	else if (enable)
		count_reg <= count_reg + 1;
end

assign count = count_reg;

endmodule