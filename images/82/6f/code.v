module bidirectional_shift_reg_8bit(
	input clk,
	input reset,
	input shift_left,
	input shift_right,
	input load,
	input [7:0] data_in,
	output reg [7:0] q);

	always @(posedge clk or posedge reset) begin
		if (reset)
			q <= 8'b00000000;
		else if (load)
			q <= data_in;
		else if (shift_left)
			q <= {q[6:0], 1'b0};
		else if (shift_right)
			q <= {1'b0, q[7:1]};
	end
	
endmodule