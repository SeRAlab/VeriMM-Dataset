module top_module(
	input clk,
	input rst,
	input [3:0] BIN,
	output reg[3:0] GRAY
	);always @ (posedge clk)
		begin
			if (rst)
				GRAY <= 4'b0000;
			else
				GRAY <= BIN ^ (BIN >> 1);
		end

endmodule