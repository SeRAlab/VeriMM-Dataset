module top_module(z, clk, in, reset);input clk, in, reset;
	output z;

	reg [4:0] shift_reg;
	reg z;

	always @ (negedge clk)
		if (!reset) begin
			shift_reg[4:0] = 5'b00000;
		end
		else begin
			shift_reg[0] = shift_reg[1];
			shift_reg[1] = shift_reg[2];
			shift_reg[2] = shift_reg[3];
			shift_reg[3] = shift_reg[4];
			shift_reg[4] = in;

			if ((shift_reg[4:0] == 5'b00010) || 
			   (shift_reg[4:0] == 5'b00100) ||
			   (shift_reg[4:0] == 5'b10100) ||
			   (shift_reg[4:0] == 5'b01001) ||
			   (shift_reg[4:0] == 5'b01000))
				z = 1;
			else
				z = 0;
		end
endmodule