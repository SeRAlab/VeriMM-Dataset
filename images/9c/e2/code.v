module edge_detector (
	input clk,
	input rst,
	input d,
	output reg edge_detected);

	reg d_prev;

	always @(posedge clk) begin
		if (rst)
			d_prev <= 0;
		else
			d_prev <= d;
	end

	always @(posedge clk) begin
		if (rst)
			edge_detected <= 0;
		else
			edge_detected <= d & ~d_prev;
	end
	
endmodule