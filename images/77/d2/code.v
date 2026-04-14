module shift_register (
	input clk,
	input reset,
	input [3:0] d,
	output reg [3:0] q);always @(posedge clk or posedge reset) begin
		if (reset)
			q <= 4'b0;
		else
			q <= {q[2:0], d};
	end
	
endmodule