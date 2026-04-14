module top_module(clk, rst, load, shift_left, shift_right, serial_in, shift_reg);input clk, rst, load, shift_left, shift_right, serial_in;
	output reg [3:0] shift_reg;

	always @(posedge clk) begin
		if (rst) begin
			shift_reg <= 0;
		end else if (load) begin
			shift_reg <= serial_in;
		end else if (shift_left) begin
			shift_reg <= {shift_reg[2:0], shift_reg[3]};
		end else if (shift_right) begin
			shift_reg <= {shift_reg[1], shift_reg[3:1]};
		end
	end
endmodule