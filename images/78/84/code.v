module top_module (
	input clk,
	input in_signal,
	output reg edge_detected);reg prev_signal;

always @(posedge clk) begin
		prev_signal <= in_signal;
		edge_detected <= (in_signal & ~prev_signal);
	end
	
endmodule