module top_module(
	input clk,
	input reset,
	output [3:0] out);reg [3:0] counter;

	always @(posedge clk or posedge reset) begin
		if (reset)
			counter <= 4'b0000;
		else
			counter <= counter + 1;
	end

	assign out = counter;

endmodule