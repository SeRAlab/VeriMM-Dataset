module shift_register(
	input clk,
	input reset,
	input [11:0] data_in,
	output reg [11:0] q);always @(posedge clk) begin
		if (reset)
			q <= 12'b0;
		else
			q <= {q[10:0], data_in[11]};
	end

endmodule