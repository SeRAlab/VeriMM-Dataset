module shift_register (
	input clk,
	input reset,
	input [7:0] d,
	input load,
	input shift,
	output reg [7:0] q);

	always @(posedge clk or posedge reset) begin
		if (reset)
			q <= 8'b00000000;
		else if (load)
			q <= d;
		else if (shift)
			q <= {1'b0, q[7:1]};
	end
	
endmodule