module top_module(
		input clk,
		input rst_n,
		input in,
		output reg out
	);reg ff1_reg, ff1_next;
	reg ff2_reg, ff2_next;
	
	always @(negedge rst_n, posedge clk) begin
		if (!rst_n) begin
			ff1_reg <= 1'b0;
			ff2_reg <= 1'b0;
		end else begin
			ff1_reg <= ff1_next;
			ff2_reg <= ff2_next;
		end
	end
	
	always @(*) begin
		ff1_next <= in;
		ff2_next <= ff1_reg;
	end
	
	always @(*) begin
		out <= 1'b0;
		if (ff1_reg == 1'b1 && ff2_reg == 1'b0)
			out <= 1'b1;
	end

endmodule