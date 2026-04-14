module up_counter (
	input clk,
	input reset,
	output [2:0] count
);reg [2:0] count_reg;

always @(posedge clk) begin
	if (reset) begin
		count_reg <= 3'b000;
	end else begin
		count_reg <= count_reg + 1;
	end
end

assign count = count_reg;

endmodule