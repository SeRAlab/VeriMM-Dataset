module shift_register(
	input clk,
	input rst,
	input din,
	output reg [3:0] q
);

	always @(posedge clk) begin
		if (rst) begin
			q <= 4'b0000;
		end
		else begin
			q <= {q[2:0], din};
		end
	end

endmodule