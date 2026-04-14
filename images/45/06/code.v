module shift_register(
	input clk,
	input rst_n,
	input shift_in,
	output reg [7:0] shift_out
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			shift_out <= 8'b00000000;
		else
			shift_out <= {shift_out[6:0], shift_in};
	end
	
endmodule