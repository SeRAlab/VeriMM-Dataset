module top_module(
	input clk,
	input signal,
	output reg edge_detected);reg prev_signal;

always @(posedge clk) begin
		prev_signal <= signal;
		edge_detected <= signal & ~prev_signal;
	end

endmodule