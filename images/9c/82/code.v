module edge_detector(
	input clk,
	input rst_n,
	input in_signal,
	output reg rising_edge,
	output reg falling_edge
);

	reg in_signal_delayed;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			in_signal_delayed <= 1'b0;
		else
			in_signal_delayed <= in_signal;
	end
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			rising_edge <= 1'b0;
			falling_edge <= 1'b0;
		end
		else begin
			rising_edge <= (~in_signal_delayed & in_signal);
			falling_edge <= (in_signal_delayed & ~in_signal);
		end
	end
	
endmodule