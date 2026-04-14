module top_module(input wire rx_in, clk, rst, brg_en, 
		output wire shift_0, shift_15);reg [15:0] shift_reg, next_shift_reg;
	
	assign shift_15 = shift_reg[15];
	assign shift_0 = shift_reg[0];

	always @(posedge clk, posedge rst) begin
		if (rst) begin
			shift_reg <= 16'hFFFF;
		end else begin
			shift_reg <= next_shift_reg;
		end
	end

	always @(*) begin
		if (brg_en) begin
			next_shift_reg <= {rx_in, shift_reg[15:1]};
		end else begin
			next_shift_reg <= shift_reg;
		end
	end

endmodule