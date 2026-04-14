module shift_register (
	input clk,
	input shift_left,
	input shift_right,
	input data_in,
	output reg [3:0] register);always @(posedge clk)
		if (shift_left)
			register <= {register[2:0], data_in};
		else if (shift_right)
			register <= {data_in, register[3:1]};

endmodule