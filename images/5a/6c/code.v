module johnson_counter (
	input clk,
	input reset,
	output [3:0] count
);reg [3:0] count_reg;

always @(posedge clk or posedge reset) begin
	if (reset) begin
		count_reg <= 4'b0000;
	end else begin
		count_reg <= {~count_reg[3], count_reg[3:1]};
	end
end

assign count = count_reg;

endmodule