module freq_divider(
	input clk,
	input rst_n,
	output reg clk_out
);

	reg [1:0] counter;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			counter <= 2'b0;
		else
			counter <= counter + 1;
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			clk_out <= 1'b0;
		else if (counter == 2'b10)
			clk_out <= ~clk_out;
	end

endmodule