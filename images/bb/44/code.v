module top_module(
	input wire clock,
	input wire[23:0] clock_divider,
	output reg output_clock = 0
);reg[23:0] counter = 0;

	always @(posedge clock) begin
		if (counter == 0) begin
			counter <= clock_divider;
			output_clock <= 1;
		end else begin
			counter <= counter - 1;
			output_clock <= 0;
		end
	end
endmodule