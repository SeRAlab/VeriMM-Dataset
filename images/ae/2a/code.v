module shift_register(
	input clk,
	input rst_n,
	input en,
	input dir,
	input load,
	input [3:0] d,
	output reg [3:0] q
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			q <= 4'b0000;
		else if (load)
			q <= d;
		else if (en) begin
			if (dir)
				q <= {1'b0, q[3:1]};
			else
				q <= {q[2:0], 1'b0};
		end
	end

endmodule