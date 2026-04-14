module shift_register8bit(
	input clk,
	input rst,
	input si,
	output reg [7:0] q);

	always @(posedge clk or posedge rst) begin
		if (rst)
			q <= 8'b0;
		else
			q <= {q[6:0], si};
	end

endmodule