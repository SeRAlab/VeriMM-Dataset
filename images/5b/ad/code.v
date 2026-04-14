module edge_detector (
	input clk,
	input signal,
	output reg edge_detected);reg signal_delayed;

always @(posedge clk) begin
	signal_delayed <= signal;
	edge_detected <= signal & ~signal_delayed;
end

endmodule