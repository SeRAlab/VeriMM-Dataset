module edge_detector(
	input wire clk,
	input wire reset,
	input wire signal,
	output reg edge_detected
);reg signal_d;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			signal_d <= 1'b0;
			edge_detected <= 1'b0;
		end else begin
			edge_detected <= signal & ~signal_d;
			signal_d <= signal;
		end
	end
endmodule