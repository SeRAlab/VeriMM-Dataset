module shift_reg (
	input clk,
	input rst_n,
	input load,
	input [3:0] parallel_data,
	output reg [3:0] q
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			q <= 4'd0;
		end else if (load) begin
			q <= parallel_data;
		end else begin
			q <= {q[2:0], 1'b0};
		end
	end
endmodule