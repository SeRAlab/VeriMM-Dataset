module top_module(
	areset,
	inclk0,
	c0,
	c1,
	locked);input	  areset;
	input	  inclk0;
	output	  c0;
	output	  c1;
	output	  locked;
	
	reg c0_reg;
	reg c1_reg;
	reg locked_reg;

	always @(posedge inclk0 or negedge areset) begin
		if (!areset) begin
			c0_reg <= 1'b0;
			c1_reg <= 1'b1;
			locked_reg <= 1'b0;
		end else begin
			if (c0_reg & c1_reg) begin
				c0_reg <= 1'b1;
				c1_reg <= 1'b0;
				locked_reg <= 1'b1;
			end else begin
				c0_reg <= c1_reg;
				c1_reg <= ~c0_reg;
				locked_reg <= 1'b0;
			end
		end
	end

	assign c0 = c0_reg;
	assign c1 = c1_reg;
	assign locked = locked_reg;

endmodule