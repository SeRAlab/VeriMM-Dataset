module top_module (
	input clk,
	input load,
	input [3:0] data_in,
	input shift_in,
	output reg [3:0] q);initial
		q = 0;
		
	always@(posedge clk) begin
		if (load)
			q <= data_in;
		else
			q <= {q[2:0], shift_in};
	end

endmodule