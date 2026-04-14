module top_module(clk, rst, x, sync_x);input clk, rst, x;

	output sync_x;

	reg f1, f2;

	assign sync_x = f2;

	always @(posedge clk or posedge rst) begin

		if (rst) begin

			f1 <= 0;

			f2 <= 0;

		end else begin

			f1 <= x;

			f2 <= f1;

		end

	end

endmodule