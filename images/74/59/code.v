module parallel_load_reg(
	input clk,
	input clr,
	input load,
	input [5:0] d,
	output reg [5:0] q);
always @(posedge clk or posedge clr) begin
		if (clr)
			q <= 6'b0;
		else if (load)
			q <= d;
	end
endmodule